({
	doInit : function(component, event, helper) {

		component.set("v.cargandoPdf", true);
		component.set("v.cargaPdfExitosa", false);
		helper.cargarPdf(component);
	},

	closeModalPDF : function(component, event, helper) {
		
		component.set("v.openModalPDF", false);
	}
})