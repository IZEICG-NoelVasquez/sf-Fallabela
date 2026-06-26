({
    doInit : function (component, event, helper) {

        ///helper.cargarProductos(component);
        helper.getProductTypeCatalogJS(component);
        
        helper.setColumns(component);
        helper.loadMainFields(component);
        ///
        helper.loadCaseRTypes(component);

        // Se carga informacion de Alto Riesgo para creacion de Casos
        helper.loadInfoAltoRiesgo(component);

        /// Validaciones OTP Dinamicas
        component.set("v.validacionesOTPCargadas", false);
        helper.loadValidacionesOTPDinamicas(component);
    },

    handleSelecionarReclamo : function (component, event, helper) {
        
        var reclamoId = event.target.id;
        
        console.log("reclamoId", reclamoId);
        
        helper.fireStepChange(component, 3, reclamoId);
        
        
    },
    
    handleSelecionarMovimiento : function (component, event, helper) {
        
        var productIdx = component.get("v.productIdx");
        var movimientoIdx = event.target.id;
        
        if (productIdx != movimientoIdx) {

            component.set("v.saldos", null);
            component.set("v.fechasCorteOptions", null);
            helper.cargarSaldos(component, movimientoIdx);
            component.set("v.movimientoIdx", movimientoIdx);   
        } 

        component.set("v.isOpen", true); // Open Modal
        component.set("v.loadedMovConFechaCorte", true);
        component.set("v.loadedMovSinFechaCorte", true);
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
    
    toggleContacto : function(component, event, helper) {
        
        var cmp = component.find("contacto");
        
        $A.util.toggleClass(cmp, "slds-is-open");
        
        var button = event.getSource();
        
        var iconName = button.get("v.iconName") === 'utility:chevronright' ? 'utility:chevrondown' : 'utility:chevronright';
        
        button.set("v.iconName", iconName);
        
    },
    
    seleccionarProducto : function(component, event, helper) {
        
        var arr = component.find("camposProductos").getElement();
        
        for(var i=0 ; i<arr.childNodes.length ;i++){
            //console.log(arr.childNodes[i].outerHTML);
            $A.util.removeClass(arr.childNodes[i], "selectedRow");
        }
        
        var tr = event.target.parentNode.parentNode;
        if(tr.nodeName==='TBODY') {
            tr =  event.target.parentNode;
        }
        $A.util.addClass(tr, "selectedRow");

        ///
        var productoSeleccionado = event.target.parentNode.name;        
        component.set("v.productoSeleccionado", productoSeleccionado);
        
        helper.fireStepChange(component, 3, tr.id);
    },

    handleModalEstadoDeCuenta : function (component, event, helper) {
        
        var productIdx = component.get("v.productIdx");
        var movimientoIdx = event.target.id;

        ///
        component.set("v.movimientoIdx", movimientoIdx);
        
        //Open Modal PDF EdoCta
        component.set("v.isOpenEdoCta", true);

        if (productIdx != movimientoIdx) {

            component.set("v.saldos", null);
            component.set("v.fechasCorteOptions", null);
            helper.cargarSaldos(component, movimientoIdx);

            //Open Modal PDF EdoCta
            component.set("v.loadedPDFEdoCta", false);
        }
    },
    
    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
        //var mode = event.getParam("mode");
		//var validatedRecordId = event.getParam("validatedRecordId");
		
        component.set("v.verificadoOTP", isValid);
    },
    handleCustomerDataPhoneE : function(component, event, helper){
        var phoneCustomerData = event.getParam("phoneCustomerData");
        component.set("v.phoneCustomerData", phoneCustomerData);
        var ultimos4digitos = phoneCustomerData.slice(-4);
        component.set("v.ultimos4digitos", ultimos4digitos);
        if(ultimos4digitos != null){
            component.set("v.tieneNumeroSat",true);
            component.set("v.loadedCustomerData",false);
        }
        else{
            component.set("v.loadedCustomerData",false);
        }
    },

    handleCloseModalContactMethod : function(component, event, helper) {

        var blnBalancesCase = component.get("v.blnBalancesCase");
		var blnCloseModal = event.getParam("blnContactMethodSelected");

		if( blnBalancesCase && blnCloseModal ) {
			
            ///
            component.set("v.openModalCasoSaldos", true);
            component.set("v.blnBalancesCase", false);
		}
	},

    handleModalBloqueoDeTarjeta : function(component, event, helper) {

        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;
        var movimientoIdx = event.target.id;
        var productos = component.get("v.productos");
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
        var identificadorProducto = productos[movimientoIdx].tarjetaCredito.identificadorProducto;
        var titularidadProduct = productos[movimientoIdx].plastico.titularidad;
        var productName = productos[movimientoIdx].glosaCodigoSubProducto;
        console.log('productos[movimientoIdx]',JSON.stringify(productos[movimientoIdx].plastico.titularidad));
        console.log('productos[movimientoIdx]',JSON.stringify(productos[movimientoIdx].glosaCodigoSubProducto));
        /// Componente MS Bloqueo de Tarjeta
        var modalMSCardLock = component.find("modalMSCardLock");
        modalMSCardLock.set("v.stepNumberMSCardLock", 1);
        modalMSCardLock.set("v.numeroDocumento", numeroDocumento);
        modalMSCardLock.set("v.identificador", identificador);
        modalMSCardLock.set("v.identificadorProducto", identificadorProducto);
        modalMSCardLock.set("v.titularidadProduct", titularidadProduct);
        modalMSCardLock.set("v.productName", productName);

        modalMSCardLock.openModalCardLock();
    }

})