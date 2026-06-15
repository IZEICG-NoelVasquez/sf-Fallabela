({
    handleModalEmailUpdate : function (component, event, helper) {        

        ///
        component.set("v.enableOTPModal", true);

        // OTP  
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizaicionCorreo && mapValidacionesOTP.MicroServicioActualizaicionCorreo.otp ) {

            if( mapValidacionesOTP.MicroServicioActualizaicionCorreo.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizaicionCorreo.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioActualizaicionCorreo.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioActualizaicionCorreo.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP Email Update:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP Email Update:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;

        } else {

            ///
            helper.openModalContactMethod(component);
        }
    },

    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
        component.set("v.verificadoOTP", isValid);

        /// Validaciones OTP Dinamicas
        if( isValid ) {

            component.set("v.verificadoOTPGlobal", true);

            ///
            helper.openModalContactMethod(component);

        }
    },

    confirmarEmailUpdate : function (component, event, helper) {

        var emailUpdate = component.find("emailUpdateId_1").get("v.value");
        console.log("emailUpdate", emailUpdate);

        helper.validaEmail(component, emailUpdate);

        ///
        console.log("v.strEmailUpdate 1", component.get("v.strEmailUpdate") );
    },

    guardarEmailUpdate : function (component, event, helper) {

        console.log("v.strEmailUpdate 2", component.get("v.strEmailUpdate") );

        component.set("v.noPasoEmailUpdate", 3);
        component.set("v.loadingEmailUpdate", true);
        var strEmailUpdate = component.get("v.strEmailUpdate");

        helper.actualizarEmail(component, strEmailUpdate);
    },

    closeModalEmailUpdate : function(component, event, helper) {

        helper.limpiarVaribles(component);

        component.set("v.openEmailUpdate", false);
    },

    handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {
			component.set("v.enableOTPModal", false);
		}
	},

    regresarModalEmailUpdate : function(component, event, helper) {

        component.set("v.noPasoEmailUpdate", 1);
    },

    handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.openModalEmailUpdate(component);
		}
	}
})