({
	doInit : function (component, event, helper) {

		helper.consultaDeCupo(component);

		component.set("v.noPasoAumentoLinea", 1);
	},

	actualizarAumentoDeLinea : function(component, event, helper) {

		component.set("v.enableOTPModal", true);

		/// OTP
		var verificadoOTP = component.get("v.verificadoOTP");
		
		var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioAumentoDeLinea && mapValidacionesOTP.MicroServicioAumentoDeLinea.otp ) {

            if( mapValidacionesOTP.MicroServicioAumentoDeLinea.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioAumentoDeLinea.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioAumentoDeLinea.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioAumentoDeLinea.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

		console.log("esAltoRiesgo OTP AumentoCupo:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP AumentoCupo:  ", verificadoOTP);

		if (esAltoRiesgo && !verificadoOTP) {

			component.set("v.classBackdrop", "slds-backdrop slds-backdrop_open");
            
            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;
		} else {

			helper.openModalContactMethod(component);
		}		
	},

	handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
		component.set("v.verificadoOTP", isValid);
		
		/// Validaciones OTP Dinamicas
        if( isValid ) {

			component.set("v.verificadoOTPGlobal", true);

			helper.openModalContactMethod(component);
		}
    },

	confirmarAumentoDeLinea : function(component, event, helper) {
		component.set("v.noPasoAumentoLinea", 3);
		component.set("v.loadingAumentoCupo", true);
		helper.aumentoDeCupo(component);
	},

	closeModalAumentoDeLinea : function(component, event, helper) {

		component.set("v.openModalAumentoLinea", false);

		component.set("v.enableOTPModal", false);
	},

	handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {

			component.set("v.classBackdrop", '');
		}
	},

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
			component.set("v.classBackdrop", '');
            component.set("v.noPasoAumentoLinea", 2);
		}
	}
})