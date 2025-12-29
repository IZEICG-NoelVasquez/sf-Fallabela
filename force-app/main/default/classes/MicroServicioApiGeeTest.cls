/**
* Nombre: MicroServicioApiGeeTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/06/2021      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioApiGeeTest {

    @isTest static void getDocumentApiGee_Success() {

        String body = '{"DocumentInfo":{"documentId":"123","status":{"statusId":"200","statusDescription":"Documento electronico encontrado"}},"document":{"fileUrl":"","fileBase64":"test123"}}';

        MockHttpResponseGeneratorApiGee mockMSApiGee = new MockHttpResponseGeneratorApiGee();
        mockMSApiGee.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSApiGee);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioApiGee.getDocumentApiGee( '01', '123', false);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getDocumentApiGee_Error() {

        MockHttpResponseGeneratorApiGee mockMSApiGee = new MockHttpResponseGeneratorApiGee();
        mockMSApiGee.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockMSApiGee);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioApiGee.getDocumentApiGee( '01', '123', false);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void getDocumentApiGee_Catch() {

        MockHttpResponseGeneratorApiGee mockMSApiGee = new MockHttpResponseGeneratorApiGee();
        mockMSApiGee.setBody('');
        Test.setMock(HttpCalloutMock.class, mockMSApiGee);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioApiGee.getDocumentApiGee( '01', '123', false);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }
}