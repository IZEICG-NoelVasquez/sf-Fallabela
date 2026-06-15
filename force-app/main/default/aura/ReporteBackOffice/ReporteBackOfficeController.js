({
	init: function (component, event, helper) {

		///
		component.set("v.cargandoDatos", true);

		var fechaInicio = component.get("v.fechaInicio");
		var fechaFin = component.get("v.fechaFin");
		fechaInicio = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		fechaFin = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		component.set("v.fechaInicio", fechaInicio);
		component.set("v.fechaFin", fechaFin);
		
		helper.cargarData(component, null, false, 0);

		helper.loadCanalOrigenList(component);
	},
	
	previousRecords : function(component, event, helper) {

		///
		var recordsPerPage = component.get("v.recordsPerPage");
		var offSet = component.get("v.offSet");

		console.log('offSetPrevious:  ', offSet - recordsPerPage);
		component.set("v.cargandoDatos", true);
		helper.cargarData(component, null, false, offSet - recordsPerPage);
	},

	nextRecords : function(component, event, helper) {

		///
		var recordsPerPage = component.get("v.recordsPerPage");
		var offSet = component.get("v.offSet");

		console.log('offSetNext:  ', offSet + recordsPerPage);
		component.set("v.cargandoDatos", true);
		helper.cargarData(component, null, false, offSet + recordsPerPage);
	},

	actualizarReporte: function (component, event, helper) {

		var fechaInicio = component.get("v.fechaInicio");
		var fechaFin = component.get("v.fechaFin");

		if( helper.validarCampo(component, fechaInicio) || helper.validarCampo(component, fechaFin) ) {

			helper.showToast( "Accion Requerida","Debe ingresar la Fecha de Inicio y la Fecha Fin" ,"warning");

		} else {

			component.set("v.curp", null);
			component.set("v.colapsarCasos", false);

			component.set("v.cargandoDatos", true);
			helper.cargarData(component, null, false, 0);
		}		
	},

	colapsarReporte: function (component, event, helper) {

		var fechaInicio = component.get("v.fechaInicio");
		var fechaFin = component.get("v.fechaFin");

		if( helper.validarCampo(component, fechaInicio) || helper.validarCampo(component, fechaFin) ) {

			helper.showToast( "Accion Requerida","Debe ingresar la Fecha de Inicio y la Fecha Fin" ,"warning");
		} else {

			component.set("v.curp", null);
			component.set("v.colapsarCasos", true);

			component.set("v.cargandoDatos", true);
			helper.cargarData(component, null, false, 0);
		}
	},

	buscarCURP: function(component, event, helper) {		

		var curp = component.get("v.curp");

		if( helper.validarCampo(component, curp) ) {

			helper.showToast( "Accion Requerida","Debe ingresar un CURP","warning");
		} else{

			component.set("v.fechaInicio", null);
			component.set("v.fechaFin", null);

			component.set("v.cargandoDatos", true);
			helper.cargarData(component, curp, false, 0);
		}
	},

	descargarReporte: function(component, event, helper) {

		component.set("v.cargandoDatos", true);

		helper.cargarData(component, null, true, 0);
    }
})