/**
* Nombre: ScheduleBatchUpdateCaseGestorBO
* Autor: Mauricio Rosales
* Descripcion: Clase Schedule para programar el Batch BatchUpdateCaseGestorBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           04/10/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class ScheduleBatchUpdateCaseGestorBO implements Schedulable {

    public void execute(SchedulableContext SC) {

		BatchUpdateCaseGestorBO batchApex = new BatchUpdateCaseGestorBO();
        Database.executeBatch(batchApex, 5);
	}
}