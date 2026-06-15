({
    
    extractDigits: function (txt) {
        
        if (!txt) {return null;}
        var numb = txt.match(/\d/g);
        if (!numb) {return null;}
        numb = numb.join("");
        return numb;
        
    },
    
    validateFields: function (component, customer, fechaNacimiento) {
        
        var action = component.get("c.getCustomer");
        var esClienteAnonimo = component.get("v.esClienteAnonimo");
        
        action.setParams({
            "customerId" : customer.Id
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var acc = response.getReturnValue();
                
                if (esClienteAnonimo || ( acc.Fecha_de_nacimiento1__c === fechaNacimiento ) ) {
                    
                    this.showToast("Autenticación Exitosa", "La Autenticación ha sido exitosa", "success");
                    this.fireStepChange(component, 2);
                    
                } else {
                    
                    this.showToast("Autenticación No Exitosa", "Los valores proveidos no son correctos", "error");
                    //this.fireStepChange(component, 3);
                    
                }
                
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
    
    loadAgent : function (component) {
        
        var action = component.get("c.getAgent");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                component.set("v.agent", response.getReturnValue());
                
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
    
    fireStepChange : function (component, step) {
        
        var stepChangeEvent = component.getEvent("stepChange");
        
        var attributes = {};
		attributes.esClienteAnonimo = component.get("v.esClienteAnonimo");
        attributes.clienteAnonimo = component.get("v.clienteAnonimo");
        
        stepChangeEvent.setParams({
            "step" : step,
            "attributes" : attributes
        });
        
        stepChangeEvent.fire();
        
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