({
	doInit : function(component, event, helper) {

		helper.loadAgent(component);

	},

	doReturn : function(component, event, helper) {

		helper.fireStepChange(component, 1);
	}
})