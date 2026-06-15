({
	doInit : function(component, event, helper) {

		component.set("v.cargandoImagen", true);

		var nombreImagen = component.get("v.nombreImagen");

		var blnReporteBuro = component.get("v.blnReporteBuro");

		var blnDocumentApiGee = component.get("v.blnDocumentApiGee");

		var workspaceAPI = component.find("workspace");
		workspaceAPI.getFocusedTabInfo().then(function(response) {
			var focusedTabId = response.subtabId;
			workspaceAPI.setTabLabel({
				tabId: focusedTabId,
				label: nombreImagen 
			});
			workspaceAPI.setTabIcon({
				tabId: focusedTabId,
				icon: "utility:preview",
				iconAlt: nombreImagen
			});
		})

		if( !blnReporteBuro && !blnDocumentApiGee ) {
			
			var microServicio = component.get("v.microServicio");
			if(microServicio == 'BlobStorage'){
				
				component.set("v.blnEsPDF", false);
				helper.cargarImagen(component, false);

			}else if(microServicio == 'WistonData'){
				//llamada a apigee
				component.set("v.blnEsPDF", true);
				helper.getDocumentApiGee(component);
			}
			/*var microServicio = component.get("v.microServicio");
			var esPDF;
			console.log('doInit - microServicio:  ', microServicio);
			if( microServicio == 'BlobStorage' ) {

				esPDF = false;

			} else if( microServicio == 'WistonData' ) {

				esPDF = true;
			}
			component.set("v.blnEsPDF", esPDF);
			helper.cargarImagen(component, esPDF);*/
			/////////
		} else if( blnDocumentApiGee && !blnReporteBuro ) {

			/// Documentos APIGee
			component.set("v.blnEsPDF", true);
			helper.getDocumentApiGee(component);

		} else {

			component.set("v.blnEsPDF", true);
			helper.cargarReporteBuro(component);
		}
	}

})