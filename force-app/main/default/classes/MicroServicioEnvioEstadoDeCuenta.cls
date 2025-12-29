public class MicroServicioEnvioEstadoDeCuenta {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String ENVIOEDOCUENTA = 'client/send/document';

    public MicroServicioEnvioEstadoDeCuenta() {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(ENVIOEDOCUENTA);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    public EnvioEstadoDeCuentaJSON enviarEstadoDeCuenta(Map<String, String> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        EnvioEstadoDeCuentaJSON result;

        System.debug('MicroServicioEnvioEstadoDeCuenta - req  ' + req);

        try {   
			
            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);
                if (res.getStatusCode() == 200) {

                    System.debug('MicroServicioEnvioEstadoDeCuenta - LLAMADO ');
                    isSuccess = true;
                    break;
                }
            }

            System.debug('MicroServicioEnvioEstadoDeCuenta - res.getBody()  ' + res.getBody());

            for (String str : res.getBody().split(':')) {

                System.debug('str ' + str);
            }
            
            if (isSuccess) {

                result = EnvioEstadoDeCuentaJSON.parse(res.getBody());          
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());        
        }
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> envioEstadoCuenta(String contrato, String fechaCorte, String direccionCorreoElectronico) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        ///
        //contrato = '000000000000001898';
        //fechaCorte = '2021-08-24';
        //direccionCorreoElectronico = 'mrosales@izeicg.com';
        
        Map<String, String> params = new Map<String, String>();
        params.put('contrato', contrato); 
        params.put('fechaCorte', fechaCorte);
        params.put('direccionCorreoElectronico', direccionCorreoElectronico);
        
        System.debug('Envio Estado de Cuenta - contrato: ' + contrato);
        System.debug('Envio Estado de Cuenta - fechaCorte: ' + fechaCorte);
        System.debug('Envio Estado de Cuenta - direccionCorreoElectronico: ' + direccionCorreoElectronico);
        
        MicroServicioEnvioEstadoDeCuenta enviaEdoCta = new MicroServicioEnvioEstadoDeCuenta();
        EnvioEstadoDeCuentaJSON resultEnvioEdoCta = enviaEdoCta.enviarEstadoDeCuenta(params);
        
        if(resultEnvioEdoCta != null) {
            success = true;
        }

        System.debug('Envio Estado de Cuenta - Success: ' + success);
        result.put('success', success);
        result.put('resultEnvioEdoCta', resultEnvioEdoCta);
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedEnvioEdoCta (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

}