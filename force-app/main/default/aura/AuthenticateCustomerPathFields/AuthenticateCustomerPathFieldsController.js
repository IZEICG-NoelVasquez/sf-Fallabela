({
    
    handleSubmit : function (component, event, helper) {

        console.log("event.getParams", JSON.stringify(event.getParams()));
        
        var payload = event.getParam("fields");
        var hasNull = helper.hasNull(payload);
        
        if (hasNull) {
            
            helper.showToast("Campos Requeridos", "Favor de llenar todos los campos", "warning");
            //component.set("v.isDisabled", true);
            component.set("v.isComplete", false);
            
        } else {
            
            event.preventDefault();
            helper.moveStatus(component);
            
            console.log("isComplete", component.get("v.isComplete"));
            component.set("v.isComplete", true);
            component.find("editform").submit();
			            
        }
    	
        //var cmp = component.find("submitbtn");
	    //cmp.addEventListener("onsubmit", component.getReference("c.handleSubmit"));
        
    },
    
    onInputChange : function (component, event, helper) {
        
        var val = event.getParam("value");
        console.log("val", val);

        if (!val) {
        	//component.set("v.isDisabled", false); 
        	component.set("v.isComplete", false);   
            
        }

    },
 
    handleError : function (component, event, helper) {
        
        var payload = event.getParams().response;
        console.log("Error", JSON.stringify(payload));
        
    },
    
    setStatus : function (component, event, helper) {
		
        helper.moveStatus(component);
        component.set("v.isDisabled", false);
        
    },
    
	handleRecordIdSelected : function (component, event, helper) {
		
		
		var recordId = event.getParam("recordId");
		var selectedAccount = event.getParam("selectedAccount");

		component.set("v.recordId", recordId);
		component.set("v.selectedAccount", selectedAccount);

		helper.loadFormFields(component);
		helper.loadPanelFields(component);


    },

    handleSaveRecord : function (component, event, helper) {
    	
    	helper.showSpinner(component);

		window.setTimeout(
		    $A.getCallback(function() {
		        helper.showSpinner(component)
		    }), 2000
		);


    },

    handleCompleteCase : function (component, event, helper) {
		
        var isComplete = component.get("v.isComplete");
        var payload = event.getParams().response;
        //console.log("Complete", JSON.stringify(payload));
        console.log("isComplete 2", isComplete);
        if (isComplete) {
            component.set("v.recordId", null);
            helper.fireStepChange(component, 1);
            helper.navigateToSObject(payload.id);
            helper.showToast("Registro Guardado", "Los cambios han sido guardados", "success");
        }
    	

    },
    
    handleUploadFinished : function (component, event, helper) {
		
        helper.showToast("Carga Exitosa", "El archivo se ha cargado", "success");
    	
    }
    
    
})