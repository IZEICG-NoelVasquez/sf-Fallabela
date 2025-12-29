public class MicroServicioConsultaMedioDeEnvio {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String ADDRESS = 'product/get/address';

    public MicroServicioConsultaMedioDeEnvio() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(ADDRESS);
        cliente.setMicroServicio(currentClassName);
        //if( !Test.isRunningTest() )
        cliente.generarToken();             
    }

    public ConsultarMedioEnvioJSON consultarMedioEnvio(Map<String, String> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        ConsultarMedioEnvioJSON result;

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

                result = ConsultarMedioEnvioJSON.parse(res.getBody());                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());        
        }
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> consulta_Medio_Envio(String numeroDocumento, String identificador) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento); 
        params.put('identificador', identificador);
        
        System.debug('Consulta MedioEnvio numeroDocumento: ' + numeroDocumento);
        System.debug('Consulta MedioEnvio identificador: ' + identificador);
        
        MicroServicioConsultaMedioDeEnvio medioEnvio = new MicroServicioConsultaMedioDeEnvio();
        ConsultarMedioEnvioJSON resultMedioEnvio = medioEnvio.consultarMedioEnvio(params);
        
        if(resultMedioEnvio != null) {
            success = true;
        }
        //resultMedioEnvio = null;

        System.debug('Consultar MedioEnvio Success: ' + success);
        result.put('success', success);
        result.put('resultMedioEnvio', resultMedioEnvio);
        return result;
    }

}