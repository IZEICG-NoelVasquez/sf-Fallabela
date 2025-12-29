public class EnviarOTPErrorJSON {

    @AuraEnabled public String code;
	@AuraEnabled public String message;
	
	public static EnviarOTPErrorJSON parse(String json) {
		return (EnviarOTPErrorJSON) System.JSON.deserialize(json, EnviarOTPErrorJSON.class);
	}
}