public class BlobStorageJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public String base64TextId;
		@AuraEnabled public String base64Text;
	}
	
	public static BlobStorageJSON parse(String json) {
		return (BlobStorageJSON) System.JSON.deserialize(json, BlobStorageJSON.class);
	}
}