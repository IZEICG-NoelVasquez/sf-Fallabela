public class MicroServicioSaldoEnPuntos {
    private ClienteMicroServicios cliente;
    private static String POST = 'POST';
    private static String SALDO = 'get/points';

    public MicroServicioSaldoEnPuntos() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(SALDO);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    public SaldoPuntosJSON obtenerSaldoEnPuntosMS(Map<String, String> params ) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params);
        Boolean isSuccess = false;
        SaldoPuntosJSON result;

        System.debug('obtenerSaldoEnPuntos - req:  ' + req);

        try{

            for(Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if(res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res:  ' + res.getBody() );

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }

            if(isSuccess) {

                result = SaldoPuntosJSON.parse((res.getBody() ));
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

        } catch(Exception ex) {

            cliente.logError(currentClassName, ex.getMessage() );
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerSaldoEnPuntos(String numeroDocumento){
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);

        System.debug('numeroDocumento:  ' + numeroDocumento);

        MicroServicioSaldoEnPuntos msSaldoPuntos = new MicroServicioSaldoEnPuntos();
        SaldoPuntosJSON saldoPuntos = msSaldoPuntos.obtenerSaldoEnPuntosMS(params);

        if( saldoPuntos != null ) {
            success = true;
        }

        System.debug('MicroServicioSaldoEnPuntos - success:  ' + success);
        result.put('success', success);
        result.put('saldoPuntos', saldoPuntos);

        return result;
    }


}