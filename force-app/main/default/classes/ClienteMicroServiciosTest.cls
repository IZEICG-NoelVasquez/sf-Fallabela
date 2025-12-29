/**
* Nombre: ClienteMicroServiciosTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase ClienteMicroServicios
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           25/06/2021      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ClienteMicroServiciosTest {

    @isTest static void setMicroServicio() {

        Test.startTest();

        ClienteMicroServicios clientMS = new ClienteMicroServicios();
        clientMS.setEndpoint('test');
        clientMS.setMethod('GET');
        clientMS.setVersion('v0');

        Test.stopTest();

        System.assertEquals( clientMS.cm.Channel__c, 'Web');
        System.assertEquals( clientMS.endpoint, 'test');
        System.assertEquals( clientMS.method, 'GET');
        System.assertEquals( clientMS.version, 'v0');
    }

    @isTest static void generarToken() {

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        clientMS.generarToken();

        Test.stopTest();

        System.assertEquals( clientMS.access_token, 'test');
    }

    @isTest static void obtenerURLENDPOINT() {

        ClienteMicroServicios clientMS = new ClienteMicroServicios();
        clientMS.cm.Ambiente__c = null;

        Test.startTest();
        
        String url = clientMS.obtenerURLENDPOINT();

        Test.stopTest();

        System.assertEquals( url, 'https://cmr-mx-business.fif.tech/api/business/v1/backend/products');
    }

    @isTest static void crearRequest() {

        Map<String, String> params = new Map<String,String>();
        params.put('param1', 'param1');

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        HttpRequest req = clientMS.crearRequest(params);

        Test.stopTest();

        System.assertEquals( req.getBody(), '{"param1":"param1"}');
    }

    @isTest static void crearRequest_v2() {

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('param1', new Map<String,String>{'param1' => 'param1'} );

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        HttpRequest req = clientMS.crearRequest_v2(params);

        Test.stopTest();

        System.assertEquals( req.getBody(), '{"param1":{"param1":"param1"}}');
    }

    @isTest static void crearRequest_v2_1() {

        Map<String, Object> params = new Map<String, Object>();
        params.put('param1', 'param1');

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        HttpRequest req = clientMS.crearRequest_v2_1(params);

        Test.stopTest();

        System.assertEquals( req.getBody(), '{"param1":"param1"}');
    }

    @isTest static void crearRequest_v3() {

        Map<String, Map<String, Object> > params = new Map<String, Map<String, Object> >();
        params.put('param1', new Map<String,Object>{'param1' => 'param1'});

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        HttpRequest req = clientMS.crearRequest_v3(params);

        Test.stopTest();

        System.assertEquals( req.getBody(), '{"param1":{"param1":"param1"}}');
    }

    @isTest static void crearRequestFigital() {

        Map<String, String> params = new Map<String,String>();
        params.put('param1', 'param1');

        ClienteMicroServicios clientMS = new ClienteMicroServicios();
        clientMS.setMicroServicio('MicroServicioIncodeStart');

        Test.startTest();
        
        HttpRequest req = clientMS.crearRequestFigital(params, 'token123');

        Test.stopTest();

        System.assertEquals( req.getBody(), '{"param1":"param1"}');
    }

    @isTest static void addDateHour() {

        HttpRequest reqParam = new HttpRequest();

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        HttpRequest req = clientMS.addDateHour(reqParam, '01-12-2020', '12:00:00');

        Test.stopTest();

        System.assertEquals( req.getHeader('mdw-cs-date'), '01-12-2020');
        System.assertEquals( req.getHeader('mdw-cs-hour'), '12:00:00');
    }

    @isTest static void enviarRequest() {

        String body = '{"bodyTest":"test"}';

        MockHttpResponseGeneratorMicroServicios mockMSBloqueo = new MockHttpResponseGeneratorMicroServicios();
        mockMSBloqueo.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSBloqueo);

        Map<String, String> params = new Map<String,String>();
        params.put('param1', 'param1');

        ClienteMicroServicios clientMS = new ClienteMicroServicios();
        HttpRequest req = clientMS.crearRequest(params);

        Test.startTest();
        
        HttpResponse response = clientMS.enviarRequest(req);

        Test.stopTest();

        System.assertEquals( response.getBody(), '{"bodyTest":"test"}');
    }

    @isTest static void logError() {

        ClienteMicroServicios clientMS = new ClienteMicroServicios();

        Test.startTest();
        
        clientMS.logError('apexClassTest', 'Message__c');

        Test.stopTest();

        List<Error_Log__c> lstError = [SELECT ApexClass__c, Message__c FROM Error_Log__c WHERE CreatedDate = TODAY LIMIT 1];

        System.assertEquals( lstError[0].Message__c, 'Message__c');
    }
}