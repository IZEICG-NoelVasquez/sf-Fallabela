({
	getDataHelper : function(component, event, helper) {
        
        var currentTime = new Date();
        var year = currentTime.getFullYear();

        //component.set("v.currentYear",year);

        /**************************/
        var action = component.get("c.anioActualTEST");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var anioActual =  response.getReturnValue();
                component.set("v.currentYear",anioActual);        
                console.log(anioActual);
            }        
        });
        $A.enqueueAction(action);
        /**************************/
        

        ///
        var idSolicitud = '85159558';
        var tipoReporte = 'B';

        var action = component.get("c.getJSON");
        action.setParams({
            "idSolicitud" : idSolicitud,
            "tipoReporte" : tipoReporte
		});        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var persona =  response.getReturnValue();
                component.set("v.Persona",persona);
        
                console.log(persona);
                console.log(persona.ScoreBuroCredito);
               
            }
        
        });
        $A.enqueueAction(action);
    }
})