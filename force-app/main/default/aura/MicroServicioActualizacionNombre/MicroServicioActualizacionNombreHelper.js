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

	validarCampo : function(component, campo) {
		if( campo == undefined || campo == null || campo == '' ) {
            this.showToast("Accion Requerida", "No se permiten campos vacíos" ,"info");
			return true;
		} else if( !this.validaFormatoTexto(campo) ) {
            this.showToast("Accion Requerida", "No se permiten caracteres especiales" ,"warning");
            return true;
        } else {
            return false;
        }
    },
    
    validaFormatoTexto : function(campo) {

		var formato = /^[A-Z ]+$/i;
		return formato.test(campo);
	},

	actualizarNombre : function(component) {

		console.log('Actualizar Email');
		var selectedAccount = component.get("v.selectedAccount");
		var numeroDocumento = selectedAccount.CURP__c;
		
		var mapCamposMicroS = component.get("v.mapCamposMicroS");
		mapCamposMicroS["numeroDocumento"] = numeroDocumento;
		
		mapCamposMicroS["apellidoMaterno"] = component.get("v.strApellidoMaterno");
		mapCamposMicroS["apellidoPaterno"] = component.get("v.strApellidoPaterno");
		mapCamposMicroS["nombres"] = component.get("v.strNombres");
		///
		mapCamposMicroS["apellidos"] = component.get("v.strApellidoPaterno") + ' ' + component.get("v.strApellidoMaterno");

		component.set("v.mapCamposMicroS", mapCamposMicroS);

		var action = component.get("c.actualizarNombre");
        action.setParams({
            "campos" : mapCamposMicroS
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state nameUpdate: ", state);
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result nameUpdate', result);
                if (result.success) { 
                    
                    component.set("v.nameUpdated", true);
                    component.set("v.loadingNameUpdate", false);

                    this.crearCasoNameUpdate(component);
                    component.set("v.creatingCase", true);

                } else {
                    component.set("v.nameUpdated", false);
                    component.set("v.loadingNameUpdate", false);
                }

            } else {
                component.set("v.nameUpdated", false);     
                component.set("v.loadingNameUpdate", false);     
            }
        });

		$A.enqueueAction(action);
	},

	crearCasoNameUpdate : function(component) {

        /// Variables para la Creacion del Caso 'Actualización Nom, RFC, FN'
        var catSubSelected = 'Actualización Nom, RFC, FN'; // <-------------------------
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
         var camposRequeridos = 'Nombre_s__c:';
         camposRequeridos += component.get("v.strNombres") + ' ' + component.get("v.strApellidoPaterno") + ' ' + component.get("v.strApellidoMaterno");
         camposRequeridos += ',';
         camposRequeridos += 'Tipo_de_informaci_n__c:Nombre';

         var action = component.get("c.createCaseClosedName");
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
                    component.set("v.newCaseName", result.folioCaso );
                    console.log("v.newCaseName:  ", component.get("v.newCaseName") );
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
        
        var otpModalNamelUpdate = component.find("otpModalNamelUpdate");
        otpModalNamelUpdate.setState(state);
    },

	limpiarVaribles : function(component) {

		component.set("v.strApellidoPaterno", '');
		component.set("v.strApellidoMaterno", '');
		component.set("v.strNombres", '');

		component.set("v.creatingCase", false);
		component.set("v.newCaseName", '');
		
        component.set("v.mapCamposMicroS", {});
        
        ///
        component.set("v.enableOTPModal", false);
	}

})