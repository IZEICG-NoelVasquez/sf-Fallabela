({
	showToast : function(title, message, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
	},
	
	cargarImagen : function(component, esPDF) {

		var idSolicitud = component.get("v.idSolicitud");
		var link = component.get("v.link");
		var microServicio = component.get("v.microServicio");

		var action = component.get("c.descargarImagen");
        action.setParams({
            "idSolicitud" : idSolicitud,
            "link" : link,
            "microServicio" : microServicio
		});
		
		action.setCallback(this, function(response) {
            
            var state = response.getState();            
			console.log("state DescargarImg", state);
			
            if (state === "SUCCESS") {
				var result = response.getReturnValue();
				
                console.log("result:  ", result )
                if (result.success) {

					component.set("v.cargandoImagen", false);
					component.set("v.consultaExitosa", true);

					if( esPDF ) {

						component.set("v.fileDownload", 'data:application/pdf;base64,' + result.base64_Img);
						component.set("v.pdfData", result.base64_Img);
					} else {

						component.set("v.fileDownload", result.base64_Img);
					}

                } else {

					component.set("v.cargandoImagen", false);
					component.set("v.consultaExitosa", false);
                	this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
				}
            } else {

				component.set("v.cargandoImagen", false);
				component.set("v.consultaExitosa", false);
                this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
            }
        });

        $A.enqueueAction(action);
	},

	cargarReporteBuro : function(component) {

		var urlImagen = component.get("v.urlImagen");

		var action = component.get("c.getPDFReporteBuro");
        action.setParams({
            "urlReporte" : urlImagen
		});

		action.setCallback(this, function(response) {
            
            var state = response.getState();            
			console.log("state DescargarImg", state);
			
            if (state === "SUCCESS") {
				var result = response.getReturnValue();
				
                console.log("result:  ", result )

				component.set("v.cargandoImagen", false);
				component.set("v.consultaExitosa", true);

				component.set("v.fileDownload", 'data:application/pdf;base64,' + result);
				component.set("v.pdfData", result);

            } else {

				component.set("v.cargandoImagen", false);
				component.set("v.consultaExitosa", false);
                this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
            }
        });

        $A.enqueueAction(action);
	},

	getDocumentApiGee : function(component) {

		var idSolicitud = component.get("v.idSolicitud");
		var link = component.get("v.link");

		var action = component.get("c.getDocumentApiGee");

		action.setParams({
            "documentSubTypeId" : link,
            "idRequest" : idSolicitud
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getDocumentApiGee - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

				console.log("getDocumentApiGee - result: ", result);
                
                if (result.success) { 
					
					component.set("v.cargandoImagen", false);
					component.set("v.consultaExitosa", true);

                    ///
					component.set("v.fileDownload", 'data:application/pdf;base64,' + result.resultApiGee.document.fileBase64);
					component.set("v.pdfData", result.resultApiGee.document.fileBase64);
					
                } else {

					component.set("v.cargandoImagen", false);
					component.set("v.consultaExitosa", false);
                	this.showToast("Ha ocurrido un error en el MS APIGee", "Favor de reportarlo a su administrador", "warning");
				}


            } else {

                component.set("v.cargandoImagen", false);
				component.set("v.consultaExitosa", false);
                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }

        });

        $A.enqueueAction(action);

	}
})