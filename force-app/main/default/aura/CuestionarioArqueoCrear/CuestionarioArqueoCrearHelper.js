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
                        component.set("v.pasoDocumentReady",true);
                        
                    }
                }
                else{
                    component.set("v.pasoDocumentReady",true);
                }
            }  
        });  
        $A.enqueueAction(action); 
    },
    getComments : function(component) {
        var comentariosPrivada = component.get("v.simpleNewCuestionario.Privada_Comentarios__c");
        var comentariosMC = component.get("v.simpleNewCuestionario.MC_Comentarios__c");
        var comentariosErrorPrivada = component.get("v.simpleNewCuestionario.Error_Privada_Comentarios__c");
        var comentariosErrorMC = component.get("v.simpleNewCuestionario.Error_MC_Comentarios__c");
        var comentariosMCCL = component.get("v.simpleNewCuestionario.MC_CONTACLESS_Comentarios__c");
        var comentariosErrorMCCL = component.get("v.simpleNewCuestionario.Error_MC_CONTACLESS_Comentarios__c");
        if(comentariosPrivada != null){
            var privadaComments = [];
            if(comentariosPrivada.includes(",")){
              	privadaComments =  comentariosPrivada.split(',');
            }
            else{
                privadaComments[0] = comentariosPrivada;
            }    
            component.set('v.PrivadaComentarios',privadaComments);
        }
        if(comentariosMC != null){
            var comentariosMCArr = [];
            if(comentariosMC.includes(",")){
              	comentariosMCArr =  comentariosMC.split(',');
            }
            else{
                comentariosMCArr[0] = comentariosMC;
            }    
            component.set('v.comentariosMC',comentariosMCArr);
        }
        if(comentariosErrorPrivada != null){
            var comentariosErrorPrivadaArr = [];
            if(comentariosErrorPrivada.includes(",")){
              	comentariosErrorPrivadaArr =  comentariosErrorPrivada.split(',');
            }
            else{
                comentariosErrorPrivadaArr[0] = comentariosErrorPrivada;
            }    
            component.set('v.comentariosErrorPrivada',comentariosErrorPrivadaArr);
        }
        if(comentariosErrorMC != null){
            var comentariosErrorMCArr = [];
            if(comentariosErrorMC.includes(",")){
              	comentariosErrorMCArr =  comentariosErrorMC.split(',');
            }
            else{
                comentariosErrorMCArr[0] = comentariosErrorMC;
            }    
            component.set('v.comentariosErrorMC',comentariosErrorMCArr);
        }
        if(comentariosMCCL != null){
            var comentariosMCCLArr = [];
            if(comentariosMCCL.includes(",")){
              	comentariosMCCLArr =  comentariosMCCL.split(',');
            }
            else{
                comentariosMCCLArr[0] = comentariosMCCL;
            }    
            component.set('v.comentariosMCCL',comentariosMCCLArr);
        }
        if(comentariosErrorMCCL != null){
            var comentariosErrorMCCLArr = [];
            if(comentariosErrorMCCL.includes(",")){
              	comentariosErrorMCCLArr =  comentariosErrorMCCL.split(',');
            }
            else{
                comentariosErrorMCCLArr[0] = comentariosErrorMCCL;
            }    
            component.set('v.comentariosErrorMCCL',comentariosErrorMCCLArr);
        }
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
        console.log('component.get("v.recordId") ',component.get("v.recordId") );
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
                    component.set("v.steps",6);
                    if(component.get("v.simpleNewCuestionario.Status__c")=='Completado'){
                        component.set("v.steps",6);
                    }
                    else{
                        component.set("v.steps",7);
                    }
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
        var PrivadaComentarios = component.get("v.PrivadaComentarios");
        var PrivadaComentariosString = '';
        if(PrivadaComentarios != undefined && PrivadaComentarios != null){
        	for(var i=0; i<PrivadaComentarios.length;i++){
                if(i+1!=PrivadaComentarios.length){
                    PrivadaComentariosString+=PrivadaComentarios[i]+',';
                }
                else{
                    PrivadaComentariosString+=PrivadaComentarios[i]
                }
        	}
            component.set("v.simpleNewCuestionario.Privada_Comentarios__c", PrivadaComentariosString);
        }
        var comentariosMC = component.get("v.comentariosMC");
        var comentariosMCString = '';
        if(comentariosMC != undefined && comentariosMC != null){
        	for(var i=0; i<comentariosMC.length;i++){
                if(i+1!=comentariosMC.length){
                    comentariosMCString+=comentariosMC[i]+',';
                }
                else{
                    comentariosMCString+=comentariosMC[i]
                }
        	}
            component.set("v.simpleNewCuestionario.MC_Comentarios__c", comentariosMCString);
        }
        var comentariosErrorPrivada = component.get("v.comentariosErrorPrivada");
        var comentariosErrorPrivadaString = '';
        if(comentariosErrorPrivada != undefined && comentariosErrorPrivada != null){
        	for(var i=0; i<comentariosErrorPrivada.length;i++){
                if(i+1!=comentariosErrorPrivada.length){
                    comentariosErrorPrivadaString+=comentariosErrorPrivada[i]+',';
                }
                else{
                    comentariosErrorPrivadaString+=comentariosErrorPrivada[i]
                }
        	}
            component.set("v.simpleNewCuestionario.Error_Privada_Comentarios__c", comentariosErrorPrivadaString);
        }
        var comentariosErrorMC = component.get("v.comentariosErrorMC");
        var comentariosErrorMCString = '';
        if(comentariosErrorMC != undefined && comentariosErrorMC != null){
        	for(var i=0; i<comentariosErrorMC.length;i++){
                if(i+1!=comentariosErrorMC.length){
                    comentariosErrorMCString+=comentariosErrorMC[i]+',';
                }
                else{
                    comentariosErrorMCString+=comentariosErrorMC[i]
                }
        	}
            component.set("v.simpleNewCuestionario.Error_MC_Comentarios__c", comentariosErrorMCString);
        }
        var comentariosMCCL = component.get("v.comentariosMCCL");
        var comentariosMCCLString = '';
        if(comentariosMCCL != undefined && comentariosMCCL != null){
        	for(var i=0; i<comentariosMCCL.length;i++){
                if(i+1!=comentariosMCCL.length){
                    comentariosMCCLString+=comentariosMCCL[i]+',';
                }
                else{
                    comentariosMCCLString+=comentariosMCCL[i]
                }
        	}
            component.set("v.simpleNewCuestionario.MC_CONTACLESS_Comentarios__c", comentariosMCCLString);
        }
        var comentariosErrorMCCL = component.get("v.comentariosErrorMCCL");
        var comentariosErrorMCCLString = '';
        if(comentariosErrorMCCL != undefined && comentariosErrorMCCL != null){
        	for(var i=0; i<comentariosErrorMCCL.length;i++){
                if(i+1!=comentariosErrorMCCL.length){
                    comentariosErrorMCCLString+=comentariosErrorMCCL[i]+',';
                }
                else{
                    comentariosErrorMCCLString+=comentariosErrorMCCL[i]
                }
        	}
            component.set("v.simpleNewCuestionario.Error_MC_CONTACLESS_Comentarios__c", comentariosErrorMCCLString);
        }
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
                console.log("last ",component.get("v.simpleNewCuestionario.El_personal_est_ubicado_de_manera_dist__c"));
                if(component.get("v.simpleNewCuestionario.El_personal_est_ubicado_de_manera_dist__c") != null){
                    component.set("v.simpleNewCuestionario.Status__c", "Completado");
                    console.log('status final',component.get("v.simpleNewCuestionario.Status__c"));
                }
            }
        }
        console.log('v.simpleNewCuestionario.MapUploadImage__c ',mapString);
        console.log('v.simpleNewCuestionario.El_personal_est_ubicado_de_manera_dist__c ',component.get("v.simpleNewCuestionario.El_personal_est_ubicado_de_manera_dist__c"));
        
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