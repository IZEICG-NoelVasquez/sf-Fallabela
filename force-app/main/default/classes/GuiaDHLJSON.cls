/************************************************************************************************
Apex Class Name	:	GuiaDHLJSON 
Version			:	1.0
Created Date    :	17/10/2019 11:31
Function 		: 	clase JSON para el microServicio GuiaDHL
Test Class		:	microServicioGuiaDHL_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     17/10/2019 	   Original Version
*************************************************************************************************/
public class GuiaDHLJSON {
    //Clase TrackingResponse con las dos clases que recibe
    public class TrackingResponse {
	    @AuraEnabled public Response response;
	    @AuraEnabled public AWBInfo awbinfo;
        @AuraEnabled public String LanguageCode;
    }
    //Clase Response con las 2 variables string que recibe
    public class Response {
        @AuraEnabled public ServiceHeader serviceheader;
	}
        public class ServiceHeader {
            @AuraEnabled public String MessageTime;
            @AuraEnabled public String MessageReference;
            @AuraEnabled public String SiteID;
	    }
        //calse AWBInfo con las las 2 variables string que recibe
         public class Status {
                @AuraEnabled public String ActionStatus;
	        }
        public class AWBInfo {
	        @AuraEnabled public String AWBNumber;
            @AuraEnabled public Status status;
        //    @AuraEnabled public ShipmentInfo shipmentinfo;     
	    //}
           
        //    public class ShipmentInfo {
                @AuraEnabled public OriginServiceArea originservicearea;
                @AuraEnabled public DestinationServiceArea destinationservicearea;
                @AuraEnabled public String ShipperName;
                @AuraEnabled public String ShipperAccountNumber;
                @AuraEnabled public String ConsigneeName;
                @AuraEnabled public String ShipmentDate;
                @AuraEnabled public String Pieces;
                @AuraEnabled public String Weight;
                @AuraEnabled public String WeightUnit;
                @AuraEnabled public String GlobalProductCode;
                @AuraEnabled public String ShipmentDesc;
                @AuraEnabled public String DlvyNotificationFlag;
                @AuraEnabled public Shipper shipper;
                @AuraEnabled public Consignee consignee;
                @AuraEnabled public ShipperReference shipperreference;
                @auraenabled public List<ShipmentEvent> shipmentevent;
	        }
                public class OriginServiceArea {
                    @AuraEnabled public String ServiceAreaCode;
                    @AuraEnabled public String Description;
	            }
                public class DestinationServiceArea {
                    @AuraEnabled public String ServiceAreaCode;
                    @AuraEnabled public String Description;
	            }
                public class Shipper {
                    @AuraEnabled public String City;
                    @AuraEnabled public String PostalCode;
                    @AuraEnabled public String CountryCode;
	            }
                public class Consignee {
                    @AuraEnabled public String City;
                    @AuraEnabled public String PostalCode;
                    @AuraEnabled public String CountryCode;
	            }
                public class ShipperReference {
                    @AuraEnabled public String ReferenceID;
	            }
                public class ShipmentEvent {
                    @AuraEnabled public String Datex;
                    @AuraEnabled public String Timex;
                    @AuraEnabled public ServiceEvent serviceevent;
                    @AuraEnabled public String Signatory;
                    @AuraEnabled public ServiceArea servicearea;
	            }
                    public class ServiceEvent {
                        @AuraEnabled public String EventCode;
                        @AuraEnabled public String Description;
	                }
                    public class ServiceArea {
                        @AuraEnabled public String ServiceAreaCode;
                        @AuraEnabled public String Description;
	                }
    //variables que recibe el MicroServicio
    @auraenabled public TrackingResponse TrackingResponse;
    //Parseo de la Respuesta en formato JSON
    public static GuiaDHLJSON parse(String json) {
	    return (GuiaDHLJSON) System.JSON.deserialize(json, GuiaDHLJSON.class);
    }
}