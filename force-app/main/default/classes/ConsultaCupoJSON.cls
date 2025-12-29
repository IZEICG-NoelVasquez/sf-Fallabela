public class ConsultaCupoJSON {	

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

    public class Cupo {
		@AuraEnabled public Integer cupoTotal;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public Cupo cupo;
		@AuraEnabled public Integer cupoPreAprobado;
	}
	
	public static ConsultaCupoJSON parse(String json) {
		return (ConsultaCupoJSON) System.JSON.deserialize(json, ConsultaCupoJSON.class);
	}
}