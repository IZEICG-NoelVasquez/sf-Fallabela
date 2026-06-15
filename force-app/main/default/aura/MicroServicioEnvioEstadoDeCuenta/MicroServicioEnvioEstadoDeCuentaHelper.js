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

    reenviarEdoCta : function(component) {

        var productos = component.get("v.productos");
        var movimientoIdx = component.get("v.movimientoIdx");
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;

        var contrato = identificador.substr(-12);
        contrato = "000000" + contrato;

        //
        var fechaCorteValue = component.get("v.fechaCorteValue");
        console.log("fechaCorteValue:  ", fechaCorteValue);

        var fechaAjusteFormato, dateTMP, yearTMP, monthTMP, dayTMP;
        dateTMP = fechaCorteValue.split("-");

        dayTMP = dateTMP[0];
        monthTMP = dateTMP[1];
        yearTMP = dateTMP[2];

        fechaAjusteFormato = yearTMP + "-" + monthTMP + "-" + dayTMP;
        console.log("fechaAjusteFormato:  ", fechaAjusteFormato);
        
        /// Valores de Prueba
		//var contrato = "000000000000001898";
        //var fechaCorte = "2021-08-24";
        //var direccionCorreoElectronico = "mrosales@izeicg.com";

        var direccionCorreoElectronico = component.get("v.email_Text");

		var action = component.get("c.envioEstadoCuenta");
        action.setParams({
            "contrato": contrato,
            "fechaCorte": fechaAjusteFormato,
            "direccionCorreoElectronico": direccionCorreoElectronico
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                if (result.success) { 
                    
                    component.set("v.loadingEnvioEdoCta", false);
                    component.set("v.edoCtaEnviado", true);

                    this.crearCasoEnvioEdoCta(component, direccionCorreoElectronico);
                    component.set("v.creatingCase", true);

                } else {
                    component.set("v.loadingEnvioEdoCta", false);
                    component.set("v.edoCtaEnviado", false);
                }

            } else {
                component.set("v.loadingEnvioEdoCta", false);
                component.set("v.edoCtaEnviado", false);       
            }
        });

        $A.enqueueAction(action);
	},

	crearCasoEnvioEdoCta : function(component, direccionCorreoElectronico) {

		/// Variables para la Creacion del Caso 'Reenvío de Estado de Cuenta'
        var catSubSelected = 'Reenvío de Estado de Cuenta'; // <-------------------------
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
        camposRequeridos += 'Correo_actual__c:';
        camposRequeridos += direccionCorreoElectronico;
        camposRequeridos += ',';
        camposRequeridos += 'Reenv_o_de_EDC__c:Sí'; 

        var action = component.get("c.createCaseClosedEnvioEdoCta");
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

                    console.log("result ", result );
                    component.set("v.newCaseEnvioEdoCta", result.folioCaso );
                    console.log("v.newCaseEnvioEdoCta:  ", component.get("v.newCaseEnvioEdoCta") );
    
                    component.set("v.creatingCase", false);
                    component.set("v.casoEdoCtaCreado", true);
                } else {
                    component.set("v.creatingCase", false);
                    component.set("v.casoEdoCtaCreado", false);
                }
             } else {
                 component.set("v.creatingCase", false);
                 component.set("v.casoEdoCtaCreado", false);
             }
 
         });
 
         $A.enqueueAction(action);
    }
    
})