({
	doInit : function(component, event, helper) {

		component.set("v.showComponent", false);
		component.set("v.productsLoaded", true);
		component.set("v.cardLocked", false);
		
		helper.getCaseInfo(component);
	},

	openModalMSCardLock : function(component, event, helper) {

		if( component.get("v.cardLocked") ) {
			console.log('entra tarjeta cancelada');
			helper.showToast("", "La tarjeta ya se encuentra bloqueada", "warning");

		} else {

			///
			component.set("v.productsLoaded", false);

			helper.getProducts(component);
		}		
	}
})