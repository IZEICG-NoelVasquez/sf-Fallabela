({
	loadbandejaBackOfficeList : function(component) {

        ///
        var dataUpdateOptions = [];
        var dataUpdateList = component.get("v.dataUpdateList");

        for(var i = 0; i < dataUpdateList.length; i ++ ) {

			dataUpdateOptions.push({label:dataUpdateList[i], value:dataUpdateList[i]});
		}

        component.set("v.dataUpdateValue", dataUpdateList[0]);
		component.set("v.dataUpdateOptions", dataUpdateOptions);
	},

    showToast : function(title, message, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    validateIdRequest : function(field) {

        var regex = /^([0-9])*$/,
            validate = field.match(regex);

        return validate;
    },

    validarCampoVacio : function(campo) {

        if( campo == undefined || campo == null || campo == '' ) {
            
            return true;
        } else {

            return false;
        }
    },
    
    crearCasoBO : function(component, mapCamposCreateData) {

        console.log('mapCamposCreateData:  ', mapCamposCreateData);

        var action = component.get("c.crearCasoBackOffice");
        action.setParams({
            "campos" : mapCamposCreateData
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log('crearCasoBackOffice - state:  ', state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('crearCasoBackOffice - result:  ', result);

                if (result.success) { 
                    
                    this.limpiarCampos(component);
                    this.showToast("", "Se creo el caso con éxito", "success");

                } else if( result.errorMessage && result.errorMessage == 'No_se_encontro_la_solicitud' ) {

                    this.showToast("", "No se encontró la solicitud en Onboarding", "error");

                } else if( result.errorMessage && result.errorMessage == 'Solicitud_formalizada' ) {

                    this.showToast("No es posible realizar un cambio de estado", "El cliente ya cuenta con tarjeta Falabella.", "error");

                } else if( result.errorMessage && result.errorMessage == 'No_se_encontro_numero_llamada_f2' ) {

                    this.showToast("", "La solicitud no se encuentra en un estado correspondiente para el cambio", "error");

                } else {

                    this.showToast("", "Ocurrió un error al crear el caso", "error");
                }

                component.set("v.creadoCaso", false);

            } else {

                component.set("v.creadoCaso", false);
                this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
            }
        });

        $A.enqueueAction(action);
    },

    limpiarCampos : function(component) {

        component.set("v.cardapplicationid", '');
        component.set("v.mapCamposCreateData", {});

        var dataUpdateList = component.get("v.dataUpdateList");
        component.set("v.dataUpdateValue", dataUpdateList[0]);
        component.set("v.commetsValue", '');
    }	
})