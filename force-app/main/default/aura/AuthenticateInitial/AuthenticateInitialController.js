({
	doInit : function(component, event, helper) {

		helper.loadAgent(component);

	},

	doAuth : function(component, event, helper) {

		var customer = component.get("v.lookupobj");
        var esClienteAnonimo = component.get("v.esClienteAnonimo");
        var fechaNacimiento = esClienteAnonimo ? null : component.find("fecha_nacimiento").get("v.value");
		
        console.log("fechaNacimiento", fechaNacimiento);
        console.log("customer", customer);
        
		if (!esClienteAnonimo && customer && fechaNacimiento) {

			helper.validateFields(component, customer, fechaNacimiento);

        } else if ( esClienteAnonimo ) {

            var nombresAnonimo = component.find("nombresAnonimo").get("v.value");
            var apellidosAnonimo = component.find("apellidosAnonimo").get("v.value");
            var fdnAnonimo = component.find("fdnAnonimo").get("v.value");
            var celularAnonimo = component.find("celularAnonimo").get("v.value");
            var oficinaAnonimo = component.find("oficinaAnonimo").get("v.value");
            var contratoAnonimo = component.find("contratoAnonimo").get("v.value");
            
            if (nombresAnonimo && apellidosAnonimo && celularAnonimo) {
				
                var clienteAnonimo = {};
                clienteAnonimo.nombresAnonimo = nombresAnonimo;
                clienteAnonimo.apellidosAnonimo = apellidosAnonimo;
                clienteAnonimo.fdnAnonimo = fdnAnonimo;
                clienteAnonimo.celularAnonimo = celularAnonimo;
                clienteAnonimo.oficinaAnonimo = oficinaAnonimo;
                clienteAnonimo.contratoAnonimo = contratoAnonimo;
                component.set("v.clienteAnonimo", clienteAnonimo);
                
                helper.validateFields(component, customer, null);
                
            } else {
                
                component.set("v.clienteAnonimo", null);
                helper.showToast("Campos requeridos", "Favor de llenar los campos requeridos", "warning");
                
            }
            
        } else {

			helper.showToast("Campos requeridos", "Favor de llenar los campos requeridos", "warning");

		}

	},

	handleSelectedEvent : function (component, event, helper) {
		
        console.log('handleSelectedEvent');
        
        var lookupcomponent = component.find("lookupcomponent");
        var customer = lookupcomponent.get("v.value");
        var esClienteAnonimo;
        if (customer){
        	 esClienteAnonimo = customer.Cliente_Anonimo__c;
        }
        
        console.log('esClienteAnonimo', customer.Cliente_Anonimo__c);
        
        component.set("v.lookupobj", customer);
        component.set("v.esClienteAnonimo", esClienteAnonimo);

	},
    
    handleRemovedEvent : function (component, event, helper) {
		
	}, 
    
    selectRecord : function (component, event, helper) {
        
        var lookupCmp = component.find("lookupcomponent");
        var params = event.getParam('arguments');
        if (params) {
            // add your code here
            lookupCmp.set("v.selectedObjectDisplayName", params.nombre);
			lookupCmp.set("v.selectedObject", params.cuenta);
        }
        
        
        
    }
})