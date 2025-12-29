/**
* Nombre: ScheduleBatchUpdateGuias
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchUpdateGuias
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/02/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
global class ScheduleBatchUpdateGuias implements Schedulable {
    
    public void execute(SchedulableContext SC) {

		BatchUpdateGuias batchApex = new BatchUpdateGuias();
        Database.executeBatch(batchApex, 100);
	}
}