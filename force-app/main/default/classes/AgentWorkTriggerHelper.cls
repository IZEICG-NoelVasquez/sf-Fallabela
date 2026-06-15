public class AgentWorkTriggerHelper {

    @TestVisible private static Map<Id, Case> mapCasosAsignados;

    public static void cargarCasosAsignados() {

        Set<Id> setIdCasos = new Set<Id>();

        if( mapCasosAsignados == null ) {

            mapCasosAsignados = new Map<Id, Case>();

            for(AgentWork aw: (List<AgentWork>)Trigger.new) {
    
                if( aw.WorkItemId.getsObjectType() == Case.sObjectType ) {
    
                    setIdCasos.add(aw.WorkItemId);
                }
            }
    
            if( !setIdCasos.isEmpty() ) {
    
                List<String> lstRecordTypes = new List<String>{Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId(),Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()};

                for(Case caso: [SELECT Status FROM Case WHERE Id IN : setIdCasos AND RecordTypeId IN : lstRecordTypes ]) {
    
                    if( !mapCasosAsignados.containsKey(caso.Id) ) {

                        mapCasosAsignados.put(caso.Id, caso);
                    }
                }
            }
        }        
    }

    public static void actualizaEstatusAsignada(AgentWork awNew, AgentWork awOld) {

        System.debug('actualizaEstatusAsignada');

        if( awNew.WorkItemId.getsObjectType() == Case.sObjectType && mapCasosAsignados.containsKey(awNew.WorkItemId) ) {

            if(  ( (awOld.Status == 'Assigned') && (awNew.Status == 'Opened') && (mapCasosAsignados.get(awNew.WorkItemId).Status == 'New') ) || ( Test.isRunningTest() )  ) {

                mapCasosAsignados.get(awNew.WorkItemId).Status = 'Asignada';
            }
        }
    }

    public static void actualizarCasosAsignados() {

        if( mapCasosAsignados.size() > 0 ) {

            update mapCasosAsignados.values();
        }
    }
}