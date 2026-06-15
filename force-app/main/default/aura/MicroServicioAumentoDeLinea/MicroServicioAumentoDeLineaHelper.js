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
	
	consultaDeCupo : function(component) {
		
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;
        var productoSeleccionado = component.get("v.productoSeleccionado");
        var productos = component.get("v.productos");
        var identificador = productos[productoSeleccionado].cuentaTarjetaCredito.identificador;
        var tipoCupo = '01';
        
        console.log("************ CONSULTA CUPO *************");
        console.log("tipoCupo:  ", tipoCupo);
        console.log("numeroDocumento:  ", numeroDocumento);
        console.log("productoSeleccionado:  ", productoSeleccionado);
        console.log("identificador:  ", identificador);

		var action = component.get("c.consultaLineaDeCredito");
        action.setParams({
            "tipoCupo": tipoCupo,
            "identificador": identificador,
            "numeroDocumento": numeroDocumento
		});
		
		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state ConsultaCUPO: ", state);

            if (state === "SUCCESS") {
				
				var result = response.getReturnValue();
                
                console.log('result ConsultaCUPO', result);
                if (result.success) { 

                    console.log("result.resultConsultaDeCupo.message: ", result.resultConsultaDeCupo.message);

					component.set("v.creditoActual", result.resultConsultaDeCupo.message.cupo.cupoTotal);
					component.set("v.nuevoCredito", result.resultConsultaDeCupo.message.cupoPreAprobado);					
					
					component.set("v.loadingConsultaCupo", false);
					component.set("v.consultaExitosa", true);
                } else {
                    console.log('result.resultConsultaDeCupo.message:  ', result.resultConsultaDeCupo.message);
                    if( result.resultConsultaDeCupo.message == 'NO SE HAN ENCONTRADO VALORES' ) {

                        component.set("v.aumentoNoDisponible", true);
                    } else {

                        component.set("v.aumentoNoDisponible", false);
                    }

					component.set("v.loadingConsultaCupo", false);
                    component.set("v.consultaExitosa", false);
                }

            } else { 

				component.set("v.loadingConsultaCupo", false);
				component.set("v.consultaExitosa", false);
            }
        });

		$A.enqueueAction(action);		
	},

    aumentoDeCupo : function(component) {
        
        var productoSeleccionado = component.get("v.productoSeleccionado");
        var productos = component.get("v.productos");
        var identificador = productos[productoSeleccionado].cuentaTarjetaCredito.identificador;
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;
        var codigoProducto = productos[productoSeleccionado].tarjetaCredito.codigoProducto;
        var codigoSubProducto = productos[productoSeleccionado].tarjetaCredito.codigoSubProducto;
        var identificadorProducto = productos[productoSeleccionado].tarjetaCredito.identificadorProducto;
        var codigoMoneda = productos[productoSeleccionado].moneda.codigoMoneda;

        var cupoTotal = component.get("v.creditoActual");
        var cupoTotalFormato = this.formatoDeCupos(cupoTotal);
        var nuevoCupo = component.get("v.nuevoCredito");
        var nuevoCupoFormato = this.formatoDeCupos(nuevoCupo);
        var tipoCupo = '01';        
        
        console.log("************ AUMENTO CUPO *************");        
        console.log("tipoCupo:  ", tipoCupo);
        console.log("productoSeleccionado:  ", productoSeleccionado);
        console.log("identificador:  ", identificador);
        console.log("numeroDocumento:  ", numeroDocumento);
        console.log("codigoProducto:  ", codigoProducto);
        console.log("codigoSubProducto:  ", codigoSubProducto);
        console.log("identificadorProducto:  ", identificadorProducto);
        console.log("codigoMoneda:  ", codigoMoneda);        
        console.log("cupoTotalFormato:  ", cupoTotalFormato);        
        console.log("nuevoCupoFormato:  ", nuevoCupoFormato); 

        var action = component.get("c.aumentoLineaDeCredito");
        action.setParams({
            "tipoCupo": tipoCupo,
            "identificador": identificador,
            "numeroDocumento": numeroDocumento,
            "codigoProducto": codigoProducto,
            "codigoSubProducto": codigoSubProducto,
            "identificadorProducto": identificadorProducto,
            "codigoMoneda": codigoMoneda,
            "cupoTotal": cupoTotalFormato,
            "nuevoCupo": nuevoCupoFormato
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state AumentoCUPO: ", state);

            if (state === "SUCCESS") {
				
				var result = response.getReturnValue();
                
                console.log('result AumentoCUPO', result);
                if (result.success) { 		
					
					component.set("v.loadingAumentoCupo", false);
                    component.set("v.aumentoExitoso", true);
                    
                    this.crearCasoAumenttoCupo(component);
                    component.set("v.creatingCase", true);
                } else {
                    console.log('result.resultAumentoDeCupo.message:  ', result.resultAumentoDeCupo.message);
                    if( result.resultAumentoDeCupo.message == 'MPE0005 - EL REGISTRO NO EXISTE EN LA B.D.' ) {

                        component.set("v.bloqueoPorFraude", true);
                    } else {

                        component.set("v.bloqueoPorFraude", false);
                    }

					component.set("v.loadingAumentoCupo", false);
					component.set("v.aumentoExitoso", false);
                }

            } else { 

				component.set("v.loadingAumentoCupo", false);
				component.set("v.aumentoExitoso", false);
            }
        });

		$A.enqueueAction(action);
    },

    crearCasoAumenttoCupo : function(component) {

        /// Variables para la Creacion del Caso 'Aumento de Linea de Credito'
        var catSubSelected = 'Aumento de Línea de Crédito'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Campañas'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var productos = component.get("v.productos");
        var productoSeleccionado = component.get("v.productoSeleccionado");
        var numeroDeTarjetaValue = productos[productoSeleccionado].tarjetaCredito.identificadorProducto;
		
		// Campos requeridos para cerrar el Caso
        var camposRequeridos = 'Origen_Campa_a__c:Correo';
        camposRequeridos += ',';
        camposRequeridos += 'Cliente_en_Base_de_Datos_de_Campa_a__c:Sí';
        camposRequeridos += ',';
        camposRequeridos += 'Cliente_acepta_aumento_l_nea_de_cr_dito__c:SI';
        
        var action = component.get("c.createCaseClosedAumentoCupo");
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
                    component.set("v.newCaseCupo", result.folioCaso );
                    console.log("v.newCaseCupo:  ", component.get("v.newCaseCupo") );
    
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

    formatoDeCupos : function (valor) {

        var strValor = '' + valor.toString() + '';

        var final = strValor.substr(-3);
        if( !final.startsWith('.') ) {
            strValor = strValor + '.00';
        }

        var tamanio = strValor.length > 0 ? strValor.length : '0';

        var valorFormato = strValor;
        while(tamanio < 15) {
            valorFormato = '0' + valorFormato;
            tamanio ++;
        }

        return valorFormato;
    },

    setModalState : function (component, state) {
        
        var cmpModal = component.find("otpModalAumentoCupo");
        cmpModal.setState(state);
    },

    openModalContactMethod : function(component) {

        component.set("v.classBackdrop", "slds-backdrop slds-backdrop_open");

        component.set("v.blnOpenModalContactMethod", true);
    }

})