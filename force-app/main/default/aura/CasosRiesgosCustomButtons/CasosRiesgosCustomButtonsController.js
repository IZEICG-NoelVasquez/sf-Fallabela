({
	doInit : function (component, event, helper) {

		component.set("v.loadedInfo", false);
		component.set("v.showDataUpdateGestor", false);

		helper.getCaseInfo(component);
	},

	abrirConsulta : function(component, event, helper) {

		console.log('abrirConsulta');

		component.set("v.openModalConsulta", true);		
	},

	abrirActualizacion : function (component, event, helper) {

		console.log('abrirActualizacion');

		component.set("v.openModalActualizacion", true);
	},

	openDataUpdateGestor : function(component, event, helper) {

		component.set("v.openModalDataUpdate", true);
	}
})