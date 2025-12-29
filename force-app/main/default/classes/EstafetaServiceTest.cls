/**
* Nombre: EstafetaServiceTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase EstafetaService
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           17/01/2023      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class EstafetaServiceTest {
    
    @isTest static void headersToken() {

        Map<String,String> mapResult;

        Test.startTest();

        mapResult = EstafetaService.headersToken();

        Test.stopTest();

        System.assertEquals(true, !mapResult.isEmpty());
    }

    @isTest static void bodyToken() {

        String result = null;

        Test.startTest();

        result = EstafetaService.bodyToken('clientId', 'clientSecret');

        Test.stopTest();

        System.assertEquals(true, String.isNotBlank(result));
    }

    @isTest static void headersCustShipmentTracking() {

        Map<String,String> mapResult;

        Test.startTest();

        mapResult = EstafetaService.headersCustShipmentTracking('clientId', 'accessToken');

        Test.stopTest();

        System.assertEquals(true, !mapResult.isEmpty());
    }

    @isTest static void bodyCustShipmentTrackingList() {

        List<String> lstWayBill = new List<String>{'wayBill'};

        String result;

        Test.startTest();

        result = EstafetaService.bodyCustShipmentTrackingList('suscriberId', 'login', 'password', lstWayBill);

        Test.stopTest();

        System.assertEquals(true, String.isNotBlank(result));
    }

    @isTest static void oauthToken() {

        Map<String,Object> mapResult;

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setBody('{"bodyTest":"test"}');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        mapResult = EstafetaService.oauthToken();

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void custShipmentTracking() {

        Map<String,Object> mapResult;

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setBody('{"bodyTest":"test"}');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        mapResult = EstafetaService.custShipmentTracking('accessToken', 'wayBill');

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void custShipmentTrackingList() {

        List<String> lstWayBill = new List<String>{'wayBill'};

        Map<String,Object> mapResult;

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setBody('{"bodyTest":"test"}');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        mapResult = EstafetaService.custShipmentTrackingList('accessToken', lstWayBill);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }
}