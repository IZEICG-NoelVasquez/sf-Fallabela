/**
* Nombre: ScheduleBatchDeleteErrorLog
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchDeleteErrorLog
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           02/06/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
global class ScheduleBatchDeleteErrorLog implements Schedulable {
    
    public void execute(SchedulableContext SC) {

		BatchDeleteErrorLog batchApex = new BatchDeleteErrorLog();
    	Database.executeBatch(batchApex, 100);
	}
}