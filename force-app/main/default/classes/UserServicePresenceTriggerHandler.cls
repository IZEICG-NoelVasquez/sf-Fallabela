public class UserServicePresenceTriggerHandler extends TriggerHandler {
    
    public override void afterInsert() {

        UserServicePresenceTriggerHelper.loadUsers((List<UserServicePresence>)Trigger.new);

        /// Admin Omni-Channel
        PendingServiceRoutingService.loadOmniChannelConfig();
        PendingServiceRoutingService.loadCapacityAgentsBO();
        PendingServiceRoutingService.loadQueuePendingServiceRouting();
        PendingServiceRoutingService.loadPendingServiceRoutingToUpdate();

        for(UserServicePresence usp: (List<UserServicePresence>)Trigger.new) {

            UserServicePresenceTriggerHelper.agentLogin(usp);
        }

        /// Actualizar PendingServiceRouting
        PendingServiceRoutingService.updatePendingServiceRouting();
    }
}