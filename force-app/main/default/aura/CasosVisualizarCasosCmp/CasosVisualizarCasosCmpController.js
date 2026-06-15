({
	init : function(component, event, helper) {

		helper.getCasos(component);
		helper.getCasosToday(component);
		helper.getCasosCerrados(component);

		var interval = window.setInterval(
            $A.getCallback(function() {

                helper.intervalCasos(component);

            }), 120000
        );

		component.set("v.setIntervalId",interval);
	},

	navToRecord : function (component, event, helper) {

		var recordId = event.currentTarget.id;

		var navEvt = $A.get("e.force:navigateToSObject");
		navEvt.setParams({
		  "recordId": recordId
		});
		navEvt.fire();
	}
})