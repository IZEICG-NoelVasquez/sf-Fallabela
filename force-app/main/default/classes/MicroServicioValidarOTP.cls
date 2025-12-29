public class MicroServicioValidarOTP {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String VALIDATEOTP = 'client/validate/otp';

    public MicroServicioValidarOTP() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(VALIDATEOTP);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    public String validarOTP(Map<String, String> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
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

            System.debug('MicroServicioValidarOTP - res.getBody():  ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }
            
            if (isSuccess) {

                result = res.getBody();    
                System.debug('MicroServicioValidarOTP - result:  ' + result);
            } else {
                // Se envia el error para mostrarlo en Pantalla
                result = res.getBody(); 
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());        
        }
        
        return result;
    }    

}