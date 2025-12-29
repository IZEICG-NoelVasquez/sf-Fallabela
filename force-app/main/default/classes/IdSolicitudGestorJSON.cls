/**
* Nombre: IdSolicitudGestorJSON
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para el parseo de la respuesta del MicroServicio GestorIdSolicitud
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           16/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class IdSolicitudGestorJSON {

    @AuraEnabled public String code;
	@AuraEnabled public String message;
	@AuraEnabled public List<Data> data;

	public class Productos {

		@AuraEnabled public String id;
		@AuraEnabled public Integer tipo;
	}	

	public class Data {

		@AuraEnabled public String numero;
		@AuraEnabled public Integer tipo_solicitud;
		@AuraEnabled public Integer estado;
		@AuraEnabled public String fecha;
		@AuraEnabled public List<Productos> productos;
	}
	
	public static IdSolicitudGestorJSON parse(String json) {

		return (IdSolicitudGestorJSON) System.JSON.deserialize(json, IdSolicitudGestorJSON.class);
	}
}