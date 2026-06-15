({
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
        
        stepChangeEvent.setParams({
            "step" : step
        });

        stepChangeEvent.fire();

	}
})