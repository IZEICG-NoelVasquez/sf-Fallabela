/**
* Nombre: ClienteMicroServicios
* Autor: ---
* Descripcion: Clase cliente para el consumos de los Micro Servicios de Falabella
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ----                    Creación
* 2.0           01/06/2021      Mauricio Rosales        Se agrega metodo addDateHour
* --------------------------------------------------------------------------
*/
public class ClienteMicroServicios {

    private final String BASE_URL = 'https://cmr-mx-business';
    private final String URI = '.fif.tech/api/business/';

    private String BACKEND = 'backend';
    //private final String ENV = 'test';
    private final String APP_JSON = 'application/json';
    private final String CONT_TYPE = 'Content-Type';
    private final Integer TIME_OUT = 120000;
    @TestVisible private String endpoint = 'products';
    @TestVisible private String method = 'POST';
    @TestVisible private String version = 'v1';
    private final String MDW_CS_CHANNEL = 'mdw-cs-channel';
    private final String MDW_CS_COMMERCE = 'mdw-cs-commerce';
    private final String MDW_CS_COUNTRY = 'mdw-cs-country';
    private final String MDW_CS_DATE = 'mdw-cs-date';
    private final String MDW_CS_HOUR = 'mdw-cs-hour';
    @TestVisible private Configuracion_Microservicio__mdt cm;
    private String microServicio = 'default';
    
    // oAuth
    private final String GRANT_TYPE = 'grant_type';
    private final String PASSWORD = 'password';
    private final String CLIENT_ID = 'client_id';
    private final String CLIENT_SECRET = 'client_secret';
    private final String PROVISION_KEY = 'provision_key';
    private final String AUTHENTICATED_USERID = 'authenticated_userid';
    private final String AT = 'access_token';
    
    private final String AUTH = 'Authorization';
    private final String BEARER = 'Bearer';
    private final String OAUTH = 'oauth2/token';
    
    /// Figital
    private final String SECCTION = 'secction';
    private final String APIVERSION = 'apiversion';
    private final String SCORETOKEN = 'token';
    
    
    @TestVisible private String access_token = '';
    
    public ClienteMicroServicios () {
       setMicroServicio(microServicio);
    }

    
    public void setEndpoint (String endpoint) {
        
        this.endpoint = endpoint;
    }

    public void setMethod (String method) {
        
        this.method = method;
    }
    
    public void setVersion (String version) {
        
        this.version = version;
    }
    
    public void setMicroServicio (String microServicio) {
        
        this.microServicio = microServicio;
         cm = [SELECT Ambiente__c, Channel__c, Commerce__c, Country__c, Client_ID__c, 
              			Client_Secret__c, Provision_Key__c, Authenticated_UserID__c, 
                        Section__c, Apiversion__c
              FROM Configuracion_Microservicio__mdt WHERE Label =: microServicio LIMIT 1];
    }
    
    public void generarToken () {

		//https://cmr-mx-business-test.fif.tech/api/business/v1/backend/products/oauth2/token
        Map<String, String> params = new Map<String, String>{GRANT_TYPE => PASSWORD, 
                                                             CLIENT_ID => cm.Client_ID__c,
                                                             CLIENT_SECRET => cm.Client_Secret__c,
                                                             PROVISION_KEY => cm.Provision_Key__c,
												             AUTHENTICATED_USERID => cm.Authenticated_UserID__c};
                                                                 
		String url = obtenerURLENDPOINT() + '/' + OAUTH;
        
        HttpRequest req = crearRequest(params);
        HttpResponse res;
        
        req.setEndpoint(url);
        if( !Test.isRunningTest() ) {
            res = enviarRequest(req);
        } else {
            HttpResponse resMock = new HttpResponse();
            resMock.setHeader('Content-Type', 'application/json');
            resMock.setBody('{"access_token":"test"}');
            resMock.setStatusCode(200);
            res = resMock;
        }
        
        oAuthJSON.oAuth result = oAuthJSON.parse(res.getBody());
        
        System.debug('res token ' + res.getBody());
        
        this.access_token = result.access_token;
    }
    
    @TestVisible private String obtenerURLENDPOINT () {

        String url = '';
        String Enviroment = '-' + cm.Ambiente__c;
        
        if ( cm.Ambiente__c != null ) {
            
            url = BASE_URL  + Enviroment + URI + VERSION + '/' + BACKEND + '/' + endpoint;
            
        } else {
            
            url = BASE_URL + URI  + VERSION + '/' + BACKEND + '/' + endpoint;            
        }
        
        return url;        
    }

    public HttpRequest crearRequest (Map<String, String> params) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));

        return crearRequest_v1_v2(req);
    }

    public HttpRequest crearRequest_v2 (Map<String, Map<String, String> > params) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));
        
        return crearRequest_v1_v2(req);
    }

    public HttpRequest crearRequest_v2_1 (Map<String, Object> params) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));
        
        return crearRequest_v1_v2(req);
    }

    public HttpRequest crearRequest_v3 (Map<String, Map<String, Object> > params) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));
        
        return crearRequest_v1_v2(req);
    }

    public HttpRequest crearRequestFigital(Map<String, String> params, String token) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));

        req.setHeader(SECCTION, cm.Section__c);
        req.setHeader(APIVERSION, cm.Apiversion__c);
        if( String.isNotBlank(token) ) { req.setHeader(SCORETOKEN, token); }

        return crearRequest_v1_v2(req);
    }

    public HttpRequest crearRequest_v1_v2(HttpRequest req) {
        
        String url = obtenerURLENDPOINT();        
            
        String strChannel = cm.Channel__c;
        String strCommerce = cm.Commerce__c;
        String strCountry = cm.Country__c;
        
        req.setEndpoint(url);
        req.setMethod(method);
        req.setTimeout(TIME_OUT);
        req.setHeader(CONT_TYPE, APP_JSON);
        req.setHeader(MDW_CS_CHANNEL, strChannel);
        req.setHeader(MDW_CS_COMMERCE, strCommerce);
        req.setHeader(MDW_CS_COUNTRY, strCountry);
        
        if (String.isNotBlank(access_token)) {
            
			req.setHeader(AUTH, BEARER + ' ' + access_token);            
        }

        imprimirRequest(req);

        return req;
    }

    public HttpRequest addDateHour(HttpRequest req, String strDate, String strHour) {

        req.setHeader(MDW_CS_DATE, strDate);
        req.setHeader(MDW_CS_HOUR, strHour);

        return req;
    }

    public void imprimirRequest(HttpRequest req) {
        
        System.debug('REQ: ' + req);
        System.debug('req.getHeader(Content-Type):  ' + req.getHeader('Content-Type') );
        System.debug('req.getHeader(mdw-cs-channel):  ' + req.getHeader('mdw-cs-channel') );
        System.debug('req.getHeader(mdw-cs-commerce):  ' + req.getHeader('mdw-cs-commerce') );
        System.debug('req.getHeader(mdw-cs-country):  ' + req.getHeader('mdw-cs-country') );
        System.debug('req.getBody():  ' + req.getBody() );
    }

    public HttpResponse enviarRequest (HttpRequest req) {

        Http http = new Http();
        return http.send(req);
    }

    public void logError (String apexClass, String message) {
        System.debug('error message'+message);
        Error_Log__c el = new Error_Log__c(ApexClass__c = apexClass, Message__c = message);
        insert el;
    }

}