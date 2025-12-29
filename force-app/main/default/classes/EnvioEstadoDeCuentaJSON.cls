public class EnvioEstadoDeCuentaJSON {

    @AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
	}
	
	public static EnvioEstadoDeCuentaJSON parse(String json) {
		return (EnvioEstadoDeCuentaJSON) System.JSON.deserialize(json, EnvioEstadoDeCuentaJSON.class);
	}
}