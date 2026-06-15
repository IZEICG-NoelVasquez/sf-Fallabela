({
	handleStepChange : function (component, event, helper) {
		
        var recordId = component.get("v.recordId");
		var step = event.getParam("step");
        var attributes = event.getParam("attributes");
		
        //console.log("attributes", JSON.stringify(attributes));
        
        if (attributes) {
            
            var esClienteAnonimo = attributes.esClienteAnonimo;
            var clienteAnonimo = attributes.clienteAnonimo;
            var numeroDeTarjetaValueProducto = attributes.reclamoId;
            var isMovimiento = attributes.isMovimiento;
            var movimientosList = attributes.movimientosList;
            
            component.set("v.esClienteAnonimo", esClienteAnonimo);
            component.set("v.clienteAnonimo", clienteAnonimo);
            component.set("v.numeroDeTarjetaValueProducto", numeroDeTarjetaValueProducto);
            component.set("v.isMovimiento", isMovimiento);
            component.set("v.movimientosList", movimientosList);
            
        }
        
       if (step == 1 && recordId) {
        	component.set("v.step", 2);    
        } else  if (step == 1) {
            component.set("v.authCurp", null);
            component.set("v.step", step);
        } else {
            component.set("v.step", step);
        }

	},
	
	handleSelectedEvent : function (component, event, helper) {

        /// Se Valida si se esta asignando un registro de Cuenta
        var selectedAccount = [];
        selectedAccount = event.getParam("selectedObject");
        if( selectedAccount.Id && selectedAccount.Id.startsWith('001') ) {
            component.set("v.selectedAccount", event.getParam("selectedObject"));
        }

	},
    
    doInit : function(component, event, helper) {
        
		var recordId = component.get("v.recordId");
        if (recordId!=null) {
            helper.loadAccount(component, recordId);
        } else {
            component.set("v.step",1);
        }        
        
        var pageReference = component.get("v.pageReference");
        
        if (pageReference) {
            
            var curp = pageReference.state.c__authCurp; 
            var step = component.get("v.step");   
            
            var authCurp = component.get("v.authCurp");

            /// Variables para Re-dirigor al Autenticador desde un registro de Caso
            var idAcc = pageReference.state.c__idAcc;
            var fechaNac = pageReference.state.c__fechaNac;
            
            if(curp) {
                if (curp != authCurp && step === 1) {
                    component.set("v.authCurp", curp);
                    helper.loadAccountByCurp(component, curp);
                }
            } else if(idAcc && fechaNac) {
                component.set("v.idAcc", idAcc);
                component.set("v.fechaNac", fechaNac);
                /// Re-dirigir al Autenticador desde un registro de Caso
                helper.loadAccountByIdAcc(component, idAcc, fechaNac);
            }
            
        }
        
        
	},
    handleAuthByCurpStateAppEvent : function(component, event, helper) {

        ///
        /*console.log("handleAuthByCurpStateAppEvent ***");
        var curp = event.getParam('curp'); 
        var step = component.get("v.step");   
        
        var authCurp = component.get("v.authCurp");

        if (curp != authCurp && step === 1) {
            component.set("v.authCurp", curp);
            helper.loadAccountByCurp(component, curp);
        }*/
    },
    actualizar : function(component, event, helper) {
    	/*var initialCmp = component.find("authInitial");
    	component.set("v.selectedAccount", null);
        initialCmp.set("v.lookupobj", null);
        initialCmp.set("v.lookupId", null);
        initialCmp.selectRecord('', null);
        
        var pageReference = component.get("v.pageReference");
        
        if (pageReference) {
            
            var curp = pageReference.state.c__authCurp; 
            var step = component.get("v.step");   
            
            var authCurp = component.get("v.authCurp");
    
            if (curp != authCurp && step === 1) {
                component.set("v.authCurp", curp);
                helper.loadAccountByCurp(component, curp);
            }
            
        }*/
	}
})