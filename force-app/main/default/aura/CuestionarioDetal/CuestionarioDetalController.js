({
    doInit: function(component, event, helper) {
       helper.doInit(component, event);
        helper.getRecordTypes(component, event);
       
    },
    handleSaveCuestionario: function (component, event, helper) {
        helper.handleSave(component, event);
    }
    
});