public class SaldosJson {
	
    @AuraEnabled public String code;
	@AuraEnabled public Message message;
    
    public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public TarjetaCredito tarjetaCredito;
	}
    public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}
    
    public class TarjetaCredito {
		@AuraEnabled public String codigoProducto;
		@AuraEnabled public String codigoSubProducto;
		@AuraEnabled public String identificadorProducto;
        @AuraEnabled public Moneda moneda;
        @AuraEnabled public ResumenFacturacion resumenFacturacion;
        @AuraEnabled public CuentaTarjetaCredito cuentaTarjetaCredito;
	}
    
    public class Moneda {
		@AuraEnabled public String codigoMoneda;
	}
    
    public class ResumenFacturacion {
        @AuraEnabled public String fechaInicioFacturacion;
        @AuraEnabled public String fechaTerminoFacturacion;
        @AuraEnabled public String montoPendientePago;
        @AuraEnabled public ResumenUltimaFacturacion resumenUltimaFacturacion;
        @AuraEnabled public ResumenProximaFacturacion resumenProximaFacturacion;
    }
    
    public class ResumenUltimaFacturacion {
        @AuraEnabled public String fechaPago;
        @AuraEnabled public String fechaUltimaFacturacion;
        @AuraEnabled public String fechaVencimiento;
        @AuraEnabled public String consumoFacturado;
        @AuraEnabled public String montoPagado;
        @AuraEnabled public String pagoMinimo;
    }
    
    public class ResumenProximaFacturacion {
        @AuraEnabled public String consumoPeriodoPorFacturar;
        @AuraEnabled public String fechaProximaFacturacion;
        @AuraEnabled public String fechaProximoVencimiento;
    }
    
    public class CuentaTarjetaCredito {
        @AuraEnabled public String identificador;
        @AuraEnabled public CupoNacional cupoNacional;
        @AuraEnabled public Avance avance;
        @AuraEnabled public Titular titular;
        @AuraEnabled public SuperAvance superAvance;
    }
    public class CupoNacional {
        @AuraEnabled public String cupoDisponible;
        @AuraEnabled public String cupoTotal;
        @AuraEnabled public String cupoUtilizado;
    }
    public class Avance {
        @AuraEnabled public String cupoDisponible;
        @AuraEnabled public String cupoTotal;
        @AuraEnabled public String cupoUtilizado;
    }
    
    public class Titular {
        @AuraEnabled public InformacionContacto informacionContacto;
        @AuraEnabled public Plastico plastico;
    }
    
    public class InformacionContacto {
        @AuraEnabled public Direccion direccion;
    }
    
    public class Direccion {
        @AuraEnabled public String direccionCompleta;
    }
    
    public class Plastico {
        @AuraEnabled public String logoMarca;
        @AuraEnabled public Situacion situacion;
    }
    
    public class Situacion {
        @AuraEnabled public String codigo;
        @AuraEnabled public String estado;
        @AuraEnabled public String glosa;
    }
    
    public class SuperAvance {
        @AuraEnabled public String cupoDisponible;
        @AuraEnabled public String cupoTotal;
        @AuraEnabled public String cupoUtilizado;
    }
    
	public static SaldosJson parse(String json) {
		return (SaldosJson) System.JSON.deserialize(json, SaldosJson.class);
	}
}