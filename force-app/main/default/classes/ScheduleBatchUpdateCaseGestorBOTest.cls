/**
* Nombre: ScheduleBatchUpdateCaseGestorBOTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase ScheduleBatchUpdateCaseGestorBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/10/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ScheduleBatchUpdateCaseGestorBOTest {
    
    @isTest static void ScheduleBatchUpdateCaseGestorBO() {

        String CRON_EXP = '0 0 0 6 1 ? 2050';

		System.schedule('Test_Schedule', CRON_EXP, new ScheduleBatchUpdateCaseGestorBO());
    }
}