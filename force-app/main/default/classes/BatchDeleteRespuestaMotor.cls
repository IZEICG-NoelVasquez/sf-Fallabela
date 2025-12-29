/**
* Nombre: BatchDeleteRespuestaMotor
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para la borrar los registros de Respuestas de Motor con mas de X meses desde la fecha de creacion
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           31/05/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchDeleteRespuestaMotor implements Database.Batchable<sObject> {

    /// Historico de dias
    Date dtDaysHistory;

    public BatchDeleteRespuestaMotor() {

        Integer intDaysHistory = Integer.valueOf(System.Label.BATCH_DELETE_RESPUESTA_MOTOR_DAYS_HISTORY);

        dtDaysHistory = System.today().addDays(-intDaysHistory);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([SELECT Id FROM Respuesta_Motor__c WHERE DAY_ONLY(CreatedDate) <= : dtDaysHistory]);
    }

    public void execute(Database.BatchableContext BC, List<Respuesta_Motor__c> scope) {

        delete scope;
    }

    public void finish (Database.BatchableContext BC) {

    }
}