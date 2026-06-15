({
    /******************************************************************************************
    Método para abrir el modal
    *******************************************************************************************/
    openModal: function(component) {
        var cmpTarget = component.find('modal-sectionVQ');
        $A.util.removeClass(cmpTarget, 'slds-hide');
    },
    validationTry : function(component){
        var action = component.get("c.getValidateQuestionsTry");
        var tipoDeIntento = 'validateQuestions';
        ///
        var rangoDiasVencimiento = 'rangoDiasVencimiento';
        var rangoDiasUltimoPago = 'rangoDiasUltimoPago';

        action.setParams({
            "tipoDeIntento": tipoDeIntento,
            "rangoDiasVencimiento" : rangoDiasVencimiento,
            "rangoDiasUltimoPago" : rangoDiasUltimoPago
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var acc = response.getReturnValue();
                if (acc != null) {

                    component.set("v.validacionesPermitidas", acc.validateQuestions);
                    component.set("v.rangoDiasVencimiento", acc.rangoDiasVencimiento);
                    component.set("v.rangoDiasUltimoPago", acc.rangoDiasUltimoPago);

                    this.validationToday(component);            
                }	
            }
        });
        $A.enqueueAction(action);  
    },
    validationToday : function(component){
        var validacionesPermitidas= component.get("v.validacionesPermitidas");
        var customerId= component.get("v.customer.Id");
        var action = component.get("c.getValidationToday");
        action.setParams({
            "customerId": customerId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var acc = response.getReturnValue();
                console.log('validaciones incorrectas',acc);
                if (acc != null) {
                    component.set("v.validacionesIncorrectas", acc);
                    var validar= component.get("v.checkboxVisibility");
                    if(acc >= validacionesPermitidas && !validar){
                        component.set("v.validacionesIncorrectasMax", true);  
                        component.set("v.validacionesIncorrectasNO", false);           
                    }	                  
                }	
                console.log('acc5',component.get("v.validacionesIncorrectas"));
            }
        });
        $A.enqueueAction(action);  
    },
    casosAbiertos : function(component){
        var customerId= component.get("v.customer.Id");
        var action = component.get("c.casosAbiertosDelCliente");
        action.setParams({
            "customerId": customerId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var acc = response.getReturnValue();
                if (acc != null) {
                    if(acc != 0){
                        component.set("v.tieneCasosAbiertosAns", 'SI');	
                        this.validateAnswers(component); 
                        
                    }
                    else{
                        component.set("v.tieneCasosAbiertosAns", 'NO');	
                        this.validateAnswers(component);                   
                    }
                    component.set("v.casosAbiertos", acc);	
                    
                }
                else{
                }		
            }
        });
        $A.enqueueAction(action);  
        
    },
    /******************************************************************************************
    Método que realiza una consulta a los datos de la tarjeta 
    del cleinte para conocer las respuestas correctas, y después mandar al método que valida
    *******************************************************************************************/
    validateQuestions : function(component){ 
        var recordId = component.get("v.recordId");
        var numeroDeTarjeta = component.get("v.numeroDeTarjeta");
        var customerId= component.get("v.customer.Id");        
        var action = component.get("c.getCardData");
        var DiaDeCorte = component.get("v.DiaDeCorte");
        var UltimoPago = component.get("v.UltimoPago");
        var DiaUltimoPago = component.get("v.DiaUltimoPago");
        var recurrencia = component.get("v.recurrencia");
        var CompraDiferida = component.get("v.CompraDiferida");
        var tieneCasosAbiertos = component.get("v.tieneCasosAbiertos");
        var coincidencia = 0;
        
        var requiredFields = component.get("v.requiredFields");

        if(!requiredFields){
            this.showToast("Validación Exitosa", "La Validación ha sido exitosa", "success");
            var evt = component.getEvent("validateQuestionsE");
            this.closeModal(component);
            evt.setParams({
                "coincidencia" : true,
            });        
            evt.fire();
        }else{
            if(DiaDeCorte != undefined && UltimoPago != '-' &&
            CompraDiferida != '-' && tieneCasosAbiertos != '-'){
                action.setParams({
                    "numeroDeTarjeta": numeroDeTarjeta,
                    "customerId": customerId
                });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        var acc = response.getReturnValue();
                        console.log('acc ',acc);
                        component.set("v.diaDeCorteAns", acc.D_a_Fecha_de_corte__c);
                        if (acc != null) {
                            component.set("v.dondePagoAns", acc.Donde_pag_su_tarjeta__c);
                            component.set("v.cuandoPagoAns", acc.Cuando_realiz_el_pago_de_tarjeta__c);
                            component.set("v.compraDiferidaAns", acc.Compra_diferida__c);    
                            this.casosAbiertos(component);                    
                        }
                        else{
                            this.showToast("Error", "Tarjeta no encontrada en Salesforce", "error");
                            this.closeModal(component);
                        }
                    }
                    else{
                            this.showToast("Error", "Tarjeta no encontrada en Salesforce", "error");
                            this.closeModal(component);
                    }
                });
                $A.enqueueAction(action);  
                
            }
            else{
                this.showToast("Datos no completados", "Debe completar todas las respuestas", "warning");
            }
        }
        
    },
    /******************************************************************************************
    Método que valida las respuestas del cliente, calculando el número de respuestas que 
    coinciden con los valores reales de la tarjeta, y envía un evento que crea el caso
    si hay coincidencia, o bien envía un mensaje de error si no todas las respuestas 
    coinciden, para ambos casos manda a llamar al método que crea un registro de 
    validación de preguntas
    *******************************************************************************************/
    validateAnswers : function(component){       
        var DiaDeCorte = component.get("v.DiaDeCorte");
        var UltimoPago = component.get("v.UltimoPago");
        var DiaUltimoPago = component.get("v.DiaUltimoPago");
        var CompraDiferida = component.get("v.CompraDiferida");
        var coincidencia = 0;
        var coincideniaIndispensable = 0;
        var diaDeCorteAns = component.get("v.diaDeCorteAns");
        var dondePagoAns = component.get("v.dondePagoAns");
        var cuandoPagoAns = component.get("v.cuandoPagoAns");
        var compraDiferidaAns = component.get("v.compraDiferidaAns");
        var tieneCasos = component.get("v.tieneCasos");
        var tieneCasosAns = component.get("v.tieneCasosAns");
        var tieneCasosAbiertos = component.get("v.tieneCasosAbiertos");
        var tieneCasosAbiertosAns = component.get("v.tieneCasosAbiertosAns");
        ///
        var rangoDiasVencimiento = component.get("v.rangoDiasVencimiento");
        var rangoDiasUltimoPago = component.get("v.rangoDiasUltimoPago");

        if(component.get("v.dondePagoAns") == component.get("v.UltimoPago")){
            coincidencia = coincidencia +1;
            coincideniaIndispensable = coincideniaIndispensable + 1;
        }
        if(component.get("v.compraDiferidaAns") == component.get("v.CompraDiferida")){
            coincidencia = coincidencia +1;
            coincideniaIndispensable = coincideniaIndispensable + 1;
        }
        if(component.get("v.tieneCasosAbiertosAns") == component.get("v.tieneCasosAbiertos")){
            
            coincidencia = coincidencia +1;
            coincideniaIndispensable = coincideniaIndispensable + 1;
        }
        if(undefined!== diaDeCorteAns && diaDeCorteAns.includes(",")){
            var diaDeCorteAnsArr =  diaDeCorteAns.split(',');
            var coincideciaCorte = false;

            for(var i=0; i < diaDeCorteAnsArr.length; i++) {

                if(component.get("v.DiaDeCorte")== parseInt(diaDeCorteAnsArr[i])) {

                    coincidencia = coincidencia +1;
                    coincideciaCorte = true;
                    break;
                }
            }
            ///
            if( (!coincideciaCorte) && (rangoDiasVencimiento > 0) ) {

                for(var i=0; i < diaDeCorteAnsArr.length; i++) {

                    var difDiaCorte = Math.abs( component.get("v.DiaDeCorte") - parseInt(diaDeCorteAnsArr[i]) );;

                    if(difDiaCorte <= rangoDiasVencimiento) {

                        coincidencia = coincidencia + 1;
                        coincideciaCorte = true;
                        break;
                    }
                }
            }

        } else if( diaDeCorteAns && !diaDeCorteAns.includes(',') ) {

            var diferenciaDiaCorte = Math.abs( component.get("v.DiaDeCorte") - parseInt(diaDeCorteAns) );

            if(diferenciaDiaCorte <= rangoDiasVencimiento) {

                coincidencia = coincidencia +1;
            }
        }
        if(cuandoPagoAns == 'NULL'){
            if(undefined == component.get("v.DiaUltimoPago") || component.get("v.DiaUltimoPago") == ''){
                coincidencia = coincidencia +1;
            }
        }
        else{
            var cuandoPagoAnsInt = parseInt(cuandoPagoAns);
            var diferenciaPago = Math.abs(component.get("v.DiaUltimoPago") - cuandoPagoAnsInt);

            ///
            if(diferenciaPago <= rangoDiasUltimoPago){
                coincidencia = coincidencia +1;
            } 
        }
        if(coincidencia >= 4 && coincideniaIndispensable == 3){
            this.showToast("Validación Exitosa", "La Validación ha sido exitosa", "success");
            var evt = component.getEvent("validateQuestionsE");
            this.closeModal(component);
            this.validacionIncorrecta(component, true, coincidencia, '');
            evt.setParams({
                "coincidencia" : true,
            });        
            evt.fire();
        }else{
            this.showToast("Validación No Exitosa", "Datos proporcionados incorrectos", "error");
            this.closeModal(component);
            this.crearCasoValidacionIncorrecta(component, coincidencia);
            //this.validacionIncorrecta(component, false, coincidencia);
            var valinc = component.get("v.validacionesIncorrectas");
            if(valinc == undefined || valinc == null){
                valinc = 0;
            }
            valinc = valinc +1;
            console.log('valinc',valinc);
            component.set("v.validacionesIncorrectas",valinc);
            var validacionesPermitidas= component.get("v.validacionesPermitidas");
            var validar= component.get("v.checkboxVisibility");
            if(valinc >= validacionesPermitidas && !validar ){
                component.set("v.validacionesIncorrectasMax", true);  
                component.set("v.validacionesIncorrectasNO", false);           
            }	
            var evt = component.getEvent("validateQuestionsE");
            evt.setParams({
                "coincidencia" : false,
            });        
            //evt.fire();
        }
    },
    /******************************************************************************************
    Método para crear un caso de Actualización de Celular Cerrado, para las validaciones Incorrectas
    *******************************************************************************************/
    crearCasoValidacionIncorrecta : function(component, coincidencia){
        var catSubSelected = 'Actualización de Celular'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.customer");
        var selectedAccountID = component.get("v.customer.Id");
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Actualización de Datos'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = 'Contact Center';
        var numeroDeTarjetaValue = component.get("v.numeroDeTarjeta");   
        // Campos requeridos para cerrar el Caso            
        var camposRequeridos = 'Autenticaci_n_exitosa__c:No';
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
                    this.validacionIncorrecta(component, false, coincidencia, result.caseId);
                } else {
                    this.validacionIncorrecta(component, false, coincidencia, '');
                }
            } else {
            }
        });
        $A.enqueueAction(action);
    },
    /******************************************************************************************
    Método para crear un registro de validación de Preguntas, colocando las respuestas
    reales de los datos de la tarjeta del cliente y las respuestas ingresadas por el cliente
    así como el número de respuestas que coincidieron
    *******************************************************************************************/
    validacionIncorrecta : function(component, result, coincidencia, idCaso){
        var DiaDeCorte = component.get("v.DiaDeCorte");
        var UltimoPago = component.get("v.UltimoPago");
        var DiaUltimoPago = component.get("v.DiaUltimoPago");
        var CompraDiferida = component.get("v.CompraDiferida");
        var numeroDeTarjeta = component.get("v.numeroDeTarjeta");
        var customerId= component.get("v.customer.Id");
        var tieneCasosAbiertos = component.get("v.tieneCasosAbiertos");
        var tieneCasosAbiertosAns = component.get("v.tieneCasosAbiertosAns");
        var action = component.get("c.createValidacionIncorrecta");
        action.setParams({
            "numeroDeTarjeta": numeroDeTarjeta,
            "customerId": customerId,
            "DiaDeCorte": DiaDeCorte,
            "UltimoPago": UltimoPago,
            "DiaUltimoPago": DiaUltimoPago,
            "CompraDiferida": CompraDiferida,
            "exitosa": result,
            "coincidencias":coincidencia,
            "tieneCasosAbiertos":tieneCasosAbiertos,
            "tieneCasosAbiertosAns":tieneCasosAbiertosAns,
            "idCaso":idCaso
        });
        action.setCallback(this, function(response) {

            var state = response.getState(); 
			if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log('result ValidacionExitosa --> ', result);
				if (result.Id) {

                    component.set("v.idValidacionExitosa", result.Id);
                }
            }
        });

        $A.enqueueAction(action);
    },
    /******************************************************************************************
    Método para cerrar el Modal
    *******************************************************************************************/
    closeModal: function(component) {
        var cmpTarget = component.find('modal-sectionVQ');
        $A.util.addClass(cmpTarget, 'slds-hide');
    },   
    /******************************************************************************************
    Método para enviar un mensaje pop up
    *******************************************************************************************/
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    /**
     * 
     * Método para recuperar el tipo de perfil del usuario que tiene la sesión en SF
     */
    getUserProfile : function(component){
        
        var action = component.get("c.getUserProfile");
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                
                var userProfile = response.getReturnValue();

                if(userProfile == "Supervisor de Call Center Externo"){
                    component.set("v.checkboxVisibility", true);
                }
                
            }else {
                console.error("Error al obtener el perfil del usuario: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})