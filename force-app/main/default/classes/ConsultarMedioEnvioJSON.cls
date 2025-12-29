public class ConsultarMedioEnvioJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

    public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public Producto_Z producto;
	}

	public class Producto_Z {
		@AuraEnabled public Producto producto;
		@AuraEnabled public InformacionContacto informacionContacto;
	}

	public class Producto {
		@AuraEnabled public String codigoProducto;
		@AuraEnabled public String codigoSubProducto;
		@AuraEnabled public String identificadorProducto;
	}

	public class InformacionContacto {
		@AuraEnabled public Direccion direccion;
		@AuraEnabled public CorreoElectronico correoElectronico;
	}

	public class CorreoElectronico {
		@AuraEnabled public String codigoTipoCorreo;
		@AuraEnabled public String direccionCorreoElectronico;
		@AuraEnabled public Boolean esPrimario;
	}

	public class Direccion {
		@AuraEnabled public String codigoCiudad;
		@AuraEnabled public String codigoPostal;
		@AuraEnabled public String codigoRegion;
		@AuraEnabled public String codigoTipoVia;
		@AuraEnabled public String descripcionCiudad;
		@AuraEnabled public String descripcionRegion;
		@AuraEnabled public String descripcionTipoVia;
		@AuraEnabled public String direccionCompleta;
		@AuraEnabled public String estado;
		@AuraEnabled public String nombreVia;
		@AuraEnabled public String numeroVivienda;
		@AuraEnabled public String tipoDireccion;
		@AuraEnabled public Boolean esPrimario;
	}
	
	public static ConsultarMedioEnvioJSON parse(String json) {
		return (ConsultarMedioEnvioJSON) System.JSON.deserialize(json, ConsultarMedioEnvioJSON.class);
	}
}