/**
* Nombre: BatchDeleteErrorLogTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchDeleteErrorLog
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/06/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchDeleteErrorLogTest {

    @testSetup
    static void setupData() {

        Error_Log__c errorLog = new Error_Log__c();
        errorLog.ApexClass__c = 'TestClass';
        errorLog.Message__c = 'Test Test';
        insert errorLog;

        Integer intDaysHistory = Integer.valueOf(System.Label.BATCH_DELETE_ERROR_LOG_DAYS_HISTORY) + 10;
        Test.setCreatedDate(errorLog.Id, System.now().addDays(-intDaysHistory));
    }

    @isTest 
    static void BatchDeleteErrorLog() {

        Test.startTest();

        BatchDeleteErrorLog batchApex = new BatchDeleteErrorLog();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Error_Log__c> lstErrorLog = [SELECT Id FROM Error_Log__c];
        System.assertEquals(true, lstErrorLog.isEmpty());
    }
}