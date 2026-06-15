({
	doInit : function (component, event, helper) {
		component.set("v.creatingCase", true);
		
		helper.crearCasoSaldos(component);
	},
	
	closeModalCasoSaldos : function(component) {

		component.set("v.openModalCasoSaldos", false);
	}
	 
})