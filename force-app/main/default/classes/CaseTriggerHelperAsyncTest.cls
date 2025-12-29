/**
* Nombre: CaseTriggerHelperAsyncTest
* Autor: ---
* Descripcion: Test de la Clase CaseTriggerHelperAsync
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ----                    Creación
* 2.0           10/09/2021      Mauricio Rosales        Validacion dinamica Motivos de Retencion
* --------------------------------------------------------------------------
*/@isTest
public class CaseTriggerHelperAsyncTest {

    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso_1 = new Case();
        caso_1.AccountId = acc.Id;
        caso_1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId();
        caso_1.Solicitud_de_cancelaci_n__c = true;
        caso_1.Categor_a__c = 'Cancelación de Tarjeta';
        insert caso_1;
    }

    @isTest static void test_method_1() {

        List<Id> lisIdCasos = new List<Id>();
        Case casoTest = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1];
        lisIdCasos.add(casoTest.Id);

        Test.startTest();

        CaseTriggerHelperAsync.cierraCasosAsync(lisIdCasos);

        Test.stopTest();

        Case casoResult = [SELECT Status FROM Case WHERE Id =: casoTest.Id];
        System.assertEquals( casoResult.Status, 'Cerrado');
    }
}