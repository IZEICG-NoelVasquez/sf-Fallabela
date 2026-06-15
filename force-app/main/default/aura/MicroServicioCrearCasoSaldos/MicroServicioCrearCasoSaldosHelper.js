({
	crearCasoSaldos : function(component) {
		
		/// Variables para la Creacion del Caso 'Consulta de Saldos'
        var catSubSelected = 'Consulta de Saldos y Movimientos'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Consultas'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
		var productos = component.get("v.productos");
        var movimientoIdx = component.get("v.movimientoIdx");
        var numeroDeTarjetaValue = productos[movimientoIdx].tarjetaCredito.identificadorProducto;

        /// Tipo de Consulta
        var valuesSelected = component.get("v.valuesSelected");
		
		// Campos requeridos para cerrar el Caso
        var camposRequeridos = 'Tipodeconsulta__c:';
        camposRequeridos += valuesSelected;

		var action = component.get("c.createCaseClosedSaldos");
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
                    component.set("v.newCaseSaldos", result.folioCaso );
                    console.log("v.newCaseSaldos:  ", component.get("v.newCaseSaldos") );
    
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
    }
})