/**
* Nombre: PDFAclaracionesViewerControllerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase PDFAclaracionesViewerController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           28/01/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class PDFAclaracionesViewerControllerTest {

    

    @isTest static void pdfFormatoAclaraciones() {

        String urlPdf = '/apex/pdfformatoaclaraciones?id=123456789012345&t=1234567890123456';

        Test.startTest();

        String resultBase64 = PDFAclaracionesViewerController.getFormatoAclaracionesPdf(urlPdf);

        Test.stopTest();

        System.assertEquals(resultBase64, EncodingUtil.base64Encode(blob.valueOf('Test')));
    }
}