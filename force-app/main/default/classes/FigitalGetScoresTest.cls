@isTest
public class FigitalGetScoresTest {

    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        List<Case> lstCases = new List<Case>();

        Case caso1 = new Case();
        caso1.AccountId = acc.Id;
        caso1.ID_Solicitud__c = '1521133';
        caso1.Cupo__c = 100;
        caso1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();
        lstCases.add(caso1);

        Case caso2 = new Case();
        caso2.AccountId = acc.Id;
        caso2.ID_Solicitud__c = '1521144';
        caso2.Cupo__c = 100;
        caso2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();
        lstCases.add(caso2);

        insert lstCases;

        Validacion_Figital__c validacionFigital = new Validacion_Figital__c();
        validacionFigital.Name = 'Score Test';
        validacionFigital.Caso__c = caso2.Id;
        insert validacionFigital;
    }
    
    @isTest static void msIncodeStart() {

        String body = '{"code":"ok","message":{"interviewId":"626c16","token":"eyJhbGciOiJIUzI1NiJ9","interviewCode":"WMGIFZ","idCaptureTimeout":25,"selfieCaptureTimeout":25,"idCaptureRetries":3,"selfieCaptureRetries":3,"curpValidationRetries":1,"clientId":"falabella858","env":"demo","existingSession":true}}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeStart = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeStart.setMethod('POST');
        mockMSIncodeStart.setEndpoint('client/incode/start');
        mockMSIncodeStart.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeStart);

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521133' LIMIT 1];

        Test.startTest();

        Map<String, Object> mapResult = FigitalGetScores.msIncodeStart('ALL', 'test123', lstCases[0].Id);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void msIncodeStart_RecordExist() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521144' LIMIT 1];

        Test.startTest();

        Map<String, Object> mapResult = FigitalGetScores.msIncodeStart('ALL', 'test123', lstCases[0].Id);

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
        System.assertEquals(true, mapResult.get('recordAlreadyCreated'));
    }

    @isTest static void msIncodeScore() {

        String body = '{"code":"ok","message":{"parseResponse":{"idValidation":{"overall":{"value":"100.0","status":"OK"}},"liveness":{"overall":{"value":"99.9","status":"OK"}},"faceRecognition":{"overall":{"value":"75.6","status":"OK"}},"ineScrapingValidation":{"result":"success"},"governmentValidation":{"ocrValidationOverall":{"value":"92.0","status":"OK"}},"overall":{"value":"91.8","status":"OK"}}}}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeScore = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeScore.setMethod('POST');
        mockMSIncodeScore.setEndpoint('client/incode/score');
        mockMSIncodeScore.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeScore);

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521133' LIMIT 1];

        Test.startTest();

        Map<String, Object> mapResult = FigitalGetScores.msIncodeScore('test123', lstCases[0].Id, 'token123');

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void msIncodeScore_Error() {

        String body = '{"code":"ok","message":{"parseResponse":{"idValidation":{"overall":{"value":"100.0","status":"OK"}},"liveness":{"overall":{"value":"99.9","status":"OK"}},"faceRecognition":{"overall":{"value":"75.6","status":"OK"}},"ineScrapingValidation":{"result":"success"},"governmentValidation":{"ocrValidationOverall":{"value":"92.0","status":"OK"}},"overall":{"value":"91.8","status":"OK"}}}}';

        MockHttpResponseGeneratorMicroServicios mockMSIncodeScore = new MockHttpResponseGeneratorMicroServicios();
        mockMSIncodeScore.setMethod('POST');
        mockMSIncodeScore.setEndpoint('client/incode/score');
        mockMSIncodeScore.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSIncodeScore);

        Test.startTest();

        Map<String, Object> mapResult = FigitalGetScores.msIncodeScore('test123', null, 'token123');

        Test.stopTest();

        System.assertEquals(false, mapResult.get('success'));
    }
}