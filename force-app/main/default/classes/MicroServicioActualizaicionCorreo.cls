public class MicroServicioActualizaicionCorreo {

    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc) {
        
        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }
    
    @AuraEnabled
    public static Map<String, Object> createCaseClosedEmail (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> actualizarEmail(Map<String, String> campos) {
        
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

        Map<String, String> mapCorreo = new Map<String,String>();
        if( campos.containsKey('direccionCorreoElectronico') ) {
            mapCorreo.put('direccionCorreoElectronico', campos.get('direccionCorreoElectronico') );
        }
        params.get('informacionContacto').put('correoElectronico', mapCorreo);

        System.debug('params:  ' + params);
        
        MicroServicioActualizacionDatosCliente msMail = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON correo = msMail.actualizarDatosJSON3n(params);
        
        if(correo != null) {
            success = true;
        }

        System.debug('Actualizar Correo Success: ' + success);
        result.put('success', success);
        result.put('correo', correo);
        return result;
    }

}