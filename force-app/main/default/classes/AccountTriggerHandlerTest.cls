/**
* Nombre: AccountTriggerHandlerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase AccountTriggerHandler
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           17/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class AccountTriggerHandlerTest {
    
    @testSetup
    static void setupData() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'AccountTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        Account acc1 = new Account();
        acc1.LastName = 'AccTest1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.Emboce_Centralizado__c = '12';
        acc1.Caso_Emboce_Creado__c = false;
        acc1.CURP__c = 'ABCD112233HDFABC01';
        insert acc1;
    }

    @isTest static void afterInsertTest() {

        Account acc2 = new Account();
        acc2.LastName = 'AccTest1';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc2.Emboce_Centralizado__c = Constants.EMBOCE_CENTRALIZADO_VALOR_CREACION_DE_CASOS;
        acc2.Caso_Emboce_Creado__c = false;
        acc2.CURP__c = 'ABCD112233HDFABC02';

        Test.startTest();

        insert acc2;

        Test.stopTest();

        List<Account> lstAccount = [SELECT Caso_Emboce_Creado__c FROM Account WHERE CURP__c = 'ABCD112233HDFABC02'];
        System.assertEquals( true, lstAccount[0].Caso_Emboce_Creado__c);
    }

    @isTest static void beforeUpdateTest() { 

        List<Account> lstAccount = [SELECT Emboce_Centralizado__c FROM Account WHERE CURP__c = 'ABCD112233HDFABC01' LIMIT 1];

        lstAccount[0].Emboce_Centralizado__c = Constants.EMBOCE_CENTRALIZADO_VALOR_CREACION_DE_CASOS;

        Test.startTest();

        update lstAccount;

        Test.stopTest();

        List<Account> lstAccountUpdated = [SELECT Caso_Emboce_Creado__c FROM Account WHERE CURP__c = 'ABCD112233HDFABC01'];
        System.assertEquals( true, lstAccountUpdated[0].Caso_Emboce_Creado__c);
    }
}