@isTest
public class CustomNotificationServiceTest {

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
    
    @isTest static void sendCustomNotification() {

        List<CustomNotificationType> lstCustomNotification = [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName =: Constants.CUSTOM_NOTIFICATION_BO ];

        List<Case> lstCases = [SELECT OwnerId FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Test.startTest();

        CustomNotificationService.sendCustomNotification(new Set<String>{lstCases[0].OwnerId}, 'Test', 'Test', lstCustomNotification[0].Id, lstCases[0].Id);

        Test.stopTest();
    }
    
    @isTest
    static void sendCustomNotificationTarget(){
        Map<String, Object> pageRef = new Map<String, Object>{
                                           'type' => 'standard__objectPage',
                                           'attributes' => new Map<String, Object>{
                                                   'objectApiName' => 'Campaign',
                                                   'actionName' => 'list'}, 
                                            'state' => new Map<String, Object>{
                                                    'filterName' => 'Todas_las_campa_as'} };
       List<CustomNotificationType> typeId = [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName =: Constants.CUSTOM_NOTIFICATION_BO ];

       Test.startTest();
        CustomNotificationService.sendCustomNotificationPageRef(new Set<String>{UserInfo.getUserId()}, 'title', 'body', typeId[0].id, JSON.serialize(pageRef));
       Test.stopTest();       
        
    }
}