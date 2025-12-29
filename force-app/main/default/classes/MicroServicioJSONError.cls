public class MicroServicioJSONError {

    @AuraEnabled public String code;
    @AuraEnabled public String message;
    
    public static MicroServicioJSONError parse(String json) {
        return (MicroServicioJSONError) System.JSON.deserialize(json, MicroServicioJSONError.class);
    }
}