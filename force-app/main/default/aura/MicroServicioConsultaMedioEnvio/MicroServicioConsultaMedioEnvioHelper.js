({
    
	consultaMedioDeEnvio : function(component, movimientoIdx) {

		var selectedAccount = component.get("v.selectedAccount");
		var numeroDocumento = selectedAccount.CURP__c;
		var productos = component.get("v.productos");        
		var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
		
		var action = component.get("c.consulta_Medio_Envio");        
        action.setParams({
            "numeroDocumento" : numeroDocumento,
            "identificador" : identificador
		});
		
		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state ConsultaMedEnv: ", state);

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                console.log('result ConsultaMedEnv', result);
                if (result.success) { 

					component.set("v.email_Text", result.resultMedioEnvio.message.producto.informacionContacto.correoElectronico.direccionCorreoElectronico );
					component.set("v.papel_Text", result.resultMedioEnvio.message.producto.informacionContacto.direccion.direccionCompleta );
					component.set("v.blnEmail", result.resultMedioEnvio.message.producto.informacionContacto.correoElectronico.esPrimario );
					component.set("v.blnDireccion", !result.resultMedioEnvio.message.producto.informacionContacto.correoElectronico.esPrimario );					

                    component.set("v.loadingConsultaMedioEnvio", false);
                    component.set("v.consultaExitosa", true);

                } else {
					
                    component.set("v.loadingConsultaMedioEnvio", false);
                    component.set("v.consultaExitosa", false);
                    this.showToast("Ha ocurrido un error al consultar Medio de Envio", "Favor de reportar a su administrador", "warning");
                    component.set("v.blnEmail", false);
                    component.set("v.blnDireccion", false);
                }

            } else {
				  
                component.set("v.loadingConsultaMedioEnvio", false);
                component.set("v.consultaExitosa", false);
                this.showToast("Ha ocurrido un error al consultar Medio de Envio", "Favor de reportar a su administrador", "warning");
                component.set("v.blnEmail", false);
                component.set("v.blnDireccion", false);
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

    setModalState : function (component, state) {
        
        var cmpModal = component.find("otp-modal-MedioEnvio");
        cmpModal.setState(state);
        
    },

    openModalMedioDeEnvio : function(component) {

        component.set("v.testClass", "slds-backdrop slds-backdrop_open");

        component.set("v.openMedioDeEnvio", true);
        component.set("v.noPasoMedioEnvio", 1);
        ///
        component.set("v.blnEmail_TMP", component.get("v.blnEmail") ); 
        component.set("v.medioEnvioSelected", true);
    },

    openModalContactMethod : function(component) {

        component.set("v.blnOpenModalContactMethod", true);
    }

})