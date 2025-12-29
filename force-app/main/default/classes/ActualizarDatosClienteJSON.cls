public class ActualizarDatosClienteJSON {

    @AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
	}
	
	public static ActualizarDatosClienteJSON parse(String json) {
		return (ActualizarDatosClienteJSON) System.JSON.deserialize(json, ActualizarDatosClienteJSON.class);
	}
}