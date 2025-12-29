public class AumentoCupoJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
	}
	
	public static AumentoCupoJSON parse(String json) {
		return (AumentoCupoJSON) System.JSON.deserialize(json, AumentoCupoJSON.class);
	}
}