({

    doInit : function (component, event, helper) {

        component.set("v.cargandoRecordData", true);

        helper.getUserInfo(component);
    },

    actualizar : function(component,event,helper) {

        component.set("v.actualizando", true);
        helper.actualizarTicket(component, event);   
    },

    closeModalActualizacion : function(component, event, helper) {

        component.set("v.cargandoRecordData", true);
        component.set("v.openModalActualizacion", false);
    }
})