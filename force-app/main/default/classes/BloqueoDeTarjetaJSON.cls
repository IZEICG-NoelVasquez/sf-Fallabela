public class BloqueoDeTarjetaJSON {

    @AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
	}
	
	public static BloqueoDeTarjetaJSON parse(String json) {
		return (BloqueoDeTarjetaJSON) System.JSON.deserialize(json, BloqueoDeTarjetaJSON.class);
	}
}