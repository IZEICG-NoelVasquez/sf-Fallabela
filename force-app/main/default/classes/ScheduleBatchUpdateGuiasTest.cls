/**
* Nombre: ScheduleBatchUpdateGuiasTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase ScheduleBatchUpdateGuias
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/02/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ScheduleBatchUpdateGuiasTest {
    
    @isTest static void ScheduleBatchUpdateGuias() {

        Date dtToday = System.today().addYears(20);
        String strYear = String.valueOf(dtToday.year());

        String CRON_EXP = '0 0 0 6 1 ? ' + strYear;

		System.schedule('Test_Schedule', CRON_EXP, new ScheduleBatchUpdateGuias());
    }
}