({
	cargarPdf : function(component) {
		
		var urlPdf = component.get("v.urlPdf");

		var action = component.get("c.getFormatoAclaracionesPdf");
        action.setParams({
            "urlPdf" : urlPdf
		});

		action.setCallback(this, function(response) {
            
            var state = response.getState();            
			console.log("state PdfAclaraciones", state);
			
            if (state === "SUCCESS") {

				var result = response.getReturnValue();

				component.set("v.pdfData", result);
				component.set("v.pdfDownload", 'data:application/pdf;base64,' + result);
				component.set("v.cargandoPdf", false);
				component.set("v.cargaPdfExitosa", true);

            } else {

				component.set("v.cargandoPdf", false);
				component.set("v.cargaPdfExitosa", false);

            }
        });

        $A.enqueueAction(action);
	}
})