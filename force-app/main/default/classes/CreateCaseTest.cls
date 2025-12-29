/**
* Nombre: CreateCaseTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase CreateCase
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           25/06/2021      Mauricio Rosales        Creación
* 2.0           22/07/2021      Mauricio Rosales        Validacion de saltos de etapa en el trigger
* 3.0           10/08/2021      Mauricio Rosales        Bloqueo de tarjetas desde un registro de Casos
* 4.0           08/12/2021      Mauricio Rosales        Try Catch para regresar las DmlException al componente
* --------------------------------------------------------------------------
*/
@isTest
public class CreateCaseTest {

    @testSetup
    static void setupData () {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        List<Case> lstCases = new List<Case>();

        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        case1.AccountId = acc1.Id;
        case1.Categor_a__c = 'Consultas';
        lstCases.add(case1);

        Case case2 = new Case();
        case2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        case2.Categor_a__c = 'Cancelación de Tarjeta';
        case2.Status = 'Cerrado';
        case2.AccountId = acc1.Id;
        lstCases.add(case2);

        insert lstCases;
    }

    @isTest static void createCaseClosedByRT() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';
        String camposRequeridos = 'Tipodeconsulta__c:Saldos;Movimientos';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        CreateCase caseTest = new CreateCase();

        Test.startTest();

        Map<String, Object> mapResult = caseTest.createCaseClosedByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstContacts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue, 
                                                                        camposRequeridos );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void createCaseClosedByRT_catch() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';
        String camposRequeridos = 'Correo_Actualizado_Microservicio__c:false,Tipodeconsulta__c:true';

        CreateCase caseTest = new CreateCase();

        Test.startTest();

        Map<String, Object> mapResult = caseTest.createCaseClosedByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstContacts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue, 
                                                                        camposRequeridos );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void createCaseClosedByRT_curp() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_CURP').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';

        String camposRequeridos = 'Actualizaci_n_Alta__c:Actualización,';
        camposRequeridos += 'CURP_texto__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Curp_Anterior__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Nombre_s__c:TEST,';
        camposRequeridos += 'Segundo_Apellido__c:TEST,';
        camposRequeridos += 'Primer_Apellido__c:TEST,';
        camposRequeridos += 'Actualizaci_n_de_CURP__c:CURP Duplicado,';
        camposRequeridos += 'Type:CURP Duplicado,';
        camposRequeridos += 'Actualizaci_n_de_nombre__c:No,';
        camposRequeridos += 'Actualizar_domicilio__c:No';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        CreateCase caseTest = new CreateCase();

        Test.startTest();

        Map<String, Object> mapResult = caseTest.createCaseClosedByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstContacts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue, 
                                                                        camposRequeridos );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void createCaseOpenByRT() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';

        Test.startTest();

        Map<String, Object> mapResult = CreateCase.createCaseOpenByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstContacts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void createCaseOpenByRT_catch() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';

        Test.startTest();

        Map<String, Object> mapResult = CreateCase.createCaseOpenByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstAccounts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void closeCaseByRT() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();

        List<Case> lstCases = [SELECT Id FROM Case WHERE RecordTypeId = : recordTypeId];

        Map<String, Object> mapRequiredFields = new Map<String,Object>();
        mapRequiredFields.put('Tipodeconsulta__c', 'Saldos');

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        Map<String, Object> mapResult = CreateCase.closeCaseByRT(lstCases[0].Id, mapRequiredFields );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void closeCaseByRT_catch() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();

        List<Case> lstCases = [SELECT Id FROM Case WHERE RecordTypeId = : recordTypeId];

        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];

        Map<String, Object> mapRequiredFields = new Map<String,Object>();
        mapRequiredFields.put('Tipodeconsulta__c', 'Saldos');
        mapRequiredFields.put('ContactId', lstAccounts[0].Id);

        Test.startTest();

        Map<String, Object> mapResult = CreateCase.closeCaseByRT(lstCases[0].Id, mapRequiredFields );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void updateCaseByRT() {

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' AND RecordTypeId = : recordTypeId LIMIT 1 ];

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put( 'TarjetaCaso__c', '555512******1234');

        Test.startTest();

        Map<String, Object> mapResult = CreateCase.updateCaseByRT( lstCases[0].Id, mapFields);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void updateCaseByRT_catch() {

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' AND RecordTypeId = : recordTypeId LIMIT 1 ];

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put( 'TarjetaCaso__c', true);

        String error = '';

        Test.startTest();

        try {

            Map<String, Object> mapResult = CreateCase.updateCaseByRT( lstCases[0].Id, mapFields);

        } catch(Exception ex) {

            error = ex.getMessage();
        }

        Test.stopTest();

        System.assertEquals( 'Script-thrown exception', error);
    }

    @isTest static void updateCaseByRT_ErrorDml() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'CaseTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' AND RecordTypeId = : recordTypeId LIMIT 1 ];

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put( 'Subgrupo__c', 'Nuevos con uso');

        String error = '';

        Test.startTest();

        try {

            Map<String, Object> mapResult = CreateCase.updateCaseByRT( lstCases[0].Id, mapFields);

        } catch(Exception ex) {

            error = ex.getMessage();
        }
        
        Test.stopTest();

        System.assertEquals( 'Script-thrown exception', error);
    }
}