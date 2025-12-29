/**
* Nombre: ApiGeeJSON
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para el parseo de la respuesta del MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           09/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class ApiGeeJSON {

    @AuraEnabled public DocumentInfo DocumentInfo;
	@AuraEnabled public Document document;

	public class Status {

		@AuraEnabled public String statusId;
		@AuraEnabled public String statusDescription;
	}	

	public class Document {

		@AuraEnabled public String fileUrl;
		@AuraEnabled public String fileBase64;
	}

	public class DocumentInfo {

		@AuraEnabled public String documentId;
		@AuraEnabled public Status status;
	}
	
	public static ApiGeeJSON parse(String json) {

		return (ApiGeeJSON) System.JSON.deserialize(json, ApiGeeJSON.class);
	}
}