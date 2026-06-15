({
	doInit : function(component, event, helper) {

		component.set("v.reasonReplacementValue", '');
		helper.loadReasonReplacementList(component);
	},

	closeModalReasonReplacement : function(component, event, helper) {

		component.set("v.blnOpenModalReasonReplacement", false);
	}, 

	handleReasonReplacement : function(component, event, helper) {

		helper.fireCloseModalEvent(component);
		component.set("v.blnOpenModalReasonReplacement", false);
	},

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");

		if( blnCloseModal ) {
			
			component.set("v.blnOpenModalReasonReplacement", true);
		}
	}
})