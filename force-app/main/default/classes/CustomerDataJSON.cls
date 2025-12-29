/************************************************************************************************
Apex Class Name	:	CustomerDataJSON 
Version			:	1.0
Created Date    :	19/08/2019 11:43
Function 		: 	clase JSON para el microServicio CustomerData
Test Class		:	MicroServicioCustomerData_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     19/08/2019 	   Original Version
*************************************************************************************************/
public class CustomerDataJSON {
    //variables que recibe el MicroServicio
    @auraenabled public String code;
    @auraenabled public Message message;
    //Clase Message con las dos clases que recibe
        public class Message {
		    @AuraEnabled public EstadoOperacion estadoOperacion;
		    @AuraEnabled public Cliente cliente;
	    }
            //Clase EstadoOperación con las 2 variables string que recibe
            public class EstadoOperacion {
		        @AuraEnabled public String codigoOperacion;
		        @AuraEnabled public String glosaOperacion;
	        }
            public class Cliente {
		        @AuraEnabled public String apellidoMaterno;
		        @AuraEnabled public String apellidoPaterno;
                @AuraEnabled public String nombres;
                @AuraEnabled public DocumentoIdentidad documentoIdentidad;
                @AuraEnabled public String tipoCliente;
                @AuraEnabled public InformacionContacto informacionContacto;    
            }
                //calse DocumentoIdentidad con las las 2 variables string que recibe
                public class DocumentoIdentidad {
                    @AuraEnabled public String tipoDocumento;
                    @AuraEnabled public String numeroDocumento;
                } 
                public class InformacionContacto {
                    @auraenabled public List<Telefono> telefono;
                    @AuraEnabled public Direccion direccion;
                    @AuraEnabled public CorreoElectronico correoElectronico;
                }
                    public class Telefono {
                        @AuraEnabled public String tipoTelefono;
                        @AuraEnabled public String numeroTelefono;
                    }
                    public class Direccion {
                        @AuraEnabled public String direccionCompleta;
                        @AuraEnabled public String nombreVia;
                        @AuraEnabled public String numeroVivienda;
                        @AuraEnabled public String tipoBarrio;
                        @AuraEnabled public String tipoDireccion;
                    }
                    public class CorreoElectronico {
                        @AuraEnabled public String codigoTipoCorreo;
                        @AuraEnabled public String direccionCorreoElectronico;
                    }
    //Parseo de la Respuesta en formato JSON
    public static CustomerDataJSON parse(String json) {
		return (CustomerDataJSON) System.JSON.deserialize(json, CustomerDataJSON.class);
	}
}