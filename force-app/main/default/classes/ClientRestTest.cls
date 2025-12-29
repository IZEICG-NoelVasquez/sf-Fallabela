/**
* Nombre: ClientRestTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase ClientRest
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           17/01/2023      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ClientRestTest {

    @isTest static void callWebService() {

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking');        

        HttpRequest request = new HttpRequest();

        /// Http Mock
        MockHttpResponseGeneratorApiGee mockHttp = new MockHttpResponseGeneratorApiGee();
        mockHttp.setBody('{"bodyTest":"test"}');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Map<String,Object> mapResult;

        Test.startTest();

        mapResult = client.callWebService(request);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void callWebServiceError() {

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking');        

        HttpRequest request = new HttpRequest();

        /// Http Mock
        MockHttpResponseGeneratorApiGee mockHttp = new MockHttpResponseGeneratorApiGee();
        mockHttp.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Map<String,Object> mapResult;

        Test.startTest();

        mapResult = client.callWebService(request);

        Test.stopTest();

        System.assertEquals(false, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void makeRequest() {

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking');

        Map<String,String> mapHeaders = new Map<String,String>{'headerTest' => 'test'};

        HttpRequest request;

        Test.startTest();

        request = client.makeRequest('https://test.com.mx', 'POST', mapHeaders, '{"param1":"test"}');

        Test.stopTest();

        System.assertEquals('{"param1":"test"}', request.getBody());
    }

    @isTest static void makeResponse() {

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking');

        HttpRequest request = new HttpRequest();

        /// Http Mock
        MockHttpResponseGeneratorApiGee mockHttp = new MockHttpResponseGeneratorApiGee();
        mockHttp.setBody('{"bodyTest":"test"}');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        HttpResponse response;

        Test.startTest();

        response = client.makeResponse(request);

        Test.stopTest();

        System.assertEquals('{"bodyTest":"test"}', response.getBody());
    }
}