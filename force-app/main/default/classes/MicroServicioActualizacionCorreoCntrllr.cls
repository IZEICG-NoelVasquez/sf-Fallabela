public class MicroServicioActualizacionCorreoCntrllr {

    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc) {
        System.debug('updateSelectedAccount');

        if (idAcc == null) {
            return null;
        }

        List<Account> accts = [SELECT ID_PersonAccount__c, Tipo_Direcci_n__c, Poblaci_n__c, Tipo_de_v_a__c, 
                                        Regi_n__c, Resto_Direcci_n__c, Delegaci_n__c, Nombre_v_a__c, Colonia__c, 
                                        N_mero_de_v_a__c, C_digo_Postal__c, ltimos_4_d_gitos_de_Celular__pc, PT__pc, 
                                        Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Autenticar_Sin_Celular__c, 
                                        Name, Oficina__c, N_m_contrato__c, CURP__c, ID_Cliente__c, PersonMailingAddress, 
                                        PersonEmail, PersonContactId, PersonMobilePhone, Ultimos_4_d_gitos_de_Mobile__c, 
                                        (select Subject, Status from cases limit 10), (select N_mero_de_tarjeta__c from Tarjetas__r), 
                                        VIP__c, Empleado__c, Subgrupo__pc, Flex__c
                                FROM Account WHERE Id =: idAcc LIMIT 1];
        Account acc;
        if ( accts != null && !accts.isEmpty() ) {
            acc = accts[0];
        }
        return acc;
    }
    
    @AuraEnabled
    public static Map<String, Object> createCaseClosedEmail (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> actualizarEmail(String numeroDocumento, String email) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento); 
        params.put('email', email);
        
        System.debug('numeroDocumento: ' + numeroDocumento);
        System.debug('email: ' + email);
        
        MicroServicioActualizaicionCorreo mac = new MicroServicioActualizaicionCorreo();
        ActualizarCorreoJSON correo = mac.actualizarCorreo(params);
        
        if(correo!=null) {
            success = true;
        }

        System.debug('Actualizar correo Success: ' + success);
        result.put('success', success);
        result.put('correo', correo);
        return result;
    }

}