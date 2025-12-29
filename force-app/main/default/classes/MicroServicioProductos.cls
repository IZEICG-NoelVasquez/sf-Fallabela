/**
* Nombre: MicroServicioProductos
* Autor: ---
* Descripcion: Llamado al MicroServicio Productos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     Creación
* 2.0           16/06/2021      Mauricio Rosales        Se agrega el metodo obtenerProductosCliente 
* --------------------------------------------------------------------------
*/
public class MicroServicioProductos {
    
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String PRODUCTOS = 'products';

    public MicroServicioProductos () {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(PRODUCTOS);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();

    }
    
    public String obtenerProductos (Map<String, String> params) {

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
            
			//result = ProductosJson.parse('{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consulta exitosa\"},\"tarjetaCredito\":[{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"522375******8626\"},\"situacion\":{\"estado\":\"02\",\"glosa\":\"Basico\"},\"moneda\":{\"codigoMoneda\":\"484\"},\"plastico\":{\"titularidad\":\"Titular\",\"situacion\":{\"codigo\":\"88\",\"estado\":\"5\",\"glosa\":\"PRUEBA\"}},\"cuentaTarjetaCredito\":{\"identificador\":\"00010252000000000838\"},\"cupoNacional\":{\"cupoDisponible\":\"564165.23\",\"cupoTotal\":\"600000.0\",\"cupoUtilizado\":\"35834.77\"},\"avance\":{\"cupoDisponible\":\"50000.0\"},\"resumenProximaFacturacion\":{\"fechaProximoVencimiento\":\"2021-01-16\"}},{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"522375******5363\"},\"situacion\":{\"estado\":\"02\",\"glosa\":\"Basico\"},\"moneda\":{\"codigoMoneda\":\"484\"},\"plastico\":{\"titularidad\":\"Titular\",\"situacion\":{\"codigo\":\"25\",\"estado\":\"5\",\"glosa\":\"ROB/EXT\"}},\"cuentaTarjetaCredito\":{\"identificador\":\"00010252000000000769\"},\"cupoNacional\":{\"cupoDisponible\":\"50999.0\",\"cupoTotal\":\"50000.0\",\"cupoUtilizado\":\"-999.0\"},\"avance\":{\"cupoDisponible\":\"50000.0\"},\"resumenProximaFacturacion\":{\"fechaProximoVencimiento\":\"2021-01-02\"}},{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"522375******7877\"},\"situacion\":{\"estado\":\"02\",\"glosa\":\"Basico\"},\"moneda\":{\"codigoMoneda\":\"484\"},\"plastico\":{\"titularidad\":\"Adicional\",\"situacion\":{\"codigo\":\"11\",\"estado\":\"5\",\"glosa\":\"BLQEREM\"}},\"cuentaTarjetaCredito\":{\"identificador\":\"00010252000000000769\"},\"cupoNacional\":{\"cupoDisponible\":\"50999.0\",\"cupoTotal\":\"50000.0\",\"cupoUtilizado\":\"-999.0\"},\"avance\":{\"cupoDisponible\":\"50000.0\"},\"resumenProximaFacturacion\":{\"fechaProximoVencimiento\":\"2021-01-02\"}}]}}');

            /// Mora
            ///result = ProductosJson.parse('{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consulta exitosa\"},\"tarjetaCredito\":[{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"040001\",\"identificadorProducto\":\"854899******1711\"},\"situacion\":{\"estado\":\"00\",\"glosa\":\"Activa\"},\"moneda\":{\"codigoMoneda\":\"484\"},\"plastico\":{\"titularidad\":\"Adicional\",\"situacion\":{\"codigo\":\"0\",\"estado\":\"5\"}},\"contrato\":{\"morosidad\":{\"diasMora\":\"78\"}},\"cuentaTarjetaCredito\":{\"identificador\":\"78650252000000192447\"},\"cupoNacional\":{\"cupoDisponible\":2103.35,\"cupoTotal\":3000,\"cupoUtilizado\":896.65},\"avance\":{\"cupoDisponible\":2103.35},\"resumenProximaFacturacion\":{\"fechaProximoVencimiento\":\"2020-02-04T00:00:00.000Z\"}}]}}');

        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());        
        }
        
        return result;
    }    


    /**
    * Llamado al MicroServicio Productos para obtener las tarjetas relacionadas con el CURP del cliente
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param curp: curp del cliente
    **/
    public static Map<String, Object> obtenerProductosCliente(String curp) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('curp', curp);
        
        System.debug('curp: ' + curp);

        MicroServicioProductos msp = new MicroServicioProductos();
        String productos = msp.obtenerProductos(params);
        System.debug('MS Productos - productos:  ' + productos);

        ProductosJson productosExito = null;
        MicroServicioJSONError productosError = null;

        try {

            // Se intenta pasear la respuesta con la clase ProductosJson
            productosExito = ProductosJson.parse(productos); 

        } catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );

            try {

                // Se intenta pasear la respuesta con la clase MicroServicioJSONError
                productosError = MicroServicioJSONError.parse(productos); 

            } catch (Exception ex2) {

                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }
        System.debug('productosExito:  ' + productosExito);
        System.debug('productosError:  ' + productosError);

        if( productosExito != null ) {

            //  ProductosJson
            result.put('success', true);
            result.put('productos', productosExito );

        } else if( productosError != null ) {

            // MicroServicioJSONError
            result.put('success', false);
            result.put('productos', productosError );

        } else {

            // Error
            result.put('success', false);
            result.put('productos', productos );
        }

        System.debug('Productos Success: ' + result.get('success'));
        System.debug('productos:  ' + result.get('productos'));

        return result;
    }
}