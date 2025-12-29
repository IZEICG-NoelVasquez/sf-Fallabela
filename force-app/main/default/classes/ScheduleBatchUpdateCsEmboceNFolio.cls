/**
* Nombre: ScheduleBatchUpdateCsEmboceNFolio
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchUpdateCasesEmboceNumFolio
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           17/07/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
global class ScheduleBatchUpdateCsEmboceNFolio implements Schedulable {
    
    public void execute(SchedulableContext SC) {

		BatchUpdateCasesEmboceNumFolio batchApex = new BatchUpdateCasesEmboceNumFolio();
    	Database.executeBatch(batchApex, 50);
	}
}