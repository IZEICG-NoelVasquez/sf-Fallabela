public class MicroServicioEnviarOTP {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String CREATEOTP = 'client/create/otp';

    public MicroServicioEnviarOTP() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(CREATEOTP);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    public String enviarOTP(Map<String, String> params) {

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

            System.debug('MicroServicioEnviarOTP - res.getBody() ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }
            
            if (isSuccess) {

                result = res.getBody();
                System.debug('MicroServicioEnviarOTP - result:  ' + result);
            } else {
                System.debug('MicroServicioEnviarOTP - error:  ' + res.getBody());
                // Se envia el error para mostrarlo en Pantalla
                result = res.getBody(); 
                cliente.logError(currentClassName, String.valueOf(res.getBody()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }
        
        return result;
    }

}