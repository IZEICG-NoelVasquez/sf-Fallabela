@isTest
public class MicroServicioEnviarOTPTest {

    @isTest static void test_method_1() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/create/otp');
        //mockMicroSer.generarToken();
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Boolean success = false;
        
        String numeroDocumento = 'ABCD112233HDFABC00';
        String numeroCelular = '5511223344';

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);
        params.put('numeroCelular', numeroCelular);
        params.put('codigoArea', '00521');

        MicroServicioEnviarOTP msEnviarOTP = new MicroServicioEnviarOTP();
        String respEnviarOTP = msEnviarOTP.enviarOTP(params);

        if (respEnviarOTP != null) {
            success = true;
        }
        
        // Verify response received contains fake values
        System.assertEquals(success, true, 'Success');
    }
}