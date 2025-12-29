/**
* Nombre: BatchUpdateCasesEmboceNumFolioTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchUpdateCasesEmboceNumFolio
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           28/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchUpdateCasesEmboceNumFolioTest {

    @testSetup
    static void setupData() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'CaseTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;
        
        Account acc = new Account();
        acc.LastName = 'AccTest1';
        acc.Emboce_Centralizado__c = '15';
        acc.Caso_Emboce_Creado__c = true;
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case case1 = new Case();
        case1.AccountId = acc.Id;
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case1.Num_Folio_a_Consultar__c = null;
        case1.Categor_a__c = 'Información de Producto';
        /// Validaciones en Custom Metadata
        case1.Calle_y_N_mero_Int_Ext__c = 'Test 123';
        case1.Estatus__c = 'Test';
        insert case1;

        Guia_DHL__c guia = new Guia_DHL__c();
        guia.Name = '1234567890123456789012';
        guia.ID_Guia__c = '1234567890123456789012';
        guia.Cuenta__c = acc.Id;
        guia.Caso_de_Emboce_Actualizado__c = false;
        insert guia;
    }

    @isTest 
    static void BatchUpdateCasesEmboceNumFolio() {

        Test.startTest();

        BatchUpdateCasesEmboceNumFolio batchApex = new BatchUpdateCasesEmboceNumFolio();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Case> lstCasesUpdated = [SELECT Num_Folio_a_Consultar__c FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1];
        System.assertEquals('1234567890123456789012', lstCasesUpdated[0].Num_Folio_a_Consultar__c);
    }
}