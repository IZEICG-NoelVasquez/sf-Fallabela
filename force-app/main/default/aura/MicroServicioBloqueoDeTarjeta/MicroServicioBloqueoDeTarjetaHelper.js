({
	showToast : function(title, message, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

	setModalState : function(component, state) {
        
        var otpModalCardLock = component.find("otpModalCardLock");
        otpModalCardLock.setState(state);
        
    },

	openModal : function(component) {

		component.set("v.blnOpenModalMSCardLock", true);

		var now = new Date();
		var currentHour = $A.localizationService.formatDate(now, "HH:mm");
		component.set("v.currentHour", currentHour);

		component.set("v.cardLockValue", null);
		component.set("v.cardReplacementValue", null);
		component.set("v.incidenceValue", null);
		component.set("v.cardlockInfoLoaded", false);
		this.getCardLockValues(component);
	},

	getCardLockValues : function(component) {

		var selectedAccount = component.get("v.selectedAccount");
        var accountId = selectedAccount.Id;

		var action = component.get("c.getCardLockValues");

		action.setParams({
            "accountId" : accountId
        })
		
		action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state getCardLockValues: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result getCardLockValues', result);

                if (result.success) { 

					var lstCMCardLock = result.lstCMCardLock;

					var cardLockOptions = [];

					if( lstCMCardLock ) {

						var mapCardLockInfo = {};

						cardLockOptions.push({label:'- Ninguno', value:''});

						for(var i = 0; i < lstCMCardLock.length ; i ++ ) {

							mapCardLockInfo[lstCMCardLock[i].MasterLabel] = lstCMCardLock[i];
							cardLockOptions.push({
													label:lstCMCardLock[i].MasterLabel + ' - ' + lstCMCardLock[i].Etiqueta_en_SF__c, 
													value:lstCMCardLock[i].MasterLabel
												});
						}						

						///
						component.set("v.mapCardLockInfo", mapCardLockInfo);
						component.set("v.cardLockOptions", cardLockOptions);
						component.set("v.cardlockInfoLoaded", true);
						component.set("v.disabledCardLockButton", false);
					}

					/// Vencimiento de Tarjetas
					if( result.successCardsInfo ) {

						var mapCardsInfo = {};

						mapCardsInfo = result.mapCards;

						component.set("v.mapCardsInfo", mapCardsInfo);						
					}
					

                } else {
                    
					component.set("v.cardlockInfoLoaded", true);
					this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                }

            } else {
                
				component.set("v.cardlockInfoLoaded", true);
				this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }
        });

        $A.enqueueAction(action);	
	},
	
	cardLock : function(component, attempt) {

		var mapRequestFields = {};

		/// Primer Intento 'I', Segundo Intento '1'
		if( attempt === 1 ) {

			mapRequestFields = this.setRequestFields(component, mapRequestFields, 'I');

		} else if( attempt === 2 ) {

			mapRequestFields = this.setRequestFields(component, mapRequestFields, '1');

		} else {

			component.set("v.msCardLockLoaded", true);
			component.set("v.msCardLockSuccess", false);
			return;
		}

		///
		var caseRecordCardLock = component.get("v.caseRecordCardLock");

		var action = component.get("c.cardLock");
        action.setParams({
            "mapRequestFields" : mapRequestFields
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state cardLock: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result cardLock', result);

                if( result.success && result.cardLockJSON && result.cardLockJSON.message && result.cardLockJSON.message.estadoOperacion && result.cardLockJSON.message.estadoOperacion.glosaOperacion
					&& result.cardLockJSON.message.estadoOperacion.glosaOperacion == '[AZ7] OPERACIÓN REALIZADA CON ÉXITO' ) {

					component.set("v.msCardLockLoaded", true);
					component.set("v.msCardLockSuccess", true);

					//
					console.log('EXITO INTENTO:  ', attempt);

					/// 
					if( caseRecordCardLock ) {

						this.updateCase(component);

					} else {

						this.createCase(component);
					}
					component.set("v.creatingCase", true);

				} else {

					console.log('ERROR INTENTO: ', attempt);

					/// Se valida el numero de Intentos
					if( attempt < 2 ) {

						this.cardLock(component, attempt + 1);

					} else {

						if( result.cardLockJSON && (result.cardLockJSON.message === '[AZ7][COD:02]ERROR: LA OPERACIÓN NO SE PUDO REALIZAR') ) {

							component.set("v.messageErrorMS", "Es posible que la Tarjeta se encuentre bloqueada, favor de validar en SAT, de no ser así, reportar al Administrador.");
						}

						component.set("v.msCardLockLoaded", true);
						component.set("v.msCardLockSuccess", false);
					}					
				}

            } else {
                
				component.set("v.msCardLockLoaded", true);
				component.set("v.msCardLockSuccess", false);
            }
        });

        $A.enqueueAction(action);
	}, 

	setRequestFields : function(component, mapRequestFields, tipoDocumento) {

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		/// plastico
		mapRequestFields["tipoPlastico"] = 'credito';
		mapRequestFields["identificadorProducto"] = component.get("v.identificadorProducto");
		/// cuentaTarjetaCredito
		mapRequestFields["identificador"] = component.get("v.identificador");
		/// informacionContactoRequirente
		mapRequestFields["numeroDocumento"] = component.get("v.numeroDocumento");
		mapRequestFields["tipoDocumento"] = tipoDocumento;
		/// motivoRequerimiento 
		mapRequestFields["descripcionMotivoReq"] = mapCardLockInfo[cardLockValue].Descripcion__c;
		mapRequestFields["codigoMotivoReq"] = cardLockValue;
		/// tipoRequerimiento
		mapRequestFields["descripcionTipoReq"] = 'BLOQUEO';
		mapRequestFields["codigoTipoReq"] = '001';

		return mapRequestFields;
	},

	createCase : function(component) {

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");

		/// Variables para la Creacion del Caso 
        var catSubSelected = mapCardLockInfo[cardLockValue].SubCategoria__c;
		component.set("v.catSubSelected", catSubSelected);
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = mapCardLockInfo[cardLockValue].Categoria__c;
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var numeroDeTarjetaValue = component.get("v.identificadorProducto");

		var action = component.get("c.createCaseOpenByRT");
		action.setParams({

			"recordTypeId": recordType,
			"customerId": selectedAccountID,
			"personId" : selectedPerson,
			"category" : category,
			"altoRiesgo" : esAltoRiesgo,
			"metodoContactoValue": metodoContactoValue,
			"numeroDeTarjetaValue": numeroDeTarjetaValue
		});

		action.setCallback(this, function(response) {

            var state = response.getState(); 
			if (state === "SUCCESS") {
			
				var result = response.getReturnValue();
				if (result.success) {

					console.log("result createCase:  ", result );
					component.set("v.newCaseFolio", result.caseNumber );
					component.set("v.newCaseId", result.caseId );

					component.set("v.creatingCase", false);
					component.set("v.successfulCase", true);

				} else {

					component.set("v.creatingCase", false);
					component.set("v.successfulCase", false);
				}

			} else {

				component.set("v.creatingCase", false);
				component.set("v.successfulCase", false);
			}

		});

		$A.enqueueAction(action);
	},

	updateCase : function(component) {

		var cardLockValue = component.get("v.cardLockValue");
		var mapCardLockInfo = component.get("v.mapCardLockInfo");

		if( mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r && mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r.length > 0 ) {

			///
			var mapFields = {};

			for(var i = 0; i < mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r.length; i++ ) {

				mapFields[ mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r[i].Nombre_de_API__c ] = this.changeStringToBoolean(mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r[i].Valor_del_Campo__c);
			}

			var caseId = component.get("v.newCaseId");

			var action = component.get("c.updateCaseByRT");

			action.setParams({
				"caseId": caseId,
				"mapFields": mapFields
			});

			action.setCallback(this, function(response) {

				var state = response.getState(); 

				if (state === "SUCCESS") {
				
					var result = response.getReturnValue();
	
					console.log("result updateCaseByRT:  ", result );
	
					if (result.success) {
	
						component.set("v.cardLocked", true);
						component.set("v.successfulCase", true);
	
					} else {
	
						component.set("v.successfulCase", false);
					}
	
				} else {
	
					component.set("v.successfulCase", false);
				}
	
				component.set("v.creatingCase", false);
			});
	
			$A.enqueueAction(action);
		}
	},

	closeCase : function(component) {

		component.set("v.modalTitle", 'Informe de Folio');
		component.set("v.closingCase", true);
		component.set("v.successfulCloseCase", false);
		component.set("v.stepNumberMSCardLock", 8);
		

		var mapCardLockInfo = component.get("v.mapCardLockInfo");
		var cardLockValue = component.get("v.cardLockValue");
		var newCaseId = component.get("v.newCaseId");

		var cardReplacementValue = component.get("v.cardReplacementValue");
		var incidenceValue = component.get("v.incidenceValue");

		// Campos requeridos para cerrar el Caso
		var mapRequiredFields = {};

		mapRequiredFields['Medio_de_entrega_tarjeta__c'] = cardReplacementValue;

		if( cardReplacementValue == 'Domicilio' ) {

			mapRequiredFields['La_cuenta_presenta_incidencia__c'] = incidenceValue;
		}

		if( mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r && mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r.length > 0 ) {

			for(var i = 0; i < mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r.length; i++ ) {

				mapRequiredFields[ mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r[i].Nombre_de_API__c ] = this.changeStringToBoolean(mapCardLockInfo[cardLockValue].Bloqueo_de_Tarjeta_Campos_Requeridos__r[i].Valor_del_Campo__c);
			}
		}

		console.log('mapRequiredFields:  ', JSON.stringify(mapRequiredFields));

		var action = component.get("c.closeCaseByRT");
		action.setParams({
			"newCaseId": newCaseId,
			"mapRequiredFields": mapRequiredFields
		});

		action.setCallback(this, function(response) {

            var state = response.getState(); 
			if (state === "SUCCESS") {
			
				var result = response.getReturnValue();

				console.log("result closeCaseByRT:  ", result );

				if (result.success) {

					component.set("v.closingCase", false);
					component.set("v.successfulCloseCase", true);

				} else {

					component.set("v.closingCase", false);
					component.set("v.successfulCloseCase", false);
				}

			} else {

				component.set("v.closingCase", false);
				component.set("v.successfulCloseCase", false);
			}

		});

		$A.enqueueAction(action);

	},

	changeStringToBoolean : function(field) {

		if( field === 'true' ) {

			field = true;

		} else if( field === 'false' ) {

			field = false;

		}

		return field;
	},

	getDifferenceOfMonths : function(expiration) {

		var expirationYear =  parseInt( expiration.substring(0,4) );
		var expirationMonth =  parseInt( expiration.substring(4,6) );

		//// <------------------------------------- PRUEBAS UAT ------------------------------------------------------------------------------------
		console.log('expirationYear:  ', expirationYear);
		console.log('expirationMonth:  ', expirationMonth);

		var now = new Date();
		var currentYear = parseInt( $A.localizationService.formatDate(now, "YYYY") );
		var currentMonth = parseInt( $A.localizationService.formatDate(now, "MM") );

		//// <------------------------------------- PRUEBAS UAT ------------------------------------------------------------------------------------
		console.log('currentYear:  ', currentYear);
		console.log('currentMonth:  ', currentMonth);

		var differenceOfMonths = expirationMonth + ( 12 * (expirationYear - currentYear) ) - currentMonth;

		console.log('differenceMonths:  ', differenceOfMonths);

		return differenceOfMonths;
	}
})