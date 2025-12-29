/**
* Nombre: DataUpdateGestorTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase DataUpdateGestor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/02/2022      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class DataUpdateGestorTest {
    
    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        String rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        List<Case> lstCases = new List<Case>();

        Case case_1 = new Case();
        case_1.AccountId = acc.Id;
        case_1.ID_Solicitud__c = '12345678';
        case_1.Cupo__c = 100;
        case_1.RecordTypeId = rtCredito;
        case_1.Status = 'Asignada';
        lstCases.add(case_1);

        insert lstCases;
    }

    @isTest static void getCaseInfo() {

        ///
        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Test.startTest();

        Map<String,Object> mapResult = DataUpdateGestor.getCaseInfo(lstCases[0].Id);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void dataUpdateMS_Telefono() {

        String telefonoId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('telefonos/' + telefonoId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('mobilePhone', '5215511223344');
        mapFields.put('telefonoId', telefonoId);

        Test.startTest();

        Map<String, Object> mapResult = DataUpdateGestor.dataUpdateMS(mapFields);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('updateMobilePhone'));
    }

    @isTest static void dataUpdateMS_TelefonoError() {

        String telefonoId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('telefonos/' + telefonoId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('mobilePhone', '5215511223344');
        mapFields.put('telefonoId', telefonoId);

        Test.startTest();

        Map<String, Object> mapResult = DataUpdateGestor.dataUpdateMS(mapFields);

        Test.stopTest();

        System.assertEquals(false, mapResult.get('updateMobilePhone'));
    }

    @isTest static void dataUpdateMS_Custom() {

        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        String customId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('evaluaciones/' + evaluacionId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('creditLimit', '15000');
        mapFields.put('evaluacionId', evaluacionId);
        mapFields.put('customId', customId);

        Test.startTest();

        Map<String, Object> mapResult = DataUpdateGestor.dataUpdateMS(mapFields);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('updateCreditLimitEvaluaciones'));
        System.assertEquals(true, mapResult.get('updateCreditLimitCustom'));
    }

    @isTest static void dataUpdateMS_CustomError() {

        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        String customId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('evaluaciones/' + evaluacionId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('creditLimit', '15000');
        mapFields.put('evaluacionId', evaluacionId);
        mapFields.put('customId', customId);

        Test.startTest();

        Map<String, Object> mapResult = DataUpdateGestor.dataUpdateMS(mapFields);

        Test.stopTest();

        System.assertEquals(false, mapResult.get('updateCreditLimitEvaluaciones'));
        System.assertEquals(false, mapResult.get('updateCreditLimitCustom'));
    }

    @isTest static void updateCaseRecord() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put('N_mero_de_Tel_fono_M_vil__c', '5215511223344');

        Test.startTest();

        Map<String, Object> mapResult = DataUpdateGestor.updateCaseRecord(lstCases[0].Id, mapFields);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void createCaseHistory() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];        

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put('Caso__c', lstCases[0].Id);
        mapFields.put('Name', 'Número de Teléfono Móvil');
        mapFields.put('Valor_nuevo__c', '5215511223344');
        mapFields.put('Valor_original__c', '5215511223322');
        mapFields.put('Numero_de_intento__c', 1);
        mapFields.put('API_Name__c', 'N_mero_de_Tel_fono_M_vil__c');

        List<Map<String, Object>> lstMapFields = new List<Map<String, Object>>();
        lstMapFields.add(mapFields);

        Test.startTest();

        Map<String,Object> mapResult = DataUpdateGestor.createCaseHistory(lstMapFields);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }

    @isTest static void createCaseHistory_ErrorDml() {

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put('Name', 'Número de Teléfono Móvil');

        List<Map<String, Object>> lstMapFields = new List<Map<String, Object>>();
        lstMapFields.add(mapFields);

        String error = '';

        Test.startTest();

        try {
        
            Map<String,Object> mapResult = DataUpdateGestor.createCaseHistory(lstMapFields);
            
        } catch(Exception ex) {

            error = ex.getMessage();
        }

        Test.stopTest();

        System.assertEquals('Script-thrown exception', error);
    }

    @isTest static void createCaseHistory_Catch() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];        

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put('Caso__c', lstCases[0].Id);
        mapFields.put('Name', true);

        List<Map<String, Object>> lstMapFields = new List<Map<String, Object>>();
        lstMapFields.add(mapFields);

        String error = '';

        Test.startTest();

        try {
            
            Map<String,Object> mapResult = DataUpdateGestor.createCaseHistory(lstMapFields);
            
        } catch(Exception ex) {

            error = ex.getMessage();
        }

        Test.stopTest();

        System.assertEquals('Script-thrown exception', error);
    }

    @isTest static void submitForApproval() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Map<String, String> mapFields = new Map<String, String>();
        mapFields.put('recordId', lstCases[0].Id);

        Test.startTest();

        Map<String,Object> mapResult = DataUpdateGestor.submitForApproval(mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }
}