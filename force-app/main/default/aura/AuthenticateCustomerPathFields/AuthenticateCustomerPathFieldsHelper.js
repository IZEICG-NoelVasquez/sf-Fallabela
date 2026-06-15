({
    hasNull : function (target) {
        
        for (var member in target) {

            if (target[member] == null)
                return true;
        }
        return false;
    },
    
    moveStatus : function (component) {

        var statusField = component.find("statusField");
        var subCategoria = component.find("subCategoria").get("v.value");
        
        // act de domicilio y de correo, quejas y fraude se cierran        
        if ( subCategoria === "Actualización Correo (Módulo)" || subCategoria === "Actualización Domicilio (Módulo)" || 
           	 subCategoria === "Quejas y/o Sugerencias (Módulo)" || subCategoria === "Sospecha de fraudes (Módulo)" ) {
        	
            statusField.set("v.value", "Cerrado");
            
        } else if ( subCategoria === "Cancelación por fallecimiento del titular (Módulo)" ) {
            
         	statusField.set("v.value", "Análisis de Cartera del Titular");   
            
        } else if ( subCategoria === "Cancelación de Adicional (Módulo)" ) {
            
            statusField.set("v.value", "Cancelación de la cuenta");   
            
        } else if ( subCategoria === "Cargo No Reconocido (Módulo)" || subCategoria === "Desconoce transacción en ATM (Módulo)" ) {
            
            statusField.set("v.value", "Análisis de Prosa");   
            
        } else if ( subCategoria === "Liberar Saldo Retenido (Módulo)" || subCategoria === "Retiro de Efectivo en ATM (Módulo)" ||
                  	subCategoria === "Pago No Aplicado (Módulo)" ) {
            	
            statusField.set("v.value", "Investigación del caso");   
            
        } else if ( subCategoria === "Tarjeta no pasa (Módulo)" ) {
            
            statusField.set("v.value", "Desbloqueo de PIN");   
            
        }
       
    },
    
	navigateToSObject : function (recordId) {
	
		var navEvt = $A.get("e.force:navigateToSObject");

	    navEvt.setParams({
	      "recordId": recordId
	    });

	    navEvt.fire();

	},

	showSpinner : function (component) {

		
		var showSpinner = component.get("v.showSpinner");

    	if (showSpinner) {

    		component.set("v.showSpinner", false);

    	} else {

    		component.set("v.showSpinner", true);

    	}

		
    	

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


	fireStepChange : function (component, step) {

		var stepChangeEvent = component.getEvent("stepChange");
        
        stepChangeEvent.setParams({
            "step" : step
        });

        stepChangeEvent.fire();

	},

	loadFormFields : function(component) {

		var action = component.get("c.getPortalFieldsConfig");
		var recordId = component.get("v.recordId");

		action.setParams({
			"recordId": recordId
		});

		console.log("loadFields 3");

		action.setCallback(this, function(response) {


			if (response.getState() === "SUCCESS") {

				var result = response.getReturnValue();
				
				component.set("v.rtID", result.rtID);
				component.set("v.fields", result.fields);


			}

		});

		$A.enqueueAction(action);        

	},

	loadPanelFields : function (component) {

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
		

	}

})