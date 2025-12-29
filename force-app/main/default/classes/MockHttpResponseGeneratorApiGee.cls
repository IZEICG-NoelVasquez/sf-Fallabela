/**
* Nombre: MockHttpResponseGeneratorApiGee
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para generar el Mock del llamado el MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
global class MockHttpResponseGeneratorApiGee implements HttpCalloutMock {

    private String body = '{"example":"test"}';
    private Integer statusCode = 200;

    public void setBody(String body) {

        this.body = body;
    }

    public void setStatusCode(Integer statusCode) {

        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();

        res.setHeader('Content-Type', 'application/json');

        res.setBody(body);

        res.setStatusCode(statusCode);

        return res;
    }
    
}