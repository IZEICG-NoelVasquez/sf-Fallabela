/**
* Nombre: GuiaDHLTriggerHandlerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase GuiaDHLTriggerHandler
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           30/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class GuiaDHLTriggerHandlerTest {
    
    @testSetup
    static void setupData() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'GuiaDHLTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        Account acc1 = new Account();
        acc1.LastName = 'AccTest1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.CURP__c = 'ABCD112233HDFABC01';
        insert acc1;
    }

    @isTest static void afterInsertTest() {

        List<Account> lstAccounts = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC01' LIMIT 1];

        Guia_DHL__c guia = new Guia_DHL__c();
        guia.Cuenta__c = lstAccounts[0].Id;
        guia.Name = '1234567890123456789012';
        guia.ID_Guia__c = '1234567890123456789012';

        Test.startTest();

        insert guia;

        Test.stopTest();
    }
}