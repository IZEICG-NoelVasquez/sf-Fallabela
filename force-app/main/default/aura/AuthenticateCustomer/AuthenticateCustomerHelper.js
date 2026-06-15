({
	loadAccount : function(component, recordId) {
        console.log('loadAccount');
    	var action = component.get("c.getCustomerByCaseId");

		action.setParams({
			"caseId" : recordId
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();
            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();
                //console.log("acc",acc);
                if (acc) {
                    component.set("v.showPanel", false);
                	component.set("v.selectedAccount", acc);
                    component.set("v.step", 3);
                    
                    
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
    
    loadAccountByCurp : function(component, curp) {
		/*console.log('loadAccountByCurp');
        var action = component.get("c.getCustomerByCURP");
        
        var showPanel = component.get("v.showPanel");
        
        var initialCmp = component.find("authInitial");
        
        action.setParams({
			"curp" : curp
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();
            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();
                
                if (acc) {      
                    
                    component.set("v.selectedAccount", acc);
                    //component.set("v.step", 2);
                    //
                    console.log('acc', acc);
					initialCmp.set("v.lookupobj", acc);
                    initialCmp.set("v.lookupId", acc.Id);
                    
                    console.log('initialCmp', initialCmp);
                   	 
					initialCmp.selectRecord(acc.Name, acc);

                    
                    
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

		$A.enqueueAction(action);*/
        
    },

    loadAccountByIdAcc : function(component, idAcc, fechaNac) {
		console.log('loadAccountByIdAcc');
        var action = component.get("c.getCustomerById");
        
        var initialCmp = component.find("authInitial");
        
        action.setParams({
			"idAcc" : idAcc
        });

        action.setCallback(this, function(response) {
			
			var state = response.getState();
            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();
                
                if (acc) {      
                    
                    component.set("v.selectedAccount", acc);

                    initialCmp.set("v.fechaDeNacimiento", fechaNac);

					initialCmp.set("v.lookupobj", acc);
                    initialCmp.set("v.lookupId", idAcc);
                    initialCmp.selectRecord(acc.Name, acc);
                    
                    ///
                    component.set("v.step", 2);
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
        
    }
})