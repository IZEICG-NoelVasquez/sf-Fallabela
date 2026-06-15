({
    doInit : function (component, event, helper) {
    } ,
     handleSelect : function (component, event, helper) {

        var stepName = event.getParam("detail").value;    
        component.set("v.caseStatus", stepName);
    }, handleSubmit : function(cmp, event, helper) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.getParam('fields');
       console.log('fields'+fields);
        // fields.LastName = 'My Custom Last Name'; // modify a field
        // cmp.find('myRecordForm').submit(fields);
    },
    changeStatus : function(component, event, helper) {

        var caseRecord = component.get("v.caseRecord");
        component.set("v.caseStatus", caseRecord.Status);
    }
})