/**
* Nombre: MicroServicioDetalleMovimientos
* Autor: ---
* Descripcion: Clase para el consumo del MicroServicio Detalle Movimientos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     Creación
* 2.0           02/07/2021      Mauricio Rosales        Validar movimientos No Facturados al llamar al MS Detalle Movimientos
* --------------------------------------------------------------------------
*/
public class MicroServicioDetalleMovimientos {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String MOVIMIENTOSDETAIL = 'product/transaction/detail';
    
    public MicroServicioDetalleMovimientos() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(MOVIMIENTOSDETAIL);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();

    }
    
    public String obtenerDetalleMovimientos(Map<String, String> params) {
        
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
                
                // Se envia el error al Componente
                result = res.getBody();
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
                
            }
            
			//String jsonDetalleMovimientos='{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"[OPCOCUO-OPCOMOC]OperacionRealizadaConExito\"},\"movimientoDetalle\":{\"movimiento\":{\"monto\":1150,\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"nombreComercio\":\"SORIANA\",\"pais\":\"840\",\"codigoComercio\":\"000000000000001\"},\"indicadorNacionalidad\":\"I\"},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":1,\"interes\":{\"codigoInteres\":\"1\",\"descripcionInteres\":\"TEM\",\"porcentaje\":0,\"valorInteres\":0}},\"montoMovimientoTC\":{\"montoLocal\":1150,\"montoOrigen\":3.99,\"tipoCambio\":20.08},\"moneda\":{\"codigoMoneda\":\"840\",\"moneda\":\"DOLAR\"},\"tipoAccionContable\":{\"codigo\":\"C\",\"descripcion\":\"CARGO\"},\"estadoMovimiento\":{\"codigo\":\"3\",\"descripcion\":\"AMORTIZADAOFINALIZADA\"}},\"persona\":{\"apellidoMaterno\":\"LOPEZ\",\"apellidoPaterno\":\"CANO\",\"nombres\":\"MAGDALENO\"},\"origenCompra\":{\"tipoTransaccion\":\"1012\"},\"compra\":{\"impugnacion\":\"N\"},\"detalleInternoMovimiento\":{\"moneda\":{\"codigoMoneda\":\"840\",\"moneda\":\"DOLAR\"}}}}}';
            //String jsonDetalleMovimientos='{ \"code\": \"ok\", \"message\": { \"estadoOperacion\": { \"codigoOperacion\": \"00\", \"glosaOperacion\": \"[OPCOCUO-OPCOMOC]Operacion Realizada Con Exito\" },     \"movimientoDetalle\": { \"movimiento\": { \"identificador\": \"75412918355967062129539\", \"fechaContable\": \"2018-12-22\", \"monto\": 209.9, \"titularidad\": \"Adicional\", \"transaccion\": { \"fechaHoraTransaccion\": \"2018-12-20T00:00:00\", \"localidadTransaccion\": { \"nombreComercio\": \"HEB VALLE ORIENTE\", \"pais\": \"484\", \"codigoComercio\": \"000000006706212\" }, \"indicadorNacionalidad\": \"N\" }, \"cuota\": { \"cuotaPendientes\": 0, \"totalCuota\": 1, \"numeroCuota\": 1, \"interes\": { \"codigoInteres\": \"1\", \"descripciÃ³nInteres\": \"TEM\", \"porcentaje\": 0, \"valorInteres\": 0 } }, \"montoMovimientoTC\": { \"montoLocal\": 0, \"montoOrigen\": 209.9, \"tipoCambio\": 1.0 }, \"moneda\": { \"codigoMoneda\": \"484\", \"moneda\": \"PESO MEXICANO\" }, \"tipoAccionContable\": { \"codigo\": \"C\", \"descripcion\": \"CARGO\" }, \"estadoMovimiento\": { \"codigo\": \"1\", \"descripcion\": \"EXTRACTADO\" } }, \"persona\": { \"apellidoMaterno\": \"CONTRERAS\", \"apellidoPaterno\": \"DE LA VEGA\", \"nombres\": \"KARINA CECILIA\" }, \"origenCompra\": { \"tipoTransaccion\": \"5\" }, \"compra\": { \"impugnacion\": \"N\" }, \"detalleInternoMovimiento\": { \"numeroExtracto\": \"21\", \"numeroMovimientoExtracto\": \"74\", \"numeroOperacionCuota\": \"0\", \"numeroFinanciacion\": \"0\", \"titularidad\": \"Adicional\", \"contrato\": \"00010252000000000132\", \"moneda\": { \"codigoMoneda\": \"484\", \"moneda\": \"PESO MEXICANO\" } } } } }';
            //String jsonDetalleMovimientos = '{\"code\":\"error\",\"message\":\"Transaction Detail service error\"}';
            //result = DetalleMovimientosJSON.parse(jsonDetalleMovimientos);
            
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
            
        }        
        
        return result;
    }
}