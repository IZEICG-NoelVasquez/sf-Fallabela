({
    navigateToSObject : function (recordId) {
	
		var navEvt = $A.get("e.force:navigateToSObject");

	    navEvt.setParams({
	      "recordId": recordId
	    });

	    navEvt.fire();

    },
    
    fireStepChange : function (component, step, reclamoId, isMovimiento, movWithDetallesList) {
        
        var stepChangeEvent = component.getEvent("stepChange");
        component.set("v.tarjetaSelected",reclamoId);
        var attributes = {};
        attributes.esClienteAnonimo = component.get("v.esClienteAnonimo");
        attributes.clienteAnonimo = component.get("v.clienteAnonimo");
        attributes.reclamoId = reclamoId;
        attributes.isMovimiento = isMovimiento;
        attributes.movimientosList = JSON.stringify(movWithDetallesList);
        
        stepChangeEvent.setParams({
            "step" : step,
            "attributes" : attributes
        });
        
        stepChangeEvent.fire();
        
    },

    getProductTypeCatalogJS : function(component) {

        component.set("v.loadedProductos", true);

        var action = component.get("c.getMetadataProductTypeCatalog");

        action.setCallback(this, function(response) {

            var state = response.getState();

            console.log("getProductTypeCatalogJS - state:  ", state);

            if(state == "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getProductTypeCatalogJS - result:  ", result);

                if( result.success ) {

                    var mapTypeProduct = {};

                    for(var key in result.mapTypeProduct ) {

                        mapTypeProduct[key] = result.mapTypeProduct[key];
                    }

                    component.set("v.mapTypeProduct", mapTypeProduct);
                }
            }

            this.cargarProductos(component,mapTypeProduct);
        });

        $A.enqueueAction(action);
    },
    
    cargarProductos : function(component, mapTypeProduct) {
        
        component.set("v.productos", null);
        component.set("v.loadedProductos", true);
        
        var action = component.get("c.obtenerProductosCliente");
        var selectedAccount = component.get("v.selectedAccount");
        
        component.set("v.curp", selectedAccount.CURP__c);
        action.setParams({
            "curp" : selectedAccount.CURP__c
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 

                    var oRes = result.productos.message.tarjetaCredito;

                    ///
                    console.log('Productos result:  ', result);
                    
                    for(var i=0; i < oRes.length; i++) {

                        oRes[i].glosaCodigoSubProducto = oRes[i].tarjetaCredito.codigoSubProducto && mapTypeProduct[oRes[i].tarjetaCredito.codigoSubProducto] ? mapTypeProduct[oRes[i].tarjetaCredito.codigoSubProducto] : oRes[i].tarjetaCredito.codigoSubProducto;
                    }
                    
                    component.set("v.productos", oRes);
                    ///
                    component.set("v.loadedProductos", false);

                    /// 
                    if( oRes.length < 1 ) {
                        this.showToast("No se encontraron Tarjetas", "Favor de reportar a su administrador", "info");
                        this.fireStepChange(component, 3);
                    }
                    
                } else if( !result.success && result.productos && result.productos.message && (result.productos.message == 'the curp is not correct') ) {
                    this.showToast("Accion Requerida", "El CURP del cliente no cumple con el formato", "warning");
                    component.set("v.loadedProductos", false);
                    this.fireStepChange(component, 3);
                }else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                    component.set("v.loadedProductos", false);
                    this.fireStepChange(component, 3);
                }
                
                
            } else if (state === "INCOMPLETE") {
                
                console.log("Unknown error");
                ///
                component.set("v.loadedProductos", false);
                
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
                ///
                component.set("v.loadedProductos", false);
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    setColumns : function (component) {
        
        component.set('v.columns', [
            
            { label: 'Tarjeta de Credito', fieldName: 'tarjetaCredito.identificadorProducto', type: 'text' },
            { label: 'Limite de Credito', fieldName: 'tarjetaCredito.identificadorProducto', type: 'text' },
            { label: 'Saldo actual', fieldName: 'tarjetaCredito.identificadorProducto', type: 'text' },
            { label: 'Credito Disponible', fieldName: 'tarjetaCredito.identificadorProducto', type: 'text' },
            { label: 'Estatus', fieldName: 'tarjetaCredito.identificadorProducto', type: 'text' }
            
        ]);
        
    },
    
    loadMainFields : function (component) {
        
        var account = component.get("v.selectedAccount");
        if (account) {
            var fields = [];
            
            var rfc = { "label" : "Oficina", "value": account.Oficina__c};
            var fechaNacimiento = { "label" : "Contrato", "value": account.N_mero_de_Contrato_texto__c };
            var curp = {"label" : "BIN", "value" : account.BIN__c };
            var idCliente = {"label" : "Correo", "value": account.PersonEmail};
            var email = {"label": "Celular", "value": account.ltimos_4_d_gitos_de_Celular__pc};
            var mobile = {"label": "CURP", "value": account.CURP__c};
            
            fields.push(rfc);
            fields.push(fechaNacimiento);
            fields.push(curp);
            fields.push(idCliente);
            fields.push(email);
            fields.push(mobile);
            
            var Empleado = { "label" : "Empleado", "value": account.Empleado__c};
            var Subgrupo = { "label" : "Subgrupo", "value": account.Subgrupo__pc};
            fields.push(Empleado);
            fields.push(Subgrupo);
            
            component.set("v.mainFields", fields);
        }        
        
    },
    
    cargarSaldos : function(component, movimientoIdx) {
        
        var productos = component.get("v.productos");
        
        var codigoProducto = productos[movimientoIdx].tarjetaCredito.codigoProducto;
        var codigoSubProducto = productos[movimientoIdx].tarjetaCredito.codigoSubProducto;
        var identificadorProducto = productos[movimientoIdx].tarjetaCredito.identificadorProducto;
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
        
        var action = component.get("c.obtenerSaldosCliente");
        
        action.setParams({
            "codigoProducto" : codigoProducto,
            "codigoSubProducto" : codigoSubProducto,
            "identificadorProducto" : identificadorProducto,
            "identificador" : identificador
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 

                    ///
                    //console.log('Saldos result:  ', result);

                    ///
                    component.set("v.cargarFechasDeCorte", true);
                    component.set("v.fechaCorteValue", result.saldos.message.tarjetaCredito.resumenFacturacion.fechaTerminoFacturacion);

                    component.set("v.saldos", result.saldos.message.tarjetaCredito );
                    
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                }
                
                
            } else if (state === "INCOMPLETE") {
                
                console.log("Unknown error");
                
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
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    showToast : function(title, message, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    loadCaseRTypes : function (component) {

		var action = component.get("c.getCaseRecordTypesByName");

		action.setCallback(this, function(response) {

			var state = response.getState();

			if (state === "SUCCESS") {

                component.set("v.caseRTypes", response.getReturnValue());
			}

		});

		$A.enqueueAction(action);
    },

    setModalState : function (component, state) {
        
        var cmpModal = component.find("otp-modal");
        cmpModal.setState(state);
        
    }, 

    loadInfoAltoRiesgo : function (component) {

        var action = component.get("c.getInfoAltoRiesgo");

        action.setCallback(this, function(response) {

			var state = response.getState();

			if (state === "SUCCESS") {

                var infoAltoRiesgo = response.getReturnValue();
                component.set("v.altoRiesgo", infoAltoRiesgo.altoRiesgo);

                console.log('infoAltoRiesgo.altoRiesgo:  ', infoAltoRiesgo.altoRiesgo);
			}

		});

		$A.enqueueAction(action);
    }, 

    loadValidacionesOTPDinamicas : function (component) {

        var action = component.get("c.validacionesOTPDinamicas");

        action.setCallback(this, function(response) {

            var state = response.getState();

            console.log("Validaciones OTP - state:  ", state);

            if(state == "SUCCESS") {

                var result = response.getReturnValue();

                console.log("Validaciones OTP - result:  ", result);

                ///
                component.set("v.mapValidacionesOTP", result);

                component.set("v.validacionesOTPCargadas", true);
            }
        });

        $A.enqueueAction(action);
    }
})