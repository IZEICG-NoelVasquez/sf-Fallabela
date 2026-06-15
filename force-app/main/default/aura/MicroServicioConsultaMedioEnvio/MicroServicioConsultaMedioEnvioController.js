({
    doInit : function (component, event, helper) {

        component.set("v.consultaExitosa", false);

        component.set("v.loadingConsultaMedioEnvio", true);
        var movimientoIdx = component.get("v.movimientoIdx");
        helper.consultaMedioDeEnvio(component, movimientoIdx);
    },
    
    handleModalMedioDeEnvio : function (component, event, helper) {

        // OTP       
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizacionMedioEnvio && mapValidacionesOTP.MicroServicioActualizacionMedioEnvio.otp ) {

            if( mapValidacionesOTP.MicroServicioActualizacionMedioEnvio.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizacionMedioEnvio.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioActualizacionMedioEnvio.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioActualizacionMedioEnvio.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP MedioEnvio:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP MedioEnvio:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

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

    handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.openModalMedioDeEnvio(component);
		}
	}
	
})