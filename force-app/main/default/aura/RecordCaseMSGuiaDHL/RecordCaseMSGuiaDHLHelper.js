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
    
    getCaseRecordInfo : function(component) {

        var recordId = component.get("v.recordId");

        console.log('getCaseRecordInfo - recordId:  ', recordId);

        var action = component.get("c.getCaseRecordInfo");

		action.setParams({
            "recordId" : recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state getCaseRecordInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result getCaseRecordInfo', result);

                if (result.success) { 

					if( result.caseRecord ) {

                        component.set("v.accountId", result.caseRecord.AccountId);
                        component.set("v.curp", result.caseRecord.Account.CURP__c);                        
                        component.set("v.currentEstatus", result.caseRecord.Estatus__c);
                    }
                }
            }
            
            component.set("v.loadedRecordCaseInfo", true);
        });

        $A.enqueueAction(action);
    }
})