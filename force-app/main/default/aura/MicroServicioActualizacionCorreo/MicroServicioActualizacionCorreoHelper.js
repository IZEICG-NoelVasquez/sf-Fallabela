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
	
	validaEmail : function(component, emailUpdate) {

        if( emailUpdate != null && emailUpdate != '' ) {
            
            if( this.validaFormatoEmail(emailUpdate) ) {
                if( this.validaEmailAnterior(component, emailUpdate) ) {
					this.showToast("El Email ingresado ya se encuentra en el Sistema", "Por favor revisar la dirección de Email" ,"warning");
				} else {					
					component.set("v.noPasoEmailUpdate", 2);
                }                
            } else {
                this.showToast("Debe ingresar un Email válido", " Por favor revisar la dirección de Email" ,"info");
            }            
        } else {
            this.showToast("Debe ingresar un Email", "No se permite el campo Email vacío" ,"info");
        }
    },

    validaFormatoEmail : function (emailUpdate) {

        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(String(emailUpdate).toLowerCase());
    }, 

    validaEmailAnterior : function(component, correo) {

        var correoAnterior = component.get("v.selectedAccount").PersonEmail;
        console.log("correoAnterior:  ", correoAnterior);
        console.log("correo:  ", correo);
        
        var blnMailAnterior = false;
		if( correoAnterior && correo ) {
			if( correoAnterior == correo ) {
				blnMailAnterior = true;
			}
			else {
				blnMailAnterior = false;
			}
		}

		return blnMailAnterior;
    },

    actualizarEmail : function(component, emailUpdate) {

        console.log('Actualizar Email');
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;

        var mapCamposMicroS = component.get("v.mapCamposMicroS");
        mapCamposMicroS["numeroDocumento"] = numeroDocumento;

        mapCamposMicroS["direccionCorreoElectronico"] = emailUpdate;

        component.set("v.mapCamposMicroS", mapCamposMicroS);
        
        var action = component.get("c.actualizarEmail");
        action.setParams({
            "campos" : mapCamposMicroS
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state emailUpdate: ", state);
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result emailUpdate', result);
                if (result.success) { 
                    
                    component.set("v.emailUpdated", true);
                    component.set("v.loadingEmailUpdate", false);

                    this.crearCasoEmailUpdate(component, emailUpdate);
                    component.set("v.creatingCase", true);

                } else {
                    component.set("v.emailUpdated", false);
                    component.set("v.loadingEmailUpdate", false);
                }

            } else {
                component.set("v.emailUpdated", false);     
                component.set("v.loadingEmailUpdate", false);     
            }
        });

        $A.enqueueAction(action);
    },

    crearCasoEmailUpdate : function(component, emailUpdate) {

        /// Variables para la Creacion del Caso 'Actualización de Correo'
        var catSubSelected = 'Actualización de Correo'; // <-------------------------
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
        
         // Campos requeridos para cerrar el Caso            
         var camposRequeridos = 'Actualizaci_n_Alta__c:Actualización';
         camposRequeridos += ',';
         camposRequeridos += 'Correo_actual__c:';
         camposRequeridos += emailUpdate;
         camposRequeridos += ',';
         camposRequeridos += 'Correo_Actualizado_Microservicio__c:true';          

         var action = component.get("c.createCaseClosedEmail");
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
                    component.set("v.newCaseEmail", result.folioCaso );
                    console.log("v.newCaseEmail:  ", component.get("v.newCaseEmail") );
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

    loadAccountById : function(component, isAcc) {

        console.log('loadAccountById');

        var action = component.get("c.updateSelectedAccount");        
        
        action.setParams({
			"idAcc" : isAcc
        });
        
        action.setCallback(this, function(response) {
			
			var state = response.getState();            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();                
                if (acc) {      
                    
                    component.set("v.selectedAccount", acc);                    
                } else {
                    console.log("Error acc: ", acc);
                }
			} else {
				console.log("Error state: ", state);
			}

		});

		$A.enqueueAction(action);
    },

    setModalState : function (component, state) {
        
        var otpModalEmailUpdate = component.find("otpModalEmailUpdate");
        otpModalEmailUpdate.setState(state);
        
    },

    limpiarVaribles : function(component) {

		component.set("v.strEmailUpdate", '');

		component.set("v.creatingCase", false);
		component.set("v.newCaseEmail", '');
		
        component.set("v.mapCamposMicroS", {});
        
        ///
        component.set("v.enableOTPModal", false);
	}, 

    openModalContactMethod : function(component) {

        component.set("v.blnOpenModalContactMethod", true);
    },

    openModalEmailUpdate : function(component) {

        component.set("v.openEmailUpdate", true);
        component.set("v.noPasoEmailUpdate", 1);
    }
})