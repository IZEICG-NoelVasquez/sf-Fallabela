public class ActualizarSolicitudResponseJSON {

	@AuraEnabled public Integer cardApplicationId;
	@AuraEnabled public String codigoOperacion;
	@AuraEnabled public String descCodigoOperacion;
	@AuraEnabled public String result;
	@AuraEnabled public String queueType;
	
	public static ActualizarSolicitudResponseJSON parse(String json) {
		return (ActualizarSolicitudResponseJSON) System.JSON.deserialize(json, ActualizarSolicitudResponseJSON.class);
	}
}