public class ActualizarMedioEnvioJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Mesagge message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Mesagge {
		@AuraEnabled public EstadoOperacion estadoOperacion;
	}

	
	public static ActualizarMedioEnvioJSON parse(String json) {
		return (ActualizarMedioEnvioJSON) System.JSON.deserialize(json, ActualizarMedioEnvioJSON.class);
	}
}