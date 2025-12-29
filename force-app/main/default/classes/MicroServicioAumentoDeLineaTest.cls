@isTest
public class MicroServicioAumentoDeLineaTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_method_1() {

        init();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Campañas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '522375******1912';
        String camposRequeridos;
        camposRequeridos = 'Origen_Campa_a__c:Correo';
        camposRequeridos += ',';
        camposRequeridos += 'Cliente_en_Base_de_Datos_de_Campa_a__c:Sí';
        camposRequeridos += ',';
        camposRequeridos += 'Cliente_acepta_aumento_l_nea_de_cr_dito__c:SI';
        
        Map<String, Object> crearCasoAumentoCupo = new Map<String, Object>();

        Test.startTest();

        crearCasoAumentoCupo = MicroServicioAumentoDeLinea.createCaseClosedAumentoCupo(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        Test.stopTest();

        System.assertEquals( crearCasoAumentoCupo.get('success'), true);
    }

    @isTest static void Consulta_Exito() {
        
        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSerConsulta = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerConsulta.setMethod('POST');
        mockMicroSerConsulta.setEndpoint('client/get/cupo');
        mockMicroSerConsulta.setMicroServicio('MicroServicioConsultaDeLinea');
        mockMicroSerConsulta.setBody('{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"OK AUMENTO CONSULTADO"},"cupo":{"cupoTotal":22000},"cupoPreAprobado":27000}}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerConsulta);

        String tipoCupo = '01';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';        

        Test.startTest();

        Map<String, Object> consultaCupo = MicroServicioAumentoDeLinea.consultaLineaDeCredito(tipoCupo, identificador, numeroDocumento);

        Test.stopTest();

        System.assertEquals( consultaCupo.get('success'), true);
    }

    @isTest static void Aumento_Exito() {     

        /// 
        MockHttpResponseGeneratorMicroServicios mockMicroSerAumento = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerAumento.setMethod('POST');
        mockMicroSerAumento.setEndpoint('producto/update/cupo');
        mockMicroSerAumento.setMicroServicio('MicroServicioAumentoDeLinea');
        mockMicroSerAumento.setBody('{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"OK"}}}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerAumento);

        String tipoCupo = '02';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';  

        String codigoProducto = '1';
        String codigoSubProducto = '010001';
        String identificadorProducto = '522375******1912';
        String codigoMoneda = '484';
        String cupoTotal = '000000001000.00';
        String nuevoCupo = '000000002000.00';

        Test.startTest();

        Map<String, Object> aumentoCupo = MicroServicioAumentoDeLinea.aumentoLineaDeCredito(tipoCupo, identificador, numeroDocumento, codigoProducto, codigoSubProducto, identificadorProducto, codigoMoneda, cupoTotal, nuevoCupo);

        Test.stopTest();

        System.assertEquals( aumentoCupo.get('success'), true);
    }

    @isTest static void Consulta_Sin_Aumento() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerConsulta = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerConsulta.setMethod('POST');
        mockMicroSerConsulta.setEndpoint('client/get/cupo');
        mockMicroSerConsulta.setMicroServicio('MicroServicioConsultaDeLinea');
        mockMicroSerConsulta.setBody('{"code":"error","message":"internal error"}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerConsulta);

        String tipoCupo = '01';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';

        Test.startTest();

        Map<String, Object> consultaCupo = MicroServicioAumentoDeLinea.consultaLineaDeCredito(tipoCupo, identificador, numeroDocumento);

        Test.stopTest();

        System.assertEquals( consultaCupo.get('success'), false);
    }

    @isTest static void Aumento_Bloqueo() {     

        /// 
        MockHttpResponseGeneratorMicroServicios mockMicroSerAumento = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerAumento.setMethod('POST');
        mockMicroSerAumento.setEndpoint('producto/update/cupo');
        mockMicroSerAumento.setMicroServicio('MicroServicioAumentoDeLinea');
        mockMicroSerAumento.setBody('{"code":"error","message":"internal error"}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerAumento);

        String tipoCupo = '02';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';  

        String codigoProducto = '1';
        String codigoSubProducto = '010001';
        String identificadorProducto = '522375******1912';
        String codigoMoneda = '484';
        String cupoTotal = '000000001000.00';
        String nuevoCupo = '000000002000.00';

        Test.startTest();

        Map<String, Object> aumentoCupo = MicroServicioAumentoDeLinea.aumentoLineaDeCredito(tipoCupo, identificador, numeroDocumento, codigoProducto, codigoSubProducto, identificadorProducto, codigoMoneda, cupoTotal, nuevoCupo);

        Test.stopTest();

        System.assertEquals( aumentoCupo.get('success'), false);
    }

    @isTest static void Consulta_Error() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerConsulta = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerConsulta.setMethod('POST');
        mockMicroSerConsulta.setEndpoint('client/get/cupo');
        mockMicroSerConsulta.setMicroServicio('MicroServicioConsultaDeLinea');
        mockMicroSerConsulta.setBody('{"code":{"example":"test"},"message":"error"}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerConsulta);

        String tipoCupo = '01';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';

        Test.startTest();

        Map<String, Object> consultaCupo = MicroServicioAumentoDeLinea.consultaLineaDeCredito(tipoCupo, identificador, numeroDocumento);

        Test.stopTest();

        System.assertEquals( consultaCupo.get('success'), false);
    }

    @isTest static void Aumento_Error() {     

        /// 
        MockHttpResponseGeneratorMicroServicios mockMicroSerAumento = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerAumento.setMethod('POST');
        mockMicroSerAumento.setEndpoint('producto/update/cupo');
        mockMicroSerAumento.setMicroServicio('MicroServicioAumentoDeLinea');
        mockMicroSerAumento.setBody('{"code":{"example":"test"},"message":"error"}');

        Test.setMock(HttpCalloutMock.class, mockMicroSerAumento);

        String tipoCupo = '02';
        String identificador = '00010252000000002850';
        String numeroDocumento = 'ABCD112233HDFABC00';  

        String codigoProducto = '1';
        String codigoSubProducto = '010001';
        String identificadorProducto = '522375******1912';
        String codigoMoneda = '484';
        String cupoTotal = '000000001000.00';
        String nuevoCupo = '000000002000.00';

        Test.startTest();

        Map<String, Object> aumentoCupo = MicroServicioAumentoDeLinea.aumentoLineaDeCredito(tipoCupo, identificador, numeroDocumento, codigoProducto, codigoSubProducto, identificadorProducto, codigoMoneda, cupoTotal, nuevoCupo);

        Test.stopTest();

        System.assertEquals( aumentoCupo.get('success'), false);
    }
}