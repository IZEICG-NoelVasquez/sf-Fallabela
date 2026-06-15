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
    setModalState : function (component, state) {
        
        var otpModalCURPUpdate = component.find("otpModalCURPUpdate");
        otpModalCURPUpdate.setState(state);
        
    },
	validaCurp : function(component, curpUpdate) {
        if( curpUpdate != null && curpUpdate != '' ) {         
            if( this.validaFormatoCurp(curpUpdate) ) {
                this.validaCurpExiste(component, curpUpdate);         
            } else {
                this.showToast("Debe ingresar un Curp válido", "Por favor revisar el CURP" ,"info");
            }            
        } else {
            this.showToast("Debe ingresar un Curp", "No se permite el campo Curp vacío" ,"info");
        }
    },
    validaFormatoCurp : function (curpUpdate) {
        if(curpUpdate != null){
            if(curpUpdate.length == 18){
                var re = /[^A-Za-z 0-9]/g;
                var retorno = !re.test(String(curpUpdate));
                return retorno;
            }
            else{
                return false;
            }
        }
        else{
            return false;
        }
    }, 
    validaCurpExiste : function(component, curpUpdate){
        // component.set("v.productos", null);
        component.set("v.loadingCurpUpdate", true);
        var action = component.get("c.obtenerProductosCliente");
         action.setParams({
             "curp" : curpUpdate
         });  
         action.setCallback(this, function(response) {      
             var state = response.getState();  
             if (state === "SUCCESS") {  
                 var result = response.getReturnValue(); 
                 if (result.success) {  
                    var oRes = result.productos.message.tarjetaCredito;
                    console.log('oRes:  ', oRes);
                    if(oRes != null){
                        if(oRes.length >0){
                           // component.set("v.loadingCurpUpdate", false);  
                            component.set("v.curpUpdated", true);
                            //  component.set("v.loadingCurpUpdate", false);
                            component.set("v.noPasoCurpUpdate", 4);
                            component.set("v.loadingCurpUpdate", true);
                            this.showToast("Curp Duplicado", "El Curp Ingresado ya está asignado a otro Cliente" ,"info");
                            this.crearCasoCurpDuplicado(component, curpUpdate);
                            component.set("v.creatingCase", true);
                            component.set("v.loadingCurpUpdate", false);
                            //component.set("v.noPasoCurpUpdate", 2);
                        }
                        else{
                            component.set("v.loadingCurpUpdate", false);  
                            component.set("v.noPasoCurpUpdate", 2);
                        }  
                    }
                    else{
                        component.set("v.loadingCurpUpdate", false);  
                        component.set("v.noPasoCurpUpdate", 2);
                    }
                 } else if( !result.success && result.productos && result.productos.message && (result.productos.message == 'the curp is not correct') ) { 
                    /// Se agrega validacion para procesar el Mensaje de error que regresa el Micro Servicio 
                    this.showToast("Accion Requerida", "El CURP del cliente no cumple con el formato", "warning");
                    component.set("v.loadingCurpUpdate", false);
                 } else {
                     component.set("v.loadingCurpUpdate", false);
                     component.set("v.noPasoCurpUpdate", 2);
                     //this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                     //this.fireStepChange(component, 3);
                 }   
             } else if (state === "INCOMPLETE") {
                 console.log("Unknown error");
                 this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                 component.set("v.loadingCurpUpdate", false);
             } else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + 
                         errors[0].message);
                     }
                 } else {
                     console.log("Unknown error");
                 }
                 this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                 component.set("v.loadingCurpUpdate", false);
             }
         });
         $A.enqueueAction(action);
     },
    actualizarCurp : function(component, curpUpdate) {
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = component.get("v.strCurpAntes");
        var action = component.get("c.actualiza_Curp");        
        action.setParams({
            "numeroDocumento" : numeroDocumento,
            "newnumeroDocumento" : curpUpdate
		});
        action.setCallback(this, function(response) {         
            var state = response.getState();          
            if (state === "SUCCESS") {
                var result = response.getReturnValue();    
                if (result.success) {                     
                    component.set("v.curpUpdated", true);
                    component.set("v.loadingCurpUpdate", false);
                    this.crearCasoCurpUpdate(component, curpUpdate);
                    /// Se comenta asignacion de variable
                    /*if(curpUpdate != null){
                    	component.set("v.strCurpUpdate", curpUpdate);
                    }*/
                    component.set("v.creatingCase", true);
                } else {
                    component.set("v.curpUpdated", false);
                    component.set("v.loadingCurpUpdate", false);
                }
            } else {
                component.set("v.curpUpdated", false);     
                component.set("v.loadingCurpUpdate", false);     
            }
        });
        $A.enqueueAction(action);
    },
    crearCasoCurpDuplicado : function(component, curpUpdate) {
        /// Variables para la Creacion del Caso 'Actualización de Curp'
        var selectedAccount = component.get("v.selectedAccount");
        var soriban = selectedAccount.Campa_a_Actualizaci_n_SORIBAN__c ;
        var catSubSelected;
        if(soriban == true){
            catSubSelected = 'Actualización SORIBAN';
        }
        else{
            catSubSelected = 'Actualización de CURP';
        }
        // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccountID = selectedAccount.Id;
        var selectedAccountNombre = 'NULL';
        var selectedAccountApellido = 'NULL';
        var selectedAccountSegundoApellido = 'NULL';

        var numeroDocumento = component.get("v.strCurpAntes");
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Actualización de Datos'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var numeroDeTarjetaValue = '';     
         // Campos requeridos para cerrar el Caso            
         var camposRequeridos = 'Actualizaci_n_Alta__c:Actualización';
         camposRequeridos += ',';
         camposRequeridos += 'CURP_texto__c:';
         camposRequeridos += curpUpdate;
         camposRequeridos += ',';
         camposRequeridos += 'Curp_Anterior__c:';
         camposRequeridos += numeroDocumento;
         camposRequeridos += ',';
         camposRequeridos += 'Nombre_s__c:';
         camposRequeridos += selectedAccountNombre;
         camposRequeridos += ',';
         camposRequeridos += 'Segundo_Apellido__c:';
         camposRequeridos += selectedAccountSegundoApellido;
         camposRequeridos += ',';
         camposRequeridos += 'Primer_Apellido__c:';
         camposRequeridos += selectedAccountApellido;
         camposRequeridos += ',';
         camposRequeridos += 'Actualizaci_n_de_CURP__c:CURP Duplicado';    
         camposRequeridos += ',';      
         camposRequeridos += 'Type:CURP Duplicado';  
         camposRequeridos += ',';      
         camposRequeridos += 'Actualizaci_n_de_nombre__c:No';    
         camposRequeridos += ',';      
         camposRequeridos += 'Actualizar_domicilio__c:No';  
         console.log('camposRequeridos ',camposRequeridos);   
         var action = component.get("c.createCaseClosedCurp");
         action.setParams({
             "recordTypeId": recordType,
             "customerId": selectedAccountID,
             "personId" : selectedPerson,
             "category" : category,
             "altoRiesgo" : esAltoRiesgo,
             "metodoContactoValue": metodoContactoValue,
             "numeroDeTarjetaValue": numeroDeTarjetaValue,
             "camposRequeridos" : camposRequeridos
         }); 
         action.setCallback(this, function(response) {
            var state = response.getState(); 
             if (state === "SUCCESS") {		
				var result = response.getReturnValue();
                if (result.success) {
                    component.set("v.newCaseCurp", result.folioCaso );
                   // this.loadAccountById(component, result.account, curpUpdate);
                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", true);
                } else {
                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", false);
                }
             } else {
                component.set("v.creatingCase", false);
                component.set("v.successfulCase", false);
             }
         });
         $A.enqueueAction(action);
    },
    crearCasoCurpUpdate : function(component, curpUpdate) {
        /// Variables para la Creacion del Caso 'Actualización de Curp'
        var catSubSelected = 'Actualización de CURP'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var numeroDocumento = component.get("v.strCurpAntes");
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Actualización de Datos'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var numeroDeTarjetaValue = '';     
         // Campos requeridos para cerrar el Caso            
         var camposRequeridos = 'Actualizaci_n_Alta__c:Actualización';
         camposRequeridos += ',';
         camposRequeridos += 'CURP_texto__c:';
         camposRequeridos += curpUpdate;
         camposRequeridos += ',';
         camposRequeridos += 'Curp_Anterior__c:';
         camposRequeridos += numeroDocumento;
         camposRequeridos += ',';
         camposRequeridos += 'Actualizaci_n_de_CURP__c:Sí';          
         var action = component.get("c.createCaseClosedCurp");
         action.setParams({
             "recordTypeId": recordType,
             "customerId": selectedAccountID,
             "personId" : selectedPerson,
             "category" : category,
             "altoRiesgo" : esAltoRiesgo,
             "metodoContactoValue": metodoContactoValue,
             "numeroDeTarjetaValue": numeroDeTarjetaValue,
             "camposRequeridos" : camposRequeridos
         }); 
         action.setCallback(this, function(response) {
            var state = response.getState(); 
             if (state === "SUCCESS") {		
				var result = response.getReturnValue();
                if (result.success) {
                    component.set("v.newCaseCurp", result.folioCaso );
                    this.loadAccountById(component, result.account, curpUpdate);
                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", true);
                } else {
                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", false);
                }
             } else {
                component.set("v.creatingCase", false);
                component.set("v.successfulCase", false);
             }
         });
         $A.enqueueAction(action);
    },
    loadAccountById : function(component, isAcc, curpUpdate) {
        /// Se cambia variable de parametro curpUpdate
        var action = component.get("c.updateSelectedAccount");               
        action.setParams({
            "idAcc" : isAcc,
            "curpUpdate" : curpUpdate
        });        
        action.setCallback(this, function(response) {
			var state = response.getState();            
			if (state === "SUCCESS") {
				var acc = response.getReturnValue();                
                if (acc) {                 
                    component.set("v.selectedAccount", acc);                    
                } else {
                    console.log("Error acc: ", acc);
                }
			} else {
				console.log("Error state: ", state);
			}
		});
		$A.enqueueAction(action);
    },
    
    openModalCurpUpdate : function(component) {

        component.set("v.openCurpUpdate", true);
        component.set("v.noPasoCurpUpdate", 1);
        var selectedAccount = component.get("v.selectedAccount");

        console.log("v.strCurpUpdate ANTES:  ", component.get("v.strCurpUpdate") );

        component.set("v.strCurpAntes",selectedAccount.CURP__c);
        component.set("v.strCurpUpdate",selectedAccount.CURP__c);
    },

    openModalContactMethod : function(component) {

        component.set("v.blnOpenModalContactMethod", true);
    }
})