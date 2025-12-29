public class ActualizarCorreoJSON {

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public Cliente cliente;
		@AuraEnabled public InformacionContacto informacionContacto;
	}

	public class DocumentoIdentidad {
		@AuraEnabled public String tipoDocumento;
		@AuraEnabled public String numeroDcumento;
	}

	public class InformacionContacto {
		@AuraEnabled public CorreoElectronico correoElectronico;
	}

	public class CorreoElectronico {
		@AuraEnabled public String direccionCorreoElectronico;
	}

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Cliente {
		@AuraEnabled public DocumentoIdentidad documentoIdentidad;
	}

	
	public static ActualizarCorreoJSON parse(String json) {
		return (ActualizarCorreoJSON) System.JSON.deserialize(json, ActualizarCorreoJSON.class);
	}
}