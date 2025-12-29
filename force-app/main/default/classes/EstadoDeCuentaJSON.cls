public class EstadoDeCuentaJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public String urlResumenExtractoElectronico;
	}
	
	public static EstadoDeCuentaJSON parse(String json) {
		return (EstadoDeCuentaJSON) System.JSON.deserialize(json, EstadoDeCuentaJSON.class);
	}
}