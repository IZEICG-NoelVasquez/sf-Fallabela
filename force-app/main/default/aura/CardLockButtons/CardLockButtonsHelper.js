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

    getCaseInfo : function(component) {     

        var recordId = component.get("v.recordId");

        var action = component.get("c.getCaseInfo");

		action.setParams({
            "recordId" : recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state getCaseInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result getCaseInfo', result);

                if (result.success) { 

					component.set("v.showComponent", true);

                    ///
                    if( result.cardLocked ) {

                        component.set("v.cardLocked", true);
                    }

                    component.set("v.customMetadataCardLock", result.cmCardLock);

                    component.set("v.numeroDocumento", result.caseRecord.CURPcontacto__c);
                    component.set("v.identificadorProducto", result.caseRecord.TarjetaCaso__c);
                } 
            } 
        });

        $A.enqueueAction(action);
    },

    getProducts : function(component) {

        var identificadorProducto = component.get("v.identificadorProducto");

        var curp = component.get("v.numeroDocumento");
		
		var action = component.get("c.getProducts");

		action.setParams({
            "curp" : curp
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state getProducts: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result getProducts', result);

                if (result.success) { 

					///
					var products = result.productos.message.tarjetaCredito;

                    if( products.length > 0 ) {

                        for(var i = 0; i < products.length; i ++) {

                            if( identificadorProducto === products[i].tarjetaCredito.identificadorProducto ) {

                                component.set("v.identificador", products[i].cuentaTarjetaCredito.identificador);
                                this.openModalMSCardLock(component);  

                                break;
                            }
                        }                        

                    } else {

                        component.set("v.productsLoaded", true);
                        this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "warning");
                    }

                } else {
                    
                    component.set("v.productsLoaded", true);
                    this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "warning");
                }

            } else {
                
                component.set("v.productsLoaded", true);
                this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "warning");
            }

			component.set("v.productsLoaded", true);
        });

        $A.enqueueAction(action);	
	},

    openModalMSCardLock : function(component) {

        component.set("v.productsLoaded", true);

        var modalMSCardLock = component.find("idModalMSCardLock");
        
        modalMSCardLock.set("v.blnOpenModalMSCardLock", true);
        modalMSCardLock.set("v.stepNumberMSCardLock", 2);
        modalMSCardLock.set("v.cardlockInfoLoaded", true);
        modalMSCardLock.set("v.caseRecordCardLock", true);
        modalMSCardLock.set("v.newCaseId", component.get("v.recordId"));

        modalMSCardLock.set("v.numeroDocumento", component.get("v.numeroDocumento"));
        modalMSCardLock.set("v.identificador", component.get("v.identificador"));
        modalMSCardLock.set("v.identificadorProducto", component.get("v.identificadorProducto"));

        var customMetadataCardLock = component.get("v.customMetadataCardLock");
        var mapCardLockInfo = {};
        mapCardLockInfo[customMetadataCardLock.MasterLabel] = customMetadataCardLock;

        modalMSCardLock.set("v.cardLockDescriptionSelected", customMetadataCardLock.MasterLabel + ' - ' + customMetadataCardLock.Etiqueta_en_SF__c);
        modalMSCardLock.set("v.cardLockValue", customMetadataCardLock.MasterLabel);
        modalMSCardLock.set("v.mapCardLockInfo", mapCardLockInfo);
    }
})