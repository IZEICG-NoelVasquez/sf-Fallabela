({
	doInit : function(component, event, helper) {

		component.set("v.cargandoLinks", true);

		helper.obtenerImagenes(component);
	},

	abrirImagenNuevaVentana : function(component, event, helper) {

		var link = event.currentTarget.id;
		var nombre = event.currentTarget.title;
		var microServicio = event.currentTarget.name;

		var idSolicutud = component.get("v.sObj.ID_Solicitud__c");
		
		if( !helper.validarCampoVacio(link) && !helper.validarCampoVacio(nombre) && !helper.validarCampoVacio(microServicio) ) {

			var evt = $A.get("e.force:navigateToComponent");
			evt.setParams({
				componentDef : "c:MicroServicioModalImagenesBO",
				componentAttributes: {
					idSolicitud : idSolicutud,
					link : link,
					microServicio : microServicio,
					nombreImagen : nombre,
					blnReporteBuro : false
				}
			});
			evt.fire();
		}
	}, 

	abrirReporteBuroNuevaVentana : function(component, event, helper) {

		var urlReporteBuro = component.get("v.urlReporteBuro");

		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "c:MicroServicioModalImagenesBO",
			componentAttributes: {
				urlImagen : urlReporteBuro,
				nombreImagen : 'ReporteDeCredito.pdf',
				blnReporteBuro : true
			}
		});
		evt.fire();
	}
})