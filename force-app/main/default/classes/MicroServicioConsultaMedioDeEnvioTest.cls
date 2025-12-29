@isTest
public class MicroServicioConsultaMedioDeEnvioTest {
    @isTest static void test_method_1() {
        
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('product/get/address');
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        String numeroDocumento = 'ABCD112233HDFABC00';
        String identificador = '00010252000000001352';

        Map<String, Object> testMedioEnvio = MicroServicioConsultaMedioDeEnvio.consulta_Medio_Envio( numeroDocumento, identificador);

    }
}