/**
* Nombre: MockHttpResponseGeneratorApiGee
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para generar el Mock del llamado el MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           29/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class MockHttpResponseGeneratorWithToken implements HttpCalloutMock {
    
    private String strEndpointToken = 'token';
    private String bodyToken = '{"example":"test"}';
    private String body = '{"example":"test"}';    
    private Integer statusCode = 200;
    private Integer statusCodeToken = 200;

    public void setEndpointToken(String endpointToken) {

        this.strEndpointToken = endpointToken;
    }

    public void setBodyToken(String bodyToken) {

        this.bodyToken = bodyToken;
    }

    public void setBody(String body) {

        this.body = body;
    }

    public void setStatusCodeToken(Integer statusCodeToken) {

        this.statusCodeToken = statusCodeToken;
    }

    public void setStatusCode(Integer statusCode) {

        this.statusCode = statusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');

        if( req.getEndpoint().contains(strEndpointToken) ) {

            res.setBody(bodyToken);
            res.setStatusCode(statusCodeToken);

        } else {

            res.setBody(body);
            res.setStatusCode(statusCode);
        }        

        return res;
    }
}