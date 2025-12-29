@isTest
public class AuthenticateCampaniasControllerTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_method_1() {

        init();

        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        System.debug('person.Id:  ' + person.Id);

        List<CampaignMember> listCampaign = AuthenticateCampaniasController.obtenerCampaignsCliente(person.Id);

        ///
        Map<String, String> mapParametrosCampanias = AuthenticateCampaniasController.configuracionAumentoDeLinea();
    }
}