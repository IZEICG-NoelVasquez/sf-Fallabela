/**
* Nombre: BatchUpdateCasesEmboceNumFolio
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para actualizar el campo Num_Folio_a_Consultar__c de los Casos Emboce Centralizado, al cargar los registros del Objeto Guia_DHL__c
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           21/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchUpdateCasesEmboceNumFolio implements Database.Batchable<sObject>, Database.Stateful {

    String query;

    Integer intAddDaysFechaEstimadaDeEntrega = Integer.valueOf(System.Label.EMBOCE_CENTRALIZADO_FECHA_ESTIMADA_DE_ENTREGA);

    String businessHoursId;

    /// Errores
    Map<String,Map<String,String>> mapErrors;
    

    public BatchUpdateCasesEmboceNumFolio() {

        Integer numDays = Integer.valueOf(System.Label.EMBOCE_CENTRALIZADO_BATCH_NUM_GUIA_DIAS_QUERY);

        query = 'SELECT ID_Guia__c, Cuenta__c, Caso_de_Emboce_Actualizado__c ' +
                'FROM Guia_DHL__c ' +
                'WHERE CreatedDate = LAST_N_DAYS:' + numDays + ' ' +
                'AND Caso_de_Emboce_Actualizado__c = false ' +
                'LIMIT 50000';

        List<BusinessHours> lstBusinessHours = [SELECT Id FROM BusinessHours WHERE Name = 'Horario Laboral' LIMIT 1];
        businessHoursId = lstBusinessHours.size() > 0 ? lstBusinessHours[0].Id : null;

        mapErrors = new Map<String,Map<String,String>>();
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator(query);
    }    

    public void execute(Database.BatchableContext BC, List<Guia_DHL__c> scope) {

        List<Case> lstCasesToUpdate = new List<Case>();

        ///
        Map<String, Guia_DHL__c> mapAccountGuia = new Map<String, Guia_DHL__c>();
        for(Guia_DHL__c guia: scope ) {

            mapAccountGuia.put(guia.Cuenta__c, guia);
        }

        String caseIdEmboce = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();

        List<Account> lstAccounts = [SELECT Id, 
                                            (SELECT Num_Folio_a_Consultar__c, Fecha_de_Recepci_n__c, CreatedDate, Status 
                                            FROM Cases WHERE RecordTypeId =: caseIdEmboce 
                                            AND Status NOT IN ('Cerrado','Cancelado')
                                            ORDER BY CreatedDate DESC LIMIT 1 )
                                    FROM Account 
                                    WHERE Caso_Emboce_Creado__c = true 
                                    AND Id IN : mapAccountGuia.keySet()];

        Set<String> setUpdatedAccountIds = new Set<String>();

        for(Account acc: lstAccounts ) {

            if( acc.Cases.size() > 0 && mapAccountGuia.containsKey(acc.Id) ) {

                acc.Cases[0].Num_Folio_a_Consultar__c = mapAccountGuia.get(acc.Id).ID_Guia__c;

                /// 10 (horas laborables) * 60 * 60 * 1000 (minutos, segundos, milisegundos)
                acc.Cases[0].Fecha_de_Recepci_n__c = String.isNotBlank(businessHoursId) ? (BusinessHours.add(businessHoursId, acc.Cases[0].CreatedDate, intAddDaysFechaEstimadaDeEntrega * 10 * 60 * 60 * 1000L)).date() : acc.Cases[0].CreatedDate.date().addDays(intAddDaysFechaEstimadaDeEntrega);
                acc.Cases[0].Status = 'Asignada';

                lstCasesToUpdate.add(acc.Cases[0]);

                /// Se guarda el Id de la Cuenta, para actualizar la Guia
                setUpdatedAccountIds.add(acc.Id);
            }
        }

        if( lstCasesToUpdate.size() > 0 ) {

            Database.SaveResult[] lstSaveResult = Database.update(lstCasesToUpdate, false);

            /// Error al Actualizar los Casos de Emboce
            Map<String,String> mapErrorAux = !Test.isRunningTest() ? UtilitiesBatchCasesEmboce.validateSaveResult(lstSaveResult, false) : new Map<String,String>{'Error' => 'Error'};
            if( mapErrorAux.size() > 0 ) {

                if( !mapErrors.containsKey('DML') ) {

                    mapErrors.put('DML', mapErrorAux);

                } else {

                    mapErrors.get('DML').putAll(mapErrorAux);
                }
            }
            
            for(Guia_DHL__c guia: scope ) {

                if( setUpdatedAccountIds.contains(guia.Cuenta__c) ) {
                    
                    guia.Caso_de_Emboce_Actualizado__c = true;
                }
            }
    
            update scope;
        }        
    }

    public void finish(Database.BatchableContext BC) {

        /// Se envia notificacion via Mail
        if( mapErrors.size() > 0 ) {

            UtilitiesBatchCasesEmboce.sendEmail('Batch Actualización de Casos Emboce', mapErrors);
        }
    }
}