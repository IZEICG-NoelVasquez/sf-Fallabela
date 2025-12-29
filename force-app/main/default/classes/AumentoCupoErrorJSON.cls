public class AumentoCupoErrorJSON {

    @AuraEnabled public String code;
    @AuraEnabled public String message;
    
    public static AumentoCupoErrorJSON parse(String json) {
        return (AumentoCupoErrorJSON) System.JSON.deserialize(json, AumentoCupoErrorJSON.class);
    }
}