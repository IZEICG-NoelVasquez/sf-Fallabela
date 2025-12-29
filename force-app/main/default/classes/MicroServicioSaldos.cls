public with sharing class MicroServicioSaldos {

    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String BALANCES = 'product/balances';

    public MicroServicioSaldos () {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(BALANCES);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();

    }

    
    public SaldosJson obtenerSaldos(Map<String, String> params) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        SaldosJson result;

        System.debug('req ' + req);

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);
				system.debug('resStatus: ' + res.getStatusCode());
                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;

                }

            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);

            }
            //result = SaldosJson.parse('{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consultaexitosa\"},\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"522375XAZKZF2700\",\"moneda\":{\"codigoMoneda\":\"484\"},\"resumenFacturacion\":{\"fechaInicioFacturacion\":\"2020-09-26\",\"fechaTerminoFacturacion\":\"2020-10-26\",\"montoPendientePago\":\"4906.72\",\"resumenUltimaFacturacion\":{\"fechaPago\":\"2020-11-16\",\"fechaUltimaFacturacion\":\"2020-11-16\",\"fechaVencimiento\":\"2020-11-16\",\"consumoFacturado\":\"4906.72\",\"montoPagado\":\"4906.72\",\"pagoMinimo\":\"1245.59\"},\"resumenProximaFacturacion\":{\"consumoPeriodoPorFacturar\":\"0.0\",\"fechaProximaFacturacion\":\"2020-11-26\",\"fechaProximoVencimiento\":\"2020-12-16\"}},\"cuentaTarjetaCredito\":{\"identificador\":\"00010252000000001352\",\"cupoNacional\":{\"cupoDisponible\":\"5093.28\",\"cupoTotal\":\"10000.0\",\"cupoUtilizado\":\"4906.72\"},\"avance\":{\"cupoDisponible\":\"5093.28\",\"cupoTotal\":\"50000.0\",\"cupoUtilizado\":\"0.0\"},\"titular\":{\"informacionContacto\":{\"direccion\":{\"direccionCompleta\":\"AVUNIVERSIDAD1000AGUASCALIENTES64150\"}},\"plastico\":{\"logoMarca\":\"2\",\"situacion\":{\"codigo\":\"0\",\"estado\":\"5\",\"glosa\":null}}},\"superAvance\":{\"cupoDisponible\":\"5093.28\",\"cupoTotal\":\"50000.0\",\"cupoUtilizado\":\"0.0\"}}}}}');
            if (isSuccess) {
                result = SaldosJson.parse(res.getBody());
                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));

            }

        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        
        }

        
        return result;
    }

}