@isTest
public  class MicroServicioActualizaicionCorreoTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_method_1() {

        init();

        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Correo').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos;
        camposRequeridos = 'Actualizaci_n_Alta__c:Actualización';
        camposRequeridos += ',';
        camposRequeridos += 'Correo_actual__c:test@test.com';
        camposRequeridos += ',';
        camposRequeridos += 'Correo_Actualizado_Microservicio__c:true';
        
        Map<String, Object> crearCasoActualizarCorreo = MicroServicioActualizaicionCorreo.createCaseClosedEmail(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        Account accTest = MicroServicioActualizaicionCorreo.updateSelectedAccount(customer.Id);
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('direccionCorreoElectronico', 'test@test.com');
        campos.put('numeroDocumento', 'numeroDocumento');

        Map<String, Object> actualizaCorreo = MicroServicioActualizaicionCorreo.actualizarEmail(campos);
    }
}