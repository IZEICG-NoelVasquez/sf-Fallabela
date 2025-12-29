/**
* Nombre: BatchDeleteRespuestaMotorTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchDeleteRespuestaMotor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/06/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchDeleteRespuestaMotorTest {

    @testSetup
    static void setupData() {

        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        insert case1;

        Respuesta_Motor__c respuestaMotor = new Respuesta_Motor__c();
        respuestaMotor.Caso__c = case1.Id;
        insert respuestaMotor;

        Integer intDaysHistory = Integer.valueOf(System.Label.BATCH_DELETE_RESPUESTA_MOTOR_DAYS_HISTORY) + 10;
        Test.setCreatedDate(respuestaMotor.Id, System.now().addDays(-intDaysHistory));
    }

    @isTest 
    static void BatchDeleteRespuestaMotor() {

        Test.startTest();

        BatchDeleteRespuestaMotor batchApex = new BatchDeleteRespuestaMotor();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Respuesta_Motor__c> lstRespuestaMotor = [SELECT Id FROM Respuesta_Motor__c];
        System.assertEquals(true, lstRespuestaMotor.isEmpty());
    }
}