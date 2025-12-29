@isTest
public class SendOTPControllerTest {

    static Account acc1;
    static Case caso;

    static void init() {

        acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        caso = new Case();
        caso.AccountId = acc1.Id;
        insert caso;
    }

    @isTest static void test_method_1() {

        init();

        Account accTest = SendOTPController.getCustomerByCaseId(caso.Id);

        // Account null
        Account accNull = SendOTPController.getCustomerByCaseId(null);

        //
        SendOTPController.obtenerConfiguracionServicio();

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSerSend = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerSend.setMethod('POST');
        mockMicroSerSend.setEndpoint('client/create/otp');
        Test.setMock(HttpCalloutMock.class, mockMicroSerSend);
        Map<String, Object> mapSendOTP = SendOTPController.sendOTPMicroservicio( 'ABCD112233HDFABC00', '5511223344');

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSerValid = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerValid.setMethod('POST');
        mockMicroSerValid.setEndpoint('client/validate/otp');
        Test.setMock(HttpCalloutMock.class, mockMicroSerValid);
        Map<String, Object> mapValidateOTP = SendOTPController.validateOTPMicroservicio( 'ABCD112233HDFABC00', '112233');
        Registro_OTP__c rOTP = SendOTPController.createRegistroOTP('8129386103',acc1.Id,'ABCD112233HDFABC00','Éxito','Exitoso','Actualización Celular','Envío OTP','case',caso.Id);
    	Registro_OTP__c rOTP2 = SendOTPController.createRegistroOTP('8129386103',acc1.Id,'ABCD112233HDFABC00','Éxito','Exitoso','Actualización de Correo','Envío OTP','acc','');

    }

    @isTest static void test_method_2() {

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSerSend = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerSend.setMethod('POST');
        mockMicroSerSend.setEndpoint('client/create/otp');
        Test.setMock(HttpCalloutMock.class, mockMicroSerSend);
        Map<String, Object> mapSendOTP = SendOTPController.sendOTPMicroservicio( 'ABCD112233HDFABC00', '5511223344');

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSerValid = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSerValid.setMethod('POST');
        mockMicroSerValid.setEndpoint('client/validate/otp');
        Test.setMock(HttpCalloutMock.class, mockMicroSerValid);
        Map<String, Object> mapValidateOTP = SendOTPController.validateOTPMicroservicio( 'ABCD112233HDFABC00', '112233');

        ///
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseTwilio());
        Boolean blnSendTwilio = SendOTPController.sendOTPCodeByPhoneTwilio('5511223344');

        Boolean blnValidateTwilio = SendOTPController.validateOTPCodeTwilio('5511223344', '112233');
    }

}