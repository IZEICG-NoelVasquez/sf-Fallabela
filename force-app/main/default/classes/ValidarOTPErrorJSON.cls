public class ValidarOTPErrorJSON {

    @AuraEnabled public String code;
	@AuraEnabled public String message;
	
	public static ValidarOTPErrorJSON parse(String json) {
		return (ValidarOTPErrorJSON) System.JSON.deserialize(json, ValidarOTPErrorJSON.class);
	}
}