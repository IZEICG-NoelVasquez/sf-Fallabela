public class SaldoPuntosJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class ResumenPeriodo {
		@AuraEnabled public Decimal saldoInicialPeriodo;
	}

	public class PuntosCMR {
		@AuraEnabled public TotalPuntosDisponibles totalPuntosDisponibles;
		@AuraEnabled public Cliente cliente;
		@AuraEnabled public PuntosAcumuladosPeriodo puntosAcumuladosPeriodo;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public PuntosCMR puntosCMR;
		@AuraEnabled public Cliente cliente;
	}

	public class DocumentoIdentidad {
		@AuraEnabled public NumeroDocumento numeroDocumento;
	}

	public class TotalPuntosDisponibles {
		@AuraEnabled public String totalPuntosDisponibles;
	}

	public class NumeroDocumento {
		@AuraEnabled public String numeroDocumento;
	}

	public class Cliente {
		@AuraEnabled public DocumentoIdentidad documentoIdentidad;
	}

	public class PuntosAcumuladosPeriodo {
		@AuraEnabled public ResumenPeriodo resumenPeriodo;
	}
	
	public static SaldoPuntosJSON parse(String json) {
		return (SaldoPuntosJSON) System.JSON.deserialize(json, SaldoPuntosJSON.class);
	}
}