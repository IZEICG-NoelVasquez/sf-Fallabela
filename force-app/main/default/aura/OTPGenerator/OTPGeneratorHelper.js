({
	loadCustomerByCaseId : function(component) {
        
		var action = component.get("c.getCustomerByCaseId");
        var recordId = component.get("v.recordId");

		action.setParams({
			"caseId" : recordId
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();

			if (state === "SUCCESS") {

				var acc = response.getReturnValue();
                component.set("v.customer", acc);
                component.set("v.numeroDocumento", acc.CURP__c);
                ///
                console.log("v.numeroDocumento", component.get("v.numeroDocumento") );

			} else if (state === "INCOMPLETE") {

				console.log("Unknown error");

			} else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }


		});

		$A.enqueueAction(action);	
    },
    
    configuracionServicioOTP : function(component) {

        var action = component.get("c.obtenerConfiguracionServicio");

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log("state", state);

            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('result:  ' + result);
                console.log('result.servicio:  ' + result.servicio);
                
                /// 
                component.set("v.configServicio", result.servicio);

                component.set("v.configServicioLoaded", true);
            }
        });
        $A.enqueueAction(action);
    },

    sendCodeTwilio : function(component) {
        
		var action = component.get("c.sendOTPCodeByPhoneTwilio");
		var customer = component.get("v.customer");
        var mode = component.get("v.mode");
        var phoneCustomerData = component.get("v.phoneCustomerData");
	    var phoneNumber = mode === "case" ? component.get("v.phone") : customer.PersonMobilePhone;
        var phoneNumberSend;
        var blnUpdateMobile = component.get("v.blnUpdateMobile");
        if(blnUpdateMobile) {
            phoneNumberSend = component.get("v.mobilePhoneUpdate");
        }else if(phoneCustomerData != null){
            phoneNumberSend = phoneCustomerData;
        }else{
            phoneNumberSend = phoneNumber;
	    }  
		action.setParams({
			"phoneNumber" : phoneNumberSend
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();

			if (state === "SUCCESS") {

				var result = response.getReturnValue();
				
                if (result) {
                    this.showToast("Mensaje enviado","El codigo OTP fue enviado", "success" );
                } else {
                    this.showToast("Error","Favor de revisar los datos de envio", "error" );
                }

			} else if (state === "INCOMPLETE") {

				console.log("Unknown error");

			} else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            component.set("v.otpEnviadoValidado", true);

		});

		$A.enqueueAction(action);
    },
    
    validateCodeTwilio : function(component) {
        
		var action = component.get("c.validateOTPCodeTwilio");
		var codigo = "" + component.find("codigo_verificacion").get("v.value");
        var customer = component.get("v.customer");
        var mode = component.get("v.mode");
        var rqstFailures = component.get("v.rqstFailures");

        if( rqstFailures >= 3 ) {

            component.set("v.otpEnviadoValidado", true);
            this.showToast("Ha sobrepasado el límite de validaciones","Favor de intentarlo más tarde", "error" );
            return;
        }
        
        console.log("value: ", component.find("codigo_verificacion").get("v.value"));
        console.log("codigo: ", codigo);        
        
        
        var phoneNumber = mode === "case" ? component.get("v.phone") : customer.PersonMobilePhone;
        
		action.setParams({
            "phoneNumber" : phoneNumber,
			"code" : codigo
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();

			if (state === "SUCCESS") {

				var result = response.getReturnValue();
                
                this.fireOTPValidateEvent(component, result);
				
                if (result) {
                    this.showToast("El codigo es correcto","El codigo ingresado es correcto", "success" );
                    this.closeModal(component);
                } else {
                    this.showToast("El codigo es incorrecto","Favor de revisar el codigo ingresado", "error" );
                    rqstFailures++;
                    component.set("v.rqstFailures", rqstFailures);
                    console.log("rqstFailures");
                    console.log(rqstFailures);
                }

			} else if (state === "INCOMPLETE") {

				console.log("Unknown error");

			} else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            component.set("v.otpEnviadoValidado", true);

		});

		$A.enqueueAction(action);
	},
    
    sendCodeMicroServicio : function(component) {
        
		var action = component.get("c.sendOTPMicroservicio");
		var customer = component.get("v.customer");
        var mode = component.get("v.mode");
        var phoneCustomerData = component.get("v.phoneCustomerData");
	    var phoneNumber = mode === "case" ? component.get("v.phone") : customer.PersonMobilePhone;
        var phoneNumberSend;
        var blnUpdateMobile = component.get("v.blnUpdateMobile");
        if(blnUpdateMobile) {
            phoneNumberSend = component.get("v.mobilePhoneUpdate");
        }else if(phoneCustomerData != null){
            phoneNumberSend = phoneCustomerData;
        }else{
            phoneNumberSend = phoneNumber;
	    }
        var numeroDocumento = customer.CURP__c;
        console.log("numeroDocumento", numeroDocumento);
        
		action.setParams({
            "numeroDocumento" : numeroDocumento,
            "numeroCelular" : phoneNumberSend
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();

			if (state === "SUCCESS") {

				var result = response.getReturnValue();
				
                if ( result.success && (!result.errorMessage) ) {
                    this.showToast("Mensaje enviado","El codigo OTP fue enviado", "success" );
                    this.createRegistroOTP(component, "Envío OTP", "Exitoso","Éxito",phoneNumberSend);
                } else if( result.success && result.errorMessage ) {
                    this.showToast("Error OTP", result.message, "error" );
                    this.createRegistroOTP(component, "Envío OTP", "No Exitoso",result.message,phoneNumberSend);
                } else {
                    this.showToast("Error OTP", result, "error" );
                    this.createRegistroOTP(component, "Envío OTP", "No Exitoso",result,phoneNumberSend);
                }

			} else if (state === "INCOMPLETE") {

				console.log("Unknown error");

			} else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            component.set("v.otpEnviadoValidado", true);


		});

		$A.enqueueAction(action);	
	},
    
    validateCodeMicroServicio : function(component) {
        
		var action = component.get("c.validateOTPMicroservicio");
		var codigo = "" + component.find("codigo_verificacion").get("v.value");
        var customer = component.get("v.customer");
        var mode = component.get("v.mode");
        var rqstFailures = component.get("v.rqstFailures");
        ///
        var numeroDocumento = customer.CURP__c;

        if( rqstFailures >= 3 ) {

            component.set("v.otpEnviadoValidado", true);
            this.showToast("Ha sobrepasado el límite de validaciones","Favor de intentarlo más tarde", "error" );
            return;
        }
        
        console.log("value: ", component.find("codigo_verificacion").get("v.value"));
        console.log("codigo: ", codigo);
        
		action.setParams({
            "numeroDocumento" : numeroDocumento,
			"clave" : codigo
		});

		action.setCallback(this, function(response) {
			
            var state = response.getState();
            var validationResult = false;

			if (state === "SUCCESS") {

                var result = response.getReturnValue();
                console.log("result:  ", result);
                
                if( result.success && (!result.errorMessage) ) {
                    validationResult = true;
                }
                this.fireOTPValidateEvent(component, validationResult);
				
                if ( result.success && (!result.errorMessage) ) {
                    
                    this.createRegistroOTP(component, "Validación OTP", "Exitoso","Éxito","");
                    this.showToast("El codigo es correcto","El codigo ingresado es correcto", "success" );
                    this.closeModal(component);
                } else if ( result.success && result.errorMessage ) {
                    
                    this.createRegistroOTP(component, "Validación OTP", "No Exitoso",result.message,"");
                    this.showToast("Error Validación OTP",result.message, "error" );
                    rqstFailures++;
                    component.set("v.rqstFailures", rqstFailures);
                    console.log("rqstFailures");
                    console.log(rqstFailures);
                } else {
                    
                    this.createRegistroOTP(component, "Validación OTP", "No Exitoso",result,"");
                    this.showToast("Error Validación OTP",result, "error" );
                    rqstFailures++;
                    component.set("v.rqstFailures", rqstFailures);
                    console.log("rqstFailures");
                    console.log(rqstFailures);
                }

			} else if (state === "INCOMPLETE") {

				console.log("Unknown error");

			} else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            component.set("v.otpEnviadoValidado", true);

		});

		$A.enqueueAction(action);	
	},

    createRegistroOTP : function(component, tipo, status, mensaje, phone){
        var action = component.get("c.createRegistroOTP");
        var customer = component.get("v.customer");
        var tipificacion = component.get("v.tipificacion");
        var curp = customer.CURP__c;
        var cuenta = customer.Id;
        var caseId = component.get("v.recordId");
        console.log('id record ',caseId);
        var mode = component.get("v.mode");
        action.setParams({
            "phone" : phone,
            "cuenta" : cuenta,
            "curp" : curp,
            "mensaje" : mensaje,
            "status" : status,
            "tipificacion" : tipificacion,
            "tipo" : tipo,
            "mode" : mode,
            "caseId" : caseId
        }); 
		action.setCallback(this, function(response) {		
            var state = response.getState();
            var validationResult = false;
			if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result create:  ", result);
            } else if (state === "INCOMPLETE") {
				console.log("Unknown error");
			} else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
		});
		$A.enqueueAction(action);	
    },
    
    fireStepChange : function(component, step) {
        
        var stepChangeEvent = component.getEvent("stepChange");
        
        stepChangeEvent.setParams({
            "step" : step
        });
        
        stepChangeEvent.fire();
    },
    
    fireOTPValidateEvent : function(component, isValid) {
        
        var evt = component.getEvent("OTPValidated");
        
        var validatedRecordId = component.get("v.recordId");
        var mode = component.get("v.mode");
        console.log("validated Id", validatedRecordId);
        
        evt.setParams({
            "isValid" : isValid,
            "validatedRecordId": validatedRecordId,
            "mode" : mode
        });
        
        evt.fire();
    },
    
    openModal: function(cmp) {
        var cmpTarget = cmp.find('modal-section');
        $A.util.removeClass(cmpTarget, 'slds-hide');
    },
    
    closeModal: function(cmp) {
        var cmpTarget = cmp.find('modal-section');
        $A.util.addClass(cmpTarget, 'slds-hide');
        // Se limpia el campo codigo_verificacion
        cmp.find("codigo_verificacion").set("v.value", "");
    },
    
    showToast : function(title, message, type) {

	    var toastEvent = $A.get("e.force:showToast");
	    toastEvent.setParams({

	        "title": title,
	        "message": message,
	        "type": type
	    });
	    toastEvent.fire();
    },
    
    fireOTPCloseEvent : function(component, blnClose) {

        var evt = component.getEvent("OTPClose");

        console.log("Event OTPClose");
        evt.setParams({
            "closeModal" : blnClose
        });

        evt.fire();
    }
})