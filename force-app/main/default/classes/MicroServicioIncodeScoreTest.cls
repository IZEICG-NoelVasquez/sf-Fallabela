@isTest
public class MicroServicioIncodeScoreTest {
    
    @isTest static void getScores() {

        String body = '{"code":"ok","message":{"idValidation":{"overall":{"value":"100.0","status":"OK"}},"livenesscore":{"value":"99.9","status":"OK"},"faceRecognition":{"overall":{"value":"75.6","status":"OK"}},"ocrValidationOverall":{"value":"92.0","status":"OK"},"ineScrapingValidation":"success","overall":{"value":"91.8","status":"OK"}}}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeScore = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeScore.setMethod('POST');
        mockMSIncodeScore.setEndpoint('client/incode/score');
        mockMSIncodeScore.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeScore);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeScore.getScores('test123', 'token123');

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void getScores_ErrorStatus() {

        String body = '{"code":"ok","message":"error"}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeScore = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeScore.setMethod('POST');
        mockMSIncodeScore.setEndpoint('client/incode/score');
        mockMSIncodeScore.setStatusCode(500);
        mockMSIncodeScore.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeScore);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeScore.getScores('test123', 'token123');

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
    }

    @isTest static void getScores_Error() {

        MockHttpResponseGeneratorMicroServicios mockMSIncodeScore = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeScore.setMethod('POST');
        mockMSIncodeScore.setEndpoint('client/incode/score');
        mockMSIncodeScore.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeScore);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioIncodeScore.getScores('test123', 'token123');

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
    }
}