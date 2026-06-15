({
	handleMessage : function(cmp, event, helper) {

        console.log('handleMessage');

		var payload = event.getParam("payload");
    	var recordId = cmp.get("v.recordId");
        console.log("recordId", recordId);
        cmp.set("v.payload", payload);

        var message = payload.Message__c;
        console.log("message", message);
        var value = payload.value__c;
        console.log("value", value);
        var recordId = payload.RecordId__c;
        
        console.log("recordIdPayload", recordId);

        var userId=$A.get("$SObjectType.CurrentUser.Id");
        console.log("userId", userId);

        if (message === 'navigateToSObject' && userId === recordId) {

			helper.openTab(cmp, value);
				

        } else if (message === 'fireSendOTP') {
            
            helper.openOTP(cmp, value, recordId);
            
        } else if (message === 'fireSendOTPPAN') {
            
            helper.openOTPPAN(cmp, value, recordId);
            
        } else if (message === 'fireAuthenticate' && userId === recordId) {
            helper.openAuthenticate(cmp, value);
        }

	}
})