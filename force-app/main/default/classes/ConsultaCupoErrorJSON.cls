public class ConsultaCupoErrorJSON {

    @AuraEnabled public String code;
	@AuraEnabled public String message;
	
	public static ConsultaCupoErrorJSON parse(String json) {
		return (ConsultaCupoErrorJSON) System.JSON.deserialize(json, ConsultaCupoErrorJSON.class);
	}
}