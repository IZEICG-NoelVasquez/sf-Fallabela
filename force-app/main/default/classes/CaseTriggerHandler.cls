/**
* Nombre: CaseTriggerHelper
* Autor: ---
* Descripcion: Clase Handler del Trigger CaseTrigger
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ----                    Creación
* 2.0           19/11/2021      Mauricio Rosales        Validacion historial de casos Emboce Centralizado
* --------------------------------------------------------------------------
*/
public class CaseTriggerHandler extends TriggerHandler {
    
	public override void afterInsert() {

		CaseTriggerHelper.loadMapCasesEmboce();
		//PendingServiceRoutingService.loadOmniChannelConfig();
		//PendingServiceRoutingService.loadQueuePendingServiceRouting();
		//PendingServiceRoutingService.loadCapacityAgentsBO();
		//PendingServiceRoutingService.loadPendingServiceRoutingToInsert();


		try {

			for(Case caso: (List<Case>)Trigger.newMap.values()) {

				CaseTriggerHelper.validateCreatingCases( (Case)Trigger.newMap.get(caso.Id) );
				//CaseTriggerHelper.assignOwnerOmnichannel((Case)Trigger.newMap.get(caso.Id), (Case)Trigger.NewMap.get(caso.Id));
			}
			/// Admin Omni-Channel
			//PendingServiceRoutingService.insertPendingServiceRouting();

		} catch(Exception ex) {

			System.debug('Exception:  ' + ex + '  Linea:  ' + ex.getLineNumber());
		}
	}
	
	public override void beforeUpdate () {
        System.debug('beforeUpdate');
	
        //select
		CaseTriggerHelper.initCaseComment();
		CaseTriggerHelper.loadMapEtapaCampos();
        CaseTriggerHelper.loadCaseMilestones();
        CaseTriggerHelper.loadFieldsMap();
        CaseTriggerHelper.loadMotivosCancelacion();
        CaseTriggerHelper.loadMotivosCerrado();
        CaseTriggerHelper.loadCaseSetUp();
		CaseTriggerHelper.loadContentDocuments((List<Case>)Trigger.newMap.values());
		CaseTriggerHelper.loadLatestOwner();
		
		/// Admin Omni-Channel
		//Map<ID, Contact> m = new Map<ID, Contact>([SELECT Id, LastName FROM Contact]);
		
		try {
            Map<ID, Group> mapQueues=new Map<ID, Group>([Select id, name, developerName, QueueRoutingConfigId from group where Type = 'Queue']);
            Map<String, id> queueByDevname= new Map<String, id> ();
            for(Group qu:mapQueues.values()){
                queueByDevname.put(qu.DeveloperName, qu.id);
            }
            			
            List<Case> caseList = (List<Case>)Trigger.newMap.values();
            System.debug('caseListSize: ' + caseList.size());
			// set<Id> ownerAppId = new set<Id>();
            // for (Case c : (List<Case>)Trigger.newMap.values()) {
			// if(c.Subcategor_a_Texto__c == 'APP'){
			// 	ownerAppId.add(c.OwnerId);
			// }

			// if(ownerAppId.size() >0){
			// 	CaseTriggerHelper.verifyOwnerToUpdate(ownerAppId);
			// }

			// }
			for (Case c : (List<Case>)Trigger.newMap.values()) {
                // if(c.Subcategor_a_Texto__c == 'APP' && c.status != 'Detalle del caso'){
				// 	CaseTriggerHelper.verifyOwnerPermitUpdate(c , (Case)Trigger.oldMap.get(c.Id));
				// }
				CaseTriggerHelper.validaEtapaCerrada((Case)Trigger.newMap.get(c.Id), (Case)Trigger.oldMap.get(c.Id));
				CaseTriggerHelper.validaEtapaAnteriorCerrada((Case)Trigger.newMap.get(c.Id), (Case)Trigger.oldMap.get(c.Id));
				CaseTriggerHelper.validateRequiredFields((Case)Trigger.newMap.get(c.Id), (Case)Trigger.oldMap.get(c.Id));
	            CaseTriggerHelper.createCaseComments((Case)Trigger.newMap.get(c.Id), (Case)Trigger.oldMap.get(c.Id));                
                //validar no omni user y cerrado
                try{
                   
                   if( (c.status=='cerrado' || c.status=='cancelado') && mapQueues.containsKey(c.OwnerId)){
                        if(mapQueues.get(c.OwnerId).QueueRoutingConfigId!= null){                        
                            string devName=mapQueues.get(c.OwnerId).developerName+ 'NoOmni';
                            c.OwnerId= queueByDevname.containsKey(devName) ? queueByDevname.get(devName): c.OwnerId;
                        }
                    }
                }catch(Exception e){
                    
                }
                
                
                
				/// Admin Omni-Channel
				
			}
            
            //insert update
			CaseTriggerHelper.publishCaseComments ();

			

		} catch (Exception e) {
			
            System.debug('Exception ' + e);
            
		}
        
	}

	public override void afterUpdate () {
        System.debug('afterUpdate');
        
        CaseTriggerHelper.loadTaskStatuses();
		if (Trigger.new.size() == 1) {
			CaseTriggerHelper.completeCurrentMilestones((Map<Id, Case>)Trigger.newMap, (Map<Id, Case>)Trigger.oldMap);
		}
		//caseTriggerHelperEmail.sendEmailNotification((List<Case>)Trigger.New, (Map<Id, Case>)Trigger.oldMap);
        CaseTriggerHelper.closeTasks((Map<Id, Case>)Trigger.newMap, (Map<Id, Case>)Trigger.oldMap);
        CaseTriggerHelper.insertCases();

		try {

			for(Case cs: (List<Case>)Trigger.newMap.values()) {

				CaseTriggerHelper.approvalProcessesBO((Case)Trigger.newMap.get(cs.Id), (Case)Trigger.oldMap.get(cs.Id));
			}
			
		} catch(Exception ex) {

			System.debug('Exception:  ' + ex + '  Linea:  ' + ex.getLineNumber());
		}

	}

}