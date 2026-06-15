({
	incodeStart : function(component, event, externalId, recordId) {

		var countryCode = 'ALL';
		
		var action = component.get("c.msIncodeStart");

        action.setParams({
            "countryCode": countryCode,
            "externalId": externalId,
            "recordId": recordId
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state incodeStart: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result incodeStart', result);

                if (result.success && result.responseIncodeStart && result.responseIncodeStart.message && 
                    result.responseIncodeStart.message.interviewId && result.responseIncodeStart.message.token) { 
                    
					/// Llamado exitoso MS Incode Start
					this.incodeScore(component, event, result.responseIncodeStart.message.interviewId, recordId, result.responseIncodeStart.message.token);

                } else if( !result.success && result.recordAlreadyCreated ) {

					component.set("v.msgMSIncode", component.get("v.msgScoresAlreadyCreated") );
					component.set("v.callingMSIncode", false);

				} else {

					component.set("v.msgMSIncode", component.get("v.msgScoresError") );
					component.set("v.callingMSIncode", false);
                }

            } else {

				component.set("v.msgMSIncode", component.get("v.msgScoresError") );
				component.set("v.callingMSIncode", false);
            }
        });

        $A.enqueueAction(action);
	},

	incodeScore : function(component, event, interviewId, recordId, token) {

		var action = component.get("c.msIncodeScore");

        action.setParams({
            "interviewId": interviewId,
            "recordId": recordId,
            "token": token
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state msIncodeScore: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result msIncodeScore', result);

                if (result.success) { 
                    
					// Llamado exitoso MS Incode Score
					component.set("v.scoreAlreadyCreated", true);
					component.set("v.msgMSIncode", component.get("v.msgScoreCreatedSuccessfully") );
					component.set("v.callingMSIncode", false);

                } else {

					component.set("v.msgMSIncode", component.get("v.msgScoresError") );
					component.set("v.callingMSIncode", false);
                }

            } else {

				component.set("v.msgMSIncode", component.get("v.msgScoresError") );
				component.set("v.callingMSIncode", false);
            }
        });

        $A.enqueueAction(action);
	}
})