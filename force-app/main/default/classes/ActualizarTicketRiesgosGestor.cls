/**
* Nombre: ActualizarTicketRiesgosGestor
* Autor
* Descripcion: Clase controladora del Componente Lightning ActualizarTicketRiesgosCmp
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           26/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           12/03/2021      Mauricio Rosales            Ajustes para cerrar el caso al actualizar la Solicitud
* 4.0           30/08/2021      Mauricio Rosales            Validacion para codigos externos del gestor de solicitudes con pendientes de fraudes
* 5.0           31/01/2022      Mauricio Rosales            Actualizacion de solicitudes enviadas desde el componete Cambio de Estado con dictaminacion pendiente
* 6.0           16/02/2022      Mauricio Rosales            Actualizacion de Datos Gestor de Solicitudes, se mueve el llamado del Micro Servicio a la clase MicroServicioDataUpdateGestor
* --------------------------------------------------------------------------
*/
public class ActualizarTicketRiesgosGestor {

    /**
    * Llamado al Microservicio desde el componente lightning 
    * Regresa un mapa con una variable booleana de exito y la informacion de la actualizacion
    *
    * @param mapCampos: mapa con los parametros para actualizar la solicitud
    **/
    @AuraEnabled
    public static Map<String, Object> actualizarTicketGestor(Map<String, String> mapCampos) {

        ///
        String recordId = mapCampos.containsKey('recordId') ? mapCampos.get('recordId') : null;
        String evaluar = mapCampos.containsKey('evaluar') ? mapCampos.get('evaluar') : null;
        String motivoDePendiete = mapCampos.containsKey('motivoDePendiete') ? mapCampos.get('motivoDePendiete') : null;
        String IdSolicitud = mapCampos.containsKey('IdSolicitud') ? mapCampos.get('IdSolicitud') : null;
        ///
        Boolean blnPendientesCredito = mapCampos.containsKey('blnPendientesCredito') ? Boolean.valueOf( mapCampos.get('blnPendientesCredito') ) : false;
        Boolean blnPendientesFraudes = mapCampos.containsKey('blnPendientesFraudes') ? Boolean.valueOf( mapCampos.get('blnPendientesFraudes') ) : false;
        String idEvaluacionesC = mapCampos.containsKey('idEvaluacionesC') ? mapCampos.get('idEvaluacionesC') : null;
        String idEvaluacionesF = mapCampos.containsKey('idEvaluacionesF') ? mapCampos.get('idEvaluacionesF') : null;
        String idCustom = mapCampos.containsKey('idCustom') ? mapCampos.get('idCustom') : null;
        Boolean statusChangeRequest = mapCampos.containsKey('statusChangeRequest') ? Boolean.valueOf(mapCampos.get('statusChangeRequest')) : false;
        String requestStatus = mapCampos.containsKey('requestStatus') ? mapCampos.get('requestStatus') : null;
        String recordTypeDevName = mapCampos.containsKey('recordTypeDevName') ? mapCampos.get('recordTypeDevName') : null;
        String curp = mapCampos.containsKey('curp') ? mapCampos.get('curp') : null;
        String numTelefonoMovil = mapCampos.containsKey('numTelefonoMovil') ? mapCampos.get('numTelefonoMovil') : null;
        Date fechaActualizacion = mapCampos.containsKey('fechaActualizacion') ? Date.valueOf(mapCampos.get('fechaActualizacion')) : null;
        ///
        System.debug('mapCampos:  ' + System.JSON.serializePretty(mapCampos));

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Integer codStatus = 3;
        String rejected = '------';
        String pendient = '------';
        Map<String,String> mapMotivoPend = new Map<String,String>();

        Map<Integer,Integer> rMotor = new Map<Integer,Integer>();
        rMotor.put(0, 13); // Aprobacion Fraudes
        rMotor.put(1, 3); // Aprobacion Credito        
        rMotor.put(2, 15); // Rechazo Fraudes
        rMotor.put(3, 4); // Rechazo Credito
        rMotor.put(4, 14); // Pendiente Fraudes
        rMotor.put(5, 5); // Pendiente Credito

        String endpoint = '';

        MicroServicioDataUpdateGestor msActualizarTicket = new MicroServicioDataUpdateGestor();
        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

        Map<String,Object> mapResponseEvaluacionesMotor = new Map<String,Object>();
        Map<String,Object> mapValidateResponseEvaluacionesMotor = new Map<String,Object>();

        if( evaluar == 'Aprobar' ) {

            codStatus = 4;

            /// Aprobacion Fraudes (13)
            if( blnPendientesFraudes && String.isNotBlank(idEvaluacionesF) ) {
                
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesF, rMotor.get(0), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }    
            }

            /// Aprobacion Credito (5)
            if(  (blnPendientesCredito && String.isNotBlank(idEvaluacionesC) ) ) {

                    
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesC, rMotor.get(1), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }
            }

