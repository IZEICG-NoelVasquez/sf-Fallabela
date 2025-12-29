@isTest
public class ApprovalProcessServiceTest {
    
    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        String rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        List<Case> lstCases = new List<Case>();

        Case case_1 = new Case();
        case_1.AccountId = acc.Id;
        case_1.ID_Solicitud__c = '12345678';
        case_1.Cupo__c = 100;
        case_1.RecordTypeId = rtCredito;
        case_1.Status = 'Asignada';
        lstCases.add(case_1);

        insert lstCases;
    }

    @isTest static void submitForApproval() {

        List<Case> lstCases = [SELECT OwnerId FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Test.startTest();

        ApprovalProcessService.submitForApproval(lstCases[0].id, Constants.APPROVAL_PROCESS_BO_UPDATE_MOBILE, false, UserInfo.getUserId(), null);

        Test.stopTest();
    }

    @isTest static void submitForApproval_Catch() {        

        Test.startTest();

        ApprovalProcessService.submitForApproval('', '', false, UserInfo.getUserId(), null);

        Test.stopTest();
    }
}