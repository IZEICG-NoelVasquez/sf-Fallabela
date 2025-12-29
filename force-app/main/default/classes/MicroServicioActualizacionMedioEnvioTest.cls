@isTest
public class MicroServicioActualizacionMedioEnvioTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }
    @isTest static void test_method_1() {

        init();
        
        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Medio_Env_o').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Estado de Cuenta';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';
        String camposRequeridos;
        camposRequeridos = 'Datos_del_cliente_son_correctos__c:SI';
        camposRequeridos += ',';
        camposRequeridos += 'Medio_de_env_o_de_estado_de_cuenta_selec__c:Email';
        camposRequeridos += ',';
        camposRequeridos += 'Se_actualizo_el_medio_de_env_o__c:SI';
        camposRequeridos += ',';
        camposRequeridos += 'Actualizaci_n_Alta_en_SAT__c:true';
        camposRequeridos += ',';
        camposRequeridos += 'Medio_de_Env_o_Actualizado_Microservicio__c:true';

        Map<String, Object> mapCaseMedioEnvio = MicroServicioActualizacionMedioEnvio.createCaseClosedMedioEnvio(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );
    }

    @isTest static void test_method_2() {

        ///
        MockHttpResponseGeneratorMicroServicios mockMedioEnvio = new MockHttpResponseGeneratorMicroServicios();
        mockMedioEnvio.setMethod('POST');
        mockMedioEnvio.setEndpoint('product/address/update');        
        Test.setMock(HttpCalloutMock.class, mockMedioEnvio);
        Map<String, Object> mapMedioEnvio = MicroServicioActualizacionMedioEnvio.actualizarMedioDeEnvio('00010252000000001352', 'true');
    }
}