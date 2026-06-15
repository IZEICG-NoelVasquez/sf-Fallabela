@isTest
public with sharing class SLAconfigurationControllerTest {
    @TestSetup
    static void makeData(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

        Account newPersonAccount = new Account();
        newPersonAccount.RecordTypeID = recordTypeId;
        newPersonAccount.FirstName = 'Test FName';
        newPersonAccount.LastName = 'Test LName';
        newPersonAccount.PersonMailingStreet = 'emial@izeicg.com';
        newPersonAccount.PersonEmail = 'test@yahoo.com';
        newPersonAccount.PersonHomePhone = '1234567';
        newPersonAccount.PersonMobilePhone = '12345678';
        newPersonAccount.CURP__c = 'TEST123TEST123TEST';
        newPersonAccount.Cliente_Soriban__c = true;
        insert newPersonAccount;

        List<Case> listCasos = new List<Case>();
       
        Case newCase2 = new Case();
        newCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId();
        newCase2.Status = 'Detalle de la compra';
        newCase2.AccountId = newPersonAccount.Id;
        newCase2.Categor_a__c = 'Abono de Puntos';
        newCase2.Origin = 'Contact Center';
        listCasos.add(newCase2);
        insert listCasos;
    }
    @IsTest
    static void SLAconfigurationControllerTest(){
    Case caseInserted =  [select id,Subcategor_a_Texto__c, RecordTypeId, Origin from Case limit 1];
        Test.startTest();
        SLAconfigurationController.assingInitialSlaConfiguration(new list<Case>{caseInserted});
        Test.stopTest();
        
    }
}