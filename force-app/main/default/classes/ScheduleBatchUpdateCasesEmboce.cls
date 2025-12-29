/**
* Nombre: ScheduleBatchUpdateCasesEmboce
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchUpdateCasesEmboce
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           14/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
global class ScheduleBatchUpdateCasesEmboce implements Schedulable {
    
    public void execute(SchedulableContext SC) {

		BatchUpdateCasesEmboce batchApex = new BatchUpdateCasesEmboce();
    	Database.executeBatch(batchApex, 50);
	}
}