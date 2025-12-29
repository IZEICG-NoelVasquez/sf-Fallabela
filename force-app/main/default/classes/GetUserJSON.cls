/************************************************************************************************
Apex Class Name	:	GetUserJSON 
Version			:	1.0
Created Date    :	14/08/2019 5:50
Function 		: 	clase JSON para el microServicio GetUser
Test Class		:	microServicioGetUser_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     14/08/2019 	   Original Version
*************************************************************************************************/
public class GetUserJSON {
    //Clase Message con las dos clases que recibe
    public class Message {
		@AuraEnabled public EstadoOperacion estadoOperacion;
		@AuraEnabled public DocumentoIdentidad documentoIdentidad;
	}
    //Clase EstadoOperación con las 2 variables string que recibe
    public class EstadoOperacion {
		@AuraEnabled public String codigoOperacion;
		@AuraEnabled public String glosaOperacion;
	}
    //calse DocumentoIdentidad con las las 2 variables string que recibe
    public class DocumentoIdentidad {
		@AuraEnabled public String tipoDocumento;
		@AuraEnabled public String numeroDocumento;
	}
    //variables que recibe el MicroServicio
    @auraenabled public String code;
    @auraenabled public Message message;
    //Parseo de la Respuesta en formato JSON
    public static GetUserJSON parse(String json) {
		return (GetUserJSON) System.JSON.deserialize(json, GetUserJSON.class);
	}
}