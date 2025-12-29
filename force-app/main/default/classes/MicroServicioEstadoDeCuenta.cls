public class MicroServicioEstadoDeCuenta {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String EDOCUENTA = 'product/create/document';

    public MicroServicioEstadoDeCuenta() {
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(EDOCUENTA);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
        
    }

    public EstadoDeCuentaJSON obtenerEstadoDeCuenta(Map<String, String> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params);
        Boolean isSuccess = false;
        EstadoDeCuentaJSON result;

        System.debug('req:  ' + req);

        try {
            for(Integer i = 0; i < 3; i++) {
                
                res = cliente.enviarRequest(req);
                if(res.getStatusCode() == 200) {
                    isSuccess = true;
                    break;
                }
            }
            System.debug('res ' + res.getBody());

            if(isSuccess) {
                result = EstadoDeCuentaJSON.parse( res.getBody() );

            } else {
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()) );
            }
        } catch(Exception ex) {
            cliente.logError(currentClassName, ex.getMessage() );
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerEstadoDeCuenta(String numeroDocumento, String identificador, String fechaCorte) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean successEDoCta = false;
        Boolean success = false;
        String formato = 'PDF';
        String strURL = '';

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento); 
        params.put('identificador', identificador);
        params.put('fechaCorte', fechaCorte);
        params.put('formato', formato);
        
        System.debug('numeroDocumento: ' + numeroDocumento);
        System.debug('identificador: ' + identificador);
        System.debug('fechaCorte: ' + fechaCorte);
        
        MicroServicioEstadoDeCuenta msEdoCta = new MicroServicioEstadoDeCuenta();
        EstadoDeCuentaJSON estadoDeCuenta = msEdoCta.obtenerEstadoDeCuenta(params);

        if( estadoDeCuenta != null ) {
            successEDoCta = true;
            strURL = !Test.isRunningTest() ? estadoDeCuenta.Message.urlResumenExtractoElectronico : 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
		    //strURL = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
        }

		System.debug('successEDoCta:  ' + successEDoCta);
        System.debug('strURL:  ' + strURL );
		
        HttpRequest req = new HttpRequest();
        req.setEndpoint(strURL);
        req.setMethod('GET');
        req.setTimeout(120000);
		
		Http http = new Http();
		HttpResponse res;
        if( successEDoCta ) {
            if( !Test.isRunningTest() ) {
                res = http.send(req);
            } else {
                res = new HttpResponse();
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
            }
        } else {
            res = new HttpResponse();
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
        }

		System.debug('RES Edo Cta:  ' + res);

        if(res.getStatusCode() == 200) {

            success = true;
        }

        System.debug('EstadoDeCuenta Success: ' + success);

        System.debug('Antes del Encode  Limits.getHeapSize():  ' + Limits.getHeapSize());

        result.put('success', success);
        result.put('base64_PDF', EncodingUtil.base64Encode(res.getBodyAsBlob()));

        return result;
    }

}