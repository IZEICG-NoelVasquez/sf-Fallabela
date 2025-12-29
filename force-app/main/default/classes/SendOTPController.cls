public class SendOTPController {
	 
    @AuraEnabled
	public static Account getCustomerByCaseId (String caseId) {
        
        
        if (caseId == null) {
            return null;
        }
        
		Case c = [SELECT AccountId FROM Case WHERE Id =: caseId];

        
        Account acc = [SELECT Id, Name, Fecha_de_nacimiento1__c, PersonMobilePhone, Oficina__c, PersonContactId, CURP__c, (select N_mero_de_tarjeta__c from Tarjetas__r) 
                       FROM Account WHERE Id =: c.AccountId];
        

		return acc == null ? new Account() : acc;

	}

    @AuraEnabled
    public static Map<String, String> obtenerConfiguracionServicio() {

        Map<String, String> result = new Map<String, String>();

        Configuracion_OTP__mdt configuracionOTP = [SELECT Servicio__c FROM Configuracion_OTP__mdt LIMIT 1];

        String servicio = configuracionOTP.Servicio__c;

        System.debug('Servicio:  ' + servicio);

        result.put('servicio', servicio);

        return result;
    }

    @AuraEnabled
    public static Boolean sendOTPCodeByPhoneTwilio (String phoneNumber) { 
        
        TwilioVerifyClient client = new TwilioVerifyClient();
        HttpResponse response = client.sendCode(phoneNumber);
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
		
        System.debug('response.getBody() ' + response.getBody());
        
        return Boolean.valueOf(body.get('success'));
    
    }
    
    @AuraEnabled
    public static Boolean validateOTPCodeTwilio (String phoneNumber, String code) { 
        
        System.debug('code ' + code);
        
        TwilioVerifyClient client = new TwilioVerifyClient();
        HttpResponse response = client.validateCode(phoneNumber, code);
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
		        
        return Boolean.valueOf(body.get('success'));
    
    }

    @AuraEnabled
    public static Map<String, Object> sendOTPMicroservicio(String numeroDocumento, String numeroCelular) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);
        params.put('numeroCelular', numeroCelular);
        params.put('codigoArea', '00521');

        MicroServicioEnviarOTP msEnviarOTP = new MicroServicioEnviarOTP();
        String respEnviarOTP = msEnviarOTP.enviarOTP(params);

        System.debug('respEnviarOTP:  ' + respEnviarOTP);

        EnviarOTPJSON enviarOTPJSON_Exito;
        EnviarOTPErrorJSON enviarOTPJSON_Error;

        // Se Valida el Envio del Codigo
        try {
            enviarOTPJSON_Exito = EnviarOTPJSON.parse(respEnviarOTP); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            // Se Valida el error
            try {
                enviarOTPJSON_Error = EnviarOTPErrorJSON.parse(respEnviarOTP); 
            } catch (Exception ex2) {
                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        System.debug('enviarOTPJSON_Exito:  ' + enviarOTPJSON_Exito);
        System.debug('enviarOTPJSON_Error:  ' + enviarOTPJSON_Error);

        if( enviarOTPJSON_Exito != null ) {
            //  Validacion Exitosa
            success = true;
            result.put('success', success);
            result.put('message', enviarOTPJSON_Exito.message.glosaEstado );
            result.put('errorMessage', false);
        } else if( enviarOTPJSON_Error != null ) {
            // Error en la Validacion
            success = true;
            result.put('success', success);
            result.put('message', enviarOTPJSON_Error.message );
            result.put('errorMessage', true);
        } else {
            success = false;
            result.put('success', success);
            result.put('message', respEnviarOTP );
            result.put('errorMessage', false);
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> validateOTPMicroservicio(String numeroDocumento, String clave) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);
        params.put('clave', clave);

        MicroServicioValidarOTP msValidarOTP = new MicroServicioValidarOTP();
        String respValidarOTP = msValidarOTP.validarOTP(params);

        System.debug('respValidarOTP:  ' + respValidarOTP);

        ValidarOTPJSON validarOTPJSON_Exito;
        ValidarOTPErrorJSON validarOTPJSON_Error;

        // Se Valida si el Codigo es correcto
        try {
            validarOTPJSON_Exito = ValidarOTPJSON.parse(respValidarOTP); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            // Se Valida el error
            try {
                validarOTPJSON_Error = ValidarOTPErrorJSON.parse(respValidarOTP); 
            } catch (Exception ex2) {
                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        System.debug('validarOTPJSON_Exito:  ' + validarOTPJSON_Exito);
        System.debug('validarOTPJSON_Error:  ' + validarOTPJSON_Error);

        if( validarOTPJSON_Exito != null ) {
            //  Validacion Exitosa
            success = true;
            result.put('success', success);
            result.put('message', validarOTPJSON_Exito.message.respuesta.glosaRespuesta );
            result.put('errorMessage', false);
        } else if( validarOTPJSON_Error != null ) {
            // Error en la Validacion
            success = true;
            result.put('success', success);
            result.put('message', validarOTPJSON_Error.message );
            result.put('errorMessage', true);
        } else {
            success = false;
            result.put('success', success);
            result.put('message', respValidarOTP );
            result.put('errorMessage', false);
        }

        return result;
    }
    @AuraEnabled
	public static Registro_OTP__c createRegistroOTP (String phone, String cuenta, String curp, 
    String mensaje, String status, String tipificacion, String tipo, String mode, String caseId) {
        
        Registro_OTP__c rOTP = new Registro_OTP__c();
        rOTP.Telefono__c = phone;
        rOTP.Cuenta__c = cuenta;
        rOTP.CURP__c = curp;
        rOTP.Mensaje__c = mensaje;
        rOTP.Status__c = status;
        if(mode == 'case'){
            Case caso = [Select Id, RecordTypeId, RecordType.Name From Case Where Id=:caseId LIMIT 1];
            System.debug('caso '+caso);
         System.debug('caso '+caso.RecordTypeId);
                  System.debug('caso '+caso.RecordType.Name);

        rOTP.Tipificacion__c = caso.RecordType.Name;
        }
        else{
        rOTP.Tipificacion__c = tipificacion;
        }
        if(rOTP.Tipificacion__c == null){rOTP.Tipificacion__c = 'Actualización de datos';}
        if((rOTP.Telefono__c == '' || rOTP.Telefono__c == null)  && rOTP.Cuenta__c != null){
            Account acc = [Select PersonMobilePhone  From Account Where Id=:rOTP.Cuenta__c LIMIT 1];
            rOTP.Telefono__c = acc.PersonMobilePhone;
        }
        rOTP.Tipo__c = tipo;
        insert rOTP;
        return rOTP;
    }
    
}