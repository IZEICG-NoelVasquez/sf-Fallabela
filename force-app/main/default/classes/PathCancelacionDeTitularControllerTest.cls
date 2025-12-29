/**
* Nombre: PathCancelacionDeTitularControllerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase PathCancelacionDeTitular
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           08/12/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class PathCancelacionDeTitularControllerTest {

    @testSetup
    static void setupData() {

        List<Account> lstAccounts = new List<Account>();

        /// Cuenta con 1 caso de Retencion
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        lstAccounts.add(acc1);

        /// Cuenta con 2 casos de Retencion
        Account acc2 = new Account();
        acc2.LastName = 'Test112233';
        acc2.CURP__c = 'ABCD223344HDFABC00';
        lstAccounts.add(acc2);

        /// Cuenta sin Casos
        Account acc3 = new Account();
        acc3.LastName = 'Test445566';
        acc3.CURP__c = 'ABCD445566HDFABC00';
        lstAccounts.add(acc3);

        insert lstAccounts;


        List<Case> lstCases = new List<Case>();
        
        /// Cuenta con 1 caso de Retencion de Titular
        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId();
        case1.Categor_a__c = 'Cancelación de Tarjeta';
        case1.Status = 'Retención';
        case1.AccountId = acc1.Id;
        case1.Subgrupo__c = 'Nuevos con uso';
        case1.Motivo_de_la_Retenci_n__c = 'Bono de 1,000 puntos';
        lstCases.add(case1);
        
        Case case2 = new Case();
        case2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        case2.Categor_a__c = 'Cancelación de Tarjeta';
        case2.Status = 'Motivo de Cancelación';
        case2.AccountId = acc1.Id;
        case2.Subgrupo__c = 'Nuevos con uso';
        case2.Motivo_de_la_Retenci_n__c = 'Bono de 1,000 puntos';
        lstCases.add(case2);

        /// Cuenta con 2 casos de Retencion de Titular
        Case case3 = new Case();
        case3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId();
        case3.Categor_a__c = 'Cancelación de Tarjeta';
        case3.Status = 'Retención';
        case3.AccountId = acc2.Id;
        case3.Subgrupo__c = 'Nuevos con uso';
        case3.Motivo_de_la_Retenci_n__c = 'Beneficios';
        lstCases.add(case3);

        Case case4 = new Case();
        case4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId();
        case4.Categor_a__c = 'Cancelación de Tarjeta';
        case4.Status = 'Retención';
        case4.AccountId = acc2.Id;
        case4.Subgrupo__c = 'Nuevos con uso';
        case4.Motivo_de_la_Retenci_n__c = 'Beneficios';
        lstCases.add(case4);
        
        Case case5 = new Case();
        case5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        case5.Categor_a__c = 'Cancelación de Tarjeta';
        case5.Status = 'Motivo de Cancelación';
        case5.AccountId = acc2.Id;
        case5.Subgrupo__c = 'Nuevos con uso';
        case5.Motivo_de_la_Retenci_n__c = 'Bono de 1,000 puntos';
        lstCases.add(case5);

        /// Cuenta sin casos de Retencion de Titular
        Case case6 = new Case();
        case6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        case6.Categor_a__c = 'Cancelación de Tarjeta';
        case6.Status = 'Motivo de Cancelación';
        case6.AccountId = acc3.Id;
        case6.Subgrupo__c = 'Nuevos con uso';
        case6.Motivo_de_la_Retenci_n__c = 'Bono de 1,000 puntos';
        lstCases.add(case6);

        insert lstCases;
    }

    @isTest static void getPickListValues_1Case() {

        String idRTCancelacion = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        List<Case> lstCaseCancelacion = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' AND RecordTypeId = : idRTCancelacion LIMIT 1 ];

        Test.startTest();

        Map<String, Object> mapResult = PathCancelacionDeTitularController.getPickListValues(lstCaseCancelacion[0].Id);

        Test.stopTest();

        Map<String, List<String>> mapRetencion = (Map<String, List<String>>)mapResult.get('mapMotivoRetencionDependencias');
        System.assertEquals( false, !mapRetencion.get('Nuevos con uso').contains('Bono de 1,000 puntos') );
    }

    @isTest static void getPickListValues_2Case() {

        String idRTCancelacion = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        List<Case> lstCaseCancelacion = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD223344HDFABC00' AND RecordTypeId = : idRTCancelacion LIMIT 1 ];

        Test.startTest();

        Map<String, Object> mapResult = PathCancelacionDeTitularController.getPickListValues(lstCaseCancelacion[0].Id);

        Test.stopTest();

        Map<String, List<String>> mapRetencion = (Map<String, List<String>>)mapResult.get('mapMotivoRetencionDependencias');
        System.assertEquals( true, mapRetencion.get('Nuevos con uso').contains('Bono de 1,000 puntos') );
    }

    @isTest static void getPickListValues_0Cases() {

        String idRTCancelacion = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        List<Case> lstCaseCancelacion = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD445566HDFABC00' AND RecordTypeId = : idRTCancelacion LIMIT 1 ];

        Test.startTest();

        Map<String, Object> mapResult = PathCancelacionDeTitularController.getPickListValues(lstCaseCancelacion[0].Id);

        Test.stopTest();

        Map<String, List<String>> mapRetencion = (Map<String, List<String>>)mapResult.get('mapMotivoRetencionDependencias');
        System.assertEquals( true, mapRetencion.get('Nuevos con uso').contains('Bono de 1,000 puntos') );
    }

    @isTest static void updateCaseByRT() {

        String idRTCancelacion = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' AND RecordTypeId = : idRTCancelacion LIMIT 1 ];

        Map<String,Object> mapFields = new Map<String,Object>{ 'Motivo_de_cancelaci_n_de_tarjeta__c' => 'Deseaba otro producto' };

        Test.startTest();

        Map<String, Object> mapResult = PathCancelacionDeTitularController.updateCaseByRT(lstCases[0].Id, mapFields);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }
}