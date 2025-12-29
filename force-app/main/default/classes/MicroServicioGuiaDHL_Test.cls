/************************************************************************************************
Apex Class Name	:	MicroServicioGuiaDHL_Test 
Version			:	1.0
Created Date    :	04/11/2019 16:49
Function 		: 	Cubrir a la clase controladora del componente microServicioGuiaDHL
Cover Class		:	microServicioGuiaDHL
Modification Log:
*-------------------------------------------------------------------
* Developer		         Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	         04/11/2019 	         Original Version
* Mauricio Rosales	   30/11/2021 	         Se agrega metodo para actualizar el estatus del caso
* Mauricio Rosales	   18/01/2023 	         Se agrega llamado al WS de Estafeta
*************************************************************************************************/
@isTest
public class MicroServicioGuiaDHL_Test {

     @testSetup
    static void setupData() {

        Account acc1 = new Account();
        acc1.LastName = 'AccTest1';
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case caso = new Case();
        caso.AccountId = acc1.Id;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        caso.Categor_a__c = 'Información de Producto';
        caso.Status = 'Información';
        insert caso;
    }

     @isTest static void test_microservicio_guia_DHL() {
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'SIMF831004HDFLGR06';
        insert acc1;
         Account acc2 = new Account();
        acc2.LastName = 'Test112233';
        acc2.CURP__c = 'SIMF831004HDFLGR07';
        insert acc2;
        Guia_DHL__c guia = new Guia_DHL__c();
         guia.Name = '6473369313';
         guia.Cuenta__c = acc1.Id;
         guia.Activo__c = true;
         insert guia;
         Guia_DHL__c guia2 = new Guia_DHL__c();
         guia2.Name = '6473369313';
         guia2.Cuenta__c = acc2.Id;
         guia2.Activo__c = true;
         insert guia2;
         Guia_DHL__c guia3 = new Guia_DHL__c();
         guia3.Name = '6473369313';
         guia3.Cuenta__c = acc2.Id;
         guia3.Activo__c = true;
         insert guia3;
         test.startTest();
         String guias = MicroServicioGuiaDHL.getGuiaDHL(acc1.Id);
         String guias2 = MicroServicioGuiaDHL.getGuiaDHL(acc2.Id);
        MockHttpResponseGeneratorGuiaDHL mockMicroSer = new MockHttpResponseGeneratorGuiaDHL();
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
         
         Map<String, Object> testGuiaDHL = MicroServicioGuiaDHL.getDetailDHL(guias, acc1.CURP__c);
         test.stopTest();
    }

    @isTest static void createCaseClosedGuiaTest() {

          Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
          List<Account> lstAccount = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1];
          List<Contact> lstContact = [SELECT Id FROM Contact WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1];
          String category = 'Consultas';
          Boolean altoRiesgo = false;
          String metodoContactoValue = 'Contact Center';
          String numeroDeTarjetaValue = '123456*****1234';
          String camposRequeridos = 'Tipodeconsulta__c:Consulta de Guía DHL;Vencimiento';

          ///
          CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

          Test.startTest();

          Map<String, Object> mapResult = MicroServicioGuiaDHL.createCaseClosedGuia(recordTypeId, lstAccount[0].Id, lstContact[0].Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);

          Test.stopTest();

          System.assertEquals( true, mapResult.get('success'));
    }

    @isTest static void updateCaseStatusTest() {

          List<Case> lstCase = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1];

          Test.startTest();

          Boolean result = MicroServicioGuiaDHL.updateEstatus(lstCase[0].Id, 'Test Guia DHL');

          Test.stopTest();

          System.assertEquals( true, result);
    }

    @isTest static void getWayBillEstafeta() {

            Map<String, Object> mapResult;

            /// Http Mock
            MockHttpResponseGeneratorApiGee mockHttp = new MockHttpResponseGeneratorApiGee();
            mockHttp.setBody('{"bodyTest":"test"}');
            Test.setMock(HttpCalloutMock.class, mockHttp);

            Test.startTest();

            mapResult = MicroServicioGuiaDHL.getWayBillEstafeta('wayBill');

            Test.stopTest();

            System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void getWayBillEstafetaError() {

            Map<String, Object> mapResult;

            /// Http Mock
            MockHttpResponseGeneratorApiGee mockHttp = new MockHttpResponseGeneratorApiGee();
            mockHttp.setBody(null);
            Test.setMock(HttpCalloutMock.class, mockHttp);

            Test.startTest();

            mapResult = MicroServicioGuiaDHL.getWayBillEstafeta('wayBill');

            Test.stopTest();

            System.assertEquals(false, Boolean.valueOf(mapResult.get('success')));
    }
}