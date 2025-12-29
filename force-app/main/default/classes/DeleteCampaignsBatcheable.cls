public class DeleteCampaignsBatcheable implements Database.Batchable<sObject>{
    public  Map<String, Object> pageRef = new Map<String, Object>{
                                           'type' => 'standard__objectPage',
                                           'attributes' => new Map<String, Object>{
                                                   'objectApiName' => 'Campaign',
                                                   'actionName' => 'list'}, 
                                            'state' => new Map<String, Object>{
                                                    'filterName' => 'Todas_las_campa_as'} };
    public Id campaignId;
    public String userId;
    public DeleteCampaignsBatcheable(Id campaignId, Id userId) {
        this.campaignId = campaignId;
        this.userId= userId;
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator([SELECT Id FROM CampaignMember WHERE CampaignId = :campaignId]); 
   }

   public void execute(Database.BatchableContext bc, List<sObject> scope){
     System.debug(scope.size());
     delete scope;
    }

   public void finish(Database.BatchableContext bc){
       //Acabando de eliminar los miembros de campaña, se elimina la campaña
       Campaign cam=[Select Name, id From Campaign Where id=:campaignId LIMIT 1];
       cam.id=campaignId;
       delete cam;
       CustomNotificationType notType =[SELECT Id, DeveloperName 
             								FROM CustomNotificationType 
             								WHERE DeveloperName='Campaa_eliminada'];
       Messaging.CustomNotification notification = new Messaging.CustomNotification();
       String title='Campaña eliminada';
       String body='La campaña ' + cam.name +' ha sido eliminada exitosamente';
       String typeId=notType.Id;
       String target=JSON.serialize(pageRef);
       Set<String> recipients= new Set<String>{userid};
       CustomNotificationService.sendCustomNotificationPageRef(recipients, title, body, typeId, target);
   
  
       
   }
}