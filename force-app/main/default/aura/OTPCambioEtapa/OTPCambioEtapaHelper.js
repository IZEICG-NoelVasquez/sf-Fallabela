({
	openOTP : function (component, phone, recordId) {

		var stepChangeEvent = component.getEvent("OTPState");
        
        stepChangeEvent.setParams({
            "state" : "open",
            "mode" : "case",
            "phone": phone,
            "recordId" : recordId
        });
        
        stepChangeEvent.fire();

	},
    openOTPPAN : function (component, phone, recordId) {

        var stepChangeEvent = component.getEvent("OTPState");
        
        console.log('stepChangeEvent ', stepChangeEvent);
        
        stepChangeEvent.setParams({
            "state" : "open",
            "mode" : "casePAN",
            "recordId" : recordId
        });
        
        console.log('stepChangeEvent ');
        
        stepChangeEvent.fire();

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
	    
	},
    
    showToast : function(title, message, type) {

	    var toastEvent = $A.get("e.force:showToast");
	    toastEvent.setParams({

	        "title": title,
	        "message": message,
	        "type": type
	    });
	    toastEvent.fire();
	}
})