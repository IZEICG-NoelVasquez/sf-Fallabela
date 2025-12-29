/**
* Nombre: MicroServicioMovimientos
* Autor: ---
* Descripcion: Clase Controladora del Componente Lightning MicroServicioMovimientos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     Creación
* 2.0           02/07/2021      Mauricio Rosales        Validar movimientos No Facturados al llamar al MS Detalle Movimientos
* --------------------------------------------------------------------------
*/
public class MicroServicioMovimientos {
    
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String VERSION = 'v2';
    private static final String MOVIMIENTOS = 'product/transactions';

    public MicroServicioMovimientos() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setVersion(VERSION);
        cliente.setEndpoint(MOVIMIENTOS);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }
    
    public MovimientosJSON obtenerMovimientos(Map<String, Map<String, String> > params) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v2(params); 
        Boolean isSuccess = false;
        MovimientosJSON result;

        System.debug('obtenerMovimientos req ' + req);

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
                result = MovimientosJSON.parse(res.getBody());
                
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));

            }
            
            
            //String jsonSinFechaCorte = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consulta exitosa\"},\"tarjetaCredito\":{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"00010252000000001366\"},\"movimiento\":[{\"identificador\":\"3\",\"descripcion\":\"INTERESES MORATORIOS\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2021-01-16T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"INTERESES MORATORIOS\",\"direccionCompra\":\"INTERESES MORATORIOS\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"2004\",\"descripcion\":\"INTERESES MORATORIOS\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":1,\"numeroCuota\":1,\"valorCuota\":59.22},\"montoMovimientoTC\":{\"montoLocal\":59.22,\"montoOrigen\":0,\"montoTotal\":59.22},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"X\",\"descripcion\":\"INTERESES MORATORIOS\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"6\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"0\",\"numeroFinanciacion\":\"0\",\"moneda\":{\"codigoMoneda\":\"484\"}}}]},\"informacionPaginacion\":{\"totalPaginas\":1,\"totalRegistros\":1,\"paginaActual\":{\"numeroPagina\":1,\"identificadorPrimerRegistro\":\"000000000000 0252 0001 000000001366 1 484 00001      21 0001-01-01 0001-01-01 2021-01-18 0000   X 006 484 0000003                     000000 2004 + 00000000000005922 20210116 20210116      TI 00000000\"}}}}';
			/*String jsonConFechaCorte = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consulta exitosa\"},\"tarjetaCredito\":{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"010001\",\"identificadorProducto\":\"00010252000000001352\"},\"movimiento\":[{\"identificador\":\"-4\",\"descripcion\":\"COMISION PAGO TARDIO\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-10-26T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"COMISION PAGO TARDIO\",\"direccionCompra\":\"COMISION PAGO TARDIO\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"2002\",\"descripcion\":\"COMISION PAGO TARDIO\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":1,\"numeroCuota\":1,\"valorCuota\":275},\"montoMovimientoTC\":{\"montoLocal\":275,\"montoOrigen\":0,\"montoTotal\":275},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"X\",\"descripcion\":\"COMISION PAGO TARDIO\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"7\",\"numeroOperacionCuota\":\"0\",\"numeroFinanciacion\":\"0\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"-2\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":383.34},\"montoMovimientoTC\":{\"montoLocal\":1150,\"montoOrigen\":0,\"montoTotal\":1150},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"5\",\"numeroOperacionCuota\":\"3\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"-1\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":456.34},\"montoMovimientoTC\":{\"montoLocal\":1369,\"montoOrigen\":0,\"montoTotal\":1369},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"4\",\"numeroOperacionCuota\":\"2\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}},{\"identificador\":\"0\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"titularidad\":\"Titular\",\"transaccion\":{\"fechaHoraTransaccion\":\"2020-08-20T00:00:00.000Z\",\"localidadTransaccion\":{\"ciudad\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"direccionCompra\":\"CUOTA MES MESES SIN INTERESES SORIANA\",\"pais\":\"MEX\"},\"estadoTransaccion\":{\"codigo\":\"1101\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":3,\"numeroCuota\":3,\"valorCuota\":366.66},\"montoMovimientoTC\":{\"montoLocal\":1100,\"montoOrigen\":0,\"montoTotal\":1100},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"codigo\":\"+\",\"descripcion\":\"Cargo\"},\"estadoMovimiento\":{\"codigo\":\"E\",\"descripcion\":\"CUOTA MES MESES SIN INTERESES SORIANA\"},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"3\",\"numeroMovimientoExtracto\":\"3\",\"numeroOperacionCuota\":\"1\",\"numeroFinanciacion\":\"1\",\"moneda\":{\"codigoMoneda\":\"484\"}}}]},\"informacionPaginacion\":{\"totalPaginas\":1,\"totalRegistros\":1,\"paginaActual\":{\"numeroPagina\":1,\"identificadorPrimerRegistro\":\"000000000000 0252 0001 000000001352 0 484 00001      21 2020-10-26 0001-01-01 9999-12-31 0000   X 003 484 0000007                     000000 2002 + 00000000000027500 20201026 20201026      TI 00000000\"}}}}';			
            String jsonSinFechaCorte = jsonConFechaCorte;
            if(params.containsKey('fechaCorte')) {
                result = MovimientosJSON.parse(jsonConFechaCorte);
            } else {
                result = MovimientosJSON.parse(jsonSinFechaCorte);
            }*/
            
 
			//String jsonSinMovimientos = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Consulta exitosa\"},\"tarjetaCredito\":{\"tarjetaCredito\":{\"codigoProducto\":\"1\",\"codigoSubProducto\":\"050001\",\"identificadorProducto\":\"00010252000000001261\"},\"movimiento\":[{\"transaccion\":{\"localidadTransaccion\":{},\"estadoTransaccion\":{\"codigo\":\"0\"}},\"cuota\":{\"cuotaPendientes\":0,\"totalCuota\":1,\"numeroCuota\":1,\"valorCuota\":0},\"montoMovimientoTC\":{\"montoLocal\":0,\"montoOrigen\":0,\"montoTotal\":0},\"moneda\":{\"codigoMoneda\":\"484\"},\"tipoAccionContable\":{\"descripcion\":\"Abono\"},\"estadoMovimiento\":{},\"detalleInternoMovimiento\":{\"numeroExtracto\":\"0\",\"numeroMovimientoExtracto\":\"0\",\"numeroOperacionCuota\":\"0\",\"numeroFinanciacion\":\"0\",\"moneda\":{\"codigoMoneda\":\"0\"}}}]},\"informacionPaginacion\":{\"totalPaginas\":0,\"totalRegistros\":1,\"paginaActual\":{\"numeroPagina\":0,\"identificadorPrimerRegistro\":\"000000000000                          000 00000      00 0001-01-01 0001-01-01 0001-01-01 0000     000 000 0000000                     000000 0000   00000000000000000                           00000000\"}}}}';
     
            //result = MovimientosJSON.parse(jsonSinMovimientos);

        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        
        }

        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerMovSinFechaCorteCliente(String codigo, String identificador, String identificadorPrimerRegistro, String identificadorUltimoRegistro) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        ///
        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('movimiento', new Map<String, String>() );
        params.get('movimiento').put('codigo', codigo);
        params.get('movimiento').put('identificador', identificador);

        Integer intNumeroDeRegistros = Integer.valueOf(obtenerNumRegistrosPorPagina());
        params.put('paginacion', new Map<String, String>() );
        params.get('paginacion').put('registrosPorPagina', String.valueOf(intNumeroDeRegistros) ); // <---------------------------------------
        params.get('paginacion').put('identificadorPrimerRegistro', identificadorPrimerRegistro);
        params.get('paginacion').put('identificadorUltimoRegistro', identificadorUltimoRegistro);
        
        System.debug('codigo: ' + codigo);
        System.debug('identificador: ' + identificador);
        
        MicroServicioMovimientos msm = new MicroServicioMovimientos();
        MovimientosJSON movimientos = msm.obtenerMovimientos(params);
        
        if(movimientos!=null) {
            success = true;
        }
        System.debug('Movimientos Success: ' + success);
        result.put('success', success);
        result.put('movimientos', movimientos);
        result.put('numRegistros', String.valueOf(intNumeroDeRegistros) );
        System.debug('TESTTEST: ' + result);
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerMovConFechaCorteCliente(String codigo, String identificador, String fechaCorte, String identificadorPrimerRegistro, String identificadorUltimoRegistro) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        ///
        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('movimiento', new Map<String, String>() );
        params.get('movimiento').put('codigo', codigo);
        params.get('movimiento').put('identificador', identificador);
        params.get('movimiento').put('fechaCorte', fechaCorte);

        Integer intNumeroDeRegistros = Integer.valueOf(obtenerNumRegistrosPorPagina());
        params.put('paginacion', new Map<String, String>() );
        params.get('paginacion').put('registrosPorPagina', String.valueOf(intNumeroDeRegistros) ); // <---------------------------------------
        params.get('paginacion').put('identificadorPrimerRegistro', identificadorPrimerRegistro);
        params.get('paginacion').put('identificadorUltimoRegistro', identificadorUltimoRegistro);

        
        System.debug('codigo: ' + codigo);
        System.debug('identificador: ' + identificador);
        System.debug('fechaCorte: ' + fechaCorte);
        
        MicroServicioMovimientos msm = new MicroServicioMovimientos();
        MovimientosJSON movimientos = msm.obtenerMovimientos(params);
        
        if(movimientos!=null) {
            success = true;
        }
        System.debug('Movimientos Success: ' + success);
        result.put('success', success);
        result.put('movimientos', movimientos);
        result.put('numRegistros', String.valueOf(intNumeroDeRegistros) );
        return result;
    }

    public static Decimal obtenerNumRegistrosPorPagina() {
        Decimal result;

        Configuracion_Fecha_Corte__mdt fechasCorte = [SELECT Numero_de_Registros_Movimientos__c FROM Configuracion_Fecha_Corte__mdt LIMIT 1];

        result = fechasCorte.Numero_de_Registros_Movimientos__c;

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerDetalleMovimientoCliente(String numeroExtracto, String numeroMovimientoExtracto, String numeroOperacionCuota, String numeroFinanciacion, String titularidad, String contrato) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroExtracto', numeroExtracto); //1
        params.put('numeroMovimientoExtracto', numeroMovimientoExtracto);
        params.put('numeroOperacionCuota', numeroOperacionCuota);
        params.put('numeroFinanciacion', numeroFinanciacion);
        params.put('titularidad', titularidad);
        params.put('contrato', contrato);
        
        System.debug('numeroExtracto: ' + numeroExtracto);
        System.debug('numeroMovimientoExtracto: ' + numeroMovimientoExtracto);
        System.debug('numeroOperacionCuota: ' + numeroOperacionCuota);
        System.debug('numeroFinanciacion: ' + numeroFinanciacion);
        System.debug('titularidad: ' + titularidad);
        System.debug('contrato: ' + contrato);
        
        MicroServicioDetalleMovimientos msdm = new MicroServicioDetalleMovimientos();
        ///DetalleMovimientosJSON detalleMovimientos = msdm.obtenerDetalleMovimientos(params);
        String detalleMovimientos = msdm.obtenerDetalleMovimientos(params);
        System.debug('detalleMovimientos:  ' + detalleMovimientos);

        DetalleMovimientosJSON detalleMovJSONExito = null;
        MicroServicioJSONError detalleMovJSONError = null;

        try {
            // Se intenta pasear la respuesta con la clase DetalleMovimientosJSON
            detalleMovJSONExito = DetalleMovimientosJSON.parse(detalleMovimientos); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );

            try {
                // Se intenta pasear la respuesta con la clase MicroServicioJSONError
                detalleMovJSONError = MicroServicioJSONError.parse(detalleMovimientos); 
            } catch (Exception ex2) {
                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }
        System.debug('detalleMovJSONExito:  ' + detalleMovJSONExito);
        System.debug('detalleMovJSONError:  ' + detalleMovJSONError);

        if( detalleMovJSONExito != null ) {
            //  DetalleMovimientosJSON
            result.put('success', true);
            result.put('detalleMovimientos', detalleMovJSONExito );
        } else if( detalleMovJSONError != null ) {
            // MicroServicioJSONError
            result.put('success', false);
            result.put('detalleMovimientos', detalleMovJSONError );
        } else {
            // Error
            result.put('success', false);
            result.put('detalleMovimientos', detalleMovimientos );
        }

        System.debug('Detalle Movimientos Success: ' + result.get('success'));
        System.debug('detalleMovimientos:  ' + result.get('detalleMovimientos'));
        return result;
    }

    /**
    * Obtiene la lista con el detalle de los movimientos
    * @return regresa un mapa con una variable booleana de exito y la lista de tipo MovimientosWithDetallesJSON con el detalle de los movimientos
    *
    * @param movimientosList: lista de Movimientos de tipo MovimientosListJSON
    **/
    @AuraEnabled
    public static Map<String, Object> obtenerDetalleMovimientoClienteList(String movimientosList) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        System.debug('movimientosList');
        System.debug(movimientosList);
        
        List<MovimientosWithDetallesJSON> movWithDetallesList = new List<MovimientosWithDetallesJSON>();
        
        List<MovimientosListJSON> movimientos = MovimientosListJSON.parse(movimientosList);
        
        for (MovimientosListJSON movi: movimientos) {

            MovimientosWithDetallesJSON movWithDetalles = new MovimientosWithDetallesJSON();

            if( movi.movimientoPorAutorizar ) {
            
                /// Movimientos No Facturados
                movWithDetalles.fechaHoraTransaccion = movi.fechaHoraTransaccion;
                movWithDetalles.montoLocal = movi.montoLocal;
                movWithDetalles.nombreComercio = movi.descripcionMovimiento;
                movWithDetalles.identificador = '';
                movWithDetalles.pagoMinimo = movi.pagoMinimo;
                movWithDetalles.fechaLimiteDePago = movi.fechaLimiteDePago;
                movWithDetalles.proximaFechaDeCorte = movi.proximaFechaDeCorte;
                movWithDetalles.estatusFinalDeTarjeta = movi.estatusFinalDeTarjeta;
                movWithDetalles.blnPlanPagosConMovs = true;

                movWithDetallesList.add(movWithDetalles);

            } else {

                Map<String, Object> detalle = obtenerDetalleMovimientoCliente(movi.numeroExtracto, movi.numeroMovimientoExtracto, movi.numeroOperacionCuota, movi.numeroFinanciacion, movi.titularidad, movi.contrato);
                
                if(detalle.get('success') == true) {

                    DetalleMovimientosJSON detalleMovimientos = (DetalleMovimientosJSON) detalle.get('detalleMovimientos');
                    String nombreComercio = !Test.isRunningTest() ? detalleMovimientos.message.movimientoDetalle.movimiento.transaccion.localidadTransaccion.nombreComercio : 'Test';
                    String identificador = !Test.isRunningTest() ? detalleMovimientos.message.movimientoDetalle.movimiento.identificador : 'Test';
                    
                    movWithDetalles.fechaHoraTransaccion = movi.fechaHoraTransaccion;
                    movWithDetalles.montoLocal = movi.montoLocal;
                    movWithDetalles.nombreComercio = nombreComercio;
                    movWithDetalles.identificador = identificador;
                    movWithDetalles.pagoMinimo = movi.pagoMinimo;
                    movWithDetalles.fechaLimiteDePago = movi.fechaLimiteDePago;
                    movWithDetalles.proximaFechaDeCorte = movi.proximaFechaDeCorte;
                    movWithDetalles.estatusFinalDeTarjeta = movi.estatusFinalDeTarjeta;
                    movWithDetalles.blnPlanPagosConMovs = true;
                    
                    movWithDetallesList.add(movWithDetalles);
                    
                } else if(detalle.get('success') == false) {

                    movWithDetallesList = new List<MovimientosWithDetallesJSON>();
                    //
                    result.put('error', detalle.get('detalleMovimientos'));
                    break;
                }
            }            
        }
        
        if (movWithDetallesList.size() > 0) {
            success = true;
        }
        
        result.put('success', success);
        result.put('movWithDetallesList', movWithDetallesList);
        return result;
    }

    ///
    @AuraEnabled
    public static Boolean casoCreadoConsultaSaldos(String customerId) {

        Boolean blnResult = false;

        Id idRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulta de Saldos y Movimientos').getRecordTypeId();

        List<Case> listCasos = [SELECT CreatedDate FROM Case 
                                WHERE AccountId =: customerId 
                                AND RecordTypeId =: idRecordType
                                ORDER BY CreatedDate DESC 
                                LIMIT 1];

        System.debug('listCasos --> ' + listCasos);

        if( listCasos.size() > 0 ) {

            Cadena__mdt tiempoDeCreacion = [SELECT Cadena__c FROM Cadena__mdt WHERE DeveloperName = 'TiempoCasoConsultaMov' LIMIT 1];
            Integer minutos = Integer.valueOf(tiempoDeCreacion.Cadena__c);

            DateTime dtNow = System.now();
            dtNow = dtNow.addMinutes(-minutos);
            System.debug('dtNow:  ' + dtNow);

            if( listCasos[0].CreatedDate > dtNow ) {

                blnResult = true;
            }
        }

        return blnResult;
    }
}