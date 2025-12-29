public class MovimientosListJSON {

	@AuraEnabled public String numeroExtracto;
	@AuraEnabled public String numeroMovimientoExtracto;
	@AuraEnabled public String numeroOperacionCuota;
	@AuraEnabled public String numeroFinanciacion;
	@AuraEnabled public String titularidad;
	@AuraEnabled public String contrato;
	@AuraEnabled public String fechaHoraTransaccion;
	@AuraEnabled public Double montoLocal;
	@AuraEnabled public String pagoMinimo;
    @AuraEnabled public String fechaLimiteDePago;
    @AuraEnabled public String proximaFechaDeCorte;
	@AuraEnabled public String estatusFinalDeTarjeta;
	@AuraEnabled public String descripcionMovimiento;
	@AuraEnabled public Boolean movimientoPorAutorizar;
	
	public static List<MovimientosListJSON> parse(String json) {
		return (List<MovimientosListJSON>) System.JSON.deserialize(json, List<MovimientosListJSON>.class);
	}
}