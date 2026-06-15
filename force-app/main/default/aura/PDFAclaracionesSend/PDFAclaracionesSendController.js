({
    doInit : function (component, event, helper) {

        component.set("v.infoPerfilLoaded", false);
        helper.getUserInfo(component);
    },

    openModalPDF : function(component, event, helper) {

        var tarjetaform = component.find("tarjetaform");
        var validity = tarjetaform.get("v.validity");
        var tarjeta = tarjetaform.get('v.value');

        if( validity.valid ) {

            ///
            component.set("v.movimientosLoaded", false);
            helper.getMovimientos(component, tarjeta, false);

        } else {

            helper.showToast("Accion Requerida","Por favor ingrese los 16 digitos de la tarjeta", "warning" );
        }
    },

    sendMail: function(component, event, helper) {
        component.find("forceRecord").reloadRecord();
        
        var validity = component.find("tarjetaform").get("v.validity");
        console.log("valid: " + validity.valid)
        
        if(validity.valid) {

            ///
            component.set("v.movimientosLoaded", false);
            helper.getMovimientos(component, null, true);

        } else {

            helper.showToast("Accion Requerida","Por favor ingrese los 16 digitos de la tarjeta", "warning" );
        }
        
    },
    CheckLength : function(component, event, helper) {
        var val = component.find("tarjetaform").get('v.value');
        if(val.length > 16){
            var comp = component.find("tarjetaform");
            comp.set('v.value',val.substring(0,16));
        }
    }
    
})