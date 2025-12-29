@isTest
public with sharing class MicroServicioDetalleMovimientosTest {

        @isTest static void MicroServicioDetalleMovimientosTest() {
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('product/transaction/detail');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Boolean success = false;
        
		String numeroExtracto = '1';
        String numeroMovimientoExtracto = '5';
        String numeroOperacionCuota = '3';
        String numeroFinanciacion = '1';
        String titularidad= 'Titular';
        String contrato= '00010252000000001352';
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroExtracto', numeroExtracto);
        params.put('numeroMovimientoExtracto', numeroMovimientoExtracto);
        params.put('numeroOperacionCuota', numeroOperacionCuota);
        params.put('numeroFinanciacion', numeroFinanciacion);
        params.put('titularidad', titularidad);
        params.put('contrato', contrato);        
        
        MicroServicioDetalleMovimientos msdm = new MicroServicioDetalleMovimientos();
        ///DetalleMovimientosJSON detalleMovimientos = msdm.obtenerDetalleMovimientos(params);
        String detalleMovimientos = msdm.obtenerDetalleMovimientos(params);
        
        if (detalleMovimientos != null) {
            success = true;
        }
        
        // Verify response received contains fake values
        System.assertEquals(success, true, 'Success');
    }

    @isTest static void errorTest() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('product/transaction/detail');
        mockMicroSer.setBody('{"code":"error","message":"Transaction Detail service error"}');
        mockMicroSer.setStatusCode(404);
        
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        String numeroExtracto = '1';
        String numeroMovimientoExtracto = '5';
        String numeroOperacionCuota = '3';
        String numeroFinanciacion = '1';
        String titularidad= 'Titular';
        String contrato= '00010252000000001352';
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroExtracto', numeroExtracto);
        params.put('numeroMovimientoExtracto', numeroMovimientoExtracto);
        params.put('numeroOperacionCuota', numeroOperacionCuota);
        params.put('numeroFinanciacion', numeroFinanciacion);
        params.put('titularidad', titularidad);
        params.put('contrato', contrato);        
        
        Test.startTest();

        MicroServicioDetalleMovimientos msdm = new MicroServicioDetalleMovimientos();
        String detalleMovimientos = msdm.obtenerDetalleMovimientos(params);

        Test.stopTest();

        MicroServicioJSONError detalleMovJSONError = MicroServicioJSONError.parse(detalleMovimientos);
        System.assertEquals( detalleMovJSONError.code, 'error');
    }
}