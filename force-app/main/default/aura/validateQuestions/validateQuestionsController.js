({   
    doInit: function (component, event, helper) {       
        helper.getUserProfile(component);
        helper.validationTry(component);      
    },
    /******************************************************************************************
    Método para abrir y scerrar el Modal según el state
    *******************************************************************************************/
    doSetState : function (component, event, helper) {       
		var params = event.getParam('arguments');
        if (params) {            
            var state = params.state;           
            if (state === 'open') {              
                helper.openModal(component);               
            } else {               
                helper.closeModal(component);                
            }
        }       
    },    
    /******************************************************************************************
    Método para setear el Mode de aucerdo a los parametros recibidos
    *******************************************************************************************/
    doSetMode : function (component, event, helper) {       
		var params = event.getParam('arguments');
        if (params) {          
			component.set("v.mode", params.mode);			
        }      
    },   
    /******************************************************************************************
    Método para llamar al método helper que valida las respuestas ingresadas
    *******************************************************************************************/
    doValidate : function (component, event, helper) {
        console.log('validando...');
		helper.validateQuestions(component);        
    },  
    /******************************************************************************************
    Método para cerrar el modal
    *******************************************************************************************/  
    closeModal : function (component, event, helper) {
		helper.closeModal(component);
    },
    /******************************************************************************************
    Método para limitar el maximo de números ingresados en los inputs de Integer
    *******************************************************************************************/
    CheckLength : function(component, event, helper) {
        var val = component.find("DiaDeCorte").get('v.value');
        if(val.length > 2){
            var comp = component.find("DiaDeCorte");
            comp.set('v.value',val.substring(0,2));
        }
    },
    CheckLength2 : function(component, event, helper) {
        var val = component.find("DiaUltimoPago").get('v.value');
        if(val.length > 2){
            var comp = component.find("DiaUltimoPago");
            comp.set('v.value',val.substring(0,2));
        }
    },

    validatePreguntas : function(component, event) {

        var val = event.getSource().get("v.value");
        if(val){
            component.set('v.requiredFields', false);
        }else{
            component.set('v.requiredFields', true);
        }
        console.log('revisar la variable: ' + val);
    }
})