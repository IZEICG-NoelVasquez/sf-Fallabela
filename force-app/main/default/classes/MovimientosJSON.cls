public class MovimientosJSON {

	public class Moneda {
		@AuraEnabled public String codigoMoneda;
	}

	public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public TarjetaCredito_Z tarjetaCredito;
		@AuraEnabled public InformacionPaginacion informacionPaginacion;
	}

	public class TarjetaCredito {
		@AuraEnabled public String codigoProducto;
		@AuraEnabled public String codigoSubProducto;
		@AuraEnabled public String identificadorProducto;
	}

	public class Movimiento {
		@AuraEnabled public String identificador;
		@AuraEnabled public String descripcion;
		@AuraEnabled public String titularidad;
		@AuraEnabled public Transaccion transaccion;
		@AuraEnabled public Cuota cuota;
		@AuraEnabled public MontoMovimientoTC montoMovimientoTC;
		@AuraEnabled public Moneda moneda;
		@AuraEnabled public EstadoTransaccion tipoAccionContable;
		@AuraEnabled public EstadoTransaccion estadoMovimiento;
		@AuraEnabled public DetalleInternoMovimiento detalleInternoMovimiento;
	}

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class InformacionPaginacion {
		@AuraEnabled public Integer totalPaginas;
		@AuraEnabled public Integer totalRegistros;
		@AuraEnabled public PaginaActual paginaActual;
	}

	public class LocalidadTransaccion {
		@AuraEnabled public String ciudad;
		@AuraEnabled public String direccionCompra;
		@AuraEnabled public String pais;
	}

	public class Transaccion {
		@AuraEnabled public String fechaHoraTransaccion;
		@AuraEnabled public LocalidadTransaccion localidadTransaccion;
		@AuraEnabled public EstadoTransaccion estadoTransaccion;
	}

	public class Cuota {
		@AuraEnabled public Integer cuotaPendientes;
		@AuraEnabled public Integer totalCuota;
		@AuraEnabled public Integer numeroCuota;
		@AuraEnabled public Double valorCuota;
	}

	public class DetalleInternoMovimiento {
		@AuraEnabled public String numeroExtracto;
		@AuraEnabled public String numeroMovimientoExtracto;
		@AuraEnabled public String numeroOperacionCuota;
		@AuraEnabled public String numeroFinanciacion;
		@AuraEnabled public Moneda moneda;
	}

	public class PaginaActual {
		@AuraEnabled public Integer numeroPagina;
		@AuraEnabled public String identificadorPrimerRegistro;
		@AuraEnabled public String identificadorUltimoRegistro; // Cambio EndPoint v2
	}

	public class TarjetaCredito_Z {
		@AuraEnabled public TarjetaCredito tarjetaCredito;
		@AuraEnabled public List<Movimiento> movimiento;
	}

	public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}

	public class EstadoTransaccion {
		@AuraEnabled public String codigo;
		@AuraEnabled public String descripcion;
	}

	public class MontoMovimientoTC {
		@AuraEnabled public Double montoLocal;
		@AuraEnabled public Double montoOrigen;
		@AuraEnabled public Double montoTotal;
	}
	
	public static MovimientosJSON parse(String json) {
		return (MovimientosJSON) System.JSON.deserialize(json, MovimientosJSON.class);
	}
}