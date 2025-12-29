public class IncodeStartJSON {

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {
		@AuraEnabled public String interviewId;
		@AuraEnabled public String token;
		@AuraEnabled public String interviewCode;
		@AuraEnabled public Integer idCaptureTimeout;
		@AuraEnabled public Integer selfieCaptureTimeout;
		@AuraEnabled public Integer idCaptureRetries;
		@AuraEnabled public Integer selfieCaptureRetries;
		@AuraEnabled public Integer curpValidationRetries;
		@AuraEnabled public String clientId;
		@AuraEnabled public String env;
		@AuraEnabled public Boolean existingSession;
	}
	
	public static IncodeStartJSON parse(String json) {
        
		return (IncodeStartJSON) System.JSON.deserialize(json, IncodeStartJSON.class);
	}
}