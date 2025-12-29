/**
* Nombre: BatchUpdateGuiasTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchUpdateGuias
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/02/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchUpdateGuiasTest {
    
    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Guia_DHL__c guia = new Guia_DHL__c();
        guia.Name = '1234567890';
        guia.Activo__c = true;
        guia.Cuenta__c = acc.Id;
        guia.ID_Guia__c = '123456789';
        insert guia;

        Test.setCreatedDate(guia.Id, System.now().addDays(-100));
    }

    @isTest 
    static void BatchUpdateGuias() {

        Test.startTest();

        BatchUpdateGuias batchApex = new BatchUpdateGuias();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Guia_DHL__c> lstGuias = [SELECT Activo__c FROM Guia_DHL__c WHERE ID_Guia__c = '123456789' ];
        System.assertEquals(false, lstGuias[0].Activo__c);
    }
}