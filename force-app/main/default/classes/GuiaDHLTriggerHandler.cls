/**
* Nombre: GuiaDHLTriggerHandler
* Autor: Mauricio Rosales
* Descripcion: Clase Handler del Trigger GuiaDHLTrigger
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           24/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public with sharing class GuiaDHLTriggerHandler extends TriggerHandler {    
    
    public override void afterInsert() {
        
        GuiaDHLTriggerHelper.updateCasesEmboce(Trigger.new);
    }
}