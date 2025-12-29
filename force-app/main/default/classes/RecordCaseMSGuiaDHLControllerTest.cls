/**
* Nombre: RecordCaseMSGuiaDHLControllerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase RecordCaseMSGuiaDHLController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           30/11/2021      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class RecordCaseMSGuiaDHLControllerTest {
    
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
        insert caso;
    }

    @isTest static void getCaseRecordInfoTest() {

        List<Case> lstCase = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1];

        Test.startTest();

        Map<String,Object> mapResult = RecordCaseMSGuiaDHLController.getCaseRecordInfo(lstCase[0].Id);

        Test.stopTest();

        System.assertEquals( true, mapResult.get('success'));
    }
}