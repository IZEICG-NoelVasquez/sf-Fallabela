({
	doInit: function (component, event, helper) {

        ///
        component.set("v.categoriasLoaded", false);
        
        helper.loadCatOptions(component);
        helper.loadCaseRTypes(component);
        helper.loadMainFields(component);
        
        /// Generacion de URL para Re-dirigir al Autenticador
        var showPanel = component.get("v.showPanel");
        if( !showPanel ) {
            var selectedAccount = component.get("v.selectedAccount");
            var navService = component.find("navService");
            var pageReference = {
                type: 'standard__component',
                "attributes": {
                    "componentName": "c__AuthenticateCustomer"
                    },
                    "state": {
                    "c__idAcc": selectedAccount.Id,
                    "c__fechaNac": selectedAccount.Fecha_de_nacimiento1__c
                    }
            };
            component.set("v.pageReference", pageReference);
            var defaultUrl = "#";
            navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
        }
    },
    
    handleOTPState : function (component, event, helper) {
        
        console.log("handleOTPState");
        
        var state = event.getParam('state');
        var mode = event.getParam('mode');
        var phone = event.getParam('phone');
        var recordId = event.getParam('recordId');
        
        
        
        var currentId = component.get("v.recordId");
        console.log("Record id progress:",currentId );
        
        if (recordId === currentId) {
            helper.setModalState(component, state);
            helper.setModalMode(component, mode);
            helper.setModalPhone(component, phone);
        }
        
        
        
        
    },
     /******************************************************************************************
    Método que maneja el Evento que se ejecuta desde el componente validateQuestions
    Si hay coincidencia crea el caso, si no cierra el panel
    *******************************************************************************************/
    handlevalidateQuestionsE : function(component, event, helper){
        var coincidencia1 = event.getParam("coincidencia");
        if(coincidencia1 == true){
            component.set("v.showPanel",false);
            helper.createCaseValidate(component);
        }
        else{
            console.log('incorrecto2');
           // component.set("v.showPanel",false);
            helper.fireStepChange(component, 2);

        }
    },
    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
        var mode = event.getParam("mode");
		var validatedRecordId = event.getParam("validatedRecordId");
		
        component.set("v.verificadoOTP", isValid);
        
        if (mode === "case") {
        	
            // actualizar caso
        	helper.updateCase(component, validatedRecordId, isValid);
            
        } else if (mode === "casePAN") {
            helper.updateCasePAN(component, validatedRecordId, isValid);
        }

    },

    changeCategory : function (component, event, helper) {

        ///
        component.find("subCategoria").set("v.value", '');
        component.set("v.subCatSelected", null);

        ///
        component.set("v.subCategoriasLoaded", false);

		var category = component.find("categoria");
    	helper.loadSubOptions(component, category.get("v.value"));

    },

    changeSubCategory : function (component, event, helper) {

        var subCategory = component.find("subCategoria").get("v.value");
        component.set("v.subCatSelected", subCategory);

    },

    handleCancel : function (component, event, helper) {

        helper.fireStepChange(component, 1);

    },

    handleCreateTicket : function (component, event, helper) {

    	helper.doCreateCase(component);
    	
    },
    
    handleRetipificar : function (component, event, helper) {

    	helper.doCreateCase(component, true);
    	
    },
    
    handleSendOTP : function (component, event, helper) {

        helper.fireStepChange(component, 4);
    	
    },

    display : function(component, event, helper) {

        var tooltip = component.find("tooltip");

        $A.util.addClass(tooltip, "slds-rise-from-ground");
        $A.util.removeClass(tooltip, "slds-fall-into-ground");
    
    },

    displayOut : function(component, event, helper) {

        var tooltip = component.find("tooltip");

        $A.util.removeClass(tooltip, "slds-rise-from-ground");
        $A.util.addClass(tooltip, "slds-fall-into-ground");

    },

    navigateToPersonAccount : function (component, event, helper) {
        
        var selectedAccount = component.get("v.selectedAccount");
        helper.navigateToSObject(selectedAccount.Id);
        
    },
    
    handleMovChange : function (component, event, helper) {
        var isMovimiento = component.get("v.isMovimiento");
        var movimientosList = component.get("v.movimientosList");
        
        console.log("Hello from Authenticate Success");
        console.log("isSelectedMovimiento", isMovimiento);
        console.log("movimientosList", movimientosList);
        helper.loadCatOptions(component);
        helper.loadCaseRTypes(component);
        
    }


})