public class ValidarOTPJSON {

    @AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public Respuesta respuesta;
	}

	public class Respuesta {
		@AuraEnabled public String codigoRespuesta;
		@AuraEnabled public String glosaRespuesta;
	}
	
	public static ValidarOTPJSON parse(String json) {
		return (ValidarOTPJSON) System.JSON.deserialize(json, ValidarOTPJSON.class);
	}
}