/**
* Nombre: ScheduleBatchUpdateCsEmboceNFolioTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase ScheduleBatchUpdateCsEmboceNFolio
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           17/07/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ScheduleBatchUpdateCsEmboceNFolioTest {
    
    @isTest static void ScheduleBatchUpdateCsEmboceNFolio() {

        Date dtToday = System.today().addYears(20);
        String strYear = String.valueOf(dtToday.year());

        String CRON_EXP = '0 0 0 6 1 ? ' + strYear;

		System.schedule('Test_Schedule', CRON_EXP, new ScheduleBatchUpdateCsEmboceNFolio());
    }
}