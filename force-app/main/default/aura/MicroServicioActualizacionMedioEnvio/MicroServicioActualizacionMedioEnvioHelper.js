({
	actualizarMedioDeEnvio : function(component, identificador, esprimario) {

        var blnEmail_TMP = component.get("v.blnEmail_TMP");

        var action = component.get("c.actualizarMedioDeEnvio");
        action.setParams({
            "identificador": identificador,
            "esPrimario": esprimario
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state ActMedDeEnv: ", state);

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                console.log('result medioEnvio', result);
                if (result.success) { 
                    
                    console.log("result.medioEnvio", JSON.stringify(result.medioEnvio.message));
                    ///
                    component.set("v.blnEmail", blnEmail_TMP);
                    component.set("v.medioEnvioActualizado", true);
                    component.set("v.loadingMedioDeEnvio", false);
                    this.crearCasoMedioDeEnvio(component, esprimario);
                    component.set("v.creatingCase", true);

                } else {
                    component.set("v.medioEnvioActualizado", false);
                    component.set("v.loadingMedioDeEnvio", false);
                }

            } else {
                component.set("v.medioEnvioActualizado", false);     
                component.set("v.loadingMedioDeEnvio", false);     
            }
        });

        $A.enqueueAction(action);

    },

    crearCasoMedioDeEnvio : function(component, esprimario) {

        /// Variables para la Creacion del Caso 'Cambio de Medio de Envio'
        var catSubSelected = 'Cambio de Medio Envío'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Estado de Cuenta'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var productos = component.get("v.productos");
        var movimientoIdx = component.get("v.movimientoIdx");
        var numeroDeTarjetaValue = productos[movimientoIdx].tarjetaCredito.identificadorProducto;

        // Campos requeridos para cerrar el Caso
        var camposRequeridos = 'Datos_del_cliente_son_correctos__c:SI';
        camposRequeridos += ',';
        camposRequeridos += 'Medio_de_env_o_de_estado_de_cuenta_selec__c:';
        camposRequeridos += (esprimario ? 'Email' : 'Domicilio');
        camposRequeridos += ',';
        camposRequeridos += 'Se_actualizo_el_medio_de_env_o__c:SI';
        camposRequeridos += ',';
        camposRequeridos += 'Actualizaci_n_Alta_en_SAT__c:true';
        camposRequeridos += ',';
        camposRequeridos += 'Medio_de_Env_o_Actualizado_Microservicio__c:true';
        console.log("camposRequeridos:  ", camposRequeridos);

        var action = component.get("c.createCaseClosedMedioEnvio");
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

            if (response.getState() === "SUCCESS") {

                var result = response.getReturnValue();
                if (result.success) {

                    console.log("result:  ", result);
                    component.set("v.newCaseMedioEnvio", result.folioCaso );
                    console.log("v.newCaseMedioEnvio:  ", component.get("v.newCaseMedioEnvio") );

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

})