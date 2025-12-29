/**
* Nombre: GuiaDHLTriggerHelper
* Autor: Mauricio Rosales
* Descripcion: Clase Helper de la clase GuiaDHLTriggerHandler
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           24/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class GuiaDHLTriggerHelper {

    public static void updateCasesEmboce(List<Guia_DHL__c> lstNewGuias) {

        /*Map<String,String> mapAccGuia = new Map<String,String>();

        for(Guia_DHL__c guia: lstNewGuias ) {

            if( String.isNotBlank(guia.Cuenta__c) ) {

                mapAccGuia.put(guia.Cuenta__c, guia.ID_Guia__c);
            }
        }


        /// Llamado al Batch
        if( mapAccGuia.size() > 0 ) {

            BatchUpdateCasesEmboceNumFolio batchApex = new BatchUpdateCasesEmboceNumFolio(mapAccGuia);
            Database.executeBatch(batchApex, 50);
        }*/
    }
}