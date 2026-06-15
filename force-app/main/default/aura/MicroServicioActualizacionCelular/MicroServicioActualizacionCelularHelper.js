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
	envioSMS : function(component){
        var selectedAccount = component.get("v.selectedAccount");
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
    },
	validarCelular : function(component, celular) {

		if( celular == null || celular == '' || celular == undefined ) {
			this.showToast("Debe ingresar un Numero Celular", "No se permite el campo Celular vacío" ,"info");			
		} else {
			if( this.validaFormatoCelular(celular) ) {
				if( this.validaCelularAnterior(component, celular) ) {
					this.showToast("El Celular ingresado ya se encuentra en el Sistema", " Por favor revisar el Numero Celular" ,"warning");
				} else {					
					component.set("v.noPasoMobileUpdate", 2);
				}				
			} else {
				this.showToast("Debe ingresar un Numero Celular válido", " Por favor revisar el Numero Celular" ,"info");
			}
		}
	}, 

	validaFormatoCelular : function(celular) {

		var formato = /^[0-9]{10}$/;
		return formato.test(celular);
	},

	validaCelularAnterior : function(component, celular) {

		var phoneCustomerData = component.get("v.phoneCustomerData");
		console.log("phoneCustomerData:  ", phoneCustomerData);
		console.log("celular:  ", celular);

		var blnCelularAnterior = false;
		if( phoneCustomerData && celular ) {
			if( phoneCustomerData == celular ) {
				blnCelularAnterior = true;
			}
			else {
				blnCelularAnterior = false;
			}
		}

		return blnCelularAnterior;
	},

	setModalState : function (component, state) {
        
        var cmpModal = component.find("otpModalMobileUpdate");
        cmpModal.setState(state); 
    },

	actualizarCelular : function(component) {

		console.log("Actualizar Celular Helper");
		var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;

        var mapCamposMicroS = component.get("v.mapCamposMicroS");
        mapCamposMicroS["numeroDocumento"] = numeroDocumento;

		mapCamposMicroS["numeroTelefonoMovil"] = '521' + component.get("v.strMobilelUpdate");
		mapCamposMicroS["movilAccount"] = component.get("v.strMobilelUpdate");

		component.set("v.mapCamposMicroS", mapCamposMicroS);

		var action = component.get("c.actualizarCelular");
        action.setParams({
            "campos" : mapCamposMicroS
		});
		
		action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state mobileUpdate: ", state);
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result mobileUpdate', result);
                if (result.success) { 
                    
                    component.set("v.mobileUpdated", true);
                    component.set("v.loadingMobileUpdate", false);

                    this.crearCasoMobileUpdate(component);
                    component.set("v.creatingCase", true);

                } else {
                    component.set("v.mobileUpdated", false);
                    component.set("v.loadingMobileUpdate", false);
                }

            } else {
                component.set("v.mobileUpdated", false);     
                component.set("v.loadingMobileUpdate", false);
            }
        });

        $A.enqueueAction(action);			
	}, 

	crearCasoMobileUpdate : function(component) {
		console.log("entra al m crearCasoMobileUpdate");
		/// Variables para la Creacion del Caso 'Actualización de Celular'
		var catSubSelected = 'Actualización de Celular'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Actualización de Datos'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
		var numeroDeTarjetaValue = '';

		var strMobilelUpdate = component.get("v.strMobilelUpdate");
		var phoneCustomerData = component.get("v.phoneCustomerData");
		
		// Campos requeridos para cerrar el Caso            
		var camposRequeridos = 'Autenticaci_n_exitosa__c:Sí';
		camposRequeridos += ',';
		camposRequeridos += 'Celular_Nuevo__c:';
		camposRequeridos += strMobilelUpdate;
		camposRequeridos += ',';
		camposRequeridos += 'Actualizac_on_de_Celular_en_SAT__c:true';
		camposRequeridos += ',';
		camposRequeridos += 'Celular_Anterior__c:';
		camposRequeridos += phoneCustomerData;

		var action = component.get("c.createCaseClosedMobile");
		action.setParams({
			"recordTypeId": recordType,
			"customerId": selectedAccountID,
			"personId" : selectedPerson,
			"category" : category,
			"altoRiesgo" : esAltoRiesgo,
			"metodoContactoValue": metodoContactoValue,
			"numeroDeTarjetaValue": numeroDeTarjetaValue,
			"camposRequeridos" : camposRequeridos
		});

		action.setCallback(this, function(response) {

			var state = response.getState(); 
			
			if (state === "SUCCESS") {

				var result = response.getReturnValue();
				if (result.success) {

					console.log("result ", result );
					component.set("v.newCaseMobile", result.folioCaso );
					console.log("v.newCaseMobile:  ", component.get("v.newCaseMobile") );
					/// Se actualiza el registro de Validacion Exitosa
					var idValidacion = component.get("v.idValidacionExitosa");
					//se queda vacio cuando el perfil "Supervisor call center externo" salta las preguntas
					if(idValidacion != ''){
						this.actualizaValidacionExitosa(component, result.caseId);
					}					
					this.loadAccountById(component, result.account);
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

	actualizaValidacionExitosa : function(component, idCaso) {

		var idValidacion = component.get("v.idValidacionExitosa");
		var action = component.get("c.actualizaValidacionPreguntas");
		action.setParams({
			"idValidacion": idValidacion,
			"idCaso" : idCaso
		});

		action.setCallback(this, function(response) {				

		});

		$A.enqueueAction(action);
	},

	loadAccountById : function(component, isAcc) {

        console.log('loadAccountById');

        var campos = component.get("v.mapCamposMicroS");
        var action = component.get("c.updateSelectedAccount");        
        
        action.setParams({
            "idAcc" : isAcc, 
            "campos" : campos
        });
        
        action.setCallback(this, function(response) {
			
			var state = response.getState();            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();                
                if (acc) {      
                    
					component.set("v.selectedAccount", acc);   
					/// Se invoca el MicroServicio CustomerData
					component.set("v.cargarCustomerData", true);                 
                } else {
                    console.log("Error acc: ", acc);
                }
			} else {
				console.log("Error state: ", state);
			}

		});

		$A.enqueueAction(action);
    },

	closeModalOTP : function(component) {

		component.set("v.classBackdrop", '');
	},

	limpiarVaribles : function(component) {

		component.set("v.strMobilelUpdate", '');

		component.set("v.creatingCase", false);
		component.set("v.newCaseMobile", '');
		
		component.set("v.mapCamposMicroS", {});

		///
		component.set("v.cargarCustomerData", false);
	},

	openModalContactMethod : function(component) {

		component.set("v.classBackdrop", "slds-backdrop slds-backdrop_open");

        component.set("v.blnOpenModalContactMethod", true);
    },

    openModalMobileUpdate : function(component) {

		///
		this.closeModalOTP(component);

        component.set("v.loadingMobileUpdate", true);
        component.set("v.noPasoMobileUpdate", 3);

		this.actualizarCelular(component);
    }

})