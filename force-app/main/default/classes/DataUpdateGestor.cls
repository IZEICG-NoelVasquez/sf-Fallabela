/**
* Nombre: DataUpdateGestor
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning DataUpdateGestor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           01/02/2022      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
public class DataUpdateGestor {

    /*
    * Obtiene el registro de Casos, el nombre del perfil y el Metadata con el numero de intentos permitidos para la actualizacion
    * Regresa un Mapa con la informacion
    *
    * @param recordId: id del registro de Casos
    */
    @AuraEnabled
    public static Map<String,Object> getCaseInfo(String recordId) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        List<Case> lstCase = [SELECT N_mero_de_Tel_fono_M_vil__c, 
                                        Cupo__c, 
                                        Apellido_s_Anonimo__c, 
                                        Nombre_s_Anonimo__c, 
                                        Contrato_Anonimo__c, 
                                        RecordType.DeveloperName, 
                                        Status, 
                                        Se_bloqueo_la_tarjeta__c, 
                                        Cuenta_al_Corriente__c, 
                                        C_digo_Postal_Direcci_n_Otros__c, 
                                        (SELECT API_Name__c, Numero_de_intento__c FROM Historial_de_Cambios__r ORDER BY Numero_de_intento__c DESC)
                                FROM Case WHERE Id =: recordId];

        List<User> lstUser = [SELECT Profile.Name, UserRole.DeveloperName FROM User WHERE Id =: userinfo.getUserId()];

        List<Cadena__mdt> lstDataUpdateAttempts = [SELECT Cadena__c FROM Cadena__mdt WHERE DeveloperName = 'Intentos_Actualizacion_de_Datos_Gestor' LIMIT 1];

        if( lstCase.size() > 0 && lstUser.size() > 0 ) {

            mapResult.put('caseInfo', lstCase[0]);
            mapResult.put('userProfile', lstUser[0].Profile.Name);
            mapResult.put('userRole', lstUser[0].UserRole.DeveloperName);
            mapResult.put('dataUpdateAttempts', lstDataUpdateAttempts.size() > 0 ? Integer.valueOf(lstDataUpdateAttempts[0].Cadena__c) : 0);

            success = true;
        }

        mapResult.put('success', success);

        return mapResult;
    }

    /**
    * Llamado el Micro Servicio para la actualizacion de datos (Telefono Movil, Limite de Credito)
    * Regresa un mapa con variables booleanas de exito para cada actualizacion
    *
    * @param mapFields: mapa con los parametros para la actualizacion
    **/
    @AuraEnabled
    public static Map<String, Object> dataUpdateMS(Map<String, String> mapFields) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean updateMobilePhone = false;
        Boolean updateCreditLimitEvaluaciones = false;
        Boolean updateCreditLimitCustom = false;

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();
        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

        /// Actualizacion del Telefono Movil
        if( mapFields.containsKey('mobilePhone') ) {

            if( mapFields.containsKey('telefonoId') && String.isNotBlank( mapFields.get('telefonoId') ) ) {

                Map<String,Object> mapResponseTelefonos = new Map<String,Object>();
                mapResponseTelefonos = MicroServicioDataUpdateGestor.updateGestorTelefonos(msDataUpdate, mapFields);

                Map<String,Object> mapValidateResponseTelefonos = MicroServicioDataUpdateGestor.validateResponse(mapResponseTelefonos);
                updateMobilePhone = Boolean.valueOf(mapValidateResponseTelefonos.get('success'));

                if( !Boolean.valueOf(mapValidateResponseTelefonos.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseTelefonos.get('lstErrorLog') );
                }
            }            
        }

        /// Actualizacion del Limite de Credito
        if( mapFields.containsKey('creditLimit') ) {

            if( mapFields.containsKey('evaluacionId') && String.isNotBlank( mapFields.get('evaluacionId') ) ) {
                
                /// Actualizacion de Evaluaciones
                Map<String,Object> mapResponseEvaluaciones = new Map<String,Object>();
                mapResponseEvaluaciones = MicroServicioDataUpdateGestor.updateGestorEvaluaciones(msDataUpdate, mapFields);

                Map<String,Object> mapValidateResponseEvaluaciones = MicroServicioDataUpdateGestor.validateResponse(mapResponseEvaluaciones);
                updateCreditLimitEvaluaciones = Boolean.valueOf(mapValidateResponseEvaluaciones.get('success'));

                if( !Boolean.valueOf(mapValidateResponseEvaluaciones.get('success')) ) {

                    lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseEvaluaciones.get('lstErrorLog') );
                }

                if( mapFields.containsKey('customId') && String.isNotBlank( mapFields.get('customId') ) ) {

                    /// Actualizacion de Custom
                    Map<String,Object> mapResponseCustom = new Map<String,Object>();
                    mapResponseCustom = MicroServicioDataUpdateGestor.updateGestorCustom(msDataUpdate, mapFields);

                    Map<String,Object> mapValidateResponseCustom = MicroServicioDataUpdateGestor.validateResponse(mapResponseCustom);
                    updateCreditLimitCustom = Boolean.valueOf(mapValidateResponseCustom.get('success'));

                    if( !Boolean.valueOf(mapValidateResponseCustom.get('success')) ) {

                        lstErrorLog.addAll( (List<Error_Log__c>)mapValidateResponseCustom.get('lstErrorLog') );
                    }
                }
            }            
        }

        /// Error Logs
        if( lstErrorLog.size() > 0 ) {

            insert lstErrorLog;
        }

        mapResult.put('updateMobilePhone', updateMobilePhone);
        mapResult.put('updateCreditLimitEvaluaciones', updateCreditLimitEvaluaciones);
        mapResult.put('updateCreditLimitCustom', updateCreditLimitCustom);

        return mapResult;
    }

    /**
    * Actualizacion del caso
    * Regresa un mapa con una variable de exito y el error en caso de existir
    *
    * @param recordId: id del registro del Caso
    * @param mapFields: mapa con los campos del Caso (Nombre de API, Valor del campo)
    **/
    @AuraEnabled
    public static Map<String, Object> updateCaseRecord(String recordId, Map<String, Object> mapFields) {

        return CreateCase.updateCaseByRT(recordId, mapFields);
    }

    /**
    * Creacion de registros del objeto Historial_de_Cambios__c
    * Regresa un mapa con una variable de exito y el error al componente Lightning
    *
    * @param lstMapFields: lista de registros de Historial_de_Cambios__c
    **/
    @AuraEnabled
    public static Map<String, Object> createCaseHistory(List<Map<String, Object>> lstMapFields) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;
        String error = '';

        try {

            List<Historial_de_Cambios__c> lstHistorialCasos = new List<Historial_de_Cambios__c>();

            for(Map<String, Object> mapFields: lstMapFields) {

                Historial_de_Cambios__c newCaseHistory = new Historial_de_Cambios__c();

                for(String strField: mapFields.keySet()) {

                    newCaseHistory.put(strField, mapFields.get(strField));
                }

                lstHistorialCasos.add(newCaseHistory);
            }

            if( lstHistorialCasos.size() > 0 ) {

                insert lstHistorialCasos;
            }

            success = true;

        } catch(DmlException exDml) {

            String msg = '';

            for (Integer i = 0; i < exDml.getNumDml(); i++) {

                msg =+ exDml.getDmlMessage(i) +  '\n';
            }

            throw new AuraHandledException(msg);

        } catch(Exception ex) {

            System.debug('ERROR: ' + ex.getMessage() + '  Linea: ' + ex.getLineNumber() );
            error = ex.getMessage();
            
            throw new AuraHandledException(ex.getMessage());
        }
        
        mapResult.put('success', success);
        mapResult.put('error', error);

        return mapResult;
    }


    @AuraEnabled
    public static Map<String,Object> submitForApproval(Map<String, String> mapFields) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        String recordId = mapFields.containsKey('recordId') ? mapFields.get('recordId') : '';

        List<Case> lstCases = [SELECT Owner.FirstName, 
                                    Owner.LastName, 
                                    CaseNumber, 
                                    ID_Solicitud__c
                            FROM Case WHERE Id =: recordId];

        List<Group> lstQueueCoordinadores = [SELECT DeveloperName FROM Group WHERE DeveloperName =: Constants.QUEUE_BO_COORDINADORES_APPROVAL_NOTIFICATION LIMIT 1 ];        

        List<CustomNotificationType> lstCustomNotification = [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName =: Constants.CUSTOM_NOTIFICATION_BO ];        

        if( lstCases.size() > 0 ) {

            ApprovalProcessService.submitForApproval(lstCases[0].Id, Constants.APPROVAL_PROCESS_BO_UPDATE_MOBILE, false, UserInfo.getUserId(), null);

            if( lstQueueCoordinadores.size() > 0 && lstCustomNotification.size() > 0 ) {

                CustomNotificationService.sendCustomNotification(new Set<String>{lstQueueCoordinadores[0].Id},
                                                            lstCases[0].Owner.FirstName + ' ' + lstCases[0].Owner.LastName + ' solicita aprobación para actualizar el teléfono celular ' ,
                                                            'Numero de Folio: ' + lstCases[0].CaseNumber + ' / Agente: ' + lstCases[0].Owner.FirstName + ' ' + lstCases[0].Owner.LastName + ' / ID Solicitud: ' + lstCases[0].ID_Solicitud__c , 
                                                            lstCustomNotification[0].Id, 
                                                            lstCases[0].Id);

                success = true;
            }
        }

        mapResult.put('success', success);

        return mapResult;
    }
}