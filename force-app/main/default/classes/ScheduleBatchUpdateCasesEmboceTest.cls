/**
* Nombre: ScheduleBatchUpdateCasesEmboceTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase ScheduleBatchUpdateCasesEmboce
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           30/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ScheduleBatchUpdateCasesEmboceTest {
    
    @isTest static void ScheduleBatchUpdateCasesEmboce() {

        Date dtToday = System.today().addYears(20);
        String strYear = String.valueOf(dtToday.year());

        String CRON_EXP = '0 0 0 6 1 ? ' + strYear;

		System.schedule('Test_Schedule', CRON_EXP, new ScheduleBatchUpdateCasesEmboce());
    }
}