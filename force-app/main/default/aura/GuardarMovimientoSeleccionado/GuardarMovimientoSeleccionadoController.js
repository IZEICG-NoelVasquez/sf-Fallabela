({
	doInit : function (component, event, helper) {

		component.set("v.movimientosBackdropClass", "slds-backdrop slds-backdrop_open");

		component.set("v.casoConMovimientos", true);
	},

	closeModalCrearCaso : function(component, event, helper) {
		
		component.set("v.movimientosBackdropClass", '');
		component.set("v.openGuardarMovimientos", false);

		component.set("v.movimientosSeleccionados", false);
	}

})