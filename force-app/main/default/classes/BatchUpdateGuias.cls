/**
* Nombre: BatchUpdateGuias
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para ********
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           10/02/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchUpdateGuias implements Database.Batchable<sObject> {
    
    Date dtDaysPassed;

    public BatchUpdateGuias() {

        dtDaysPassed = System.today().addDays(-90);
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([SELECT Activo__c FROM Guia_DHL__c WHERE Activo__c = true AND DAY_ONLY(CreatedDate) <= : dtDaysPassed ]);
    }

    public void execute(Database.BatchableContext BC, List<Guia_DHL__c> scope) {

        for(Guia_DHL__c guia: scope) {

            guia.Activo__c = false;
        }

        update scope;
    }

    public void finish (Database.BatchableContext BC) {

    }
}