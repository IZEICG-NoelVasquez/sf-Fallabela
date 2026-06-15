({
	loadCatOptions : function(component) {

		var action = component.get("c.getCategories");
        var isCommunity = component.get("v.isCommunity");
        var esClienteAnonimo = component.get("v.esClienteAnonimo");
        var esSoriban = component.get("v.selectedAccount").Campa_a_Actualizaci_n_SORIBAN__c;
        var authSinCel = component.get("v.selectedAccount").Autenticar_Sin_Celular__c;
        var parentezco = component.get("v.selectedAccount").PT__pc;
		var isMovimiento = component.get("v.isMovimiento");
		/// Plan de Pagos
		var blnPlanDePagos = component.get("v.blnPlanDePagos");
		/// Liberar Saldo Retenido
		var blnSoloMovsNoFacturados = component.get("v.blnSoloMovsNoFacturados");
		/// MS Movimientos Creacion de Casos sin Seleccionar Movimientos
		var casoSinSeleccionarMovimientos = component.get("v.casoSinSeleccionarMovimientos");
        
        console.log("esSoriban", esSoriban);
        console.log("authSinCel", authSinCel);
        
        action.setParams({
            "isCommunity" : isCommunity,
            "esClienteAnonimo" : esClienteAnonimo,
            "esSoriban" : esSoriban,
            "authSinCel" : authSinCel,
            "parentezco" : parentezco,
			"isMovimiento" : isMovimiento,
			"casoSinSeleccionarMovimientos" : casoSinSeleccionarMovimientos
		});
        
		action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {

				var catOptions = response.getReturnValue();
				var catOptionsTmp = [];
				if( blnPlanDePagos ) {

					for(var i=0; i < catOptions.length; i++) {
						if( (catOptions[i].label == '-- None --') || (catOptions[i].label == 'Promociones') ) {

							catOptionsTmp.push(catOptions[i]);
						}
					}
					component.set("v.catOptions", catOptionsTmp);
				} else if( blnSoloMovsNoFacturados ) {

					for(var i=0; i < catOptions.length; i++) {
						if( (catOptions[i].label == '-- None --') || (catOptions[i].label == 'Liberar Saldo') || (catOptions[i].label == 'Promociones') ) {

							catOptionsTmp.push(catOptions[i]);
						}
					}
					component.set("v.catOptions", catOptionsTmp);
				} else {
				
					component.set("v.catOptions", response.getReturnValue());
				}
			}

			component.set("v.categoriasLoaded", true);

		});

		$A.enqueueAction(action);        

	},

	loadSubOptions : function(component, category) {

		var action = component.get("c.getCategoriesSubCategories");
        
        var isCommunity = component.get("v.isCommunity");
        var esClienteAnonimo = component.get("v.esClienteAnonimo");
        var esSoriban = component.get("v.selectedAccount").Campa_a_Actualizaci_n_SORIBAN__c;
        var authSinCel = component.get("v.selectedAccount").Autenticar_Sin_Celular__c;
		var parentezco = component.get("v.selectedAccount").PT__pc;
		/// Ajuste para Filtrar Sub Categorias con Movimientos Seleccionados
		var isMovimiento = component.get("v.isMovimiento");
		/// Plan de Pagos
		var blnPlanDePagos = component.get("v.blnPlanDePagos");
		/// Liberar Saldo Retenido
		var blnSoloMovsNoFacturados = component.get("v.blnSoloMovsNoFacturados");
		/// MS Movimientos Creacion de Casos sin Seleccionar Movimientos
		var casoSinSeleccionarMovimientos = component.get("v.casoSinSeleccionarMovimientos");
        
		action.setParams({
			"category": category,
            "isCommunity" : isCommunity,
            "esClienteAnonimo" : esClienteAnonimo,
            "esSoriban" : esSoriban,
            "authSinCel" : authSinCel,
			"parentezco" : parentezco,
			"isMovimiento" : isMovimiento,
			"casoSinSeleccionarMovimientos" : casoSinSeleccionarMovimientos
            
		});

		action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {
				
				var subCatOptions = response.getReturnValue();
				var subCatOptionsAll = subCatOptions.options;
				var subCatOptionsTmp = [];
				if( blnPlanDePagos ) {

					for(var i=0; i < subCatOptionsAll.length; i++) {
						if( (subCatOptionsAll[i].label == '-- None --') || (subCatOptionsAll[i].label == 'Plan de Pagos') ) {

							subCatOptionsTmp.push(subCatOptionsAll[i]);
						}
					}
					component.set("v.subCatOptions", subCatOptionsTmp);
				} else if( blnSoloMovsNoFacturados ) {

					for(var i=0; i < subCatOptionsAll.length; i++) {
						if( (subCatOptionsAll[i].label == '-- None --') || (subCatOptionsAll[i].label == 'Liberar saldo retenido') || (subCatOptionsAll[i].label == 'Plan de Pagos') ) {

							subCatOptionsTmp.push(subCatOptionsAll[i]);
						}
					}
					component.set("v.subCatOptions", subCatOptionsTmp);
				} else {
				
					component.set("v.subCatOptions", subCatOptions.options);
				}                
				component.set("v.altoRiesgo", subCatOptions.altoRiesgo);
				component.set("v.medioAltoRiesgo", subCatOptions.medioAltoRiesgo);
				component.set("v.disableSub", (subCatOptions ? false : true));

			}

			///
			component.set("v.subCategoriasLoaded", true);

		});

		$A.enqueueAction(action);

	},

	loadMainFields : function (component) {

		var account = component.get("v.selectedAccount");
        if (account) {
            var fields = [];
            var rfc = { "label" : "Oficina", "value": account.Oficina__c};
            var fechaNacimiento = { "label" : "Contrato", "value": account.N_m_contrato__c };
            var curp = {"label" : "BIN", "value" : account.BIN__c };
            var idCliente = {"label" : "Correo", "value": account.PersonEmail};
            var email = {"label": "Celular", "value": account.PersonMobilePhone};
            var mobile = {"label": "CURP", "value": account.CURP__c};
    
            fields.push(rfc);
            fields.push(fechaNacimiento);
            fields.push(curp);
            fields.push(idCliente);
            fields.push(email);
            fields.push(mobile);
    
            component.set("v.mainFields", fields);
        }
		

	},
    /******************************************************************************************
    Método para crear el Caso, después de que si se validaron las preguntas
    *******************************************************************************************/
   createCaseValidate : function (component, esRetipificacion){
		var action = component.get("c.createCaseByRT");
		var selectedAccount = component.get("v.selectedAccount");
		var selectedAccountID = selectedAccount.Id;
	    var selectedPerson = selectedAccount.PersonContactId;
		var catSubSelected = component.get("v.subCatSelected");
		var caseRTypes = component.get("v.caseRTypes");
		var category = component.find("categoria").get("v.value");
		var verificadoOTP = component.get("v.verificadoOTP");
		var isCommunity = component.get("v.isCommunity");
		var esClienteAnonimo = component.get("v.esClienteAnonimo");
		var clienteAnonimo = component.get("v.clienteAnonimo");
		var metodoContactoValue = component.get("v.contactMethodValue");
		var numeroDeTarjetaValue = component.get("v.numeroDeTarjetaValue");	
		var movimientosList = component.get("v.movimientosList");     
		var caseRecordId = component.get("v.recordId");
		
		var rType = caseRTypes[catSubSelected];
		var altoRiesgo = component.get("v.altoRiesgo");
		var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);

		action.setParams({

			"recordTypeId": rType,
			"customerId": selectedAccountID,
			"personId" : selectedPerson,
			"category" : category,
			"altoRiesgo" : esAltoRiesgo,
			"esClienteAnonimo" : esClienteAnonimo,
			"clienteAnonimo" : clienteAnonimo,
			"esRetipificacion" : esRetipificacion,
			"caseRecordId" : caseRecordId,
			"metodoContactoValue": metodoContactoValue,
			"numeroDeTarjetaValue": numeroDeTarjetaValue,
			"movimientosList" : movimientosList
		});

		action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {

				if (isCommunity) {

					this.fireStepChange(component, 4);
					this.fireRecordIdSelected( component, response.getReturnValue(), selectedAccount);

				} else {

					this.navigateToSObject(response.getReturnValue());
					this.fireStepChange(component, 1);

				}
				
				

			}

		});

		$A.enqueueAction(action);

	},
 	/******************************************************************************************
	Método para crear Caso
	Si es alto riesgo, manda el componente de validar código OTP
	Si es medio alto riesgo, manda el componente validateQuestions
	*******************************************************************************************/
	doCreateCase : function (component, esRetipificacion) {

		var action = component.get("c.createCaseByRT");
		var selectedAccount = component.get("v.selectedAccount");
		var selectedAccountID = selectedAccount.Id;
		var toNumber = selectedAccount.PersonMobilePhone;
       	var selectedPerson = selectedAccount.PersonContactId;
		var catSubSelected = component.get("v.subCatSelected");
		var caseRTypes = component.get("v.caseRTypes");
		var category = component.find("categoria").get("v.value");
        var verificadoOTP = component.get("v.verificadoOTP");
        var isCommunity = component.get("v.isCommunity");
        var esClienteAnonimo = component.get("v.esClienteAnonimo");
        var clienteAnonimo = component.get("v.clienteAnonimo");
        var metodoContactoValue = component.get("v.contactMethodValue");
        var numeroDeTarjetaValue = component.get("v.numeroDeTarjetaValue");
        var movimientosList = component.get("v.movimientosList");
        
        
        var caseRecordId = component.get("v.recordId");
        
        console.log("catSubSelected", catSubSelected);
        console.log("doCreateCase esClienteAnonimo", esClienteAnonimo);
        console.log("doCreateCase clienteAnonimo", clienteAnonimo);
        
		var rType = caseRTypes[catSubSelected];
		var altoRiesgo = component.get("v.altoRiesgo");
		var medioAltoRiesgo = component.get("v.medioAltoRiesgo");
		var esMedioAltoRiesgo = (medioAltoRiesgo.indexOf(catSubSelected) > -1);
		var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);

		///
		var blnPlanDePagos = component.get("v.blnPlanDePagos");
		var casoConMovimientos = component.get("v.casoConMovimientos");
		/// Liberar Saldo Retenido
		var blnSoloMovsNoFacturados = component.get("v.blnSoloMovsNoFacturados");
		
		if (!category) {
			this.showToast("Campo Requerido", "Favor de seleccionar Categoria", "error");
			return;
		}
		if (!rType) {
			this.showToast("Campo Requerido", "Favor de seleccionar Sub Categoria", "error");
			return;
		}
		
        if (esAltoRiesgo && !verificadoOTP) {
            this.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            this.setModalState(component, "open");
            return;
		}
		if (esMedioAltoRiesgo) {
            this.showToast("Accion Requerida Validar Preguntas", "Se requiere validacion adicional", "warning");
			this.setModalMedioAltoState(component, "open");
			var action2 = component.get("c.sendSMSmedioAltoRiesgo");
			var message = 'Se le informa intento de actualización de su celular en FALABELLA SORIANA. 018007674262.';
			action2.setParams({
				"selectedAccount": selectedAccount
			});
	
			action2.setCallback(this, function(response) {
	
				if (response.getState() === "SUCCESS") {			
					console.log('success send');
					console.log('success response',response);
				} 
	
			});
	
			$A.enqueueAction(action2);
            return;
		}
		/// Plan de Pagos
		/*if( casoConMovimientos && (catSubSelected == 'Plan de Pagos') && !blnPlanDePagos ) {

			this.showToast("Plan de Pagos", "Para la subcategoria seleccionada se requiere marcar la casilla Plan de Pagos", "warning");
			return;
		}*/
		if( casoConMovimientos && (catSubSelected != 'Plan de Pagos') && blnPlanDePagos ) {

			this.showToast("Plan de Pagos", "Al marcar la casilla Plan de Pagos solo se puede seleccionar esta subcategoría", "warning");
			return;
		}
		/// Liberar Saldo Retenido
		if( casoConMovimientos && (catSubSelected == 'Liberar saldo retenido') && !blnSoloMovsNoFacturados ) {

			this.showToast("Liberar Saldo Retenido", "Para la subcategoria seleccionada se requieren marcar movimientos No Autorizados", "warning");
			return;
		}

		///
		component.set("v.creandoCaso", true);

		action.setParams({

			"recordTypeId": rType,
			"customerId": selectedAccountID,
            "personId" : selectedPerson,
            "category" : category,
            "altoRiesgo" : esAltoRiesgo,
            "esClienteAnonimo" : esClienteAnonimo,
            "clienteAnonimo" : clienteAnonimo,
            "esRetipificacion" : esRetipificacion,
            "caseRecordId" : caseRecordId,
            "metodoContactoValue": metodoContactoValue,
            "numeroDeTarjetaValue": numeroDeTarjetaValue,
            "movimientosList" : movimientosList
		});

		action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {

				component.set("v.creandoCaso", false);
				if (isCommunity) {

					this.fireStepChange(component, 4);
					this.fireRecordIdSelected( component, response.getReturnValue(), selectedAccount);

				} else {

					this.navigateToSObject(response.getReturnValue());
					this.fireStepChange(component, 1);

				}				

			} else {

				var errors = action.getError();

				if( errors && errors[0] && errors[0].message ) {

					this.showToast("Ha ocurrido un error", errors[0].message, "error");

				} else {
				
					this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
				}
				console.log("response:  ", response );
				component.set("v.creandoCaso", false);				
			}

		});

		$A.enqueueAction(action);

	},
    
    setModalState : function (component, state) {
        
        var cmpModal = component.find("otp-modal");
        cmpModal.setState(state);
        
    },
    
    setModalMode : function (component, mode) {
        
        var cmpModal = component.find("otp-modal");
        cmpModal.setMode(mode);
        
    },
    setModalMedioAltoState : function (component, state) {
        
        var componentModal = component.find("medioAlto-modal");
        componentModal.setState(state);
    },
    setModalPhone : function (component, phone) {
        
        var cmpModal = component.find("otp-modal");
        cmpModal.setPhone(phone);
        
    },

	navigateToSObject : function (recordId) {
	
		var navEvt = $A.get("e.force:navigateToSObject");

	    navEvt.setParams({
	      "recordId": recordId
	    });

	    navEvt.fire();

	},

	fireStepChange : function (component, step) {

		var stepChangeEvent = component.getEvent("stepChange");
        
        stepChangeEvent.setParams({
            "step" : step
        });

        stepChangeEvent.fire();

	},

	fireRecordIdSelected : function (component, recordId, selectedAccount) {

		var recordIdEvent = $A.get("e.c:recordIdSelected");
        
        recordIdEvent.setParams({
            "recordId" : recordId,
            "selectedAccount" : selectedAccount
        });

        recordIdEvent.fire();

	},

	loadCaseRTypes : function (component) {

		var action = component.get("c.getCaseRecordTypesByName");

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state === "SUCCESS") {

				component.set("v.caseRTypes", response.getReturnValue());

			}

		});

		$A.enqueueAction(action);

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
    
    updateCase : function(component, validatedRecordId, isValid) {
		
        var action = component.get("c.actualizarNuevoCelular");
        
        action.setParams({
            "validatedRecordId": validatedRecordId,
            "isValid" : isValid
        });
        
        action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {
				
				console.log("actualizacion exitosa");

			}

		});

		$A.enqueueAction(action); 
	    
	},
	updateCasePAN : function(component, validatedRecordId, isValid) {
		
        var action = component.get("c.actualizarPANCelular");
        
        action.setParams({
            "validatedRecordId": validatedRecordId,
            "isValid" : isValid
        });
        
        action.setCallback(this, function(response) {

			if (response.getState() === "SUCCESS") {
				
				console.log("actualizacion exitosa");

			}

		});

		$A.enqueueAction(action); 
	    
	}

})