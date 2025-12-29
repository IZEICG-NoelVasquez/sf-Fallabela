/**
* Nombre: ScheduleBatchDeleteRespuestaMotor
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchDeleteRespuestaMotor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           02/06/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
global class ScheduleBatchDeleteRespuestaMotor implements Schedulable {

    public void execute(SchedulableContext SC) {

		BatchDeleteRespuestaMotor batchApex = new BatchDeleteRespuestaMotor();
        Database.executeBatch(batchApex, 100);
	}
}