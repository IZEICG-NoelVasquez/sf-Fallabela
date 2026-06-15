({
	loadConfig : function(component, event, helper) {

		///
        component.set("v.enableOTPModal", true);

        // OTP  
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioBloqueoDeTarjeta && mapValidacionesOTP.MicroServicioBloqueoDeTarjeta.otp ) {

            if( mapValidacionesOTP.MicroServicioBloqueoDeTarjeta.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioBloqueoDeTarjeta.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioBloqueoDeTarjeta.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioBloqueoDeTarjeta.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP Card Lock:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP Card Lock:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;

        } else {

            ///
			component.set("v.blnOpenModalContactMethod", true);
        }

	},

	handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
        component.set("v.verificadoOTP", isValid);

        /// Validaciones OTP Dinamicas
        if( isValid ) {

            component.set("v.verificadoOTPGlobal", true);

            ///
            component.set("v.blnOpenModalContactMethod", true);
        }
    },

	handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {

			component.set("v.enableOTPModal", false);
			component.set("v.blnOpenModalMSCardLock", false);
		}
	},

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.openModal(component);

		} else {

			component.set("v.blnOpenModalMSCardLock", false);
		}
	},

	closeModalMSCardLock : function(component, event, helper) {
		
		component.set("v.blnOpenModalMSCardLock", false);
	},

	changeCardLock : function(component, event, helper) {

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		if( cardLockValue && mapCardLockInfo[cardLockValue] && mapCardLockInfo[cardLockValue].Etiqueta_en_SF__c &&
			(mapCardLockInfo[cardLockValue].Etiqueta_en_SF__c == 'Bloqueo por vencimiento')) {

			/// Validacion de dias de Vencimiento
			var identificadorProducto = component.get("v.identificadorProducto");
			var mapCardsInfo = component.get("v.mapCardsInfo");

			/// Se valida que el Metadata tenga un valor en la Sub Categoria seleccionada
			/// Que la tarjeta devuelta por el MS exista en el objeto Tarjeta__c
			/// Y que tenga un valor en el campo feccadtar__c
			if( mapCardLockInfo[cardLockValue].X_meses_antes_de_vencimiento__c &&
				identificadorProducto && mapCardsInfo && mapCardsInfo[identificadorProducto] ) {

				var expiration = mapCardsInfo[identificadorProducto];

				if( expiration.length == 6 ) {

					var differenceOfMonths = helper.getDifferenceOfMonths(expiration);

					//// <------------------------------------- PRUEBAS UAT ------------------------------------------------------------------------------------
					console.log('mapCardLockInfo[cardLockValue].X_meses_antes_de_vencimiento__c:  ', mapCardLockInfo[cardLockValue].X_meses_antes_de_vencimiento__c);

					if( differenceOfMonths > mapCardLockInfo[cardLockValue].X_meses_antes_de_vencimiento__c ) {

						component.set("v.disabledCardLockButton", true);
						helper.showToast("", "No es posible realizar el bloqueo ya que se encuentra dentro de vigencia.", "warning");
					}
				}
			}
			
		} else {

			component.set("v.disabledCardLockButton", false);
		}
	},

	selectCardLock : function(component, event, helper) {

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		if( cardLockValue && mapCardLockInfo[cardLockValue] && mapCardLockInfo[cardLockValue].Etiqueta_en_SF__c ) {
			
			component.set("v.cardLockDescriptionSelected", cardLockValue + ' - ' + mapCardLockInfo[cardLockValue].Etiqueta_en_SF__c);
			component.set("v.stepNumberMSCardLock", 2);
			
		} else {

			helper.showToast("", "Por favor seleccione un tipo de bloqueo", "warning");
		}
		
	},

	confirmCardLock : function(component, event, helper) {

		component.set("v.msCardLockLoaded", false);
		component.set("v.msCardLockSuccess", false);
		component.set("v.stepNumberMSCardLock", 3);

		component.set("v.modalTitle", 'Informe de Folio');

		helper.cardLock(component, 1);
	},

	backCardLock : function(component, event, helper) {

		component.set("v.stepNumberMSCardLock", 1);
	},

	continueCardReplacement : function(component, event, helper) {

		var cardReplacementOptions = [];		
		var cardReplacementList = component.get("v.cardReplacementList");

		cardReplacementOptions.push({label:'- Ninguno', value:''});

		for(var i = 0; i < cardReplacementList.length; i ++ ) {

			cardReplacementOptions.push({
									label:cardReplacementList[i], 
									value:cardReplacementList[i]
								});
		}

		component.set("v.cardReplacementOptions", cardReplacementOptions);

		component.set("v.modalTitle", 'Reposición de Tarjeta');
		component.set("v.stepNumberMSCardLock", 4);

	},

	selectCardReplacement : function(component, event, helper) {

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		var cardReplacementValue = component.get("v.cardReplacementValue");

		if( cardReplacementValue == 'Domicilio' ) {

			component.set("v.modalTitle", 'Reposición a Domicilio');
			component.set("v.stepNumberMSCardLock", 5);

		} else if(cardReplacementValue == 'Sucursal') {

			if( mapCardLockInfo[cardLockValue].SubCategoria__c === 'Reporte por Deterioro' ) {

				helper.closeCase(component);

			} else {

				component.set("v.modalTitle", 'Validación de Movimientos');
				component.set("v.stepNumberMSCardLock", 7);
			}			

		} else {

			helper.showToast("", "Por favor seleccione un tipo medio de entrega", "warning");
		}
	},

	continueHomeReplacement : function(component, event, helper) {

		var incidenceOptions = [];		
		var incidenceList = component.get("v.incidenceList");

		incidenceOptions.push({label:'- Ninguno', value:''});

		for(var i = 0; i < incidenceList.length; i ++ ) {

			incidenceOptions.push({
									label:incidenceList[i], 
									value:incidenceList[i]
								});
		}

		component.set("v.incidenceOptions", incidenceOptions);

		component.set("v.modalTitle", '¿La cuenta presenta alguna incidencia para la reposición en SAT?');
		component.set("v.stepNumberMSCardLock", 6);
	},

	selectIncidenceOnTheAccount : function(component, event, helper) {
		
		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		var incidenceValue = component.get("v.incidenceValue");

		if( incidenceValue ) {

			if( mapCardLockInfo[cardLockValue].SubCategoria__c === 'Reporte por Deterioro' ) {

				helper.closeCase(component);

			} else {

				component.set("v.modalTitle", 'Validación de Movimientos');
				component.set("v.stepNumberMSCardLock", 7);
			}			

		} else {

			helper.showToast("", "Por favor seleccione un valor", "warning");
		}

	},

	closeCase : function(component, event, helper) {		

		helper.closeCase(component);
	}	
})