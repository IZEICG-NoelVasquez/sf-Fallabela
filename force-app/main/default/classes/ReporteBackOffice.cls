/**
* Nombre: ReporteBackOffice
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning ReporteBackOffice
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           23/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           21/02/2022      Mauricio Rosales            Historial de cambios, tiempo de resolucion por bandeja
* --------------------------------------------------------------------------
*/
public class ReporteBackOffice {

    private static String cssClass = 'backgroundClassRow';    
    private static String strFormatDate = 'dd/MM/yyyy HH:mm:ss';
    @TestVisible private static String strAPINameTelefonoMovil = 'N_mero_de_Tel_fono_M_vil__c';
    @TestVisible private static String strAPINameCupo = 'Cupo__c';
    @TestVisible private static String strAPINameEstatus = 'Estatus__c';


    /**
    * Regresa la lista de Codigos de Duda agrupados por Caso para el RecordType de BackOffice Credito
    *
    * @param fechaInicio: Fecha de inicio a comparar en el Query
    * @param fechaFin: Fecha de fin a comparar en el Query
    * @param colopsar: Variable booleana para obtener solo un registro de Casos por Codigos de Duda
    * @param curp: Curp del cliente a comparar en el Query
    **/
    @AuraEnabled
    public static Map<String,Object> getCasosBOCredito(Date fechaInicio, Date fechaFin, Boolean colapsar, String curp, String recordTypeDevName, Integer offset, Boolean allRecords) {

        ///
        System.debug('fechaInicio 1:  ' + fechaInicio);
        System.debug('fechaFin 1:  ' + fechaFin);
        System.debug('offset:  ' + offset);

        Map<String,Object> mapResult = new Map<String,Object>();
        Integer numberOfCases = 0;

        Integer caseLimit = Integer.valueOf(Constants.REPORTE_BACKOFFICE_PAGINATION_NUMBER_OF_RECORDS);

        List<CasoBackOffice> listCasosBackOffice = new List<CasoBackOffice>();

        try {

            fechaFin = fechaFin != null ? fechaFin.addDays(1) : fechaFin;

            /// Cutom Metadata
            List<Validaciones_de_Codigo_CM__mdt> listValidacionesDeCodigo = [SELECT Catalogo_Codigos_CM__r.MasterLabel, 
                                                                                Catalogo_Codigos_CM__r.Verificacion_Telefonica__c, 
                                                                                Catalogo_Validaciones_CM__r.DeveloperName 
                                                                        FROM Validaciones_de_Codigo_CM__mdt];

            /// Mapa para almacenar Validaciones
            Map<String, Set<String> > mapValidaciones = new Map<String, Set<String> >();
            ///
            for(Validaciones_de_Codigo_CM__mdt validaciones: listValidacionesDeCodigo) {

                if( !mapValidaciones.containsKey(validaciones.Catalogo_Codigos_CM__r.MasterLabel) ) {
                    mapValidaciones.put(validaciones.Catalogo_Codigos_CM__r.MasterLabel, new Set<String>() );
                }
                /// Validacion Fraude
                if( validaciones.Catalogo_Validaciones_CM__r.DeveloperName == 'VoBo_Fraude' ) {

                    mapValidaciones.get(validaciones.Catalogo_Codigos_CM__r.MasterLabel).add('FRAUDE');
                }
                /// Buro
                if( validaciones.Catalogo_Validaciones_CM__r.DeveloperName == 'Historial_Crediticio' ) {

                    mapValidaciones.get(validaciones.Catalogo_Codigos_CM__r.MasterLabel).add('BURO');
                }
                /// Verificacion Telefonica
                if( validaciones.Catalogo_Codigos_CM__r.Verificacion_Telefonica__c ) {

                    mapValidaciones.get(validaciones.Catalogo_Codigos_CM__r.MasterLabel).add('TELEFONICA');
                }            
            }

            Id idRecordTypeRiesgos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId();
            ///BO Fraudes
            Id idRecordTypeFraudes = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Fraudes').getRecordTypeId();

            TimeZone timeZone = UserInfo.getTimeZone();

            String strFields = 'SELECT Canal_origen__c, ';          
            strFields += 'Sucursal__c, ';
            strFields += 'ID_Solicitud__c, ';
            strFields += 'Primer_Aprobador__c, ';
            strFields += 'Segundo_Aprobador__c, ';
            strFields += 'Mismo_Aprobador__c, ';
            strFields += 'CURP__c, ';
            strFields += 'Nombre_s__c, ';
            strFields += 'Primer_Apellido__c, ';
            strFields += 'Segundo_Apellido__c, ';
            strFields += 'Cupo__c, ';
            strFields += 'Status, ';
            strFields += 'Motivo_de_Rechazo_Riesgos__c, ';
            strFields += 'Owner.Name, ';
            strFields += 'Motivo_de_Pendiente__c, ';
            strFields += '(SELECT Comentarios__c FROM Notas_a_Canales__r), ';
            strFields += '(SELECT Name, Descripci_n__c FROM Codigos_de_dudas__r), ';
            strFields += 'CreatedDate, ';
            strFields += 'ClosedDate, ';
            strFields += 'Evaluar__c, ';
            ///BO Fraudes
            strFields += 'Dictaminacion_Fraudes__c, ';
            strFields += 'Producto_solicitado__c, ';
            strFields += 'Publicidad__c, ';
            strFields += '(SELECT API_Name__c, Numero_de_intento__c FROM Historial_de_Cambios__r), ';
            strFields += 'Fecha_y_hora_de_solicitud_en_an_lisis__c ';
            strFields += 'FROM Case ';

            String strQueryCredito = 'WHERE RecordTypeId =: idRecordTypeRiesgos ';
            strQueryCredito += String.isNotBlank(curp) ? 'AND CURP__c =: curp ' : 'AND CreatedDate >=: fechaInicio AND CreatedDate <=: fechaFin' ;

            numberOfCases = !allRecords ? Database.countQuery('SELECT COUNT() FROM Case ' + strQueryCredito) : 0;

            String strQueryOrderBy = ' ORDER BY CreatedDate DESC';
            String strQueryOffSet = allRecords ? '' : ' LIMIT : caseLimit OFFSET : offset';

            List<Case> listCaso = Database.query(strFields + strQueryCredito + strQueryOrderBy + strQueryOffSet);

            ///BO Fraudes
            String strQueryFraudes = 'WHERE RecordTypeId =: idRecordTypeFraudes ';
            strQueryFraudes += String.isNotBlank(curp) ? 'AND CURP__c =: curp ' : 'AND CreatedDate >=: fechaInicio AND CreatedDate <=: fechaFin' ;

            ////numberOfCasesFraudes = recordTypeDevName == 'Riesgos_Originaci_n' && !allRecords ? Database.countQuery('SELECT COUNT() FROM Case ' + strQueryFraudes) : 0;
            List<Case> listCasosFraudes = recordTypeDevName == 'Riesgos_Originaci_n' && allRecords ? Database.query(strFields + strQueryFraudes + strQueryOrderBy) : new List<Case>();

            ///
            Integer contador = 1;
            for(Case casoBO: listCaso) {

                ///
                String backgroundCSSClass = math.mod(contador, 2) == 0 ? cssClass : '';

                String strAprobador = casoBO.Cupo__c > 30000 ? (casoBO.Cupo__c > 80000 && !casoBO.Mismo_Aprobador__c ? casoBO.Segundo_Aprobador__c : casoBO.Primer_Aprobador__c) : '';
                String strNombreDelCliente = casoBO.Nombre_s__c + ' ' + casoBO.Primer_Apellido__c + ' ' + casoBO.Segundo_Apellido__c;
                String strNotasACanal = '';
                Integer contAux = 0;
                for(Notas_a_Canales__c notaCanal: casoBO.Notas_a_Canales__r) {

                    strNotasACanal += contAux > 0 ? ', ' + notaCanal.Comentarios__c : notaCanal.Comentarios__c;
                    contAux ++;
                }
                
                String strTiempoDeResolucion = casoBO.Status == 'Cerrado' ? tiempoDeResolucion(casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c, casoBO.ClosedDate) : '';
                String strTiempoTotalDeResolucion = casoBO.Status == 'Cerrado' ? tiempoDeResolucion(casoBO.CreatedDate, casoBO.ClosedDate) : '';
                
                String strTipoDeCredito = casoBO.Evaluar__c == 'Aprobar' || casoBO.Evaluar__c == 'Rechazar' ? 'NUEVO' : (casoBO.Evaluar__c == 'Pendiente' ? 'REPETIDA' : '');

                String strHoraDeIngreso = casoBO.CreatedDate.format(strFormatDate, String.valueOf(timeZone));
                String strHoraDeAceptacion = casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c != null ? casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c.format(strFormatDate, String.valueOf(timeZone)) : '';
                String strHoraDeRespuesta = casoBO.ClosedDate != null ? casoBO.ClosedDate.format(strFormatDate, String.valueOf(timeZone) ) : '';

                /// Historial de Cambios
                Map<String,String> mapHistorial = validateHistory(casoBO.Historial_de_Cambios__r);
                String strActualizacionMovil = mapHistorial.get('strActualizacionMovil');
                String strActualizacionCupo = mapHistorial.get('strActualizacionCupo');
                String strCambioDeEstado = mapHistorial.get('strCambioDeEstado');

                for(Codigo_de_dudas__c codigoDuda: casoBO.Codigos_de_dudas__r) {                    
           
                    String strBuro = mapValidaciones.containsKey(codigoDuda.Name) ? (mapValidaciones.get(codigoDuda.Name).contains('BURO') ? 'SI' : 'NO') : 'NO';
                    String strTelefonica = mapValidaciones.containsKey(codigoDuda.Name) ? (mapValidaciones.get(codigoDuda.Name).contains('TELEFONICA') ? 'SI' : 'NO') : 'NO';
                    
                    CasoBackOffice casoBONuevo = new CasoBackOffice( casoBO.Canal_origen__c,
                                                                    backgroundCSSClass,
                                                                    casoBO.Sucursal__c,
                                                                    casoBO.ID_Solicitud__c,
                                                                    strAprobador,
                                                                    casoBO.CURP__c,
                                                                    strNombreDelCliente,
                                                                    casoBO.Cupo__c,
                                                                    casoBO.Status,
                                                                    casoBO.Motivo_de_Rechazo_Riesgos__c,
                                                                    casoBO.Owner.Name,
                                                                    casoBO.Motivo_de_Pendiente__c,
                                                                    strNotasACanal,
                                                                    codigoDuda.Name,
                                                                    strBuro,
                                                                    strTelefonica,
                                                                    strHoraDeIngreso,
                                                                    strHoraDeAceptacion, 
                                                                    strHoraDeRespuesta,
                                                                    strTiempoDeResolucion,
                                                                    strTiempoTotalDeResolucion, 
                                                                    casoBO.Producto_solicitado__c,
                                                                    strTipoDeCredito,
                                                                    strActualizacionMovil,
                                                                    strActualizacionCupo,
                                                                    strCambioDeEstado );

                    listCasosBackOffice.add(casoBONuevo);

                    if( colapsar ) {

                        break;
                    }
                }
                
                contador ++;
            }

            ///BO Fraudes
            for(Case casoBO: listCasosFraudes) {

                String backgroundCSSClass = math.mod(contador, 2) == 0 ? cssClass : '';

                String strNombreDelCliente = casoBO.Nombre_s__c + ' ' + casoBO.Primer_Apellido__c + ' ' + casoBO.Segundo_Apellido__c;

                String strTiempoDeResolucion = casoBO.Status == 'Cerrado' ? tiempoDeResolucion(casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c, casoBO.ClosedDate) : '';
                String strTiempoTotalDeResolucion = casoBO.Status == 'Cerrado' ? tiempoDeResolucion(casoBO.CreatedDate, casoBO.ClosedDate) : '';

                String strTipoDeCredito = casoBO.Dictaminacion_Fraudes__c == 'Aprobada' || casoBO.Dictaminacion_Fraudes__c == 'Rechazada' ? 'NUEVO' : (casoBO.Dictaminacion_Fraudes__c == 'Pendiente' ? 'REPETIDA' : '');

                String strHoraDeIngreso = casoBO.CreatedDate.format(strFormatDate, String.valueOf(timeZone) );
                String strHoraDeAceptacion = casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c != null ? casoBO.Fecha_y_hora_de_solicitud_en_an_lisis__c.format(strFormatDate, String.valueOf(timeZone)) : '';
                String strHoraDeRespuesta = casoBO.ClosedDate != null ? casoBO.ClosedDate.format(strFormatDate, String.valueOf(timeZone) ) : '';

                /// Historial de Cambios
                Map<String,String> mapHistorial = validateHistory(casoBO.Historial_de_Cambios__r);
                String strActualizacionMovil = mapHistorial.get('strActualizacionMovil');
                String strActualizacionCupo = mapHistorial.get('strActualizacionCupo');
                String strCambioDeEstado = mapHistorial.get('strCambioDeEstado');

                CasoBackOffice casoBONuevo = new CasoBackOffice( casoBO.Canal_origen__c,
                                                                    backgroundCSSClass,
                                                                    casoBO.Sucursal__c,
                                                                    casoBO.ID_Solicitud__c,
                                                                    null,
                                                                    casoBO.CURP__c,
                                                                    strNombreDelCliente,
                                                                    casoBO.Cupo__c,
                                                                    casoBO.Status,
                                                                    null,
                                                                    casoBO.Owner.Name,
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    null,
                                                                    strHoraDeIngreso,
                                                                    strHoraDeAceptacion, 
                                                                    strHoraDeRespuesta,
                                                                    strTiempoDeResolucion,
                                                                    strTiempoTotalDeResolucion, 
                                                                    casoBO.Producto_solicitado__c,
                                                                    strTipoDeCredito,
                                                                    strActualizacionMovil,
                                                                    strActualizacionCupo,
                                                                    strCambioDeEstado );

                    listCasosBackOffice.add(casoBONuevo);

                contador ++;
            }

        }catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }

