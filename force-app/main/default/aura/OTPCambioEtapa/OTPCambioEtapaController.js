({
	doInit : function(component, event, helper) {
		
        /**var simpleRecord = component.get("v.simpleRecord");
        var recordId = component.get("v.recordId");
        
        
        console.log('simpleRecord', JSON.stringify(simpleRecord));
        console.log('RT Name', simpleRecord.RecordType.Name);
        console.log('PAN Verificado', !simpleRecord.Celular_PAN_Verificado__c);
        console.log('Estatus', simpleRecord.Status);
        console.log('recordId', recordId);
        
        if ( (simpleRecord.RecordType.Name === 'Actualización de Celular' && !simpleRecord.Celular_Nuevo_Verificado__c
            && simpleRecord.Status === 'Actualización de Datos') ) {
            
            helper.openOTP(component, simpleRecord.Celular_Nuevo__c, recordId);
            
        } else if ((simpleRecord.RecordType.Name === 'Consulta de PAN' && !simpleRecord.Celular_PAN_Verificado__c &&
                    simpleRecord.Status === 'Consulta Cuenta')) {
            
            helper.openOTPPAN(component, null, recordId);
            
        }
        */


	},
    
    abrirOtp : function (component, event, helper) {
        ///component.set("v.otpGenerator", true);
        console.log("otpGenerator: " + true);
        
        var simpleRecord = component.get("v.simpleRecord");
        
        var cmpOTP = component.find('otpCmp');
        
        
        if (simpleRecord.RecordType.Name === 'Actualización de Celular' || simpleRecord.RecordType.Name == 'Alta Cliente') {
            if (simpleRecord.Celular_Nuevo__c==null) {
                helper.showToast("Error","Favor de ingresar el campo \"Celular Nuevo\"", "error" );
            } else {
                cmpOTP.setState('open');
                cmpOTP.setMode('case');
            	cmpOTP.setPhone(simpleRecord.Celular_Nuevo__c);
                console.log('Actualizacióncelular: ' + simpleRecord.Celular_Nuevo__c);
                ///
                cmpOTP.set("v.blnUpdateMobile", true);
                cmpOTP.set("v.mobilePhoneUpdate", simpleRecord.Celular_Nuevo__c);
                var strMobilelUpdate = simpleRecord.Celular_Nuevo__c;
                var mobilePhoneUpdate4Dig = strMobilelUpdate.slice(strMobilelUpdate.length-4, strMobilelUpdate.length);
			    cmpOTP.set("v.mobilePhoneUpdate4Dig", mobilePhoneUpdate4Dig);
            }
            
        } else if (simpleRecord.RecordType.Name === 'Consulta de PAN') {
            cmpOTP.setState('open');
            cmpOTP.setMode('casePAN');
        }
    },
    
    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
        var mode = event.getParam("mode");
		var validatedRecordId = event.getParam("validatedRecordId");

        console.log("handleOTPValidated: " + isValid);
		
        ///component.set("v.verificadoOTP", isValid);
        
        if (mode === "case") {
        	
            // actualizar caso
        	helper.updateCase(component, validatedRecordId, isValid);
            
        } else if (mode === "casePAN") {
            helper.updateCasePAN(component, validatedRecordId, isValid);
        }

    }
})