({
    doInit : function(component, event, helper) {

        component.set("v.blnRecordCase", true);
        component.set("v.loadedRecordCaseInfo", false);

        component.set("v.infoGuiasLoaded", false);

        helper.getCaseRecordInfo(component);
    },

    allowedCharacters : function(component, event, helper) {

		var caracter = event.which;
		console.log("caracter:  ", caracter);

		var lstAllowedCharacters = component.get("v.lstAllowedCharacters");

		if( !lstAllowedCharacters.includes(caracter) ) {

			event.preventDefault();
		}
	},

    deleteField : function(component, event, helper) {

		console.log("deleteField");

		event.preventDefault();
	},

    searchGuiaDHL : function(component, event, helper) {

        var numberGuiaDhl = component.get("v.numberGuiaDhl");
        var curp = component.get("v.curp");

        var minimumLengthGuiaGHL = component.get("v.minimumLengthGuiaGHL");

        if( numberGuiaDhl && numberGuiaDhl.length >= minimumLengthGuiaGHL ) {

            /// Componente MicroServicioGuiaDHL
            var msGuiaDhl = component.find("msGuiaDhl");
            msGuiaDhl.set("v.GuiaDHL", numberGuiaDhl);
            msGuiaDhl.set("v.CURP", curp);

            msGuiaDhl.openDetailDHL();

        } else {

            helper.showToast("", "Por favor de introducir un numero de guia válido", "warning");
        }        
    }
})