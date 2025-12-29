public class DetalleMovimientosJSON {

	public class Moneda {
		@AuraEnabled public String codigoMoneda;
		@AuraEnabled public String moneda;
	}

	public class Interes {
		@AuraEnabled public String codigoInteres;
		@AuraEnabled public String descripcionInteres;
		///@AuraEnabled public Integer porcentaje;
		@AuraEnabled public Decimal porcentaje;
		///@AuraEnabled public Integer valorInteres;
		@AuraEnabled public Decimal valorInteres;
	}

	public class Persona {
		@AuraEnabled public String apellidoMaterno;
		@AuraEnabled public String apellidoPaterno;
		@AuraEnabled public String nombres;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public MovimientoDetalle movimientoDetalle;
	}

	public class TipoAccionContable {
		@AuraEnabled public String codigo;
		@AuraEnabled public String descripcion;
	}

	public class Movimiento {
        @AuraEnabled public String identificador;
		@AuraEnabled public String fechaContable;
		@AuraEnabled public Double monto;
        @AuraEnabled public String titularidad;
		@AuraEnabled public Transaccion transaccion;
		@AuraEnabled public Cuota cuota;
		@AuraEnabled public MontoMovimientoTC montoMovimientoTC;
		@AuraEnabled public Moneda moneda;
		@AuraEnabled public TipoAccionContable tipoAccionContable;
		@AuraEnabled public TipoAccionContable estadoMovimiento;
	}

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class LocalidadTransaccion {
		@AuraEnabled public String nombreComercio;
		@AuraEnabled public String pais;
		@AuraEnabled public String codigoComercio;
	}

	public class Transaccion {
		@AuraEnabled public String fechaHoraTransaccion;
		@AuraEnabled public LocalidadTransaccion localidadTransaccion;
		@AuraEnabled public String indicadorNacionalidad;
	}

	public class Cuota {
		@AuraEnabled public Integer cuotaPendientes;
		@AuraEnabled public Integer totalCuota;
		@AuraEnabled public Integer numeroCuota;
		@AuraEnabled public Interes interes;
	}

	public class DetalleInternoMovimiento {
        @AuraEnabled public String numeroExtracto;
		@AuraEnabled public String numeroMovimientoExtracto;
		@AuraEnabled public String numeroOperacionCuota;
		@AuraEnabled public String numeroFinanciacion;
		@AuraEnabled public String titularidad;
		@AuraEnabled public String contrato;
		@AuraEnabled public Moneda moneda;
	}

	public class OrigenCompra {
		@AuraEnabled public String tipoTransaccion;
	}

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class MontoMovimientoTC {
		@AuraEnabled public Double montoLocal;
		@AuraEnabled public Double montoOrigen;
		@AuraEnabled public Double tipoCambio;
	}

	public class MovimientoDetalle {
		@AuraEnabled public Movimiento movimiento;
		@AuraEnabled public Persona persona;
		@AuraEnabled public OrigenCompra origenCompra;
		@AuraEnabled public Compra compra;
		@AuraEnabled public DetalleInternoMovimiento detalleInternoMovimiento;
	}

	public class Compra {
		@AuraEnabled public String impugnacion;
	}

	
	public static DetalleMovimientosJSON parse(String json) {
		return (DetalleMovimientosJSON) System.JSON.deserialize(json, DetalleMovimientosJSON.class);
	}
}