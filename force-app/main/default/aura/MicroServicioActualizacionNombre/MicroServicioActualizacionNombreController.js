({
	handleModalNameUpdate : function (component, event, helper) {

		///
		component.set("v.enableOTPModal", true);
		
		// OTP 
		var verificadoOTP = component.get("v.verificadoOTP");

		var esAltoRiesgo;
		
		/// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizacionNombre && mapValidacionesOTP.MicroServicioActualizacionNombre.otp ) {

            if( mapValidacionesOTP.MicroServicioActualizacionNombre.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizacionNombre.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioActualizacionNombre.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioActualizacionNombre.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP Name Update:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP Name Update:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;
        } else {

			component.set("v.blnOpenModalContactMethod", true);
        }		
		
	},

	handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
		component.set("v.verificadoOTP", isValid);
		
		/// Validaciones OTP Dinamicas
        if( isValid ) {

			component.set("v.verificadoOTPGlobal", true);

			component.set("v.blnOpenModalContactMethod", true);
        }
	},
	
	limpiarCampo : function(component, event, helper) {

		var caracter = event.which;
		console.log("caracter:  ", caracter);

		var listCaracteresPermitidos = component.get("v.listCaracteresPermitidos");

		/// Solo se permiten las letras [A-Z], [a-z], [espacio] Sin las letras Ñ ni ñ
		if( !listCaracteresPermitidos.includes(caracter) ) {

			event.preventDefault();
		}
	},

	confirmarNameUpdate : function (component, event, helper) {

		var strApellidoPaterno = component.get("v.strApellidoPaterno");
		var strApellidoMaterno = component.get("v.strApellidoMaterno");
		var strNombres = component.get("v.strNombres");

		if( helper.validarCampo(component, strApellidoPaterno) ) {
			return;
		}else if( helper.validarCampo(component, strApellidoMaterno) ) {
			return;
		}else if( helper.validarCampo(component, strNombres) ) {
			return;
		} else {
			component.set("v.noPasoNameUpdate", 2);
		}		
	},

	guardarNameUpdate : function (component, event, helper) {

		component.set("v.noPasoNameUpdate", 3);
		component.set("v.loadingNameUpdate", true);

		helper.actualizarNombre(component);
	},

	closeModalNameUpdate : function(component, event, helper) {

		helper.limpiarVaribles(component);

        component.set("v.openNameUpdate", false);
	},

	handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {
			component.set("v.enableOTPModal", false);
		}
	},

	regresarModalNameUpdate : function(component, event, helper) {

        component.set("v.noPasoNameUpdate", 1);
    },

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            component.set("v.openNameUpdate", true);
			component.set("v.noPasoNameUpdate", 1);
		}
	}

})