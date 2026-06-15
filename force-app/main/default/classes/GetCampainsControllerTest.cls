@isTest
public with sharing class GetCampainsControllerTest {
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

    }
    @IsTest
    static void GetCampainsControllerTest(){
   MockHttpResponseGeneratorApiGee mockMSApiGee = new MockHttpResponseGeneratorApiGee();
        String body = '{"access_token": "3232323231", "token_type": "Test1"}';

        mockMSApiGee.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSApiGee);
       Account  acc =[ select id from Account limit 1];
        Test.startTest();
        GetCampainsController.getCampains(acc.Id);
        Test.stopTest();
        
    }
}