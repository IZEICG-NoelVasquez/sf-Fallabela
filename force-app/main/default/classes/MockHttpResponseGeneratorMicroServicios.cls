@isTest
global class MockHttpResponseGeneratorMicroServicios implements HttpCalloutMock {
    private final String BASE_URL = 'https://cmr-mx-business';
    private final String URI = '.fif.tech/api/business/';
    private String BACKEND = 'backend';
    private String VERSION = 'v1';
    private final String OAUTH = 'oauth2/token';
    private String endpoint = 'products';
    private String method = 'POST';
    private Configuracion_Microservicio__mdt cm;
    private String microServicio = 'default';
    private String body = '{"example":"test"}';
    private Integer statusCode = 200;
    
    public void setEndpoint (String endpoint) { 
        this.endpoint = endpoint;
    }

    public void setMethod (String method) {  
        this.method = method;
    }

    public void setVersion (String version) {
        
        this.VERSION = version;
    }

    public void generarToken () {

        String url = obtenerURLENDPOINT() + '/' + OAUTH;
    }

    public void setMicroServicio (String microServicio) {
        
        this.microServicio = microServicio;
        cm = [SELECT Ambiente__c, Channel__c, Commerce__c, Country__c, Client_ID__c, 
                        Client_Secret__c, Provision_Key__c, Authenticated_UserID__c
                FROM Configuracion_Microservicio__mdt WHERE Label =: microServicio LIMIT 1];
    }

    public void setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
    }

    public void setBody(String body) {
        this.body = body;
    }

    private String obtenerURLENDPOINT () {

        setMicroServicio(microServicio);
        
        String url = '';
        if (cm.Ambiente__c!=null) {
            url = BASE_URL  + '-' + cm.Ambiente__c + URI + VERSION + '/' + BACKEND + '/' + endpoint;
        } else {
            url = BASE_URL + URI  + VERSION + '/' + BACKEND + '/' + endpoint;
        }

        return url;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        String url = obtenerURLENDPOINT();

        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals(url, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        System.debug('endpoint:  ' + endpoint);
        System.debug('body:  ' + body);
        if( endpoint == 'client/create/otp' ) {
            res.setBody('{"code":"ok","message":{"codigoEstado":"201","glosaEstado":"Operación realizada exitosamente"}}');
        } else if( endpoint == 'client/validate/otp' ) {
            res.setBody('{"code":"ok","message":{"respuesta":{"codigoRespuesta":"201","glosaRespuesta":"Validación del OTP exitosa"}}}');
        } 
        else {
            res.setBody(body);
        }
        
        res.setStatusCode(statusCode);
        return res;
    }
}