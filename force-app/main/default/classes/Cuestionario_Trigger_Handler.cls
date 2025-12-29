/************************************************************************************************
Apex Class Name	:	Cuestionario_Trigger_Handler 
Version			:	1.0
Created Date    :	28/10/2019 15:37
Function 		: 	Handler usado para validar Cuestionarios nuevos
Test Class		:	Cuestionario_Trigger_Test
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     28/10/2019 	   Original Version
*************************************************************************************************/
public class Cuestionario_Trigger_Handler {
     public static  void handleTrigger(List<Cuestionario__c> TriggerNew, List<Cuestionario__c> TriggerOld,
                                      Map<Id, Cuestionario__c> TriggerOldMap, System.TriggerOperation triggerEvent){
       	switch on triggerEvent{
           	when BEFORE_INSERT{
				beforeInsert(TriggerNew);
           	}
       	}
    }
    public static void beforeInsert (List<Cuestionario__c>TriggerNew){
        Id currentUser= UserInfo.getUserId();
        try {
        Cuestionario__c lastCuest = [Select Status__c 
                                     From Cuestionario__c 
                                     Where CreatedById =: currentUser 
                                     ORDER BY CreatedDate DESC
                                     LIMIT 1];
        System.debug('lastCuest '+lastCuest);
        if(lastCuest != null){if(lastCuest.Status__c == 'Pendiente'){for(Cuestionario__c cuest : TriggerNew){cuest.Anterior_Pendiente__c = true;
                    System.debug('cuest.Anterior_Pendiente__c '+cuest.Anterior_Pendiente__c);
        		}      
        	}      
        } 
        } catch (Exception e) {
                System.debug('Exception from Creating New Cuestionario: ' + e);
            } 
    } 
}