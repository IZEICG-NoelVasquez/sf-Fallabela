/**
* Nombre: MicroServicioApiGee
* Autor: Mauricio Rosales
* Descripcion: Llamado el MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           09/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class MicroServicioApiGee {

    private ClienteMicroServiciosApiGee client;
    private static final String POST = 'POST';
    private static final String ENDPOINT_TOKEN = 'oauth/cc/token';
    private static final String GET = 'GET';
    private static final String ENDPOINT_MS = 'document-management/v1/documents/';
    private static final String ENDPOINT_MS_V2 = 'document-management/v2/documents/';
private static String token;
    public MicroServicioApiGee() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        client = new ClienteMicroServiciosApiGee();
        client.setMicroServicio(currentClassName);
        client.setMethod(POST);
        client.setEndpoint(ENDPOINT_TOKEN);
        client.generateToken();
       
    }

    /**
     * Llamado al MicroServicio ApiGee para obtener el documento en Base64.
     * Alterna entre v1 y v2 dependiendo del parámetro msV2.
     *
     * @return Regresa un JSON con la respuesta del MicroServicio.
     * @param documentSubTypeId: Nombre del archivo con el que se identifica el documento en el MicroServicio.
     * @param idRequest: ID de la solicitud para la consulta del Expediente.
     * @param msV2: Indica si debe iniciar con la versión 2 del MS.
     */
    public ApiGeeJSON msGetDocumentApiGee(String documentSubTypeId, String idRequest, Boolean msV2) {
        String currentClassName = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
        HttpResponse res;
        ApiGeeJSON result;
        String[] endpoints = msV2 ? new String[]{ENDPOINT_MS_V2, ENDPOINT_MS} : new String[]{ENDPOINT_MS, ENDPOINT_MS_V2};
        Integer maxAttempts = 6; // Total de intentos alternados entre v1 y v2

        try {
            for (Integer attempt = 0; attempt < maxAttempts; attempt++) {
                // Alternar entre los endpoints
                String currentEndpoint = endpoints[Math.mod(attempt, 2)];
                System.debug('Intento ' + (attempt + 1) + ': Usando endpoint ' + currentEndpoint);

                res = tryRequest(currentEndpoint, idRequest, documentSubTypeId);

                if (res != null && (res.getStatusCode() == 200 || res.getStatusCode() == 201)) {
                    System.debug('Solicitud exitosa en intento ' + (attempt + 1));
                    result = ApiGeeJSON.parse(res.getBody());
                    return result;
                }
            }

            // Si todos los intentos fallan
            client.logError(currentClassName, 'Todos los intentos fallaron');
        } catch (Exception e) {
            client.logError(currentClassName, e.getMessage());
        }

        return null;
    }

    /**
     * Realiza una solicitud al endpoint especificado.
     *
     * @param endpoint: URL del endpoint del microservicio.
     * @param idRequest: ID de la solicitud para incluir en la URL.
     * @param documentSubTypeId: Nombre del archivo/documento para la solicitud.
     * @return Una instancia de HttpResponse si la solicitud fue procesada, incluso si falló.
     */
    private HttpResponse tryRequest(String endpoint, String idRequest, String documentSubTypeId) {
        try {
                //// tiket 195 
              if(endpoint.contains(ENDPOINT_MS_V2)){
                client.setIdRequest(idRequest);
                String tokenRequest = client.getToken();
        
                Blob textoBlob = Blob.valueOf(idRequest+tokenRequest);
                Blob hash = Crypto.generateDigest('SHA-256', textoBlob);

                // 2. Convertir a Hex o Base64
                String hashHex = EncodingUtil.convertToHex(hash);
               
               
                // endpoint = endpoint + hashHex;
                client.setEndpoint(endpoint + hashHex);
             
            }else{
            client.setEndpoint(endpoint + idRequest);

           }
            client.setMethod(GET);
            HttpRequest req = client.createRequestMS(documentSubTypeId);
        //  system.debug(JSON.serialize(req));
            
            HttpResponse res = client.sendRequest(req);
            System.debug('Código de respuesta para ' + endpoint + ': ' + res.getStatusCode());
            return res;
        } catch (Exception e) {
            System.debug('Error en la solicitud para ' + endpoint + ': ' + e.getMessage());
            return null;
        }
    }
    /**
    * Llamado al MicroServicio ApiGee para obtener el documento en Base64
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param documentSubTypeId: nombre del archivo con el que se identifica el documento en el MicroServicio
    * @param idRequest: id Solicitud para la consulta del Expediente
    **/
    public static Map<String, Object> getDocumentApiGee(String documentSubTypeId, String idRequest, Boolean msV2) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        MicroServicioApiGee apiGee = new MicroServicioApiGee();
        ApiGeeJSON resultApiGee = apiGee.msGetDocumentApiGee(documentSubTypeId, idRequest, msV2);

        if( resultApiGee != null ) {

            success = true;
        }

        mapResult.put('success', success);
        mapResult.put('resultApiGee', resultApiGee);

        return mapResult;
    }
}