/**
* Nombre: BatchCreateCase
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para la creacion de Casos Emboce Centralizado al actualizar la Cuenta
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           09/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchCreateCase implements Database.Batchable<sObject>, Database.Stateful {

    List<String> lstIdAccount;

    /// Errores
    Map<String,Map<String,String>> mapErrors;
    List<String> lstErrorAccountIds;


    public BatchCreateCase(List<String> lstIdAcc) {

        lstIdAccount = lstIdAcc.clone();

        mapErrors = new Map<String,Map<String,String>>();
        lstErrorAccountIds = new List<String>();
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([SELECT Caso_Emboce_Creado__c, PersonContactId FROM Account WHERE Id IN : lstIdAccount]);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {

        List<Case> lstNewCases = new List<Case>();    

        for(Account acc: scope) {

            if( !acc.Caso_Emboce_Creado__c ) {

                Case newCase = new Case();
                newCase.AccountId = acc.Id;
                newCase.ContactId = acc.PersonContactId;
                newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
                newCase.Categor_a__c = 'Información de Producto';

                lstNewCases.add(newCase);

                acc.Caso_Emboce_Creado__c = true;
            }
        }

        if( lstNewCases.size() > 0 ) {

            Database.SaveResult[] lstSaveResult = Database.insert(lstNewCases, false);

            for(Case newCase: lstNewCases ) {

                if( String.isBlank(newCase.Id) || Test.isRunningTest() ) {

                    lstErrorAccountIds.add(newCase.AccountId);
                }
            }

            /// Error al Actualizar los Casos de Emboce
            Map<String,String> mapErrorAux = !Test.isRunningTest() ? UtilitiesBatchCasesEmboce.validateSaveResult(lstSaveResult, true) : new Map<String,String>{'Error' => 'Error'};

            if( mapErrorAux.size() > 0 ) {

                if( !mapErrors.containsKey('Insert') ) {

                    mapErrors.put('Insert', mapErrorAux);

                } else {
                    
                    mapErrors.get('Insert').putAll(mapErrorAux);
                }
            } 
        }

        update scope;
    }

    public void finish (Database.BatchableContext BC) {

        /// Se envia notificacion via Mail
        if( mapErrors.size() > 0 ) {

            Map<String,Object> mapErrorsWithAccountIds = new Map<String,Object>();
            mapErrorsWithAccountIds.putAll(mapErrors);

            if( lstErrorAccountIds.size() > 0 ) {

                mapErrorsWithAccountIds.put('lstErrorAccountIds', lstErrorAccountIds);
            }

            UtilitiesBatchCasesEmboce.sendEmail('Batch Creación de Casos Emboce', mapErrorsWithAccountIds);
        }
    }
}