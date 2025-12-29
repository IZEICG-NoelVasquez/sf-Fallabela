/**
* Nombre: BatchUpdateCaseGestorBO
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para el consumo del MS Gestor Campos Restantes y update del Caso
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           29/09/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchUpdateCaseGestorBO implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    String idQueueFraudesCredito;
    List<String> lstRecordTypesBO;

    /// N Intentos de Consulta de Campos
    Integer intCallMSAttempts = Integer.valueOf(Constants.BATCH_BACKOFFICE_NUMBER_ATTEMPTS);

    /// Stateful
    List<String> lstRequestsWithError;

    public BatchUpdateCaseGestorBO() {

        idQueueFraudesCredito = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'BackOffice_Credito_Fraudes'].Id;
        String idRecordTypeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        String idRecordTypeFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();

        lstRecordTypesBO = new List<String>{idRecordTypeCredito,idRecordTypeFigital};

        lstRequestsWithError = new List<String>();
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator([SELECT ID_Solicitud__c, Solicitud_Repetida__c, Total_a_Condonar__c 
                                        FROM Case 
                                        WHERE OwnerId = : idQueueFraudesCredito
                                        AND RecordTypeId IN : lstRecordTypesBO 
                                        AND (Actualizaci_n_de_domicilio_en_SAT__c = false OR Total_a_Condonar__c < : intCallMSAttempts) ]);
    }

    public void execute(Database.BatchableContext BC, List<Case> scope) {

        List<String> lstIdSolicitud = new List<String>();

        Map<String,SolicitudGestorJSON> mapResponseGestor = new Map<String,SolicitudGestorJSON>();
        Map<String, Boolean> mapSolicitudRepetida = new Map<String, Boolean>();

        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();
       
        for(Case caso: scope) {

            ActualizarRestanteTicketRiesgoGestor msRecuperarInfo = new ActualizarRestanteTicketRiesgoGestor();
            Map<String,Object> recuperarInfo = msRecuperarInfo.recuperarInfoSolicitudMicroS(caso.ID_Solicitud__c);

            if( Boolean.valueOf(recuperarInfo.get('isSuccess')) && recuperarInfo.get('resultSolicitudGestor') != null ) {

                lstIdSolicitud.add(caso.ID_Solicitud__c);
                mapResponseGestor.put(caso.ID_Solicitud__c, (SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'));

                mapSolicitudRepetida.put(caso.ID_Solicitud__c, caso.Solicitud_Repetida__c);

                Map<String,Object> resultEliminaCampos = EliminaCamposGestor.eliminaCampos((SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'));

                if( !Boolean.valueOf(resultEliminaCampos.get('success')) && Boolean.valueOf(resultEliminaCampos.get('createErrorLog')) ) {

                    for(Error_Log__c error: (List<Error_Log__c>)resultEliminaCampos.get('lstErrorLog') ) {

                        lstErrorLog.add(error);
                    }
                }
                
            } else if( !Boolean.valueOf(recuperarInfo.get('isSuccess')) && recuperarInfo.containsKey('currentClassName') && recuperarInfo.containsKey('error') ) {

                Error_Log__c errorLog = new Error_Log__c();
                errorLog.ApexClass__c = String.valueOf( recuperarInfo.get('currentClassName') );
                errorLog.Message__c = String.valueOf( recuperarInfo.get('error') );

                lstErrorLog.add(errorLog);
            }
        }

        /// Se crean los registros de Error Log
        if( lstErrorLog.size() > 0 ) {

            insert lstErrorLog;
        }

        /// Update de los Casos (Mapeo de campos)
        if( lstIdSolicitud.size() > 0 ) {

            CrearCasosGestorBackOffice crearCasosGestor = new CrearCasosGestorBackOffice();
            crearCasosGestor.loadCatalogCM();
            crearCasosGestor.loadCaseInfo(lstIdSolicitud);

            for(String idSolicitud: mapResponseGestor.keySet() ) {

                Map<String, Object> mapUpsert = crearCasosGestor.casoUpsertRestantes( mapResponseGestor.get(idSolicitud), idSolicitud, mapSolicitudRepetida.get(idSolicitud));

                if( !Boolean.valueOf(mapUpsert.get('withoutNumberCallF2')) && (Integer.valueOf(mapUpsert.get('numberOfAttemps')) >= intCallMSAttempts ) ) {

                    lstRequestsWithError.add(idSolicitud);
                }
            }
        }
    }

    public void finish (Database.BatchableContext BC) {

        /// Envio de notificacion Mail
        if( lstRequestsWithError.size() > 0 ) {

            EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE developername = 'Batch_BO_Notificacion_x_Intentos' LIMIT 1];
            String[] toAddresses = Constants.BATCH_BACKOFFICE_EMAIL_ADDRESS.split(',');

            List<Messaging.SingleEmailMessage> lstMails =  new List<Messaging.SingleEmailMessage>();

            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id, null, null);

            email.setToAddresses(toAddresses);
            email.setSaveAsActivity(false);
            lstMails.add(email);

            Messaging.sendEmail(lstMails);
        }
    }
}