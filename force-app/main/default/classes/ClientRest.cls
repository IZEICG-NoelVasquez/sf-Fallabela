/**
* Nombre: ClientRest
* Autor: Mauricio Rosales
* Descripcion: Clase Cliente para el consumo Web Service Rest
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           06/01/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class ClientRest {

    public Configuracion_Microservicio__mdt microservicio;

    public ClientRest(String record) {

        microservicio = Configuracion_Microservicio__mdt.getInstance(record);
    }

    /**
    * Llamado al Web Service, con 3 intentos si no es exitosa la peticion
    * @return Regresa un mapa con una variable de exito y el Body del Response 
    *
    * @param request: Request para la peticion Http
    **/
    public Map<String,Object> callWebService(HttpRequest request) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        HttpResponse response;

        try {

            for(Integer i = 0; i < 3; i ++) {

                response = makeResponse(request);

                if( response.getStatusCode() == 200 ) {

                    mapResult.put('responseBody', response.getBody());
                    success = true;
                    break;
                }
            }

        } catch(Exception ex) {

            System.debug('ERROR: ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            ErrorLog.log(microservicio.MasterLabel , ex.getMessage());

            mapResult.put('error', ex.getMessage());
        }

        mapResult.put('response', success ? null : response);
        mapResult.put('success', success);
        
        return mapResult;
    }
    
    /**
    * Crea el Request para la peticion al Web Service
    * @return Regresa el Request para la peticion
    *
    * @param endPoint: Endpoint para la peticion Http
    * @param method: Metodo para la peticion Http
    * @param mapHeaders: Mapa con los Headers para la peticion Http
    * @param body: Body para la peticion Http
    **/
    public HttpRequest makeRequest(String endPoint, String method, Map<String,String> mapHeaders, String body) {

        HttpRequest request = new HttpRequest();

        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setTimeout(Integer.valueOf(System.Label.HTTP_TIMEOUT));

        for(String key: mapHeaders.keySet()) {

            request.setHeader(key, mapHeaders.get(key));
        }

        if( String.isNotBlank(body) ) {

            request.setBody(body);
        }  

        return request;
    }

    /**
    * Envia la peticon Http
    * @return Regresa el Response de la peticion
    *
    * @param request: Request para la peticion Http
    **/
    public HttpResponse makeResponse(HttpRequest request) {

        Http http = new Http();

        return http.send(request);
    }
}