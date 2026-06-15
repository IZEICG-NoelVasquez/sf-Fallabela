public class AgentWorkTriggerHandler extends TriggerHandler {

    public override void beforeUpdate () {

        AgentWorkTriggerHelper.cargarCasosAsignados();

        for(AgentWork agenteW : (List<AgentWork>)Trigger.newMap.values() ) {

            AgentWorkTriggerHelper.actualizaEstatusAsignada((AgentWork)Trigger.newMap.get(agenteW.Id), (AgentWork)Trigger.oldMap.get(agenteW.Id));
        }

        AgentWorkTriggerHelper.actualizarCasosAsignados();
    }
}