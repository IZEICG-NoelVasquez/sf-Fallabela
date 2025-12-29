@isTest
public class MicroServicioIncodeStartTest {
    
    @isTest static void getInterviewId() {

        String body = '{"code":"ok","message":{"interviewId":"626c16","token":"eyJhbGciOiJIUzI1NiJ9","interviewCode":"WMGIFZ","idCaptureTimeout":25,"selfieCaptureTimeout":25,"idCaptureRetries":3,"selfieCaptureRetries":3,"curpValidationRetries":1,"clientId":"falabella858","env":"demo","existingSession":true}}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeStart = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeStart.setMethod('POST');
        mockMSIncodeStart.setEndpoint('client/incode/start');
        mockMSIncodeStart.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeStart);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeStart.getInterviewId('ALL', 'test123');

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void getInterviewId_ErrorStatus() {

        String body = '{"code":"ok","message":"error"}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeStart = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeStart.setMethod('POST');
        mockMSIncodeStart.setEndpoint('client/incode/start');
        mockMSIncodeStart.setStatusCode(500);
        mockMSIncodeStart.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeStart);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeStart.getInterviewId('ALL', 'test123');

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
    }

    @isTest static void getInterviewId_Error() {

        MockHttpResponseGeneratorMicroServicios mockMSIncodeStart = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeStart.setMethod('POST');
        mockMSIncodeStart.setEndpoint('client/incode/start');
        mockMSIncodeStart.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeStart);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeStart.getInterviewId('ALL', 'test123');

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
    }
}