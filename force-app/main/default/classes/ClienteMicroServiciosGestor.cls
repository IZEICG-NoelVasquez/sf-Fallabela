public  class ClienteMicroServiciosGestor {
    private final String BASE_URL = 'https://cmr-mx-solicitud-producto';
    private final String URI = '.fif.tech/';

    //private final String ENV = 'test';
    private final String APP_JSON = 'application/json';
    private final String CONT_TYPE = 'Content-Type';
    private final Integer TIME_OUT = 120000;
    private String endpoint = 'solicitudes';
    private String method = 'GET';
    private String version = 'v1';
    private final String MDW_CS_CHANNEL = 'x-channel';
    private final String MDW_CS_COMMERCE = 'x-commerce';
    private final String MDW_CS_COUNTRY = 'x-country';
    private final String API_KEY = 'x-api-key';
    private Configuracion_Microservicio_Gestor__mdt cm;
    private String microServicio = 'ConsultaSolicitudGestor';
    

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
    
    
    private String access_token = '';
    
    public ClienteMicroServiciosGestor () {
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
        System.debug('***this.microServicio  ' + this.microServicio);
        this.microServicio = microServicio;
        cm = [SELECT ambiente__c, Channel__c, Commerce__c, Country__c, client_id__c, 
              client_Secret__c, Provision_Key__c, authenticated_userid__c,Api_Key__c
              FROM Configuracion_Microservicio_Gestor__mdt WHERE Label =: this.microServicio LIMIT 1];    
              System.debug('***Api_Key__c  ' + cm.Api_Key__c);
        }
    
    public void generarToken () {

		//https://cmr-mx-solicitud-producto-qa.fif.tech/v1/solicitudes/oauth2/token
        Map<String, String> params = new Map<String, String>{GRANT_TYPE => PASSWORD, 
                                                             CLIENT_ID => cm.client_id__c,
                                                             CLIENT_SECRET => cm.client_Secret__c,
                                                             PROVISION_KEY => cm.Provision_Key__c,
												             AUTHENTICATED_USERID => cm.authenticated_userid__c};
                                                                 
		String url = obtenerURLENDPOINT() +'/solicitud/' +'/' + OAUTH;
        System.debug('***URL  ' + Url);
        HttpRequest req = crearRequest(params);
        HttpResponse res;
        
        req.setEndpoint(url);
        if( !Test.isRunningTest() ) {
            res = enviarRequest(req);
        } else {
            HttpResponse resMock = new HttpResponse();
            resMock.setHeader('Content-Type', 'application/json');
            resMock.setBody('{"access_token":"qiERr0QboUk8RvzaHv70fNymq4DVZugP"}');
            resMock.setStatusCode(200);
            res = resMock;
        }
        
        oAuthJSON.oAuth result = oAuthJSON.parse(res.getBody());
        
        System.debug('res token ' + res.getBody());
        
        this.access_token = result.access_token;
    }
    
    private String obtenerURLENDPOINT () {

        String url = '';
        String Enviroment = '-' + cm.Ambiente__c;
        
        if ( cm.Ambiente__c != null ) {
            
            url = BASE_URL  + Enviroment + URI + VERSION + '/'  + endpoint;            
        } else {
            
            url = BASE_URL + URI  + VERSION + '/' + endpoint;            
        }
        
        return url;        
    }


    public HttpRequest crearRequest (Map<String, String> params) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(JSON.serialize(params));

        return crearRequest_v1_v2(req);
    }
    public HttpRequest doRequest (String endpoint) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String url = obtenerURLENDPOINT();        
        System.debug('***Api_Key__c crearRequest_v1_v2  ' + cm.Api_Key__c);    
        String strChannel = cm.Channel__c;
        String strCommerce = cm.Commerce__c;
        String strCountry = cm.Country__c;
        String strApiKey = cm.Api_Key__c;
        
        req.setEndpoint(url);
        req.setMethod(method);
        req.setTimeout(TIME_OUT);
        //req.setHeader(CONT_TYPE, APP_JSON);
        req.setHeader(MDW_CS_CHANNEL, strChannel);
        req.setHeader(MDW_CS_COMMERCE, strCommerce);
        req.setHeader(MDW_CS_COUNTRY, strCountry);
        req.setHeader(API_KEY, strApiKey);
        
        if (String.isNotBlank(access_token)) {
            
			req.setHeader(AUTH, BEARER + ' ' + access_token);            
        }

        imprimirRequest(req);

        return req;
    }

     public HttpRequest doRequest_2 (String bodyrequest, Boolean banUpdate) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String url = obtenerURLENDPOINT();        
        System.debug('***Api_Key__c doPatch  ' + cm.Api_Key__c);    
        String strChannel = cm.Channel__c;
        String strCommerce = cm.Commerce__c;
        String strCountry = cm.Country__c;
        String strApiKey = cm.Api_Key__c;
        
        req.setEndpoint(url);
        System.debug('*** Endpoint: ' + req.getEndpoint());
        if (banUpdate) {
         req.setHeader('X-HTTP-Method-Override','PATCH');    
        }
        
        req.setMethod(method);
        req.setTimeout(TIME_OUT);
        req.setHeader(CONT_TYPE, APP_JSON);
        req.setHeader(MDW_CS_CHANNEL, strChannel);
        req.setHeader(MDW_CS_COMMERCE, strCommerce);
        req.setHeader(MDW_CS_COUNTRY, strCountry);
        req.setHeader(API_KEY, strApiKey);
        req.setBody(bodyrequest);
        
        System.debug('*** body  ' + req.getBody()); 
        if (String.isNotBlank(access_token)) {
            
			req.setHeader(AUTH, BEARER + ' ' + access_token);            
        }

        imprimirRequest(req);

        return req;
    }

    public HttpRequest crearRequest_v1_v2(HttpRequest req) {
        
        String url = obtenerURLENDPOINT();        
        System.debug('***Api_Key__c crearRequest_v1_v2  ' + cm.Api_Key__c);    
        String strChannel = cm.Channel__c;
        String strCommerce = cm.Commerce__c;
        String strCountry = cm.Country__c;
        String strApiKey = cm.Api_Key__c;
        
        req.setEndpoint(url);
        req.setMethod(method);
        req.setTimeout(TIME_OUT);
        req.setHeader(CONT_TYPE, APP_JSON);
        req.setHeader(MDW_CS_CHANNEL, strChannel);
        req.setHeader(MDW_CS_COMMERCE, strCommerce);
        req.setHeader(MDW_CS_COUNTRY, strCountry);
        req.setHeader(API_KEY, strApiKey);
        
        if (String.isNotBlank(access_token)) {
            
			req.setHeader(AUTH, BEARER + ' ' + access_token);            
        }

        imprimirRequest(req);

        return req;
    }

    public void imprimirRequest(HttpRequest req) {
        
        System.debug('REQ: ' + req);
        System.debug('REQ Endpoint: ' + req.getEndpoint());
        System.debug('req.getHeader(Content-Type):  ' + req.getHeader('Content-Type') );
        System.debug('req.getHeader(x-channel):  ' + req.getHeader('x-channel') );
        System.debug('req.getHeader(x-commerce):  ' + req.getHeader('x-commerce') );
        System.debug('req.getHeader(x-country):  ' + req.getHeader('x-country') );
        System.debug('req.getHeader(x-api-key):  ' + req.getHeader('x-api-key') );
        System.debug('req.getBody():  ' + req.getBody() );
    }

    public HttpResponse enviarRequest (HttpRequest req) {

        Http http = new Http();
        return http.send(req);
    }

    public void logError (String apexClass, String message) {

        Error_Log__c el = new Error_Log__c(ApexClass__c = apexClass, Message__c = message);
        insert el;
    }  
}