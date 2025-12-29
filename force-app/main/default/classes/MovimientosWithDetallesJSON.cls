public class MovimientosWithDetallesJSON {

    @auraenabled public String fechaHoraTransaccion;
    @auraenabled public Double montoLocal;
    @auraenabled public String nombreComercio;
    @AuraEnabled public String identificador;
    @AuraEnabled public String pagoMinimo;
    @AuraEnabled public String fechaLimiteDePago;
    @AuraEnabled public String proximaFechaDeCorte;
    @AuraEnabled public String estatusFinalDeTarjeta;
    @AuraEnabled public Boolean blnPlanPagosConMovs;
	
	public static List<MovimientosWithDetallesJSON> parse(String json) {
		return (List<MovimientosWithDetallesJSON>) System.JSON.deserialize(json, List<MovimientosWithDetallesJSON>.class);
	}


}