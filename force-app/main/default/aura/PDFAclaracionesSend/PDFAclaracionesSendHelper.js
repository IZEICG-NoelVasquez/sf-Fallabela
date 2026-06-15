({
    sendMail : function(component) {
        var simpleRecord = component.get("v.simpleRecord");
        var recordId = component.get("v.recordId");
        var tarjeta = component.find('tarjetaform').get('v.value');
        
        //console.log('contactId: ' + simpleRecord.Contact.Id);
        //console.log('caseId: ' + recordId);
        //console.log('tarjeta: ' + tarjeta);
  
        if (simpleRecord.Correo_Formato_Aclaraciones_Enviado__c) {

            component.set("v.mailEnviado", true);
            
            this.showToast("Error","El correo ya ha sido enviado", "error" );
            return;
        }
        
        
        var action = component.get("c.send");
        action.setParams({
            'contactId': simpleRecord.Contact.Id,
            'caseId': recordId,
            'tarjeta': tarjeta
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var enviadoAnteriormente = response.getReturnValue();
                
                component.set("v.mailEnviado", true);

                if (!enviadoAnteriormente) {
                    this.showToast("Error","El correo ya ha sido enviado", "error" );
                } else {
                    this.showToast("Mensaje enviado","El correo fue enviado", "success" );
                }
                //this.handleSaveRecord(component);
                component.find("forceRecord").reloadRecord();                
                
            } else if (state === "INCOMPLETE") {
                
                component.set("v.mailEnviado", true);
                console.log("Unknown error");                

            } else if (state === "ERROR") {

                component.set("v.mailEnviado", true);
                
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
    
    
    handleSaveRecord: function(component) {
        component.set("v.simpleRecord.Correo_Formato_Aclaraciones_Enviado__c", true); // Save Case.Correo_Formato_Aclaraciones_Enviado__c = true
        component.find("forceRecord").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Mensaje enviado",
                    "message": "El correo fue enviado",
                    "type": "success"
                });
                toastEvent.fire();
                
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + 
                            JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));},
    
    
    showToast : function(title, message, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    getUserInfo : function(component) {

        var action = component.get("c.getUserInfo");

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getUserInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                if (result.success) { 

                    var perfilesVisualizacionPDF = component.get("v.perfilesVisualizacionPDF");
                    
                    var perfilVisualizacionAutorizado;                    

                    if( perfilesVisualizacionPDF.includes(result.userProfile) ) {

                        perfilVisualizacionAutorizado = true;

                    } else {

                        perfilVisualizacionAutorizado = false;

                    }

                    ///
                    component.set("v.infoPerfilLoaded", true);
                    component.set("v.perfilVisualizacionAutorizado", perfilVisualizacionAutorizado);
                } 
            } 
        });

        $A.enqueueAction(action);
    },

    getMovimientos : function(component, tarjeta, blnSendMail) {

        var recordId = component.get("v.recordId");
        var action = component.get("c.getMovimientos");

        action.setParams({
            'recordId': recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getMovimientos: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                if (result.success) { 

                    ///
                    component.set("v.movimientosLoaded", true);

                    if( blnSendMail ) {

                        if( !this.validarCampo(result.contactEmail) ) {

                            /// Envio de Formato Aclaraciones por Mail
                            component.set("v.mailEnviado", false);
                            this.sendMail(component);

                        } else {

                            component.set("v.movimientosLoaded", true);
                            this.showToast("Accion Requerida","Debe ingresar un email en la Cuenta", "warning" );
                        }

                    } else {

                        /// Ver Formato Aclaraciones
                        var urlPdf = '/apex/pdfformatoaclaraciones?id=' + recordId + '&t=' + tarjeta;
                        component.set("v.urlPdf", urlPdf);
                        component.set("v.openModalPDF", true);
                    }

                } else {

                    component.set("v.movimientosLoaded", true);
                    this.showToast("Accion Requerida","Debe seleccionar al menos un Movimiento", "warning" );
                }
            } else {

                component.set("v.movimientosLoaded", true);
                this.showToast("Ha ocurrido un error","Favor de reportar a su administrador", "info" );
            }
        });

        $A.enqueueAction(action);
    },

    validarCampo : function(campo) {

        var result = false;
        if( campo == null || campo == '' || campo == undefined ) {

            result = true;
        }

        return result;
    }
})