/**
* Nombre: ScheduleBatchDeleteErrorLogTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase ScheduleBatchDeleteErrorLog
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/06/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ScheduleBatchDeleteErrorLogTest {
    
    @isTest 
    static void ScheduleBatchDeleteErrorLog() {

        Date dtToday = System.today().addYears(10);
        String strYear = String.valueOf(dtToday.year());

        String CRON_EXP = '0 0 0 6 1 ? ' + strYear;

		System.schedule('Test_Schedule', CRON_EXP, new ScheduleBatchDeleteErrorLog());
    }
}