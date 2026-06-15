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
    
    cargarCampaigns : function(component) {
        
        var action = component.get("c.obtenerCampaignsCliente");
        var selectedAccount = component.get("v.selectedAccount");
        
        action.setParams({
            "personId" : selectedAccount.ID_PersonAccount__c
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                component.set("v.campaigns", result );
                
            } else if (state === "INCOMPLETE") {
                
                console.log("Unknown error");
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
            
        });        
        $A.enqueueAction(action);
	},

	obtenerNombresCampanias : function(component) {

		var action = component.get("c.configuracionAumentoDeLinea");

		action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log("state", state);

            if (state === "SUCCESS") {
                
				var result = response.getReturnValue();
				
				///
				console.log("result", result);

                component.set("v.campaniaEmail", result.email);
                component.set("v.campaniaSMS", result.sms);
            }
        });
        $A.enqueueAction(action);		
	}
	
})