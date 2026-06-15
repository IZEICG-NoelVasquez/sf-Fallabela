({
	navigateToSObject : function (component, event, helper) {
	
		var navEvt = $A.get("e.force:navigateToSObject");
		var recordId = component.get("v.recordId");

	    navEvt.setParams({
	      "recordId": recordId
	    });

	    navEvt.fire();

	},

	navigateToCases : function (component, event, helper) {

        var recordId = component.get("v.recordId");
        helper.gotoRelatedList("Cases", recordId);
        


    },
    
    navigateToCase : function (component, event, helper) {

        var record = event.getSource().get("v.value");		
        var navEvt = $A.get("e.force:navigateToSObject");
		var recordId = record.Id;

	    navEvt.setParams({
	      "recordId": recordId
	    });

	    navEvt.fire();

    }
})