        mapResult.put('listCasosBackOffice', listCasosBackOffice);
        mapResult.put('numberOfCases', numberOfCases);
        mapResult.put('caseLimit', caseLimit);

        return mapResult;
    }

    /**
    * Calcula la diferencia de tiempo entre dos Datetime y lo regresa en el formato de texto 'dias horas:minutos'
    *
    * @param dtInicio: Fecha de inicio para calcular la diferenica de tiempo
    * @param dtFin: Fecha de fin para calcular la diferencia de tiempo
    **/
    public static String tiempoDeResolucion(Datetime dtInicio, Datetime dtFin) {

        String strTiempoDeResolucion = '';

        Long intTiempoDeResolucion = dtFin.getTime() - dtInicio.getTime();
        Long intDays = 0;
        Long intHours = 0;
        Long intMinutes = 0;        

        intDays = Integer.valueOf( intTiempoDeResolucion / (1000 * 60 * 60 * 24) );

        if( intDays > 0 ) {

            strTiempoDeResolucion = String.valueOf(intDays) + 'd ';
            intHours = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24))) / (1000 *60 * 60) );

            if( intHours > 0 ) {
                
                strTiempoDeResolucion += intHours > 9 ? String.valueOf(intHours) + ':' : '0' + String.valueOf(intHours) + ':';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                } 
            } else {

                strTiempoDeResolucion += '00:';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                } 
            }
        } else {

            intHours = Integer.valueOf( intTiempoDeResolucion / (1000 *60 * 60) );
            if( intHours > 0 ) {

                strTiempoDeResolucion += intHours > 9 ? String.valueOf(intHours) + ':' : '0' + String.valueOf(intHours) + ':';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                }
            } else {

                strTiempoDeResolucion += '00:';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                }
            }
        }

        return strTiempoDeResolucion;
    }

    /**
    * Valida si existen registros de Cambios para los campos Telefono Movil y Cupo
    * Regresa un mapa con las validaciones de cambios para cada campo (SI, NO)
    *
    * @param lstHistorial: Lista de Historial_de_Cambios__c
    **/
    public static Map<String,String> validateHistory(List<Historial_de_Cambios__c> lstHistorial) {

        Map<String,String> mapResult = new Map<String,String>();

        Boolean movilUpdate = false;
        Boolean cupoUpdate = false;
        Boolean statusUpdate = false;

        for(Historial_de_Cambios__c historial: lstHistorial) {

            if( historial.API_Name__c == strAPINameTelefonoMovil && historial.Numero_de_intento__c != null ) {

                movilUpdate = true;
            }

            if( historial.API_Name__c == strAPINameCupo && historial.Numero_de_intento__c != null ) {

                cupoUpdate = true;
            }

            if( historial.API_Name__c == strAPINameEstatus ) {

                statusUpdate = true;
            }

            if( movilUpdate && cupoUpdate && statusUpdate ) {

                break;
            }
        }

        mapResult.put('strActualizacionMovil', movilUpdate ? 'SI' : 'NO');
        mapResult.put('strActualizacionCupo', cupoUpdate ? 'SI' : 'NO');
        mapResult.put('strCambioDeEstado', statusUpdate ? 'SI' : 'NO');

        return mapResult;
    }

    /*
    * Clase Wrapper para regresar la lista de Casos al Componente
    */
    public class CasoBackOffice {

        @AuraEnabled public String canalOrigen;
        @AuraEnabled public String backgroundCSSClass;
        @AuraEnabled public String sucursal;
        @AuraEnabled public String idSolicitud;
        @AuraEnabled public String aprobador;
        @AuraEnabled public String curp;
        @AuraEnabled public String nombreDelCliente;
        @AuraEnabled public Decimal cupo;
        @AuraEnabled public String estatus;
        @AuraEnabled public String codigoDeRechazo;
        @AuraEnabled public String analista;
        @AuraEnabled public String notasPendientesPorCatalogo;        
        @AuraEnabled public String notasPendientesLibres;
        @AuraEnabled public String codigoDeDuda;
        @AuraEnabled public String buro;
        @AuraEnabled public String telefonica;
        @AuraEnabled public String horaDeIngreso;
        @AuraEnabled public String horaDeAceptacion;
        @AuraEnabled public String horaDeRespuesta;
        @AuraEnabled public String tiempoDeResolucion;
        @AuraEnabled public String tiempoTotalDeResolucion;
        @AuraEnabled public String tipoDeTarjeta;
        @AuraEnabled public String tipoDeCredito;
        @AuraEnabled public String actualizacionMovil;
        @AuraEnabled public String actualizacionCupo;
        @AuraEnabled public String cambioDeEstado;

        public CasoBackOffice (String canalOrigen, String backgroundCSSClass, String sucursal, String idSolicitud, String aprobador, String curp, String nombreDelCliente, Decimal cupo, String estatus, String codigoDeRechazo, 
                                String analista, String notasPendientesPorCatalogo, String notasPendientesLibres, String codigoDeDuda, String buro, String telefonica, 
                                String horaDeIngreso, String horaDeAceptacion, String horaDeRespuesta, String tiempoDeResolucion, String tiempoTotalDeResolucion, String tipoDeTarjeta, String tipoDeCredito, 
                                String actualizacionMovil, String actualizacionCupo, String cambioDeEstado) {

            this.canalOrigen = canalOrigen;
            this.backgroundCSSClass = backgroundCSSClass;
            this.sucursal = sucursal;
            this.idSolicitud = idSolicitud;
            this.aprobador = aprobador;
            this.curp = curp;
            this.nombreDelCliente = nombreDelCliente;
            this.cupo = cupo;
            this.estatus = estatus;
            this.codigoDeRechazo = codigoDeRechazo;
            this.analista = analista;
            this.notasPendientesPorCatalogo = notasPendientesPorCatalogo;            
            this.notasPendientesLibres = notasPendientesLibres;
            this.codigoDeDuda = codigoDeDuda;
            this.buro = buro;
            this.telefonica = telefonica;
            this.horaDeIngreso = horaDeIngreso;
            this.horaDeAceptacion = horaDeAceptacion;
            this.horaDeRespuesta = horaDeRespuesta;
            this.tiempoDeResolucion = tiempoDeResolucion;
            this.tiempoTotalDeResolucion = tiempoTotalDeResolucion;
            this.tipoDeTarjeta = tipoDeTarjeta;
            this.tipoDeCredito = tipoDeCredito;
            this.actualizacionMovil = actualizacionMovil;
            this.actualizacionCupo = actualizacionCupo;
            this.cambioDeEstado = cambioDeEstado;
        }
    }
}