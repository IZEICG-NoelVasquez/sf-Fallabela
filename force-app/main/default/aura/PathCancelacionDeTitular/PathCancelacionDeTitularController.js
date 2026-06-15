({
    doInit : function (component, event, helper) {

        /// Visualizar Casos Cerrados
        component.set("v.caseClosed", false);
        
        component.set("v.caseInfoLoaded", false);
        helper.getPickListValues(component);
    },

    changeSubGrupo : function (component, event, helper) {

        var subgrupoValue = component.get("v.subgrupoValue");

        helper.setMotivoRetencionOptions(component, subgrupoValue);
    },

    saveRecord : function (component, event, helper) {

        component.set("v.savingRecord", true);
        
        helper.updateCase(component);
    },

    handleSelect : function (component, event, helper) {

        var stepName = event.getParam("detail").value;    
        component.set("v.caseStatus", stepName);
    },

    changeStatus : function(component, event, helper) {

        var caseRecord = component.get("v.caseRecord");
        component.set("v.caseStatus", caseRecord.Status);
    }
})