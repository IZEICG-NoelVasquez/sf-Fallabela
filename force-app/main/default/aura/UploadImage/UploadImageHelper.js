({
	showToast : function(title, message, type) {  
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({        
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    getuploadedFiles:function(component){
        var action = component.get("c.getPhotos");  
        action.setParams({  
            "documentId":component.get("v.documentId")  
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
           console.log('getupload1 ',state);
            if(state=='SUCCESS'){  
                console.log('getupload2 ',state);
                var result = response.getReturnValue(); 
                if(result != null){
                    if(result[0] != null){
                     	component.set("v.FotoCargada",true);  
                    }
                component.set("v.files",result); 
                }
            }  
        });  
        $A.enqueueAction(action);  
    },
    
    delUploadedfiles : function(component,documentId) {  
        var action = component.get("c.deletePhoto");           
        action.setParams({
            "sdocumentId":documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                this.getuploadedFiles(component);
                component.set("v.Spinner", false); 
            }  
        });  
        $A.enqueueAction(action);  
    }
})