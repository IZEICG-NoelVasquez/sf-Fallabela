({
	doInitHelper : function(component) {
        console.log('recid ',component.get("v.recordId"));
         var action = component.get("c.getRecordType");  
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
                	component.set("v.recordTypeName",result);
                    if(result == 'Zonales'){
                        component.set("v.rtZonales",true);
                    }
                    else{
                        component.set("v.rtArqueo",true);
                    }
                }
            }  
        });  
        $A.enqueueAction(action); 
    }
})