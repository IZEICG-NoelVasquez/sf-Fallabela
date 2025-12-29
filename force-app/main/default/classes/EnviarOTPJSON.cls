public class EnviarOTPJSON {

    @AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public String codigoEstado;
		@AuraEnabled public String glosaEstado;
	}
	
	public static EnviarOTPJSON parse(String json) {
		return (EnviarOTPJSON) System.JSON.deserialize(json, EnviarOTPJSON.class);
	}
}