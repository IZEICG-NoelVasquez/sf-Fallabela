/**
* Nombre: MicroServicioActualizacionDatosTest
* Autor: ---
* Descripcion: Test Method de la Clase MicroServicioActualizacionDatosCliente
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     ---
* 2.0           21/07/2021      Mauricio Rosales        Se agrega metodo consumir el MS y regresar los errores 
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioActualizacionDatosTest {

    @isTest static void actualizarDatosJSON2_1n() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON2_1n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON2_1n.setMethod('POST');
        mockMicroSerJSON2_1n.setEndpoint('client/information/update');
        mockMicroSerJSON2_1n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON2_1n);

        Map<String, Object> paramsJSON2_1n = new Map<String, Object>();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON2_1n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON2_1n.actualizarDatosJSON2_1n(paramsJSON2_1n);
        
        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( listError.isEmpty() , true);
    }

    @isTest static void actualizarDatosJSON2_1n_error() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON2_1n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON2_1n.setMethod('POST');
        mockMicroSerJSON2_1n.setEndpoint('client/information/update');
        mockMicroSerJSON2_1n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON2_1n.setStatusCode(400);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON2_1n);

        Map<String, Object> paramsJSON2_1n = new Map<String, Object>();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON2_1n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON2_1n.actualizarDatosJSON2_1n(paramsJSON2_1n);
        
        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void actualizarDatosJSON2_1n_catch() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON2_1n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON2_1n.setMethod('POST');
        mockMicroSerJSON2_1n.setEndpoint('client/information/update');
        mockMicroSerJSON2_1n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON2_1n.setBody(null);
        mockMicroSerJSON2_1n.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON2_1n);

        Map<String, Object> paramsJSON2_1n = new Map<String, Object>();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON2_1n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON2_1n.actualizarDatosJSON2_1n(paramsJSON2_1n);
        
        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( !listError.isEmpty() , true);
    }


    @isTest static void actualizarDatosJSON3n() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON3n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON3n.actualizarDatosJSON3n(paramsJSON3n);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( listError.isEmpty() , true);
    }

    @isTest static void actualizarDatosJSON3n_error() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON3n.setStatusCode(400);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON3n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON3n.actualizarDatosJSON3n(paramsJSON3n);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void actualizarDatosJSON3n_catch() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON3n.setBody(null);
        mockMicroSerJSON3n.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msCRJSON3n = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON actualizarDatos = msCRJSON3n.actualizarDatosJSON3n(paramsJSON3n);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( !listError.isEmpty() , true);
    }


    @isTest static void actualizarDatosString3n() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON3n.setBody('{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"Operación exitosa"}}}');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msActualizarDatosCliente = new MicroServicioActualizacionDatosCliente();        
        String actualizarDatos = msActualizarDatosCliente.actualizarDatosString3n(paramsJSON3n);

        Test.stopTest();

        System.assertEquals( actualizarDatos, '{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"Operación exitosa"}}}');
    }

    @isTest static void actualizarDatosString3n_error() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON3n.setBody('{"code":"error","message":"Invalid request data"}');
        mockMicroSerJSON3n.setStatusCode(400);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msActualizarDatosCliente = new MicroServicioActualizacionDatosCliente();        
        String actualizarDatos = msActualizarDatosCliente.actualizarDatosString3n(paramsJSON3n);

        Test.stopTest();

        System.assertEquals( actualizarDatos, '{"code":"error","message":"Invalid request data"}');
    }

    @isTest static void actualizarDatosString3n_cath() {

        MockHttpResponseGeneratorMicroServicios mockMicroSerJSON3n = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerJSON3n.setMethod('POST');
        mockMicroSerJSON3n.setEndpoint('client/information/update');
        mockMicroSerJSON3n.setMicroServicio('MicroServicioActualizacionDatosCliente');
        mockMicroSerJSON3n.setBody(null);
        mockMicroSerJSON3n.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSerJSON3n);

        Map<String, Map<String, Object > > paramsJSON3n = new Map<String, Map<String, Object > >();


        Test.startTest();

        MicroServicioActualizacionDatosCliente msActualizarDatosCliente = new MicroServicioActualizacionDatosCliente();        
        String actualizarDatos = msActualizarDatosCliente.actualizarDatosString3n(paramsJSON3n);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioActualizacionDatosCliente' LIMIT 1];
        System.assertEquals( !listError.isEmpty() , true);
    }
}