public class DeleteCampaignsInvocable {
    @InvocableMethod(label='Eliminar campaña' description='Elimina los registros de campaña y miembros de campaña' category='Campaign')
    public static void deleteCampaign(List<String> id) {
        //Se programa el batch
        DeleteCampaignsBatcheable del= new DeleteCampaignsBatcheable(id[0], UserInfo.getUserId());
        Database.executeBatch(del);
        
    }
}