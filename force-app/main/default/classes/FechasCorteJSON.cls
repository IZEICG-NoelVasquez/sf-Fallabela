public class FechasCorteJSON {

	public class ResumenUltimaFacturacion {
		@auraenabled public String fechaUltimaFacturacion;
	}

	public class EstadoOperacion {
		@auraenabled public String codigoOperacion;
		@auraenabled public String glosaOperacion;
	}

	public class Message {
		@auraenabled public EstadoOperacion estadoOperacion;
		@auraenabled public List<ResumenProducto> resumenProducto;
	}

	@auraenabled public String code;
	@auraenabled public Message message;

	public class ResumenProducto {
		@auraenabled public ResumenUltimaFacturacion resumenUltimaFacturacion;
	}

	
	public static FechasCorteJSON parse(String json) {
		return (FechasCorteJSON) System.JSON.deserialize(json, FechasCorteJSON.class);
	}
}