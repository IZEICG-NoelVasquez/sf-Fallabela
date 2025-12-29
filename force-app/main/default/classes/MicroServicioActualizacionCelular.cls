public class MicroServicioActualizacionCelular {

    @AuraEnabled
    public static Map<String, Object> createCaseClosedMobile (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
        System.debug('result método createCaseClosedMobile ' + result);
        return result;
    }

    @AuraEnabled
    public static void actualizaValidacionPreguntas(String idValidacion, String idCaso) {

        Validacion_Incorrecta__c validacion = [SELECT Caso__c FROM Validacion_Incorrecta__c WHERE Id =: idValidacion ];

        validacion.Caso__c = idCaso;
        update validacion;
    }

    @AuraEnabled    
    public static Map<String, Object> actualizarCelular(Map<String, String> campos ) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, Map<String, Object > > params = new Map<String, Map<String, Object > >();

        params.put('cliente', new Map<String, Object>() );

        Map<String,String> mapInfoPersonal = new Map<String, String>();
        mapInfoPersonal.put('paisResidencia', '484');
        params.get('cliente').put('informacionPersonal', mapInfoPersonal); 

        if( campos.containsKey('numeroDocumento') ) {
            params.get('cliente').put('numeroDocumento', campos.get('numeroDocumento') );
        }

        /// Se cambia la estructura del JSON en el Request
        params.put('informacionContacto', new Map<String, Object>() );

        List<Object> listMapTelefono = new List<Object>();
        Map<String, String> mapMovil = new Map<String,String>();
        if( campos.containsKey('numeroTelefonoMovil') ) {                      
            
            mapMovil.put('tipoTelefono', 'MO');
            mapMovil.put('numeroTelefono', campos.get('numeroTelefonoMovil') );
            listMapTelefono.add(mapMovil);
        }
        params.get('informacionContacto').put('telefono', listMapTelefono);

        System.debug('params:  ' + params);

        MicroServicioActualizacionDatosCliente msCel = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON celular = msCel.actualizarDatosJSON3n(params);
        
        if(celular != null) {
            success = true;
        }

        System.debug('Actualizar Celular Success: ' + success);
        result.put('success', success);
        result.put('celular', celular);
        return result;
    }

    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc, Map<String, String> campos) {

        Account accUpdate = new Account();
        accUpdate.Id = idAcc;
        if( campos.containsKey('movilAccount') ) {
            accUpdate.PersonMobilePhone = campos.get('movilAccount');
        }

        try {

            update accUpdate;
        } catch (Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() );
            System.debug('Linea:  ' + ex.getStackTraceString() );
        }        

        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }
    
    @AuraEnabled
    public static void sendSMSmedioAltoRiesgo(Account selectedAccount){
        Account acc = [Select Id, Send_SMS__c From Account Where Id =: selectedAccount.Id LIMIT 1];
        
        System.debug('selectedAccount ' +selectedAccount);
        System.debug('Send_SMS__c ' +acc.Send_SMS__c);
        if(acc.Send_SMS__c == false){acc.Send_SMS__c = true;}
        else{acc.Send_SMS__c = false;}
        update acc;
        System.debug('Send_SMS__c2 ' +acc.Send_SMS__c);
    }
}