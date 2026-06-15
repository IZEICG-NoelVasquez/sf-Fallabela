({
    doInit : function(component, event, helper) {

        component.set("v.cargandoRecordData", true);

        helper.getCaseInfo(component);
    },

    consultar : function(component, event, helper) {

        component.set("v.consultando",true);
        helper.consultarDatos(component);
    },

    closeModalConsulta : function(component, event, helper) {

        component.set("v.openModalConsulta", false);

    }
})