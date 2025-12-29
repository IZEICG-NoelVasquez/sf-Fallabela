/************************************************************************************************
Apex Class Name	:	SendNotificationJSON 
Version			:	1.0
Created Date    :	27/08/2019 12:10
Function 		: 	clase JSON para el microServicio SendNotification
Test Class		:	MicroServicioSendNotification_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     27/08/2019 	   Original Version
*************************************************************************************************/
public class SendNotificationJSON {
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
    public static SendNotificationJSON parse(String json) {
		    return (SendNotificationJSON) System.JSON.deserialize(json, SendNotificationJSON.class);
	  }
}