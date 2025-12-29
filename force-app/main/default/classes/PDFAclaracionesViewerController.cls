/**
* Nombre: PDFAclaracionesViewerController
* Autor: Mauricio Rosales
* Descripcion: Controlador Apex del Componente Lightning PDFAclaracionesViewer
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           26/01/2021       Mauricio Rosales           Creación
* --------------------------------------------------------------------------
*/
public class PDFAclaracionesViewerController {

    /*
    * Obtiene el PDF Formato Aclaraciones
    * Regresa el archivo PDF codificado en Base64
    *
    * @param urlPDF: URL de la Visualforce PdfFormatoAclaraciones
    */
    @AuraEnabled
    public static String getFormatoAclaracionesPdf(String urlPdf) {

        String resultPdf = '';

        System.debug('urlPdf:  ' + urlPdf);

        PageReference formatoAclaracionesPdf = new PageReference(urlPdf);

        resultPdf = !Test.isRunningTest() ? EncodingUtil.base64Encode(formatoAclaracionesPdf.getContent()) : EncodingUtil.base64Encode(blob.valueOf('Test'));

        return resultPdf;
    }
}