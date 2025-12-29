/************************************************************************************************
Apex Class Name	:	ActualizarCurpJSON 
Version			:	1.0
Created Date    :	24/09/2019 09:38
Function 		: 	clase JSON para el microServicio ActualizarCurp
Test Class		:	MicroServicioActualizarCurp_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     24/09/2019 	   Original Version
*************************************************************************************************/
public class ActualizarCurpJSON {
    //variables que recibe el MicroServicio
    @auraenabled public String code;
    @auraenabled public Message message;
    //Clase Message con las dos clases que recibe
        public class Message {
		    @AuraEnabled public EstadoOperacion estadoOperacion;
        }
            //Clase EstadoOperación con las 2 variables string que recibe
            public class EstadoOperacion {
		            @AuraEnabled public String codigoOperacion;
		            @AuraEnabled public String glosaOperacion;
	          } 

    //Parseo de la Respuesta en formato JSON
    public static ActualizarCurpJSON parse(String json) {
		return (ActualizarCurpJSON) System.JSON.deserialize(json, ActualizarCurpJSON.class);
	}
}