({
	getCaseInfo : function(component) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.getCaseInfo");

        action.setParams({
            "recordId": recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getCaseInfo state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('getCaseInfo result', result);

                if (result.success) { 
                    
					component.set("v.commetsValue", result.caseInfo.Comentarios__c);

                    var lstDataUpdateValues = component.get("v.lstDataUpdateValues");

                    if( lstDataUpdateValues.includes(result.caseInfo.C_digo_Postal_Direcci_n_Otros__c) ) {

                        component.set("v.showDataUpdateGestor", true);

                    }
                }
            }

			component.set("v.loadedInfo", true);
        });

        $A.enqueueAction(action);
    },
})