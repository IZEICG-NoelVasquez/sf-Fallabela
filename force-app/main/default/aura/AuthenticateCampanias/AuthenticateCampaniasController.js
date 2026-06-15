({
	doInit : function (component, event, helper) {
		helper.cargarCampaigns(component);
		helper.obtenerNombresCampanias(component);
	},
	setDescription : function(component, event, helper){
        var campaignid = event.currentTarget.id;
        document.getElementById('1'+campaignid).style.display="";
        var contents = document.getElementsByClassName("slds-p-horizontal_small");
        for (var i=0; i<contents.length; i++) {
            var rect = contents[i].getBoundingClientRect();
            var recttop = rect.top;
            var scrollTop = contents[i].scrollTop;
            var scrollHeight = contents[i].scrollHeight;
        }
        document.getElementById('1'+campaignid).style.top=(event.clientY-243+(307-recttop))+'px';
    },
    closePop : function(component, event, helper) {
        var campaignid = event.currentTarget.id;
        document.getElementById('1'+campaignid).style.display="none";
    
	},
	openModal : function(component, event, helper) {

		///
		if( component.get("v.openModalAumentoLinea") ) {
			console.log("MODAL Abierto");
			return;
		}

		var productoSeleccionado = component.get("v.productoSeleccionado");

		var campaniaEmail = component.get("v.campaniaEmail");
		var campaniaSMS = component.get("v.campaniaSMS");

		var campaignName = event.currentTarget.name;
		console.log("campaignName:  ", campaignName);
		
		if( campaniaEmail == campaignName ) {

			if( productoSeleccionado != undefined && productoSeleccionado != null && productoSeleccionado >= 0 ) {

				component.set("v.openModalAumentoLinea", true);
				component.set(" v.loadingConsultaCupo ", true);
				component.set("v.blnAumentoDeLinea", true);
			} else {

				helper.showToast("Accion Requerida", "Debe Seleccionar una Tarjeta de Credito", "warning");
			}
			
		} else if( campaniaSMS == campaignName ) {

			if( productoSeleccionado != undefined && productoSeleccionado != null && productoSeleccionado >= 0 ) {

				component.set("v.openModalAumentoLinea", true);
				component.set(" v.loadingConsultaCupo ", true);
				component.set("v.blnAumentoDeLinea", false);
			} else {

				helper.showToast("Accion Requerida", "Debe Seleccionar una Tarjeta de Credito", "warning");
			}			
		}		
		
	}
	
})