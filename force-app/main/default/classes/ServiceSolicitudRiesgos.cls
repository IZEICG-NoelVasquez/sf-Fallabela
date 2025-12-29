@RestResource(urlMapping='/riesgos/solicitudes/*')
global with sharing class ServiceSolicitudRiesgos {
    
    @HttpPost
    global static void create () {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;   
        
        System.debug('RestContext.request.requestBody '  + RestContext.request.requestBody.toString());

        String uri = req.requestURI;
        System.debug('uri:  ' + uri);

        if( uri.equals('/riesgos/solicitudes/gestor') || uri.equals('/riesgos/solicitudes/gestor/') ) {

            Map<String, Object> result = ServiceSolicitudRiesgosHelper.WSCreateSolicitudGestor(RestContext.request.requestBody.toString());
            res.responseBody = Blob.valueOf( System.JSON.serializePretty(result) );
        }
    }
}