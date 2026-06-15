({
	handleModalMobileUpdate : function (component, event, helper) {

		var validateQuestions = component.get("v.validateQuestions");

		/// Validacion de Preguntas y OTP Dinamicas
		var mapValidacionesOTP = component.get("v.mapValidacionesOTP");
		
		if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizacionCelularPreg && mapValidacionesOTP.MicroServicioActualizacionCelularPreg.validacionDePreguntas ) {

            if( mapValidacionesOTP.MicroServicioActualizacionCelularPreg.validacionDePreguntas == 'Siempre' ) {

                validateQuestions = false;

            } else if( mapValidacionesOTP.MicroServicioActualizacionCelularPreg.validacionDePreguntas == 'Sin validacion' ) {

                validateQuestions = true;

            }
		}

		var selectedtarjeta = component.get("v.numeroDeTarjetaValueProducto");
		if(selectedtarjeta == null){
			helper.showToast("Debe Seleccionar una tarjeta", "Es necesario seleccionar una tarjeta de crédito para actualizar el Celular" ,"info");			
		}		
		else {

			if( !validateQuestions ) {

				helper.showToast("Accion Requerida Validar Preguntas", "Se requiere validacion adicional", "warning");		
				var componentModal = component.find("medioAlto-modal");
				/// Se limpian valores al abrir el componente
				componentModal.set("v.DiaDeCorte", null);
				componentModal.set("v.UltimoPago", "-");
				componentModal.set("v.DiaUltimoPago", null);
				componentModal.set("v.CompraDiferida", "-");
				componentModal.set("v.tieneCasosAbiertos", "-");

				componentModal.setState("open");
				helper.envioSMS(component);
			}
			else {
				component.set("v.openMobileUpdate", true);
				component.set("v.noPasoMobileUpdate", 1);
			}
		}
	},
	/******************************************************************************************
    Método que maneja el Evento que se ejecuta desde el componente validateQuestions
    Si hay coincidencia abre el modal y continua el proceso
    *******************************************************************************************/
	handlevalidateQuestionsE : function(component, event, helper){
	var coincidencia1 = event.getParam("coincidencia");
		if(coincidencia1 == true){
			component.set("v.validateQuestions",true);
			component.set("v.openMobileUpdate", true);
			component.set("v.noPasoMobileUpdate", 1);
		}
	},
	confirmarMobileUpdate : function(component, event, helper) {

		var celular = component.find("mobileUpdateId").get("v.value");
		console.log("celular:  ", celular);

		helper.validarCelular(component, celular);
	}, 

	limpiarCelular : function(component, event, helper) {

		var caracter = event.which;
		console.log("caracter:  ", caracter);

		var listCaracteresPermitidos = component.get("v.listCaracteresPermitidos");

		if( !listCaracteresPermitidos.includes(caracter) ) {

			event.preventDefault();
		}
	},

	borrarCampo : function(component, event, helper) {
		console.log("borrarCampo ");

		event.preventDefault();
	},

	guardarMobileUpdate : function(component, event, helper) {

		// OTP
		var verificadoOTP = component.get("v.verificadoOTP");

		var esAltoRiesgo;

		/// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

		if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizacionCelular && mapValidacionesOTP.MicroServicioActualizacionCelular.otp ) {

			if( mapValidacionesOTP.MicroServicioActualizacionCelular.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizacionCelular.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

			} else if( mapValidacionesOTP.MicroServicioActualizacionCelular.otp == 'Global' ) {

				esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

			} else if( mapValidacionesOTP.MicroServicioActualizacionCelular.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

			}
			
		}
		
		console.log("esAltoRiesgo Celular OTP:  ", esAltoRiesgo);
        console.log("verificadoOTP Celular OTP:  ", verificadoOTP);
		
		if (esAltoRiesgo && !verificadoOTP) {

			component.set("v.blnUpdateMobile", true);
			///
			component.set("v.classBackdrop", "slds-backdrop slds-backdrop_open");

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
			helper.setModalState(component, "open");
					
			///
			var strMobilelUpdate = component.get("v.strMobilelUpdate");
			var mobilePhoneUpdate = strMobilelUpdate.slice(strMobilelUpdate.length-4, strMobilelUpdate.length);
			var otpModalMobileUpdate = component.find("otpModalMobileUpdate");
			otpModalMobileUpdate.set("v.blnUpdateMobile", true);
			otpModalMobileUpdate.set("v.mobilePhoneUpdate", strMobilelUpdate);
			otpModalMobileUpdate.set("v.mobilePhoneUpdate4Dig", mobilePhoneUpdate);
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

	closeModalMobileUpdate : function(component, event, helper) {

		helper.limpiarVaribles(component);
		
        component.set("v.openMobileUpdate", false);
	},
	
	handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {
			helper.closeModalOTP(component);
		}
	},

	regresarModalEmailUpdate : function(component, event, helper) {

        component.set("v.noPasoMobileUpdate", 1);
    },

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.openModalMobileUpdate(component);
		}
	}

})