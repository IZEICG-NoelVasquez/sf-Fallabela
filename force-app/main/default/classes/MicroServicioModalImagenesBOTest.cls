/**
* Nombre: MicroServicioModalImagenesBOTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioModalImagenesBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           26/11/2020      Mauricio Rosales            Ajustes para consumir los MicroServicios de Falabella.
* 3.0           22/06/2021      Mauricio Rosales            Se agrega llamado al MicroServio ApiGee
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioModalImagenesBOTest {

    @isTest static void descargaImgBlobStorage() {

        String body = '{"code":"ok","message":{"base64TextId":"123-INEFront","base64Text":"test123"}}';

        MockHttpResponseGeneratorMicroServicios mockMSBlobS = new MockHttpResponseGeneratorMicroServicios();
        mockMSBlobS.setMethod('POST');
        mockMSBlobS.setEndpoint('onboarding/file/download');
        mockMSBlobS.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSBlobS);

        String idSolicitud = '123';
        String link = 'INEFront';
        String microServicio = 'BlobStorage';

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioModalImagenesBO.descargarImagen(idSolicitud, link, microServicio);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
        System.assertEquals( mapResult.get('base64_Img'), 'test123');
    }

    @isTest static void descargaImgWistonData() {

        String body = '{"code":"ok","message":{"fileUrl":"","fileBase64":"test123"}}';

        MockHttpResponseGeneratorMicroServicios mockMSWistonD = new MockHttpResponseGeneratorMicroServicios();
        mockMSWistonD.setMethod('POST');
        mockMSWistonD.setEndpoint('integracion/file/download');
        mockMSWistonD.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSWistonD);

        String idSolicitud = '123';
        String link = '01';
        String microServicio = 'WistonData';

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioModalImagenesBO.descargarImagen(idSolicitud, link, microServicio);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
        System.assertEquals( mapResult.get('base64_Img'), 'test123');
    }

    @isTest static void descargaError() {

        MockHttpResponseGeneratorMicroServicios mockMSBlobS = new MockHttpResponseGeneratorMicroServicios();
        mockMSBlobS.setMethod('POST');
        mockMSBlobS.setEndpoint('onboarding/file/download');
        mockMSBlobS.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockMSBlobS);

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('blob', new Map<String, String>() );
        params.get('blob').put('base64TextId', '123-INEFront');

        MicroServicioModalImagenesBO msModalImg = new MicroServicioModalImagenesBO();
        msModalImg.MicroServicioBlobStorage();

        Test.startTest();        

        msModalImg.descargarImagenMS(params);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioModalImagenesBO'];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void descargaCatch() {

        MockHttpResponseGeneratorMicroServicios mockMSBlobS = new MockHttpResponseGeneratorMicroServicios();
        mockMSBlobS.setMethod('POST');
        mockMSBlobS.setEndpoint('onboarding/file/download');
        mockMSBlobS.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockMSBlobS);

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('blob', new Map<String, String>() );
        params.get('blob').put('base64TextId', '123-INEFront');

        MicroServicioModalImagenesBO msModalImg = new MicroServicioModalImagenesBO();
        msModalImg.MicroServicioBlobStorage();

        Test.startTest();        

        msModalImg.descargarImagenMS(params);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioModalImagenesBO'];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void pdfReporte() {

        String urlReporte = '/apex/PDFReporteDeCredito?tipoReporte=B&idSolicitud=1521122';

        Test.startTest();

        String resultBase64 = MicroServicioModalImagenesBO.getPDFReporteBuro(urlReporte);

        Test.stopTest();

        System.assertEquals(resultBase64, EncodingUtil.base64Encode(blob.valueOf('Test')));
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

        Map<String, Object> mapResult = MicroServicioModalImagenesBO.getDocumentApiGee( '01', '123');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }
}