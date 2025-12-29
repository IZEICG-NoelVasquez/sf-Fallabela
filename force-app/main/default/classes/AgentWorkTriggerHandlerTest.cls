@isTest
public class AgentWorkTriggerHandlerTest {

    @testSetup
    static void setupData() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'AgentWorkTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        caso.OwnerId = UserInfo.getUserId();
        insert caso;      
        
        /*ServicePresenceStatus servicePS = [SELECT Id FROM ServicePresenceStatus WHERE DeveloperName = 'Disponible' ];

        UserServicePresence userSP = new UserServicePresence();
        userSP.UserId = UserInfo.getUserId();
        userSP.ServicePresenceStatusId = servicePS.Id;
        insert userSP;*/
    }

    @isTest static void test_method_1() {

        ServiceChannel serviceCh = [SELECT Id FROM ServiceChannel WHERE DeveloperName = 'Case_Channel' LIMIT 1];
        User userTest = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() ];
        Case caso = [SELECT Id FROM Case WHERE Account.LastName = 'Test112233' LIMIT 1];

        System.runAs(userTest) {

            AgentWork aw = new AgentWork();
            aw.ServiceChannelId = serviceCh.Id;
            aw.WorkItemId = caso.Id;
            aw.UserId = userTest.Id;
            Database.insert(aw, false);

            Test.startTest();

            Database.update(aw, false);

            Test.stopTest();
        }
    }
}