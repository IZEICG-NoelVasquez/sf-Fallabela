public class AgentWorkTriggerHandler extends TriggerHandler {

    @TestVisible
    private Map<Id,AgentWork> mapNewAgentWorkTest;
    @TestVisible
    private Map<Id,AgentWork> mapOldAgentWorkTest;

    public override void beforeUpdate() {

        System.debug('AgentWorkTriggerHandler - beforeUpdate');

        AgentWorkTriggerHelper.cargarCasosAsignados();

        /// Test Methods
        Map<Id,AgentWork> mapNewAgentWork = !Test.isRunningTest() ? (Map<Id,AgentWork>)Trigger.newMap : mapNewAgentWorkTest;
        Map<Id,AgentWork> mapOldAgentWork = !Test.isRunningTest() ? (Map<Id,AgentWork>)Trigger.oldMap : mapOldAgentWorkTest;

        //for(AgentWork agenteW : (List<AgentWork>)Trigger.newMap.values() ) {
        for(AgentWork agenteW : mapNewAgentWork.values() ) {

            ///AgentWorkTriggerHelper.actualizaEstatusAsignada((AgentWork)Trigger.newMap.get(agenteW.Id), (AgentWork)Trigger.oldMap.get(agenteW.Id));
            AgentWorkTriggerHelper.actualizaEstatusAsignada(mapNewAgentWork.get(agenteW.Id), mapOldAgentWork.get(agenteW.Id));
        }

        AgentWorkTriggerHelper.actualizarCasosAsignados();
    }


    public override void afterUpdate() {

        System.debug('AgentWorkTriggerHandler - afterUpdate');

        /// Se carga en el Before Update
        ///AgentWorkTriggerHelper.cargarCasosAsignados();

        /// Admin Omni
        PendingServiceRoutingService.loadOmniChannelConfig();
        PendingServiceRoutingService.loadQueuePendingServiceRouting();
        PendingServiceRoutingService.loadPendingServiceRoutingToUpdate();

        /// Test Methods
        Map<Id,AgentWork> mapNewAgentWork = !Test.isRunningTest() ? (Map<Id,AgentWork>)Trigger.newMap : mapNewAgentWorkTest;
        Map<Id,AgentWork> mapOldAgentWork = !Test.isRunningTest() ? (Map<Id,AgentWork>)Trigger.oldMap : mapOldAgentWorkTest;

        for(AgentWork agenteW : mapNewAgentWork.values() ) {

            /// Admin Omni
            AgentWorkTriggerHelper.agentLogin(mapNewAgentWork.get(agenteW.Id), mapOldAgentWork.get(agenteW.Id));
        }


        PendingServiceRoutingService.updatePendingServiceRouting();
    }
}