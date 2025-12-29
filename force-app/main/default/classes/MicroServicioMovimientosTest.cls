/**
* Nombre: MicroServicioMovimientosTest
* Autor: ---
* Descripcion: Test Method de la clase apex MicroServicioMovimientos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     Creación
* 2.0           06/07/2021      Mauricio Rosales        Validar movimientos No Facturados al llamar al MS Detalle Movimientos
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioMovimientosTest {

    static void init() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulta de Saldos y Movimientos').getRecordTypeId();
        caso.Categor_a__c = 'Consultas';
        insert caso;  
    }

    @isTest static void test_method_1() {

        init();

        Id idAcc = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ].Id;

        Test.startTest();

        Boolean blnResult = MicroServicioMovimientos.casoCreadoConsultaSaldos(idAcc);

        Test.stopTest();

        System.assertEquals( blnResult, true);
    }

    @isTest static void MicroServicioMovimientosTest() {
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('product/transactions');
        mockMicroSer.setVersion('v2');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Boolean success = false;
        
		String codigo = '0';
        String identificador = '00010252000000001352';
        String fechaCorte = '2020-10-26';
        String registrosPorPagina = '20';
        String identificadorPrimerRegistro = '';
        String identificadorUltimoRegistro = '';

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();
        params.put('movimiento', new Map<String, String>() );
        params.get('movimiento').put('codigo', codigo);
        params.get('movimiento').put('identificador', identificador);
        params.get('movimiento').put('fechaCorte', fechaCorte);

        params.put('paginacion', new Map<String, String>() );
        params.get('paginacion').put('registrosPorPagina', registrosPorPagina);
        params.get('paginacion').put('identificadorPrimerRegistro', identificadorPrimerRegistro);
        params.get('paginacion').put('identificadorUltimoRegistro', identificadorUltimoRegistro);
        
        
        MicroServicioMovimientos msm = new MicroServicioMovimientos();
        MovimientosJSON movimientos = msm.obtenerMovimientos(params);
        
        if (movimientos != null) {
            success = true;
        }
        
        // Verify response received contains fake values
        System.assertEquals(success, true, 'Success');
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMovSinFecha = new MockHttpResponseGeneratorMicroServicios();
        mockMovSinFecha.setMethod('POST');
        mockMovSinFecha.setEndpoint('product/transactions');
        mockMovSinFecha.setVersion('v2');
        Test.setMock(HttpCalloutMock.class, mockMovSinFecha);
        Map<String, Object> mapMocSinFecha = MicroServicioMovimientos.obtenerMovSinFechaCorteCliente( 'codigo', 'identificador', '', '');

        ///
        MockHttpResponseGeneratorMicroServicios mockMovConFecha = new MockHttpResponseGeneratorMicroServicios();
        mockMovConFecha.setMethod('POST');
        mockMovConFecha.setEndpoint('product/transactions');
        mockMovConFecha.setVersion('v2');
        Test.setMock(HttpCalloutMock.class, mockMovConFecha);
        Map<String, Object> mapMocConFecha = MicroServicioMovimientos.obtenerMovConFechaCorteCliente( 'codigo', 'identificador', '01/01/2020', '', '');

        ///
        MockHttpResponseGeneratorMicroServicios mockDetalleMov = new MockHttpResponseGeneratorMicroServicios();
        mockDetalleMov.setMethod('POST');
        mockDetalleMov.setEndpoint('product/transaction/detail');        
        Test.setMock(HttpCalloutMock.class, mockDetalleMov);
        Map<String, Object> mapDetalleMov = MicroServicioMovimientos.obtenerDetalleMovimientoCliente('numeroExtracto', 'numeroMovimientoExtracto', 'numeroOperacionCuota', 'numeroFinanciacion', 'titularidad', 'contrato');

        ///
        MockHttpResponseGeneratorMicroServicios mockDetalleMovList = new MockHttpResponseGeneratorMicroServicios();
        mockDetalleMovList.setMethod('POST');
        mockDetalleMovList.setEndpoint('product/transaction/detail');
        Test.setMock(HttpCalloutMock.class, mockDetalleMovList);
        String strMovimientosList = '[{"numeroExtracto":"4","numeroMovimientoExtracto":"2","numeroOperacionCuota":"0","numeroFinanciacion":"0","titularidad":"Titular","contrato":"00010252000000002915","fechaHoraTransaccion":"2019-05-05T00:00:00.000Z","montoLocal":173.33,"movimientoPorAutorizar":false}]';
        Map<String, Object> mapDetalleMovList = MicroServicioMovimientos.obtenerDetalleMovimientoClienteList(strMovimientosList);
    }

    @isTest static void errorTest() {

        MockHttpResponseGeneratorMicroServicios mockDetalleMovList = new MockHttpResponseGeneratorMicroServicios();
        mockDetalleMovList.setMethod('POST');
        mockDetalleMovList.setEndpoint('product/transaction/detail');
        mockDetalleMovList.setBody('{"code":"error","message":"Transaction Detail service error"}');
        mockDetalleMovList.setStatusCode(404);

        Test.setMock(HttpCalloutMock.class, mockDetalleMovList);
        String strMovimientosList = '[{"numeroExtracto":"4","numeroMovimientoExtracto":"2","numeroOperacionCuota":"0","numeroFinanciacion":"0","titularidad":"Titular","contrato":"00010252000000002915","fechaHoraTransaccion":"2019-05-05T00:00:00.000Z","montoLocal":173.33,"movimientoPorAutorizar":false}]';
        
        Test.startTest();

        Map<String, Object> mapDetalleMovList = MicroServicioMovimientos.obtenerDetalleMovimientoClienteList(strMovimientosList);

        Test.stopTest();

        System.assertEquals( mapDetalleMovList.get('success'), false);
    }

    @isTest static void movNoFacturadoTest() {

        MockHttpResponseGeneratorMicroServicios mockDetalleMovList = new MockHttpResponseGeneratorMicroServicios();
        mockDetalleMovList.setMethod('POST');
        mockDetalleMovList.setEndpoint('product/transaction/detail');
        mockDetalleMovList.setBody('{"code":"error","message":"Transaction Detail service error"}');
        mockDetalleMovList.setStatusCode(404);

        Test.setMock(HttpCalloutMock.class, mockDetalleMovList);
        String strMovimientosList = '[{"numeroExtracto":"4","numeroMovimientoExtracto":"2","numeroOperacionCuota":"0","numeroFinanciacion":"0","titularidad":"Titular","contrato":"00010252000000002915","fechaHoraTransaccion":"2019-05-05T00:00:00.000Z","montoLocal":173.33,"descripcionMovimiento":"Test","movimientoPorAutorizar":true}]';
        
        Test.startTest();

        Map<String, Object> mapDetalleMovList = MicroServicioMovimientos.obtenerDetalleMovimientoClienteList(strMovimientosList);

        Test.stopTest();

        System.assertEquals( mapDetalleMovList.get('success'), true);
    }
}