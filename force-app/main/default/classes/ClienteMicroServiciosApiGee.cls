/**
* Nombre: ClienteMicroServiciosApiGee
* Autor: Mauricio Rosales
* Descripcion: Clase Cliente para el consumo del MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           07/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class ClienteMicroServiciosApiGee {

    private final String BASE_URL = 'https://integracion-cmrmx';
    private final String URI = '.fif.tech/';
    private String endpoint = '';
    private String method = '';
    private String idRequest = '';
    private final Integer TIME_OUT = 120000;

    /// APIGee Token
    public final String X_API_KEY = 'x-api-key';
    public final String AUTHORIZATION = 'Authorization';
    public final String CONTENT_TYPE = 'Content-Type';
    public final String APP_URLENCODED = 'application/x-www-form-urlencoded';
    public final String GRANT_TYPE = 'grant_type';
    public final String CLIENT_CREDENTIALS = 'client_credentials';
    private String access_token;
    private final String BEARER = 'Bearer';
    /// APIGee GetDocument
    public final String X_CHANNEL = 'X-channel';
    public final String X_COMMERCE = 'X-commerce';
    public final String X_COUNTRY = 'X-country';
    public final String DOCUMENT_SUBTYPEID = 'documentSubTypeId';

    ///
    private Configuracion_MicroServicio_APIGEE__mdt cmApiGee;
    private String microServicio = '';


    public ClienteMicroServiciosApiGee() {

        ///
    }

    /**
    * Setea el End Point del MicroServicio
    *
    * @param endpoint: end point del MicroServicio
    **/
    public void setEndpoint(String endpoint) {

        if( String.isNotBlank(cmApiGee.Ambiente__c) ) {

            this.endpoint = BASE_URL + '-' + cmApiGee.Ambiente__c + URI + endpoint;

        } else {

            this.endpoint = BASE_URL + URI + endpoint;
        }
    }

    /**
    * Setea el Metodo del MicroServicio (POST o GET)
    *
    * @param method: metodo del MicroServicio
    **/
    public void setMethod(String method) {
        
        this.method = method;
    }
  /**
    * Setea el Metodo del MicroServicio (POST o GET)
    *
    * @param idRequest: id request  del MicroServicio v2 
    **/
    public void setIdRequest(String idRequest) {
        
        this.idRequest = idRequest;
    }
    /**
    * Consulta al Custom Metadata Configuracion_MicroServicio_APIGEE__mdt
    *
    * @param microServicio: nombre del registro
    **/
    public void setMicroServicio(String microServicio) {
        
        this.microServicio = microServicio;

        cmApiGee = [SELECT Ambiente__c, 
                                        X_api_key__c, 
                                        Consumerkey__c, 
                                        ConsumerSecret__c, 
                                        X_channel__c, 
                                        X_commerce__c, 
                                        X_country__c 
                                FROM Configuracion_MicroServicio_APIGEE__mdt 
                                WHERE Label =: microServicio LIMIT 1];
    }

    /**
    * Genera el Token 
    **/
    public void generateToken() {

        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setTimeout(TIME_OUT);        

        req.setHeader(X_API_KEY, cmApiGee.X_api_key__c);
        req.setHeader(AUTHORIZATION, EncodingUtil.base64Encode(Blob.valueOf(cmApiGee.Consumerkey__c + ':' + cmApiGee.ConsumerSecret__c)) );
        req.setHeader(CONTENT_TYPE, APP_URLENCODED);

        req.setBody(GRANT_TYPE + '=' + CLIENT_CREDENTIALS);

        HttpResponse res;

        if( !Test.isRunningTest() ) {

            res = sendRequest(req);

        } else {

            HttpResponse resMock = new HttpResponse();
            resMock.setHeader('Content-Type', 'application/json');
            resMock.setBody('{"access_token":"test"}');
            resMock.setStatusCode(200);
            res = resMock;
        }

        oAuthJSON.oAuth result = oAuthJSON.parse(res.getBody());
        this.access_token = result.access_token;
    }

    /**
    * Crea el Request del MicroServicio
    *
    * @param documentSubTypeId: nombre del archivo con el que se identifica el documento en el MicroServicio
    **/
    public HttpRequest createRequestMS(String documentSubTypeId) {
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint);
        req.setMethod(method);
        req.setTimeout(TIME_OUT);

        req.setHeader(X_CHANNEL, cmApiGee.X_channel__c);
        req.setHeader(X_COMMERCE, cmApiGee.X_commerce__c);
        req.setHeader(X_COUNTRY, cmApiGee.X_country__c);
        req.setHeader(DOCUMENT_SUBTYPEID, documentSubTypeId);
        if(endpoint.contains('document-management/v2/documents/')){
                req.setHeader('X-Document-Id', idRequest);
        }

        if (String.isNotBlank(access_token)) {
            
			req.setHeader(AUTHORIZATION, BEARER + ' ' + access_token);
        }
    system.debug('X-Document-Id'+req.getHeader('X-Document-Id'));
        return req;
    }

    /**
    * Envia la peticion al MicroServicio
    *
    * @param req: request 
    **/
    public HttpResponse sendRequest(HttpRequest req) {

        Http http = new Http();
    system.debug(req);
       
        return http.send(req);
    }

     public String getToken() {
        return this.access_token;
    }

    /**
    * Crea el registro de los errores devueltos por el MicroServicio
    *
    * @param apexClass: nombre de la Clase Apex 
    * @param message: mensaje de error 
    **/
    public void logError(String apexClass, String message) {

        Error_Log__c error = new Error_Log__c(ApexClass__c = apexClass, Message__c = message);
        insert error;
    }
}