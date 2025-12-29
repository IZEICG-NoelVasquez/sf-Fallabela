@isTest
public class MicroServicioValidarOTPTest {

    @isTest static void test_method_1() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/validate/otp');
        //mockMicroSer.generarToken();
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Boolean success = false;

        String numeroDocumento = 'ABCD112233HDFABC00';
        String clave = '112233';

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);
        params.put('clave', clave);

        MicroServicioValidarOTP msValidarOTP = new MicroServicioValidarOTP();
        String respValidarOTP = msValidarOTP.validarOTP(params);

        if (respValidarOTP != null) {
            success = true;
        }
        
        // Verify response received contains fake values
        System.assertEquals(success, true, 'Success');

        ///
        Map<String, String> params_error = new Map<String, String>();
        params.put('error', 'error');

        MicroServicioValidarOTP msValidarOTP_Error = new MicroServicioValidarOTP();
        String respValidarOTP_Error = msValidarOTP_Error.validarOTP(params_error);

        System.debug('respValidarOTP_Error:  ' + respValidarOTP_Error);
    }
}