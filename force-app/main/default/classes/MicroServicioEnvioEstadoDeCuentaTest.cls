@isTest
public class MicroServicioEnvioEstadoDeCuentaTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_method_1() {

        init();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reenv_o_de_Estado_de_Cuenta').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Estado de Cuenta';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';
        String camposRequeridos;
        camposRequeridos = 'Datos_del_cliente_son_correctos__c:SI';
        camposRequeridos += ',';
        camposRequeridos += 'Correo_actual__c:test@test.com';
        camposRequeridos += ',';
        camposRequeridos += 'Reenv_o_de_EDC__c:Sí';

        Map<String, Object> mapCase_EnvioEdoCta = MicroServicioEnvioEstadoDeCuenta.createCaseClosedEnvioEdoCta(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/send/document');
        mockMicroSer.setMicroServicio('MicroServicioEnvioEstadoDeCuenta');
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Boolean success = false;

        String contrato = '000000000000001898';
        String fechaCorte = '2021-08-24';
        String direccionCorreoElectronico = 'test@test.com';

        Map<String, Object> testEnvioEdoCta = MicroServicioEnvioEstadoDeCuenta.envioEstadoCuenta( contrato, fechaCorte, direccionCorreoElectronico);        
    }

}