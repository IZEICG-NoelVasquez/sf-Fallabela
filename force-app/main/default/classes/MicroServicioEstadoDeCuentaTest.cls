@isTest
public class MicroServicioEstadoDeCuentaTest {

    @isTest static void test_method_2() {

        ///
        MockHttpResponseGeneratorMicroServicios mockEdoCta = new MockHttpResponseGeneratorMicroServicios();
        mockEdoCta.setMethod('POST');
        mockEdoCta.setEndpoint('product/create/document');        
        Test.setMock(HttpCalloutMock.class, mockEdoCta);
        Map<String, Object> mapEdoCta = MicroServicioEstadoDeCuenta.obtenerEstadoDeCuenta('numeroDocumento', 'identificador', 'fechaCorte');
    }
}