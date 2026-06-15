({
	doInit : function (component, event, helper) {
		var movimientoIdx = component.get("v.movimientoIdx");
		var fechaCorte = component.get("v.fechaCorteValue");
		var cargarFechasDeCorte = component.get("v.cargarFechasDeCorte");

		if( cargarFechasDeCorte ) {
			helper.cargarParametrosFechasCorte(component, movimientoIdx, fechaCorte);
		}
	},

	changeFechaCorte : function (component, event, helper) {

		///
		component.set("v.fechaAsignada", false);
	}
})