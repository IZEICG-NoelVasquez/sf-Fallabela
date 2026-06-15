({
	getCustomerData : function(component){
		var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;
        if(numeroDocumento != null && numeroDocumento != ''){
		var action = component.get("c.consulta_Customer_Data");        
        action.setParams({
            "numeroDocumento" : numeroDocumento
		});
		action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                if (result.success) {
                    var phoneCustomerData;
                    if(undefined !== result.resultCustomerData.message.cliente){
                    if(undefined !== result.resultCustomerData.message.cliente.informacionContacto){
                    if(undefined !== result.resultCustomerData.message.cliente.informacionContacto.telefono){
                        for(var i=0; i<result.resultCustomerData.message.cliente.informacionContacto.telefono.length;i++){
                            if(result.resultCustomerData.message.cliente.informacionContacto.telefono[i].tipoTelefono == 'MO'){
                                phoneCustomerData = result.resultCustomerData.message.cliente.informacionContacto.telefono[i].numeroTelefono;
                                if(undefined !== phoneCustomerData && phoneCustomerData.length >10){
                                    phoneCustomerData = phoneCustomerData.substring(phoneCustomerData.length - 10, phoneCustomerData.length)
                                }
                                component.set("v.Response", phoneCustomerData);
                            }
                        }
                    }
                    }
                    }    
                    if(phoneCustomerData != null){
                        var evt = component.getEvent("CustomerDataPhoneE");
                        evt.setParams({
                            "phoneCustomerData" : phoneCustomerData,
                        });        
                        evt.fire();
                    }
                } else {
                }

            } else {
            }
        });

        $A.enqueueAction(action);
        }
	}
})