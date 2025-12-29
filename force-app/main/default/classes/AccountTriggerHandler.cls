/**
* Nombre: AccountTriggerHandler
* Autor: Mauricio Rosales
* Descripcion: Clase Handler del Trigger AccountTrigger
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public with sharing class AccountTriggerHandler extends TriggerHandler {

    public override void afterInsert() {

        ///
        System.debug('Trigger Account - afterInsert');
        
        createCasesEmboce((Map<Id, Account>)Trigger.newMap);
    }

    public override void beforeUpdate() {

        ///
        System.debug('Trigger Account - beforeUpdate');

        createCasesEmboce((Map<Id, Account>)Trigger.newMap);
    }

    public void createCasesEmboce(Map<Id, Account> mapAccounts) {

        List<String> lstIdAccountEmboce = new List<String>();

        for(Account acc: mapAccounts.values() ) {

            if( AccountTriggerHelper.validateEmboce(mapAccounts.get(acc.Id)) ) {

                lstIdAccountEmboce.add(acc.Id);
            }
        }

        if( lstIdAccountEmboce.size() > 0 ) {

            BatchCreateCase batchApex = new BatchCreateCase(lstIdAccountEmboce);
            Database.executeBatch(batchApex, 50);
        }
    }
    
}