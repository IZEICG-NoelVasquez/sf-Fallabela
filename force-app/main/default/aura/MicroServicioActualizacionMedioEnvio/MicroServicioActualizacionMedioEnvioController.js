({
    confirmarMedioDeEnvio : function (component, event, helper) {

        component.set("v.noPasoMedioEnvio", 2);
    },

    guardarMedioDeEnvio : function (component, event, helper) {

        var movimientoIdx = component.get("v.movimientoIdx");
		var productos = component.get("v.productos");
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;

        var esprimario = component.get("v.blnEmail_TMP");

        component.set("v.noPasoMedioEnvio", 3);
        component.set("v.loadingMedioDeEnvio", true);

        helper.actualizarMedioDeEnvio(component, identificador, esprimario);
    },


    onWhatToUse: function(component, event) {
        var selected = event.currentTarget.value;
        component.set("v.whatToUse", selected);

        var emailSelected = event.currentTarget.id;
        ///
        component.set("v.medioEnvioSelected", true);
        if( emailSelected == 'remail' ) {
            component.set("v.blnEmail_TMP", true); 
        } else {
            component.set("v.blnEmail_TMP", false); 
        }

    },

    closeModalMedioDeEnvio : function(component, event, helper) {

        component.set("v.testClass", '');

        component.set("v.openMedioDeEnvio", false);
    },

    regresarModalEnvioUpdate : function(component, event, helper) {

        component.set("v.noPasoMedioEnvio", 1);
    }
})