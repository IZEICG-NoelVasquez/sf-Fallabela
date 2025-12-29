public class OtrosDatosJSON {
    //variables que recibe el MicroServicio
    @auraenabled public String code;
    @auraenabled public Message message;
    //Clase Message con la clase que recibe
    public class Message {
		    @AuraEnabled public EstadoOperacion estadoOperacion;
	  }
    //Clase EstadoOperación con las 2 variables string que recibe
    public class EstadoOperacion {
		    @AuraEnabled public String codigoOperacion;
		    @AuraEnabled public String glosaOperacion;
	  }
    //Parseo de la Respuesta en formato JSON
    public static OtrosDatosJSON parse(String json) {
		    return (OtrosDatosJSON) System.JSON.deserialize(json, OtrosDatosJSON.class);
	  }
}