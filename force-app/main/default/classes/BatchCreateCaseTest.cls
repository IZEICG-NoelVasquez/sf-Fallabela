/**
* Nombre: BatchCreateCaseTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchCreateCase
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           16/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchCreateCaseTest {
    
    @testSetup
    static void setupData() {

        Account acc1 = new Account();
        acc1.LastName = 'AccTest1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.Emboce_Centralizado__c = '15';
        acc1.Caso_Emboce_Creado__c = false;
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest 
    static void BatchCreateCase_Success() {

        List<String> lstIdAccounts = new List<String>();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE Emboce_Centralizado__c = '15' AND Caso_Emboce_Creado__c = false];

        for(Account acc: lstAccounts) {

            lstIdAccounts.add(acc.Id);
        }

        Test.startTest();

        BatchCreateCase batchApex = new BatchCreateCase(lstIdAccounts);
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Account> lstAccountsResult = [SELECT Id FROM Account WHERE Emboce_Centralizado__c = '15' AND Caso_Emboce_Creado__c = false];
        System.assertEquals(true, lstAccountsResult.size() == 0 );
    }
}