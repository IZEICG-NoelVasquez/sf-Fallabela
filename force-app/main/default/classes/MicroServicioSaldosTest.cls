@isTest
public class MicroServicioSaldosTest {
    @isTest static void MicroServicioProductosTest() {
        
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('product/balances');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Boolean success = false;
        
		String codigoProducto = '1';
        String codigoSubProducto = '010001';
        String identificadorProducto = '522375******2700';
        String identificador = '00010252000000001352';
        
        Map<String, String> params = new Map<String, String>();
        params.put('codigoProducto', codigoProducto);
        params.put('codigoSubProducto', codigoSubProducto);
        params.put('identificadorProducto', identificadorProducto);
        params.put('identificador', identificador);
        
        
        MicroServicioSaldos mss = new MicroServicioSaldos();
        SaldosJson saldos = mss.obtenerSaldos(params);
        
        if (saldos != null) {
            success = true;
        }
        
        // Verify response received contains fake values
        System.assertEquals(success, true, 'Success');
        
    }
    
}