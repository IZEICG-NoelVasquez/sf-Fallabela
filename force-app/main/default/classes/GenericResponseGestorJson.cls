public  class GenericResponseGestorJson {
    
    public String code;
	public String message;
	public Data data;

	public class Data {
		public String command_id;
	}

	
	public static GenericResponseGestorJson parse(String json) {
		return (GenericResponseGestorJson) System.JSON.deserialize(json, GenericResponseGestorJson.class);
	}

}