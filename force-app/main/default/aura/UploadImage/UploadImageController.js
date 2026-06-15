({
    handlerCuestionarioIdEvent:function(component,event,helper){
    	var recordId = event.getParam("CuestionarioRecordId");
        console.log('recordId from handler event ',recordId);
        component.set("v.recordId", recordId);
	},
    doInit:function(component,event,helper){ 
        console.log('recid ',component.get("v.recordId"));
        console.log('document id ',component.get("v.documentId"));
        if(component.get("v.documentId") != null){
            helper.getuploadedFiles(component);
        }
    },   
     handleStatusChange : function (component, event) {
         console.log('handle flow status ');
         console.log('status ',event.getParam("status"));
         var outputVariables = event.getParam("outputVariables");
         var outputVar;
         console.log('outputVar ',outputVar);
      if(event.getParam("status") === "FINISHED") {
         // Get the output variables and iterate over them
         var outputVariables = event.getParam("outputVariables");
         var outputVar;
         console.log('outputVar ',outputVar);
      }
   },
    previewFile :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    handleUploadFinished: function (component, event) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var validado = false;
        console.log('name ',uploadedFiles[0].name);
        console.log('name length ',uploadedFiles[0].name.length);
        console.log('documentId ',documentId);
        if(uploadedFiles[0].name == 'image' || uploadedFiles[0].name == 'image.jpg'){
            validado = true;
        }
        else{
            if(uploadedFiles[0].name.length == 38 || uploadedFiles[0].name.length == 34){
                var name32 = uploadedFiles[0].name.substring(0, 32);
                console.log('name32',name32);
                
                
                var today = new Date();
                var mes;
                var dia;
                var hora;
                var minutos;
                var minutos2;
                var hora2;
                if((today.getMonth()+1)>=10){
                    mes = today.getMonth()+1;
                }
                else{
                    mes = '0'+(today.getMonth()+1);
                }
                if(today.getDate()>=10){
                    dia = today.getDate();
                }
                else{
                    dia = '0'+today.getDate();
                }
                if(today.getHours()>=10){
                    hora = today.getHours();
                }
                else{
                    hora = '0'+today.getHours();
                }
                hora2 = hora;
                if(today.getMinutes()>=10){
                    minutos = today.getMinutes();
                    minutos2 = minutos-1;
                }
                else{
                    minutos = '0'+today.getMinutes();
                    if(minutos == '00'){
                        minutos2 = '59';
                        if(today.getHours()>10){
                            hora2 = hora-1;
                        }
                        else{
                            if(hora == '10'){
                                hora2 =='09';
                            }
                            else if(today.getHours()<10){
                                if(today.getHours() == 0){
                                    hora2 = '23';
                                }
                                else{
                                    hora2 = '0'+(today.getHours()-1);
                                }
                            }
                        }
                    }
                    else{
                        minutos2 = '0'+(today.getMinutes()-1);
                    }
                }
                var date = '_lastCapturedImage_'+today.getFullYear()+mes+dia+'_'+hora+minutos;
                var date2 = '_lastCapturedImage_'+today.getFullYear()+mes+dia+'_'+hora2+minutos2;
                console.log('date ',date);    
                console.log('date2 ',date2);   
                if(name32 == date || name32 == date2){
                    validado = true;
                    console.log('validado!!!');
                }
            }
        }
        if(validado == true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({        
                "title": "Carga Exitosa",
                "message": "La foto se ha guardado correctamente",
                "type": "success"
            });
            toastEvent.fire();
            var paso =component.get("v.paso");
            var evt = component.getEvent("UploadImageEvent");
            evt.setParams({
                "documentIdEvent" : documentId,
                "pasoEvent" : paso
            });        
            evt.fire();
            var action = component.get("c.getPhotos");  
            action.setParams({  
                "documentId":documentId
            });      
            action.setCallback(this,function(response){  
                var state = response.getState();  
                if(state=='SUCCESS'){  
                    var result = response.getReturnValue();  
                    component.set("v.files",result);  
                    component.set("v.FotoCargada",true);  

                }  
            });  
            $A.enqueueAction(action);  
            //	helper.showToast("Carga Exitosa", "La foto se ha guardado correctamente", "success");
        }
        else if (validado == false){
            //alert("imagen no se cargó1");
            
            //Se eliminará la imagen
            var action = component.get("c.deleteImage");
            action.setParams({
                "documentId": documentId
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    var acc = response.getReturnValue();
                    //   helper.showToast("Error","La foto debe ser tomadajusto ahora, no de la galeria", "error");
                }
            });
            $A.enqueueAction(action);  
            
            var toastEvent2 = $A.get("e.force:showToast");
            toastEvent2.setParams({        
                "title": "Error",
                "message": "La foto debe ser tomada justo ahora, no de la galeria",
                "type": "error"
            });    
            toastEvent2.fire();
            //alert("La foto debe ser tomadajusto ahora, no de la galeria");
        }
        console.log('result ',validado); 
    },
    delFiles:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    }
});