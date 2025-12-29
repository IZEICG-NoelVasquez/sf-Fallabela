public class MicroServicioActualizacionMedioEnvio {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String MOVIMIENTOS = 'product/address/update';
    
    public MicroServicioActualizacionMedioEnvio() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(MOVIMIENTOS);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();

    }
    
    public ActualizarMedioEnvioJSON actualizarMedioEnvio(Map<String, String> params) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        ActualizarMedioEnvioJSON result;

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
            
            //String jsonActualizarMedioEnvio = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Operación Exitosa\"}}}';
            
            //result = ActualizarMedioEnvioJSON.parse(jsonActualizarMedioEnvio);
            
            if (isSuccess) {
                result = ActualizarMedioEnvioJSON.parse(res.getBody());
                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));

            }

            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        
        }

        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> actualizarMedioDeEnvio(String identificador, String esPrimario) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('identificador', identificador);
        params.put('esPrimario', esPrimario);
        
        System.debug('identificador: ' + identificador);
        System.debug('esPrimario: ' + esPrimario);
        
        MicroServicioActualizacionMedioEnvio msMedioEnv = new MicroServicioActualizacionMedioEnvio();
        ActualizarMedioEnvioJSON medioEnvio = msMedioEnv.actualizarMedioEnvio(params);

        if (medioEnvio != null) {
            success = true;
        }
        System.debug('Actualizar Medio de Enviox Success: ' + success);
        result.put('success', success);
        result.put('medioEnvio', medioEnvio);
        
        return result;
        
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedMedioEnvio (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

}