public class ClienteAdmisiones {
/*
* Las ligas de cada ambiente son:
* Calidad: http://admisionqa.falacard.com
* Produccion: http://admision.falacard.com
* ----------------ENDPOINTS--------------------------------------
* /falabella_backend/incoming/cardPreEvaluation
* /falabella_backend/incoming/getInfoCardPreEvaluation?curp=LAPD991123HDFZVR09
* /falabella_backend/incoming/updateCardPreEvaluation
* /falabella_backend/incoming/getCardPreEvaluation
*/
    //autorización [Basic]
    //private final String BASE_URL = 'http://admisionqa';
    private final String URI = '.falacard.com/';
    private String BACKEND = 'falabella_backend/';
    private String INCOMING ='incoming/';
    private String ENDPOINT = 'cardPreEvaluation';
    private String METHOD = 'POST'; 
    private final String APP_JSON = 'application/json';
    private final String CONT_TYPE = 'Content-Type';
    private final Integer TIME_OUT = 120000;

    private Configuracion_MicroServicio_Admision__mdt configMSAdmin;

    private String microServicio = 'default';
    
    // Generacion de Token
    private final String ENDPOINT_OAUTH = 'micro-documentos/oauth/token';
    private final String APP_URLENCODED = 'application/x-www-form-urlencoded';
    private final String GRANT_TYPE = 'grant_type';
    private final String PASSWORD = 'password';

    private final String AUTH = 'Authorization';
    private final String BEARER = 'Bearer';
    
    private String access_token = '';

    private final String ORIGIN = 'Origin';
    private final String SF = 'salesforce';


    public ClienteAdmisiones() {

        setConfiguracionMicroServicio(microServicio);
    }

    public void setConfiguracionMicroServicio(String microServicio) {

        configMSAdmin = [SELECT Ambiente__c, Password__c, Username__c, Password_Body__c, Username_Body__c FROM Configuracion_MicroServicio_Admision__mdt WHERE Label =: microServicio LIMIT 1 ];
        System.debug('configMSAdmin:  ' + configMSAdmin);
    }

    public void setBackEnd(String strBackEnd) {

        this.BACKEND = strBackEnd;
    }

    public void setIncoming(String strIncoming) {

        this.INCOMING = strIncoming;
    }
    
    public String getURL(){ 

        String baseURL = configMSAdmin.Ambiente__c;
        
        String URL = baseURL + URI + BACKEND + INCOMING + ENDPOINT;
        return URL;
    }
    
    public void setMethod (String method) {
        
        this.METHOD = method;
    }
    
    public void setEndpoint(String endpoint){
        
        this.ENDPOINT  = endpoint;
    }

    /// Generacion de Token para el WS de Imagenes
    public void generarToken() {

        String baseURL = configMSAdmin.Ambiente__c;

        String url = baseURL + URI + ENDPOINT_OAUTH;

        String userNameBody = configMSAdmin.Username_Body__c;
        String passwordBody = configMSAdmin.Password_Body__c;

        String strParams = GRANT_TYPE + '=' + PASSWORD;
        strParams += '&username=' + EncodingUtil.urlEncode(userNameBody,'UTF-8');
        strParams += '&password=' + EncodingUtil.urlEncode(passwordBody,'UTF-8');

        System.debug('strParams:  ' + strParams);

        HttpRequest req = crearRequest(url, strParams, true);

        HttpResponse res;
        
        //req.setEndpoint(url);
        if( !Test.isRunningTest() ) {
            res = sendRequest(req);
        } else {
            HttpResponse resMock = new HttpResponse();
            resMock.setHeader('Content-Type', 'application/json');
            resMock.setBody('{"example":"test"}');
            resMock.setStatusCode(200);
            res = resMock;
        }
        
        oAuthJSON.oAuth result = oAuthJSON.parse(res.getBody());
        
        System.debug('res token ' + res.getBody());
        
        this.access_token = result.access_token;
    }

    public HTTPResponse doRequest_v1(String json){
        //Para este request se utilizará autorización básica
        String url = getURL();         
        
        System.debug('URL endpoint--->'+url);
        
        HttpRequest req = crearRequest(url, json, false);

        ///
        HTTPResponse res = sendRequest(req);
        return res;
    }

    public HttpResponse doRequest_WithToken(String urlMS) {

        String url = String.isBlank(urlMS) ? getURL() : urlMS;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(METHOD);
        req.setTimeout(TIME_OUT);

        if (String.isNotBlank(access_token)) {
            
            req.setHeader(AUTH, BEARER + ' ' + access_token);
            req.setHeader(ORIGIN, SF);
        }

        ///
        HTTPResponse res = sendRequest(req);
        return res;
    }

    ///
    public HttpRequest crearRequest(String url, String json, Boolean blnToken) {

        //
        String userName = configMSAdmin.Username__c;
        String password = configMSAdmin.Password__c;

        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(METHOD);
        req.setTimeout(TIME_OUT);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader(CONT_TYPE, ( blnToken ? APP_URLENCODED :  APP_JSON) );
        if(json != null){
            req.setBody(json);    
        }

        return req;
    }

    public HTTPResponse sendRequest(httpRequest req){
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('request----->'+req.getBody());
        System.debug('response---->'+res.getBody());
        return res;
    }
    
    public void logError (String apexClass, String message) {

        Error_Log__c el = new Error_Log__c(ApexClass__c = apexClass, Message__c = message);
        insert el;
    }
}