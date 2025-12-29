public class MicroServicioCrearCasoSaldosCntrllr {

    @AuraEnabled
    public static Map<String, Object> createCaseClosedSaldos (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }
}