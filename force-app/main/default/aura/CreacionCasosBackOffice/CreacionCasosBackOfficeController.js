({
	doInit : function(component, event, helper) {

		helper.loadbandejaBackOfficeList(component);
	},

	clearField : function(component, event, helper) {

		var character = event.which;
		console.log("caracter:  ", character);

		var allowedCharacters = component.get("v.allowedCharacters");

		if( !allowedCharacters.includes(character) ) {

			event.preventDefault();
		}
	},

	crearTicket : function(component, event, helper) {

		var cardapplicationid = component.get("v.cardapplicationid");

		component.set("v.mapCamposCreateData", {});
		
		var mapCamposCreateData = component.get("v.mapCamposCreateData");

		if( helper.validarCampoVacio(component, cardapplicationid) ) {

			helper.showToast("Accion Requerida", "Favor de llenar los campos requeridos", "warning");
			return;

		}  else {

			if( helper.validateIdRequest(cardapplicationid) ) {

				mapCamposCreateData["cardapplicationid"] = cardapplicationid;

			} else {

				helper.showToast("Accion Requerida", "Favor de ingresar un Id de Solicitud valido", "warning");
				return;
			}			
		}

		var dataUpdateValue = component.get("v.dataUpdateValue");

		if( !helper.validarCampoVacio(dataUpdateValue) ) {

			mapCamposCreateData["dataUpdateValue"] = dataUpdateValue;
		}

		var commetsValue = component.get("v.commetsValue");

		if( !helper.validarCampoVacio(commetsValue) ) {

			mapCamposCreateData["commetsValue"] = commetsValue;
		}		

		component.set("v.creadoCaso", true);
		helper.crearCasoBO(component, mapCamposCreateData);
	}
})