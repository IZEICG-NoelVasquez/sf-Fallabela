public class IncodeScoreJSON {

	public class Overall {

		@AuraEnabled public String value;
		@AuraEnabled public String status;
	}

	public class IdValidation {

		@AuraEnabled public Overall overall;
	}

	@AuraEnabled public String code;
	@AuraEnabled public Message message;

	public class Message {

		@AuraEnabled public ParseResponse parseResponse;
	}

	public class Liveness {

		@AuraEnabled public Overall overall;
	}

	public class GovernmentValidation {

		@AuraEnabled public Overall ocrValidationOverall;
	}

	public class ParseResponse {

		@AuraEnabled public IdValidation idValidation;
		@AuraEnabled public Liveness liveness;
		@AuraEnabled public FaceRecognition faceRecognition;
		@AuraEnabled public GovernmentValidation governmentValidation;
		@AuraEnabled public Overall overall;
		@AuraEnabled public String reasonMsg;
		@AuraEnabled public IneScrapingValidation ineScrapingValidation;
	}

	public class IneScrapingValidation {

		@AuraEnabled public String result;
	}

	public class FaceRecognition {

		@AuraEnabled public Overall overall;
	}
	
	public static IncodeScoreJSON parse(String json) {

		return (IncodeScoreJSON) System.JSON.deserialize(json, IncodeScoreJSON.class);
	}
}