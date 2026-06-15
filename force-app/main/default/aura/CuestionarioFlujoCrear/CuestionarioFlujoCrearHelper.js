({
    doInitHelper : function(component) {
        console.log('recid ',component.get("v.recordId"));
        console.log('array document Id ',component.get("v.simpleNewCuestionario.MapUploadImage__c"));
        console.log('simplenew ',component.get("v.simpleNewCuestionario"));
        console.log('simplenew ',component.get("v.record"));
        var action = component.get("c.getArrayImage");  
        action.setParams({  
            "CuestionarioId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('getupload1 ',state);
            if(state=='SUCCESS'){  
                console.log('getupload2 ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                if(result != null){
                    if(result.includes(",")){
                        var documentArray =  result.split(',');
                        var mapPasoDocument = component.get("v.pasoDocument");
                        console.log('mapPasoDocument1 ',mapPasoDocument);
                        if(documentArray[0] != 'undefined'){
                            mapPasoDocument['paso2'] = documentArray[0];
                        }
                        if(documentArray[1] != 'undefined'){
                            mapPasoDocument['paso3'] = documentArray[1];
                        }
                        if(documentArray[2] != 'undefined'){
                            mapPasoDocument['paso4'] = documentArray[2];
                        }
                        if(documentArray[3] != 'undefined'){
                            mapPasoDocument['paso5'] = documentArray[3];
                        }
                        if(documentArray[4] != 'undefined'){
                            mapPasoDocument['paso6'] = documentArray[4];
                        }
                        if(documentArray[5] != 'undefined'){
                            mapPasoDocument['paso7'] = documentArray[5];
                        }
                        if(documentArray[6] != 'undefined'){
                            mapPasoDocument['paso8'] = documentArray[6];
                        }
                        if(documentArray[7] != 'undefined'){
                            mapPasoDocument['paso9'] = documentArray[7];
                        }
                        if(documentArray[8] != 'undefined'){
                            mapPasoDocument['paso10'] = documentArray[8];
                        }
                        if(documentArray[9] != 'undefined'){
                            mapPasoDocument['paso12'] = documentArray[9];
                        }
                        if(documentArray[10] != 'undefined'){
                            mapPasoDocument['paso15'] = documentArray[10];
                        }
                        console.log('mapPasoDocument ',mapPasoDocument);
                        component.set("v.pasoDocument",mapPasoDocument);
                    }
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    getStatus : function(component) {
          var action = component.get("c.getStatus");  
        action.setParams({  
            "cuestionarioId":component.get("v.recordId") 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('stat sp ',state);
            if(state=='SUCCESS'){  
                console.log('st sp ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                if(result != null){
                    var status =result;
                    console.log('status help ',status);
                    if(status == 'Pendiente'){
                        component.set("v.status",status);
                        this.getSucursal(component);
                    }
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    getSucursal : function(component) {
         var action = component.get("c.getSucursalRecord");  
        action.setParams({  
            "cuestionarioId":component.get("v.recordId") 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('stat sp ',state);
            if(state=='SUCCESS'){  
                console.log('st sp ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                if(result != null){
                    var sucurusal =result;
                    console.log('sucurusal ',sucurusal);
                    component.set("v.simpleNewCuestionario.Sucursal",sucurusal);
                    this.PhoneSucursal(component);
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    getOTPValidado : function(component) {
          var action = component.get("c.getValidadoOTP");  
        action.setParams({  
            "CuestionarioId":component.get("v.recordId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('GET OTP1 ',state);
            if(state=='SUCCESS'){  
                console.log('getOTP ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                if(result != null){
                	component.set("v.otpValidado",result);
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    PhoneSucursal  : function(component) {
        var action = component.get("c.getPhoneSucursal");  
        action.setParams({  
            "sucursal":component.get("v.simpleNewCuestionario.Sucursal__c") 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('stat sp ',state);
            if(state=='SUCCESS'){  
                console.log('st sp ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                if(result != null){
                    var phone = parseInt(result.replace(/[^0-9]/g, ''), 10);
                    console.log('phone1 ',phone);
                    component.set("v.telefono",phone);
                    component.set("v.pasos",4);
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    EnviarOTP : function(component) {
        var codigoOTP = Math.floor((Math.random() * 100000)+1);
        if(codigoOTP.legth ==4){
            codigoOTP = codigoOTP*10;
        }
        component.set("v.codigoOTP",codigoOTP);
        console.log('otp c ',component.get("v.codigoOTP"));
        var action = component.get("c.send_notification");  
        action.setParams({  
            "tipo": "SMS",
            "inicio": "C",
            "mensaje": "ódigo OTP: " +component.get("v.codigoOTP"),
            "numeroTelefono": component.get("v.telefono"),
            "codigoArea": "521"
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            console.log('stat sp ',state);
            if(state=='SUCCESS'){  
                console.log('st sp ',state);
                var result = response.getReturnValue(); 
                console.log('result ',result);
                this.showToast("Correcto", "OTP Enviado con éxito", "success");
                component.set("v.codigoEnviado",true);
            }
            else{
            	this.showToast("Error", "OTP No Enviado", "error");
            }
        });  
        $A.enqueueAction(action); 
    },
    ValidarOTP : function(component) {
        var codigoOTP = component.get("v.codigoOTP");
        var codigoOTPIngresado = component.get("v.codigoOTPIngresado");
        console.log('codigoOTPIngresado ',codigoOTPIngresado);
        console.log('codigoOTP ',codigoOTP);
        if(codigoOTP == codigoOTPIngresado){
        	this.showToast("Correcto", "OTP Validado con éxito", "success");
            component.set("v.simpleNewCuestionario.OTP_Validado__c", true);
            this.finish(component);
        }
        else{
           this.showToast("Error", "OTP no validado", "error");
        }
    },
    finish : function(component) {
        var mapPasoDocument = component.get("v.pasoDocument");
        console.log('handle finished ',mapPasoDocument.paso2);
        console.log('handle finished3 ',mapPasoDocument.paso3);
        var mapString = mapPasoDocument.paso2+','+mapPasoDocument.paso3+','+mapPasoDocument.paso4+','+mapPasoDocument.paso5+','+mapPasoDocument.paso6+','+mapPasoDocument.paso7+','+mapPasoDocument.paso8+','+mapPasoDocument.paso9+','+mapPasoDocument.paso10+','+mapPasoDocument.paso12+','+mapPasoDocument.paso15;
        component.set("v.simpleNewCuestionario.MapUploadImage__c", mapString);
        console.log('guardando status ',component.get("v.simpleNewCuestionario.Status__c"));
                console.log('guardando desde ',component.get("v.DesdeFlujo"));

        if(component.get("v.DesdeFlujo") == true){
        	component.set("v.simpleNewCuestionario.Status__c", "Completado");
        }
        else{
            console.log('status ',component.get("v.simpleNewCuestionario.Status__c"));
            if(component.get("v.simpleNewCuestionario.Status__c") == 'Pendiente'){
                console.log("last ",component.get("v.simpleNewCuestionario.Elas_cartas_de_destrucci_n_se_encuentra__c"));
                if(component.get("v.simpleNewCuestionario.Elas_cartas_de_destrucci_n_se_encuentra__c") != null){
                    component.set("v.simpleNewCuestionario.Status__c", 'Completado');
                    console.log('status final',component.get("v.simpleNewCuestionario.Status__c"));
                }
            }
        }
        console.log('v.simpleNewCuestionario.MapUploadImage__c ',mapString);
        console.log('v.simpleNewCuestionario.Promotores_y_Ejecutivos_saben_sus_metas__c ',component.get("v.simpleNewCuestionario.Promotores_y_Ejecutivos_saben_sus_metas__c"));
        
        console.log('simpleNewCuestionario a ',component.get("v.simpleNewCuestionario"));
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
                var recordId = component.get("v.recordId");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "Cuestionario__c"
                });
                navEvt.fire(); 
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                            JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    showToast : function(title, message, type) {  
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({        
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})