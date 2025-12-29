public class MicroServicioActualizacionNombre {

    @AuraEnabled
    public static Map<String, Object> createCaseClosedName (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc, Map<String, String> campos) {

        Account accUpdate = new Account();
        accUpdate.Id = idAcc;
        if( campos.containsKey('nombres') ) {
            accUpdate.FirstName = campos.get('nombres');
        }
        if( campos.containsKey('apellidos') ) {
            accUpdate.LastName = campos.get('apellidos');
        }

        try {

            update accUpdate;
        } catch (Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() );
            System.debug('Linea:  ' + ex.getLineNumber() );
        }        

        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }

    @AuraEnabled    
    public static Map<String, Object> actualizarNombre(Map<String, String> campos ) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, Map<String, Object > > params = new Map<String, Map<String, Object > >();

        params.put('cliente', new Map<String, Object>() );

        Map<String,String> mapInfoPersonal = new Map<String, String>();
        mapInfoPersonal.put('paisResidencia', '484');
        params.get('cliente').put('informacionPersonal', mapInfoPersonal);

        if( campos.containsKey('nombres') ) {
            params.get('cliente').put('nombres', campos.get('nombres') );
        }
        if( campos.containsKey('apellidoPaterno') ) {
            params.get('cliente').put('apellidoPaterno', campos.get('apellidoPaterno') );
        }
        if( campos.containsKey('apellidoMaterno') ) {
            params.get('cliente').put('apellidoMaterno', campos.get('apellidoMaterno') );
        }

        /// Se cambia la estructura del JSON en el Request
        if( campos.containsKey('numeroDocumento') ) {
            params.get('cliente').put('numeroDocumento', campos.get('numeroDocumento') );
        }

        System.debug('params:  ' + params);

        MicroServicioActualizacionDatosCliente msName = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON nombre = msName.actualizarDatosJSON3n(params);
        
        if(nombre != null) {
            success = true;
        }

        System.debug('Actualizar Nombre Success: ' + success);
        result.put('success', success);
        result.put('nombre', nombre);
        return result;
    }

}