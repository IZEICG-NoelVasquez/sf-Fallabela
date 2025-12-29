/**
* Nombre: PathCancelacionDeTitularController
* Autor: Mauricio Rosales 
* Descripcion: Clase Controladora Apex del Componente Lightning PathCancelacionDeTitular
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           11/10/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class PathCancelacionDeTitularController {

    /**
    * Metodo para obtener los valores disponibles de los Campos configurados en el Custom Metadata Path_Cancelacion_de_Titular_RecordType__mdt
    * Regresa un mapa con los valores disponibles para los campos Motivo_de_cancelaci_n_de_tarjeta__c, Cliente_desea_continuar_con_la_cancelac__c, Subgrupo__c, Motivo_de_la_Retenci_n__c
    *
    * @param recordId: Id del Registro del Caso
    **/
    @AuraEnabled
    public static Map<String, Object> getPickListValues(String recordId) {

        Map<String, Object> mapResult = new Map<String, Object>();

        /// Motivo_de_la_Retenci_n__c
        Set<String> setMotivoRetencionPermitido = new Set<String>();

        List<Case> lstCurrentCase = new List<Case>();

        lstCurrentCase = [SELECT AccountId, 
                                Status, 
                                Motivo_de_cancelaci_n_de_tarjeta__c, 
                                Cliente_desea_continuar_con_la_cancelac__c, 
                                Subgrupo__c, 
                                Motivo_de_la_Retenci_n__c 
                        FROM Case WHERE Id = : recordId];

        /// Despues de Pruebas en UAT cambiar Prueba_Fecha_Motivo_de_Retencion__c por CreatedDate
        List<Case> lstCasesRetTitular = [SELECT AccountId, Motivo_de_la_Retenci_n__c, CreatedDate
                                            FROM Case 
                                            WHERE AccountId = : lstCurrentCase[0].AccountId
                                            AND RecordTypeId = : Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId() 
                                            ORDER BY CreatedDate DESC LIMIT 1];

        /// Mapa( Motivo de la Retencion, List dias transcurridos)
        Map<String, List<Integer> > mapRetTitularLstDias = new Map<String, List<Integer> >();
        ///
        Boolean blnCaseRetencion = false;
        Boolean blnCaseAlreadyCreated = false;
        Integer numCasesFound = 0;
        Boolean caseFound = false;

        if( !lstCasesRetTitular.isEmpty() ) {

            Date dtToday = System.today();

            for(Case casoRetTitular: lstCasesRetTitular) {

                ///
                if( !mapRetTitularLstDias.containsKey(casoRetTitular.Motivo_de_la_Retenci_n__c) ) {

                    mapRetTitularLstDias.put( casoRetTitular.Motivo_de_la_Retenci_n__c, new List<Integer>() );
                }
                mapRetTitularLstDias.get(casoRetTitular.Motivo_de_la_Retenci_n__c).add(casoRetTitular.CreatedDate.date().daysBetween(dtToday));
            }

            /// Se recorren 3 registros de Motivo_de_la_Retencion__mdt
            for(Motivo_de_la_Retencion__mdt motivo: [SELECT Retencion_caso_anterior__c, Retencion_permitida__c, Dia_inicial__c, Dia_final__c, Mensaje_retencion_no_permitida__c, Orden_de_evaluacion__c
                                                        FROM Motivo_de_la_Retencion__mdt WHERE Activo__c = true
                                                        ORDER BY Orden_de_evaluacion__c ]) {

                caseFound = false;
                blnCaseAlreadyCreated = false;

                if( String.isNotBlank(motivo.Retencion_caso_anterior__c) ) {

                    for(String retencionAnt: motivo.Retencion_caso_anterior__c.split(';') ) {

                        /// Ya existe un Caso Anterior de Retencion con el Motivo del Metadata Actual
                        if( mapRetTitularLstDias.containsKey(retencionAnt) ) {
                            
                            for(Integer diasCreacion : mapRetTitularLstDias.get(retencionAnt) ) {

                                /// Metadata Dia Inicial   <=   Dias de creacion Caso Anterior   <=   Metadata Dia Final
                                if( (motivo.Dia_inicial__c <= diasCreacion) && (diasCreacion <= motivo.Dia_final__c) ) {

                                    caseFound = true;
                                    break;// FOR - mapRetTitularLstDias.get(retencionAnt)
                                }
                            }

                            if( caseFound ) {

                                break;//For - motivo.Retencion_caso_anterior__c.split(';')
                            }
                        }
                    }
                }

                /// Metadata Dia Inicial   <=   Dias de creacion Caso Anterior   <=   Metadata Dia Final
                if( caseFound ) {

                    numCasesFound = 0;

                    if( String.isNotBlank(motivo.Retencion_permitida__c) ) {

                        for(String retencionPermitida: motivo.Retencion_permitida__c.split(';')) {

                            ///
                            if( mapRetTitularLstDias.containsKey(retencionPermitida) ) {

                                ///
                                for(Integer diasCreacion: mapRetTitularLstDias.get(retencionPermitida) ) {

                                    if( (motivo.Dia_inicial__c <= diasCreacion) && (diasCreacion <= motivo.Dia_final__c) ) {

                                        ///
                                        Integer numCasesAllowed = motivo.Retencion_caso_anterior__c.split(';').contains(retencionPermitida) ? 1 : 0;

                                        numCasesFound ++;
                                        blnCaseRetencion = true;

                                        /// Ya se creo un Caso para esta Condicion
                                        if( numCasesFound > numCasesAllowed ) {

                                            blnCaseAlreadyCreated = true;
                                            break;//FOR - mapRetTitularLstDias.get(retencionPermitida)
                                        }
                                    }
                                }
                                
                                if( blnCaseAlreadyCreated ) {

                                    break;// FOR - motivo.Retencion_permitida__c.split(';')
                                }
                            }
                        }

                        if( !blnCaseAlreadyCreated ) {

                            for(String retencionPermitida: motivo.Retencion_permitida__c.split(';')) { 

                                setMotivoRetencionPermitido.add( retencionPermitida );
                            }
                        }
                    }

                    break;// FOR - Motivo_de_la_Retencion__mdt
                }
            }
        } 
        
        if( !blnCaseRetencion && setMotivoRetencionPermitido.isEmpty() ) {

            Schema.DescribeFieldResult motivoRetencion = Case.Motivo_de_la_Retenci_n__c.getDescribe();

            for(Schema.PicklistEntry ple : motivoRetencion.getPicklistValues() ) {

                if( ple.isActive() ) {

                    setMotivoRetencionPermitido.add( ple.getLabel() );
                }
            }
        }

        /// Se agregan los Motivos de Retencion permitidos N veces
        for(String valueConstant: Constants.PATH_CAN_TIT_MOTIVOS_DE_RETENCION_PERMITIDOS_N_VECES.split(';') ) {

            setMotivoRetencionPermitido.add(valueConstant);
        }
    
        List<Path_Cancelacion_de_Titular_RecordType__mdt> lstCancelacionTitularRT = [SELECT MasterLabel, 
                                                                                            Nombre_de_API__c, 
                                                                                            Valor_del_Campo__c, 
                                                                                            Dependencia_de_Campo__c, 
                                                                                            (SELECT Valor_del_Campo__c, Valores_Disponibles__c FROM Path_Cancelacion_de_Titular_Dependencias__r)
                                                                                    FROM Path_Cancelacion_de_Titular_RecordType__mdt];

        /// Motivo_de_cancelaci_n_de_tarjeta__c
        Map<String, String> mapMotivoCancelacion = new Map<String, String>();
        /// Cliente_desea_continuar_con_la_cancelac__c 
        Map<String, String> mapContinuarCancelacion = new Map<String, String>();
        /// Subgrupo__c 
        Map<String, String> mapSubgrupo = new Map<String, String>();
        /// Motivo_de_la_Retenci_n__c  Dependencias
        Map<String, List<String>> mapMotivoRetencionDependencias = new Map<String, List<String>>();

        if( lstCancelacionTitularRT.size() > 0 ) {         

            for(Path_Cancelacion_de_Titular_RecordType__mdt pickListValue: lstCancelacionTitularRT ) {

                if( !pickListValue.Dependencia_de_Campo__c && String.isNotBlank(pickListValue.Valor_del_Campo__c) ) {

                    for(String strValor: pickListValue.Valor_del_Campo__c.split(';') ) {

                        if( pickListValue.Nombre_de_API__c == 'Motivo_de_cancelaci_n_de_tarjeta__c' ) {
    
                            mapMotivoCancelacion.put( strValor, strValor);
    
                        } else if( pickListValue.Nombre_de_API__c == 'Cliente_desea_continuar_con_la_cancelac__c' ) {
    
                            mapContinuarCancelacion.put( strValor, strValor);
    
                        } else if( pickListValue.Nombre_de_API__c == 'Subgrupo__c' ) {
    
                            mapSubgrupo.put( strValor, strValor);
                        }

                    } 

                } else if( pickListValue.Dependencia_de_Campo__c && pickListValue.Path_Cancelacion_de_Titular_Dependencias__r.size() > 0 ) {

                    for(Path_Cancelacion_de_Titular_Dependencia__mdt strDependencia: pickListValue.Path_Cancelacion_de_Titular_Dependencias__r ) {

                        mapMotivoRetencionDependencias.put(strDependencia.Valor_del_Campo__c, new List<String>() );

                        for(String strValorDependencia: strDependencia.Valores_Disponibles__c.split(';') ) {

                            if( setMotivoRetencionPermitido.contains(strValorDependencia) ) {

                                mapMotivoRetencionDependencias.get(strDependencia.Valor_del_Campo__c).add(strValorDependencia);
                            }
                        }
                    }
                }
            }
        }

        mapResult.put('mapMotivoCancelacion', mapMotivoCancelacion);
        mapResult.put('mapContinuarCancelacion', mapContinuarCancelacion);
        mapResult.put('mapSubgrupo', mapSubgrupo);
        mapResult.put('mapMotivoRetencionDependencias', mapMotivoRetencionDependencias);

        mapResult.put('currentCase', lstCurrentCase[0]);

        return mapResult;
    }

    /**
    * Metodo para actualizar el caso
    * Regresa un mapa con una variable de exito
    *
    * @param caseId: Id del Registro del Caso
    * @param mapFields: Mapa con los campos del Caso (Nombre de API, Valor del campo)
    **/
    @AuraEnabled
    public static Map<String, Object> updateCaseByRT(String caseId, Map<String, Object> mapFields) {

        return CreateCase.updateCaseByRT(caseId, mapFields);
    }    
}