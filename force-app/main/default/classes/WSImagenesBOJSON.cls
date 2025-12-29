public class WSImagenesBOJSON {

	@AuraEnabled public Integer idDocumento;
	@AuraEnabled public String name;
	@AuraEnabled public String contentType;
	@AuraEnabled public Integer cardApplication;
	@AuraEnabled public String documentType;
	@AuraEnabled public Object hideBackoffice;
	@AuraEnabled public List<Links> links;

	public class Links {
		@AuraEnabled public String rel;
		@AuraEnabled public String href;
	}
	
	public static List<WSImagenesBOJSON> parse(String json) {
		return (List<WSImagenesBOJSON>) System.JSON.deserialize(json, List<WSImagenesBOJSON>.class);
	}
}