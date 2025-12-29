/**
* Nombre: ExpedientesFalabellaTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase ExpedientesFalabella
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/06/2021      Mauricio Rosales        Creación
* 2.0           16/08/2021      Mauricio Rosales        Validar disponibilidad de reorte de buro de credito
* --------------------------------------------------------------------------
*/
@isTest
public class ExpedientesFalabellaTest {

    @isTest static void getDocumentsList() {

        Test.startTest();

        Map<String, Object> mapResult = ExpedientesFalabella.getDocumentsList();

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getDocumentApiGee() {

        Case c = new Case();
        c.ID_Solicitud__c = '123';
        c.Sucursal__c = '9999 - Oficina Central';
        insert c;

        String body = '{"DocumentInfo":{"documentId":"123","status":{"statusId":"200","statusDescription":"Documento electronico encontrado"}},"document":{"fileUrl":"","fileBase64":"test123"}}';

        MockHttpResponseGeneratorApiGee mockMSApiGee = new MockHttpResponseGeneratorApiGee();
        mockMSApiGee.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSApiGee);

        Test.startTest();

        Map<String, Object> mapResult = ExpedientesFalabella.getDocumentApiGee( '01', '123');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getDocumentBlobStorage() {

        String body = '{"code":"ok","message":{"base64TextId":"123-INEFront","base64Text":"test123"}}';

        MockHttpResponseGeneratorMicroServicios mockMSBlobS = new MockHttpResponseGeneratorMicroServicios();
        mockMSBlobS.setMethod('POST');
        mockMSBlobS.setEndpoint('onboarding/file/download');
        mockMSBlobS.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSBlobS);

        Test.startTest();

        Map<String, Object> mapResult = ExpedientesFalabella.getDocumentBlobStorage( '123', 'INEFront', 'BlobStorage');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
        System.assertEquals( mapResult.get('base64_Img'), 'test123');
    }


    @isTest static void getIdRequest() {

        String body = '{"code":"002","message":"Petición Procesada","data":[{"numero":"123","tipo_solicitud":1,"estado":6,"fecha":"test","productos":[{"id":"test123","tipo":2}]}]}';

        MockHttpResponseGeneratorGestor mockMSGestorIdSolicitud = new MockHttpResponseGeneratorGestor();
        mockMSGestorIdSolicitud.setMicroServicio('ConsultaSolicitudGestor');
        mockMSGestorIdSolicitud.setBody(body);
        mockMSGestorIdSolicitud.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockMSGestorIdSolicitud);

        Test.startTest();

        Map<String, Object> mapResult = ExpedientesFalabella.getIdRequest( 'ABCD901201HDFBCD01', '1');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getContractNumber() {

        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();  
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapResult = ExpedientesFalabella.getContractNumber('ABCD901201HDFBCD01');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getPdfCreditReport() {

        String body = '{\"code\":\"ok\",\"message\":{\"idConsulta\":\"1521122\",\"tipoReporte\":\"B\",\"reporteCredito\":\"<Persona></Persona>\",\"codigo\":\"0\",\"descripcion\":\"EL REPORTE SE CONSULTO CORRECTAMENTE\"}}';
        
        MockHttpResponseGeneratorMicroServicios mockMicroSBuro = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSBuro.setMethod('POST');
        mockMicroSBuro.setEndpoint('client/get/xml/buro/circulo');
        mockMicroSBuro.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSBuro);


        Map<String, String> params = new Map<String, String>();
		params.put('idSolicitud', '123123');
		params.put('tipoReporte', 'B');

        Test.startTest();

        BuroDeCreditoXMLJSON result = ExpedientesFalabella.getPdfCreditReport(params);

        Test.stopTest();

        System.assertEquals( result.code, 'ok');
    }
}