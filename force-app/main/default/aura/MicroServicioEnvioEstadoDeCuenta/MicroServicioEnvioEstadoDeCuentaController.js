({
	openModalConfirmacion : function(component, event, helper) {

		component.set("v.blnOpenModalContactMethod", true);
	},

	closeModalEnvioEdoCta : function(component, event, helper) {

		component.set("v.openEnvioEdoCta", false);
	},

	confirmarReenvio : function(component, event, helper) {
		
		console.log("Confirmacion de Reenvio");

		var email_Text = component.get("v.email_Text");

		console.log("email_Text:  ", email_Text);

		if( email_Text && (email_Text.length > 0) ) {

			component.set("v.noPasoEnvioEdoCta", 2);
			component.set("v.loadingEnvioEdoCta", true);

			///
			helper.reenviarEdoCta(component);

		} else {

			helper.showToast("Accion Requerida", "No tiene correo registrado", "warning");
		}

		
	},

	handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            component.set("v.openEnvioEdoCta", true);
			component.set("v.noPasoEnvioEdoCta", 1);
		}
	}

})