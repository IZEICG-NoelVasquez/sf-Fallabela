/**
* Nombre: MicroServicioModalImagenesBO
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning MicroServicioModalImagenesBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           13/11/2020      Mauricio Rosales            Ajustes para consumir los MicroServicios de Falabella. Se elimina codigo para los servicios de Admision
* 3.0           18/01/2021      Mauricio Rosales            Al agregar nuevos archivos en Custom Metadata, los Motivos de Pendiente y Solicitud Repetida se configuran en Metadata
* 4.0           18/06/2021      Mauricio Rosales            Se agrega llamado al MicroServio ApiGee
* --------------------------------------------------------------------------
*/
public class MicroServicioModalImagenesBO {

    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String ENDPOINTBLOBSTORAGE = 'onboarding/file/download';
    private static final String ENDPOINTWISTONDATA = 'integracion/file/download';
    private static final String MICROSBLOBSTORAGE = 'MicroServicioImgBlobStorage';
    private static final String MICROSWISTONDATA = 'MicroServicioImgWistonData';

    /**
    * Se setean los parametros en la clase cliente para el MicroServicio BlobStorage
    **/
    public void MicroServicioBlobStorage() {

        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(ENDPOINTBLOBSTORAGE);
        cliente.setMicroServicio(MICROSBLOBSTORAGE);
        cliente.generarToken();
    }

    /**
    * Se setean los parametros en la clase cliente para el MicroServicio WistonData
    **/
    public void MicroServicioWistonData() {

        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(ENDPOINTWISTONDATA);
        cliente.setMicroServicio(MICROSWISTONDATA);
        cliente.generarToken();
    }

    /**
    * Llamado al MicroServicio para Consulta de Imagenes. Se invoca la clase cliente 
    * Se regresa el String que devuelve el MicroServicio
    *
    * @param params: Map de 2 niveles para enviar los parametro al MicroServicio
    **/
    public String descargarImagenMS(Map<String, Map<String, String> > params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v2(params);
        Boolean isSuccess = false;
        String result;

        System.debug('descargarImagenMS req ' + req);

        try {   
			
            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());
            
            if (isSuccess) {

                result = res.getBody();

            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {

            cliente.logError(currentClassName, e.getMessage());   
            System.debug('ERROR:  ' + e.getMessage() + '  LINEA:  ' + e.getLineNumber() );
        }

        return result;
    }

    /**
    * Llamado al Microservicio desde el componente lightning, se identifica a que MicroServico se esta invocando 
    * y se arma la estructura con los parametros correspondientes
    * Devuelve un mapa con una variable booleana de exito y la imagen codificada en base64
    *
    * @param idSolicitud: id de la Solicitud de Credito
    * @param link: nombre del archivo con el que se identifica la imagen en el MicroServicio
    * @param microServicio: parametro para indentificar a que servicio se esta llamando (WistonData o BlobStorage)
    **/
    @AuraEnabled
    public static Map<String, Object> descargarImagen(String idSolicitud, String link, String microServicio) {

        Map<String,Object> result = new Map<String, Object>();
        Boolean success = false;
        String base64_Img = null;

        System.debug('idSolicitud:  ' + idSolicitud);
        System.debug('link:  ' + link);
        System.debug('microServicio:  ' + microServicio);

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();

        MicroServicioModalImagenesBO msDescargarImg = new MicroServicioModalImagenesBO();

        if( microServicio == 'BlobStorage' ) {

            params.put('blob', new Map<String, String>() );
            params.get('blob').put('base64TextId', idSolicitud + link);

            msDescargarImg.MicroServicioBlobStorage();
            BlobStorageJSON blobStorage = null;

            try {

                blobStorage = BlobStorageJSON.parse( msDescargarImg.descargarImagenMS(params) );

            } catch(Exception ex) {

                System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            }
            

            if( blobStorage != null ) {

                base64_Img = blobStorage.message.base64Text;
                success = true;
            }

        } else if( microServicio == 'WistonData' ) {

            params.put('gestor', new Map<String, String>() );
            params.get('gestor').put('solicitud', idSolicitud);
            params.get('gestor').put('documentSubTypeId', link);

            msDescargarImg.MicroServicioWistonData();
            WistonDataJSON wistonData = null;

            try {

                wistonData = WistonDataJSON.parse( msDescargarImg.descargarImagenMS(params) );

            } catch(Exception ex) {

                System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            }

            if( wistonData != null ) {

                base64_Img = wistonData.message.fileBase64;
                success = true;
            }
        }

        result.put('success', success);
        result.put('base64_Img', base64_Img);
        return result;
    }

    /**
    * Llamado a la pagina Visualforce para generar el Reporte de Credito en formato pdf
    * Se regresa el pdf en formato base64
    *
    * @param urlReporte: url de la pagina Visualforce
    **/
    @AuraEnabled
    public static String getPDFReporteBuro(String urlReporte){
        
        String resultPDF = '';
        System.debug('urlReporte:  ' + urlReporte);
        PageReference pdfReporteBuro = new PageReference(urlReporte);

        resultPDF = !Test.isRunningTest() ? EncodingUtil.base64Encode(pdfReporteBuro.getContent()) : EncodingUtil.base64Encode(blob.valueOf('Test'));

        return resultPDF;
    }


    /**
    * Llamado al MicroServicio ApiGee para obtener el documento en Base64
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param documentSubTypeId: nombre del archivo con el que se identifica el documento en el MicroServicio
    * @param idRequest: id Solicitud para la consulta del Expediente
    **/
    @AuraEnabled
    public static Map<String, Object> getDocumentApiGee(String documentSubTypeId, String idRequest) {

        System.debug('MicroservicioModalImagenesBO.cls - getDocumentApiGee: ' + idRequest);
        
        Boolean msv2 = false;
        
        try {
            Case sucuCase = [SELECT Sucursal__c FROM Case WHERE ID_Solicitud__c = :idRequest]; // obtiene el nombre de la sucursal en el caso
        
            if(sucuCase.Sucursal__c != null){
                List<String> splitSucuCase = sucuCase.Sucursal__c.split('- ');
                String sucu = splitSucuCase.size() == 1? splitSucuCase[0] : splitSucuCase[1];
                List<Sucursal_Gestor__mdt> sucuStatus = [SELECT glosa__c, msV2__c FROM Sucursal_Gestor__mdt WHERE glosa__c = :sucu]; // obtiene si la sucursal está activa en el meta para la v2

                if(sucuStatus.size() > 0 && sucuStatus[0].msV2__c){
                    msv2 = true;
                    System.debug('Estatus sucursal: ' + sucuStatus[0].glosa__c + ': ' + sucuStatus[0].msV2__c);
                }  
            }
        } catch (Exception e) {
            msV2 = true;
            System.debug('No se encontró un caso, se consultará la msV2: ' + msv2);
            System.debug('Catch CURP: ' + idRequest + ' Error: ' + e);
        }

        return MicroServicioApiGee.getDocumentApiGee(documentSubTypeId, idRequest, msv2);
    }
}