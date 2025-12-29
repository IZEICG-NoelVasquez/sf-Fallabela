@isTest
public class DeleteCampaignsTest {
    @testSetup
    static void setup(){
        Id recType =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        List<Account>lstCon= new List<Account>();
        for(Integer i=10; i<100; i++){
            Account con= new Account();
            con.RecordTypeId=recType;
            con.lastName='Apellido'+i;
            con.CURP__c='CACC000101MDFCCC'+i;
            lstCon.add(con);
        }
        insert lstCon;
        
        Campaign cam= new Campaign();
        cam.Name='Campaña';
        cam.Prioridad__c='1';
        insert cam;
        
        List<CampaignMember> members= new List<CampaignMember>();
        for(Contact  cont:[Select id from Contact]){
            CampaignMember member= new CampaignMember();
            member.ContactId =cont.id;
            member.CampaignId=cam.id;
            members.add(member);
        }
        insert members;        
    }
    
    @isTest
    static void deleteCampaigns(){
        List<Campaign> cam=[Select id from Campaign];
        test.startTest();
        DeleteCampaignsInvocable.deleteCampaign(new List<String>{cam[0].id});
        test.stopTest();
        cam=[Select id from Campaign];
        assert.areEqual(0, cam.size());
        
        
    }

}