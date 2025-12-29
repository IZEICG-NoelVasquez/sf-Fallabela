public class ProductosJson {

	public class Plastico {
		
		@AuraEnabled public String titularidad;
		@AuraEnabled public Situacion_Z situacion;
	}

	public class CuentaTarjetaCredito {
		@AuraEnabled public String identificador;
	}

	public class CupoNacional {
		@AuraEnabled public String cupoDisponible;
		@AuraEnabled public String cupoTotal;
		@AuraEnabled public String cupoUtilizado;
	}

	public class Moneda {
		@AuraEnabled public String codigoMoneda;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public List<TarjetaCredito_Z> tarjetaCredito;
	}

	public class Situacion {
		@AuraEnabled public String estado;
		@AuraEnabled public String glosa;
	}

	public class TarjetaCredito {
		@AuraEnabled public String codigoProducto;
		@AuraEnabled public String codigoSubProducto;
		@AuraEnabled public String identificadorProducto;
	}

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class TarjetaCredito_Z {
		@AuraEnabled public TarjetaCredito tarjetaCredito;
		@AuraEnabled public Situacion situacion;
		@AuraEnabled public Moneda moneda;
		@AuraEnabled public Plastico plastico;
		@AuraEnabled public CuentaTarjetaCredito cuentaTarjetaCredito;
		@AuraEnabled public CupoNacional cupoNacional;
		@AuraEnabled public Avance avance;
		@AuraEnabled public ResumenProximaFacturacion resumenProximaFacturacion;
	}

	public class Situacion_Z {
		@AuraEnabled public String codigo;
		@AuraEnabled public String estado;
		@AuraEnabled public String glosa;
	}

	public class Avance {
		@AuraEnabled public String cupoDisponible;
	}

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class ResumenProximaFacturacion {
		@AuraEnabled public String fechaProximoVencimiento;
	}

	
	public static ProductosJson parse(String json) {
		return (ProductosJson) System.JSON.deserialize(json, ProductosJson.class);
	}
}