            /// Marca de Seguridad
            if( String.isNotBlank(idCustom) ) {

                Map<String,String> mapFields = new Map<String,String>();
                mapFields.put('customId', idCustom);
                mapFields.put('back_office','back_office');

                Map<String,Object> mapResponseCustom = new Map<String,Object>();
                mapResponseCustom = MicroServicioDataUpdateGestor.updateGestorCustom(msActualizarTicket, mapFields);

                Map<String,Object> mapValidateResponseCustom = MicroServicioDataUpdateGestor.validateResponse(mapResponseCustom);

                if( !Boolean.valueOf(mapValidateResponseCustom.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseCustom.get('lstErrorLog') );
                }
            }

        } else if( evaluar == 'Pendiente' ) {

            codStatus = 2;
            
            if( String.isNotBlank(motivoDePendiete) ) {
               
                List<String> motivoparts = String.isNotBlank(motivoDePendiete) ? motivoDePendiete.split(';') : null;

                if(motivoparts != null ) {

                    for (String aux : motivoparts) {
                        System.debug(aux);
                        List <String> laux= aux.split('(\\.-)');  
                        mapMotivoPend.put(laux.get(0),laux.get(1));
                    }
                }
            }

            Boolean blnCustomUpdated = false;

            /// Se actualizan las Solicitudes enviadas desde el componente Cambio de Estado

            /// Pendiente Fraudes (14)
            if( statusChangeRequest && blnPendientesFraudes && (String.isNotBlank(idEvaluacionesF)) ) {
                
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesF, rMotor.get(4), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }
            }

            /// Pendiente Credito (5)
            if( statusChangeRequest && blnPendientesCredito && (String.isNotBlank(idEvaluacionesC)) ) {
                
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesC, rMotor.get(5), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }

                /// Se actualiza detalle_respuesta_motor
                if( String.isNotBlank(idCustom) ) {

                    ///
                    Map<String,String> mapFields = new Map<String,String>();
                    mapFields.put('customId', idCustom);
                    mapFields.put('codigoOperacion', '02');
                    mapFields.put('glosaCodigoOperacion', 'Evaluacion Pendiente');
                    mapFields.put('evaluacionId', idEvaluacionesC);
                    /// Marca de Seguridad
                    mapFields.put('back_office','back_office');

                    Map<String,Object> mapResponseCustom = new Map<String,Object>();
                    mapResponseCustom = MicroServicioDataUpdateGestor.updateGestorCustom(msActualizarTicket, mapFields);

                    Map<String,Object> mapValidateResponseCustom = MicroServicioDataUpdateGestor.validateResponse(mapResponseCustom);

                    if( !Boolean.valueOf(mapValidateResponseCustom.get('success')) ) {

                        lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseCustom.get('lstErrorLog') );
                    }

                    blnCustomUpdated = true;
                }
            }

            /// Marca de Seguridad
            if( !blnCustomUpdated && String.isNotBlank(idCustom) ) {

                Map<String,String> mapFields = new Map<String,String>();
                mapFields.put('customId', idCustom);
                mapFields.put('back_office','back_office');

                Map<String,Object> mapResponseCustom = new Map<String,Object>();
                mapResponseCustom = MicroServicioDataUpdateGestor.updateGestorCustom(msActualizarTicket, mapFields);

                Map<String,Object> mapValidateResponseCustom = MicroServicioDataUpdateGestor.validateResponse(mapResponseCustom);

                if( !Boolean.valueOf(mapValidateResponseCustom.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseCustom.get('lstErrorLog') );
                }
            }

        } else if( evaluar == 'Rechazar'  ) {

            codStatus = 7;

            /// Rechazo Fraudes (15)
            if( blnPendientesFraudes && (String.isNotBlank(idEvaluacionesF)) ) {
                
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesF, rMotor.get(2), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }
            }

            /// Rechazo Credito (4)
            if( blnPendientesCredito && (String.isNotBlank(idEvaluacionesC)) ) {
                
                mapResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.updateEvaluacionesMotor( idEvaluacionesC, rMotor.get(3), msActualizarTicket);
                mapValidateResponseEvaluacionesMotor = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluacionesMotor);

                if( !Boolean.valueOf(mapValidateResponseEvaluacionesMotor.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluacionesMotor.get('lstErrorLog') );
                }
            }

            /// Marca de Seguridad
            if( String.isNotBlank(idCustom) ) {

                Map<String,String> mapFields = new Map<String,String>();
                mapFields.put('customId', idCustom);
                mapFields.put('back_office','back_office');

                Map<String,Object> mapResponseCustom = new Map<String,Object>();
                mapResponseCustom = MicroServicioDataUpdateGestor.updateGestorCustom(msActualizarTicket, mapFields);

                Map<String,Object> mapValidateResponseCustom = MicroServicioDataUpdateGestor.validateResponse(mapResponseCustom);

                if( !Boolean.valueOf(mapValidateResponseCustom.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseCustom.get('lstErrorLog') );
                }
            }
        }
        
        endpoint = 'solicitud/'+IdSolicitud;
        Map<String, Integer> mapEstado =  new Map<String,Integer>();
        mapEstado.put('estado',codStatus );
        String bodyrequest  =JSON.serialize(mapEstado); 
        // Se actualiza el estado de la Solicitud
        Map<String,Object> mapResponseEstado = new Map<String,Object>();
        mapResponseEstado = msActualizarTicket.actualizarTicket(bodyrequest, endpoint ,true);

        Map<String,Object> mapValidateResponseEstado = MicroServicioDataUpdateGestor.validateResponse(mapResponseEstado);

        if( !Boolean.valueOf(mapValidateResponseEstado.get('success')) ) {

            lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEstado.get('lstErrorLog') );
        }

        /// SMS FIGITAL
        if( (recordTypeDevName == 'BackOffice_Figital') && String.isNotBlank(curp) && String.isNotBlank(numTelefonoMovil) && (numTelefonoMovil.length() > 9) ) {

            Boolean blnAprobado = evaluar == 'Aprobar' ? true : false;

            Datetime dtFechaActualizacion = fechaActualizacion.addDays(90);
            String strDay = dtFechaActualizacion.formatGmt('dd');
            String strMonth = Constants.MAP_MONTHS.get(dtFechaActualizacion.monthGMT());

            MicroServicioSendNotification.sendNotification( Constants.MS_SENDNOTIFICATION_TIPO_SMS, 
                                            blnAprobado ? Constants.MS_SENDNOTIFICATION_FIGITAL_SMS_APROBADO_1.left(1) : Constants.MS_SENDNOTIFICATION_FIGITAL_SMS_RECHAZO.left(1), 
                                            blnAprobado ? Constants.MS_SENDNOTIFICATION_FIGITAL_SMS_APROBADO_1.substring(1) + ' ' + strDay + strMonth : Constants.MS_SENDNOTIFICATION_FIGITAL_SMS_RECHAZO.substring(1), 
                                            numTelefonoMovil.right(10) , Constants.MS_SENDNOTIFICATION_CODIGO_AREA_MX, curp, false);
        }
       
        // Motivo de pendiente.
        endpoint='observaciones/';
        Map<String,Object> mapResponseObservaciones = new Map<String,Object>();
        Map<String,Object> mapValidateResponseObservaciones = new Map<String,Object>();
         
        for (String key : mapMotivoPend.keySet()) {

            Map<String, String> mapObservaciones =  new Map<String,String>();
            // The "key" variable is also available inside the loop
            JSONGenerator gen = JSON.createGenerator(true);
            String glosa = mapMotivoPend.get(key);
            Integer tipo=1;
            if(key == '13.0' || key == '27.0'){
                tipo=2;
            }
            gen.writeStartObject();
            gen.writeStringField('solicitud_id', IdSolicitud);
            gen.writeStringField('glosa', glosa);
            gen.writeNumberField('tipo', tipo);
            gen.writeStringField('codigo', key);
            gen.writeStringField('origen', 'back-office');
            gen.writeEndObject();
        
            // Get the JSON string.
            bodyrequest = gen.getAsString();
            mapResponseObservaciones = msActualizarTicket.actualizarTicket(bodyrequest, endpoint,false);
            mapValidateResponseObservaciones = MicroServicioDataUpdateGestor.validateResponse(mapResponseObservaciones);

            if( !Boolean.valueOf(mapValidateResponseObservaciones.get('success')) ) {

                lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseObservaciones.get('lstErrorLog') );
            }
        }
      
        GenericResponseGestorJson  actualizarEstado = Boolean.valueOf(mapValidateResponseEstado.get('success')) ? (GenericResponseGestorJson)mapResponseEstado.get('resultGenericResponseGestor') : null;

        if( actualizarEstado != null ) {

            if( actualizarEstado.code == '001' ) {

                List<Case> listCasos = [SELECT Actualizaci_n_Alta_en_SAT__c, Status FROM Case WHERE Id =: recordId];

                if( listCasos.size() > 0 ) {

                    listCasos[0].Actualizaci_n_Alta_en_SAT__c = true;
                    listCasos[0].Status = 'Cerrado';

                    update listCasos;
                }
                success = true;
            }  
        } 

        /// Historial del Caso para Solicitudes de Cambio de Estado        
        if( statusChangeRequest ) {

            Map<String,String> mapEstadoSolicitudGestor = new Map<String,String>();

            String strCodStatus = String.valueOf(codStatus);

            for(Estado_Solicitud_Gestor__mdt estadoSol: [SELECT MasterLabel, glosa__c FROM Estado_Solicitud_Gestor__mdt WHERE MasterLabel =: strCodStatus ] ) {

                mapEstadoSolicitudGestor.put(estadoSol.MasterLabel, estadoSol.glosa__c);
            }
         
            List<Map<String, Object>> lstMapFields = new List<Map<String, Object>>();
            Map<String, Object> mapCaseHistory = new Map<String, Object>();
            mapCaseHistory.put('Caso__c', recordId);
            mapCaseHistory.put('Name', 'Estatus');
            mapCaseHistory.put('Valor_nuevo__c', mapEstadoSolicitudGestor.containsKey(strCodStatus) ? mapEstadoSolicitudGestor.get(strCodStatus) : '' );
            mapCaseHistory.put('Valor_original__c', requestStatus);
            mapCaseHistory.put('API_Name__c', 'Estatus__c');

            lstMapFields.add(mapCaseHistory);

            DataUpdateGestor.createCaseHistory(lstMapFields);
        }

        if( lstErrorLog.size() > 0 ) {

            insert lstErrorLog;
        }

        result.put('success', success);
        result.put('actualizarTicket', actualizarEstado);
        return result;
    }    

    
    /*
    * Obtiene el nombre del perfil, el Id del usuario actual y el registro de Casos
    * Regresa un Mapa con una variable booleana de exito, la informacion del Perfil y el registro del Caso
    *
    * @param recordId: id de la Solicitud
    */
    @AuraEnabled
    public static Map<String, Object> getUserInfo(String recordId) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        List<User> listUsr = [SELECT Profile.Name FROM User WHERE Id =: userinfo.getUserId()];

        List<Case> listCasos = [SELECT Evaluar__c,
                                        Motivo_de_Pendiente__c,
                                        Id_Solicitud_Gestor__c,
                                        Actualizaci_n_Alta_en_SAT__c,
                                        Se_bloqueo_la_tarjeta__c,
                                        OwnerId,
                                        Publicidad__c,
                                        Validar_Movimientos__c,
                                        RecordType.DeveloperName,
                                        Apellido_s_Anonimo__c,
                                        Oficina_Anonimo__c,
                                        Nombre_s_Anonimo__c, 
                                        Solicitud_de_cancelaci_n__c, 
                                        Estatus__c, 
                                        CURP__c, 
                                        N_mero_de_Tel_fono_M_vil__c, 
                                        Fecha_de_actualizaci_n__c 
                                FROM Case WHERE Id =: recordId];


        if( listUsr.size() > 0 && listCasos.size() > 0 ) {

            mapResult.put('userProfile', listUsr[0].Profile.Name);
            mapResult.put('userId', listUsr[0].Id);

            ///
            mapResult.put('caso', listCasos[0]);

            success = true;
        }

        mapResult.put('success', success);
        
        return mapResult;
    }
}