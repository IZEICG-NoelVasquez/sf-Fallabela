({
	closeModalContactMethod : function(component, event, helper) {
		
		component.set("v.blnOpenModalContactMethod", false);	
		
		component.set("v.msMobileUpdateclassBackdrop", '');
	},

	handleContactMethod : function(component, event, helper) {

		///
		helper.fireCloseModalEvent(component);

		component.set("v.blnOpenModalContactMethod", false);
	}
})