/**
* Nombre: MicroServicioProductosTest
* Autor: ---
* Descripcion: Test Method de la Clase MicroServicioProductos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     ---
* 2.0           22/06/2021      Mauricio Rosales        Se agrega el metodo obtenerProductosCliente 
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioProductosTest {
    
    @isTest static void MicroServicioProductosTest() {
        
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('products');
        
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        Boolean success = false;
        String curp='BEPK851212HNLNRR08';
        
        Map<String, String> params = new Map<String, String>();
        params.put('curp', curp);
        
        MicroServicioProductos msp = new MicroServicioProductos();
        String productos = msp.obtenerProductos(params);
        ProductosJson productosExito = null;

        try {
            // Se intenta pasear la respuesta con la clase ProductosJson
            productosExito = ProductosJson.parse(productos); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }

        if (productosExito != null) {
            success = true;
        }
        
        // Verify response received contains fake values        
        System.assertEquals(success, true, 'Success');
        
    }

    @isTest static void obtenerProductosCliente_Exito() {

        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();
        mockProductos.setEndpoint('products'); 
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioProductos.obtenerProductosCliente('ABCD901201HDFBCD01');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void obtenerProductosCliente_Error() {

        String body = '{"code":"error","message":"the curp is not correct"}';

        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();
        mockProductos.setMethod('POST');
        mockProductos.setEndpoint('products');
        mockProductos.setBody(body);
        mockProductos.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapProductos = MicroServicioProductos.obtenerProductosCliente('ABCD901201HDFBCD01');

        Test.stopTest();

        System.assertEquals( mapProductos.get('success'), false);
    }

    @isTest static void obtenerProductosCliente_Catch() {

        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();
        mockProductos.setMethod('POST');
        mockProductos.setEndpoint('products');
        mockProductos.setBody('');
        mockProductos.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapProductos = MicroServicioProductos.obtenerProductosCliente('ABCD901201HDFBCD01');

        Test.stopTest();

        System.assertEquals( mapProductos.get('success'), false);
    }
}