/**
* Nombre: CreacionCasosBackOffice
* Autor
* Descripcion: Clase controladora del Componente Lightning CreacionCasosBackOffice
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           12/01/2022      Mauricio Rosales            Integarcion con el Gestor de Solicitudes
* 3.0           25/02/2022      Mauricio Rosales            Validacion de Solicitudes con Rechazo de Fraudes
* --------------------------------------------------------------------------
*/
public class CreacionCasosBackOffice {

    private static final String QUEUE_CREDITO = 'Riesgos_Falabella';
    private static final String QUEUE_FIGITAL = 'BackOffice_Figital';

    /**
    * Metodo para consultar el MicroServicio Consulta de campos restantes y la creacion de caso
    * Regresa una mapa con una variable de exito y los pendientes de fraudes y credito 
    *
    * @param campos: response del MicroServicio
    **/
    @AuraEnabled
    public static Map<String, Object> crearCasoBackOffice(Map<String, String> campos) {

        Map<String, Object> result = new Map<String, Object>();

        Boolean success = false;

        String errorMessage = '';

        String idSolicitud;
        String caseId = '';

        System.debug('campos:  ' + campos);

        WSCreateDataBO createData = new WSCreateDataBO(null, null, null, null, null, null, null);

        idSolicitud = campos.containsKey('cardapplicationid') ? campos.get('cardapplicationid') : '';
        createData.cardapplicationid = Integer.valueOf( idSolicitud );

        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

        ActualizarRestanteTicketRiesgoGestor msRecuperarInfo = new ActualizarRestanteTicketRiesgoGestor();
        Map<String,Object> recuperarInfo = msRecuperarInfo.recuperarInfoSolicitudMicroS(idSolicitud);

        /// Se encontro la Solicitud en el Gestor
        if( Boolean.valueOf(recuperarInfo.get('isSuccess')) && recuperarInfo.get('resultSolicitudGestor') != null ) {

            Map<String,Object> mapSearchF2 = searchNumeroLlamadaF2((SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'));

            /// Se valida que la solicitud no este Formalizada
            if( !Boolean.valueOf( mapSearchF2.get('blnEstadoFormalizada') ) ) {

                /// Se busca numero_llamada = F2 
                if(  Boolean.valueOf( mapSearchF2.get('blnNumeroLlamadaF2') )  ) {                

                    /// Se eliminan las Observaciones del Gestor
                    Map<String,Object> resultEliminaCampos = EliminaCamposGestor.eliminaCampos((SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'));
                        
                    /// Errores al eliminar Observaciones en el Gestor
                    if( !Boolean.valueOf(resultEliminaCampos.get('success')) && Boolean.valueOf(resultEliminaCampos.get('createErrorLog')) ) {

                        for(Error_Log__c error: (List<Error_Log__c>)resultEliminaCampos.get('lstErrorLog') ) {

                            lstErrorLog.add(error);
                        }
                    }

                    /// Se crea la solicitud
                    Map<String, Object> mapResultCreacion = CrearCasosGestorBackOffice.casoUpsertCreacion(createData, idSolicitud);
                    caseId = String.valueOf( mapResultCreacion.get('idCaso') );

                    if( Boolean.valueOf(mapResultCreacion.get('success')) ) {

                        /// Se cargan los catalogos de los Custom Metadata y los registros relacionados al caso
                        CrearCasosGestorBackOffice crearCasosGestor = new CrearCasosGestorBackOffice();
                        crearCasosGestor.loadCatalogCM();
                        crearCasosGestor.loadCaseInfo( new List<String>{idSolicitud} );

                        /// Se actualizan los campos restantes del Caso
                        Map<String, Object> mapResultUpsertRestantes = crearCasosGestor.casoUpsertRestantes( (SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'), idSolicitud, Boolean.valueOf(mapResultCreacion.get('blnCasoReenviado')) );

                        ///
                        Map<String,Object> mapFields = new Map<String,Object>();
                        mapFields.put('ownerCredito', mapResultUpsertRestantes.get('ownerCredito'));
                        mapFields.put('queueFigital', mapResultUpsertRestantes.get('queueFigital'));
                        mapFields.put('caseId', mapResultCreacion.get('idCaso'));
                        mapFields.put('dataUpdateValue', campos.get('dataUpdateValue'));
                        mapFields.put('commetsValue', campos.get('commetsValue'));

                        Map<String,Object> mapValidatePendings = validatePendings(mapFields);
                        
                        success = Boolean.valueOf(mapResultUpsertRestantes.get('success')) && Boolean.valueOf(mapValidatePendings.get('success'));
                    } 

                /// No se encontro numero_llamada = F2
                } else {
                    
                    errorMessage = 'No_se_encontro_numero_llamada_f2';
                }

            /// La Solcitud ya se encuentra Formalizada
            } else {

                errorMessage = 'Solicitud_formalizada';
            }

        /// No se encontro la Solicitud en el Gestor
        } else if( !Boolean.valueOf(recuperarInfo.get('isSuccess')) ) {

            errorMessage = 'No_se_encontro_la_solicitud';
        }

        /// Se crean los Error Logs
        if( lstErrorLog.size() > 0 ) {

            insert lstErrorLog;
        }

        result.put('success', success);
        result.put('errorMessage', errorMessage);

        return result;
    }

    /**
    * Valida si el campo es nulo
    * Regresa una variable de exito 
    *
    * @param field: campo a validar
    **/
    public static Boolean validateObjectNullValue(Object field) {

        return field != null ? true : false;
    }

    /**
    * Metodo para buscar en el response del MicroServicio el campo numero_llamada == 'F2'
    * Regresa una variable de exito 
    *
    * @param responseGestor: response del MicroServicio
    **/
    public static Map<String,Object> searchNumeroLlamadaF2(SolicitudGestorJSON responseGestor) {

        Map<String,Object> mapResult = new Map<String,Object>();

        Boolean blnNumeroLlamadaF2 = false;
        Boolean blnEstadoFormalizada = false;
        String keyEvaluacionFraudes = '';
        String keyEvaluacionCredito = '';

        /// Estado de la Solicitud
        if( validateObjectNullValue(responseGestor.data) && validateObjectNullValue(responseGestor.data.solicitud) && validateObjectNullValue(responseGestor.data.solicitud.estado) ) {

            if( responseGestor.data.solicitud.estado == 6 ) {

                blnEstadoFormalizada = true;
            }
        }

        /// EVALUACIONES
        if ( !blnEstadoFormalizada && validateObjectNullValue(responseGestor.data) && validateObjectNullValue(responseGestor.data.solicitud) &&
            validateObjectNullValue(responseGestor.data.solicitud.custom) && validateObjectNullValue(responseGestor.data.solicitud.custom.data) &&
            validateObjectNullValue(responseGestor.data.solicitud.custom.data.evaluaciones) ) {

            for (String keyEvaluacion: responseGestor.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.keySet()) {

                SolicitudGestorJSON.Evaluacion_ID evaluacionID = responseGestor.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.get(keyEvaluacion);

                /// Fraudes
                if ( validateObjectNullValue(evaluacionID.numero_llamada) ) {

                    if (evaluacionID.numero_llamada == 'F2') {

                        ///
                        keyEvaluacionFraudes = keyEvaluacion;
                        blnNumeroLlamadaF2 = true;
                    }
                }

                /// Credito
                if( validateObjectNullValue(evaluacionID.detalle_respuesta_motor) ) {

                    keyEvaluacionCredito = keyEvaluacion;
                }
            }
        }

        mapResult.put('blnNumeroLlamadaF2', blnNumeroLlamadaF2);
        mapResult.put('blnEstadoFormalizada', blnEstadoFormalizada);
        mapResult.put('keyEvaluacionFraudes', keyEvaluacionFraudes);
        mapResult.put('keyEvaluacionCredito', keyEvaluacionCredito);

        return mapResult;
    }

    /**
    * Valida los pendientes del Gestor con los que se ingresaron en el componente
    * Regresa un Mapa con los pendientes de Fraudes y Credito
    *
    * @param mapFields: mapa con los parametros para validar los pendientes de Fraudes y Credito
    **/
    public static Map<String,Object> validatePendings(Map<String,Object> mapFields) {

        Map<String,Object> mapResult = new Map<String,Object>();

        Boolean success = false;        

        Boolean ownerCredito = Boolean.valueOf( mapFields.get('ownerCredito') );
        Boolean queueFigital = Boolean.valueOf( mapFields.get('queueFigital') );
        String dataUpdateValue = String.valueOf( mapFields.get('dataUpdateValue') );
        String commetsValue = String.valueOf( mapFields.get('commetsValue') );
        String caseId = String.valueOf( mapFields.get('caseId') );        

        Map<String, Id> mapGrupos = new Map<String, Id>();
        List<String> listNombreGrupos = new List<String>{QUEUE_CREDITO,QUEUE_FIGITAL};

        Case updateCase = new Case();
        updateCase.Id = caseId;

        /// Se envia a la Queue de BackOffice o Figital
        if( !ownerCredito ) {                

            for (Group grupo: [SELECT DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN : listNombreGrupos] ) {

                if (!mapGrupos.containsKey(grupo.DeveloperName)) {

                    mapGrupos.put(grupo.DeveloperName, grupo.Id);
                }
            }

            ///
            updateCase.OwnerId = queueFigital ? mapGrupos.get(QUEUE_FIGITAL) : mapGrupos.get(QUEUE_CREDITO);
        }

        ///
        if( String.isNotBlank(commetsValue) ) {

            updateCase.Comentarios__c = commetsValue;
        }

        if( String.isNotBlank(dataUpdateValue) ) {

            updateCase.C_digo_Postal_Direcci_n_Otros__c = dataUpdateValue;
        }
        
        updateCase.Solicitud_de_cancelaci_n__c = true;

        try {            
                
            update updateCase;
            success = true;

        } catch(Exception ex) {

            System.debug('Error:  ' + ex.getMessage() + '  Linea:  ' + ex.getLineNumber() );
        }

        mapResult.put('success', success);

        return mapResult;
    }
}