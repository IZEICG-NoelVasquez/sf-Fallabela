({
    doInit:function(component,event,helper){ 
        helper.doInitHelper(component);   
        helper.getOTPValidado(component);
        helper.getComments(component);
        var sucursal = component.get("v.simpleNewCuestionario.Sucursal__c");  
        if(sucursal != null){
            helper.PhoneSucursal(component);
        }
        else{
            var DesdeFlujo = component.get("v.DesdeFlujo");
            if(DesdeFlujo == false){
                helper.getStatus(component);
            }
        }
    },
    handleNext : function(component, event, helper) {
        var paso = component.get("v.paso");
        paso = paso +1;
        component.set("v.paso",paso); 
    },
    handleAtras : function(component, event, helper) {
        var paso = component.get("v.paso");
        paso = paso -1;
        component.set("v.paso",paso);         
    },
    handlePasoOTP : function(component, event, helper) {  
        var paso = component.get("v.paso");
        paso = paso +1;
        component.set("v.paso",paso); 
    },
    handleEnviar : function(component, event, helper) {
        helper.EnviarOTP(component);
    },
    handleValidar : function(component, event, helper) {
        helper.ValidarOTP(component);
    },
    handleFinish : function(component, event, helper) {
        helper.finish(component);
        
    },
    handleUploadImageEvent : function(component, event, helper){
        var pasoEvent = event.getParam("pasoEvent");
        var documentIdEvent = event.getParam("documentIdEvent");
        console.log('pasoEvent ',pasoEvent);
        console.log('documentIdEvent ',documentIdEvent);
        var mapPasoDocument = component.get("v.pasoDocument");
        console.log('mapPasoDocument1 ',mapPasoDocument);
        mapPasoDocument['paso'+pasoEvent] = documentIdEvent;
        
        console.log('mapPasoDocument2 ',mapPasoDocument);
        component.set("v.pasoDocument",mapPasoDocument);
        
        console.log('pasoDocument ',mapPasoDocument['paso'+pasoEvent]);
        
    }
})