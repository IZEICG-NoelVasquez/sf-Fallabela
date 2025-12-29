public class WistonDataJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public String fileURL;
		@AuraEnabled public String fileBase64;
	}
	
	public static WistonDataJSON parse(String json) {
		return (WistonDataJSON) System.JSON.deserialize(json, WistonDataJSON.class);
	}
}