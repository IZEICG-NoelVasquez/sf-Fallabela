public class ErrorLog {

    /**
     * metodo para guardado de errores de Excepciones
    */
    public static void log (String apexClass, String message) {
        insert new Error_Log__c(Message__c = message, ApexClass__c = apexClass);
        // errors.add(new Error_Log__c(Message__c = message, ApexClass__c = apexClass));

    }

}