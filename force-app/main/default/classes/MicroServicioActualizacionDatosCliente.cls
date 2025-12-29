/**
* Nombre: MicroServicioActualizacionDatosCliente
* Autor: ---
* Descripcion: Consumo del Micro Servico Actualizacion de Datos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     ---
* 2.0           21/07/2021      Mauricio Rosales        Se agrega metodo consumir el MS y regresar los errores 
* --------------------------------------------------------------------------
*/
public class MicroServicioActualizacionDatosCliente {

    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String DATOS = 'client/information/update';
    
    public MicroServicioActualizacionDatosCliente() {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(DATOS);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    public ActualizarDatosClienteJSON actualizarDatosJSON2_1n(Map<String, Object> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v2_1(params); 
        Boolean isSuccess = false;
        ActualizarDatosClienteJSON result;

        System.debug('req ' + req);

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }
            
            if (isSuccess) {

                result = ActualizarDatosClienteJSON.parse(res.getBody());                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }
        
        return result;
    }

    public ActualizarDatosClienteJSON actualizarDatosJSON3n(Map<String, Map<String, Object> > params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v3(params); 
        Boolean isSuccess = false;
        ActualizarDatosClienteJSON result;

        System.debug('req ' + req);

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }

            //String jsonActualizarDomicilio = '{ \"code\": \"ok\", \"message\": { \"estadoOperacion\": { \"codigoOperacion\": \"00\", \"glosaOperacion\": \"Operación exitosa\" } } }';
            //result = ActualizarDatosClienteJSON.parse(jsonActualizarDomicilio);
            
            if (isSuccess) {

                result = ActualizarDatosClienteJSON.parse(res.getBody());                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }
        
        return result;
    }

    /**
    * Metodo para consumir el Cliente y el MicroServicio
    * Regresa la respuesta del MicroServicio de tipo String incluyendo los errores 
    *
    * @param params: mapa con los parametros para el consumo del MicroServicio
    **/
    public String actualizarDatosString3n(Map<String, Map<String, Object> > params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v3(params); 
        Boolean isSuccess = false;
        String result;

        System.debug('req ' + req);

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }
            
            if (isSuccess) {

                result = res.getBody();
                
            } else {

                result = res.getBody();
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }
        
        return result;
    }

    /**
    * Metodo para consumir el Cliente y el MicroServicio
    * Regresa la respuesta del MicroServicio de tipo String incluyendo los errores 
    *
    * @param params: mapa con los parametros para el consumo del MicroServicio
    **/
    public String actualizarDatos(Map<String,Object> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v2_1(params); 
        Boolean isSuccess = false;
        String result;

        System.debug('req ' + req);

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }
            
            if (isSuccess) {

                result = res.getBody();
                
            } else {

                result = res.getBody();
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }
        
        return result;
    }
    
}