@isTest
public class MicroServicioFechasCorteTest {

    @isTest static void test_method_1() {

        ///
        Map<String, String> mapParametrosFechas = MicroServicioFechasCorte.obtenerParametrosFechasCorte();
    }

    @isTest static void test_method_2() {

        ///
        MockHttpResponseGeneratorMicroServicios mockFechasCorte = new MockHttpResponseGeneratorMicroServicios();
        mockFechasCorte.setMethod('POST');
        mockFechasCorte.setEndpoint('product/billing/date');        
        Test.setMock(HttpCalloutMock.class, mockFechasCorte);
        Map<String, Object> mapFechasCorte = MicroServicioFechasCorte.obtenerFechasCorteCliente('ABCD112233HDFABC00', '01/01/2020', '01/01/2021', '01/01/2021');
    }
}