public class CustShipmentTrackingEstafetaJSON {

    public class TrackingData_Z {

		public List<TrackingData> TrackingData;
	}

	public class ExecuteQueryResult {

		public String errorCodeDescriptionSPA;
		public String errorCode;
		public String errorCodeDescriptionENG;
		public TrackingData_Z trackingData;
	}

	public ExecuteQueryResponse ExecuteQueryResponse;

	public class ExecuteQueryResponse {

		public ExecuteQueryResult ExecuteQueryResult;
	}

	public class DeliveryData {

		public String receiverName;
	}

	public class TrackingData {

		public DeliveryData deliveryData;
		public String statusSPA;
		public String waybill;
	}

	public static CustShipmentTrackingEstafetaJSON parse(String json) {

		return (CustShipmentTrackingEstafetaJSON) System.JSON.deserialize(json, CustShipmentTrackingEstafetaJSON.class);
	}
}