public class BuroDeCreditoXMLJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public String idConsulta;
		@AuraEnabled public String tipoReporte;
		@AuraEnabled public String reporteCredito;
		@AuraEnabled public String codigo;
		@AuraEnabled public String descripcion;
	}

	
	public static BuroDeCreditoXMLJSON parse(String json) {
		return (BuroDeCreditoXMLJSON) System.JSON.deserialize(json, BuroDeCreditoXMLJSON.class);
	}
}