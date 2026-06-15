({
    showToast : function(title, message, type, mode) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type,
            "mode": mode
        });
        toastEvent.fire();
    },
    
    cargarEstadoDeCuenta : function(component, movimientoIdx, fechaCorte) { 

        var productos = component.get("v.productos");        
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;

        var fechaAjusteFormato, dateTMP, yearTMP, monthTMP, dayTMP;
        dateTMP = fechaCorte.split("-");

        dayTMP = dateTMP[0];
        monthTMP = dateTMP[1];
        yearTMP = dateTMP[2];

        fechaAjusteFormato = yearTMP + "-" + monthTMP + "-" + dayTMP;

        if( (numeroDocumento == '') || (identificador == '') || (fechaCorte == '') ) {
            this.showToast("Ha ocurrido un error", "Los valores de Numero de Documento, Identificador o Fecha de Corte no son Validos.", "info");
            component.set("v.loadedPDFEdoCta", false);
        }

        var action = component.get("c.obtenerEstadoDeCuenta");        
        action.setParams({
            "numeroDocumento" : numeroDocumento,
            "identificador" : identificador,
            "fechaCorte" : fechaAjusteFormato
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state EdoCta", state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result:  ", result )
                if (result.success) {
                    //
                    component.set("v.pdfData", result.base64_PDF);
                    component.set("v.showPDF", true);
                    ///
                    component.set("v.fechaAsignada", true);
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
                    component.set("v.loadedPDFEdoCta", false);
                    ///
                    component.set("v.fechaAsignada", true);
                }
            } else {
                this.showToast("Ha ocurrido un error", "Favor de reportarlo a su administrador", "info");
                component.set("v.loadedPDFEdoCta", false);
                ///
                component.set("v.fechaAsignada", true);
            }
        });

        $A.enqueueAction(action);
    }	
})