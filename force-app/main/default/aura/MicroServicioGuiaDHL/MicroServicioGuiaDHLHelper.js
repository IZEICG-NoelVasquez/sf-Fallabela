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

    doInitHelper : function(component) {

        ///
        var blnRecordCase = component.get("v.blnRecordCase");
        var accountId = component.get("v.accountId");

		var selectedAccount = component.get("v.selectedAccount");
        var CURP = component.get("v.CURP");
        console.log('CURP ',CURP);
        var cuentaId = blnRecordCase ? accountId : selectedAccount.Id;
        console.log('cuentaid ',cuentaId);

        var action = component.get("c.getGuiaDHL");        
        action.setParams({
            "accountId" : cuentaId
		});
		action.setCallback(this, function(response) {    

            var state = response.getState();

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                if(result != null && result != ''){   

                    if(result.includes(",")) {

                        var guias =  result.split(',');
                        component.set("v.GuiasDHL",guias);
                        console.log(component.get("v.GuiasDHL"));
                        component.set("v.HayGuias",true);

                        for(var i=0; i<guias.length;i++){
                           
                        }
                        
                    } else {
                        component.set("v.HayGuia",true);
                        component.set("v.GuiaDHL",result);
                    }            
                }
            } else {
            }

            ///
            component.set("v.infoGuiasLoaded", true);
        });

        $A.enqueueAction(action);
    },

    createCase : function(component){
        //creando caso
        console.log('creando el caso');
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
        var numeroDeTarjetaValue = '';  
        var guiaDHLCase = component.get("v.guiaCaso");
        var ultimoEstado = component.get("v.ultimoEstado");

        var reasonReplacementValue = component.get("v.reasonReplacementValue");
        // Campos requeridos para cerrar el Caso            
        var camposRequeridos = 'Tipodeconsulta__c:Consulta de Guía';
        // camposRequeridos += ';' + reasonReplacementValue;
        camposRequeridos += ',';
        camposRequeridos += 'Comments:';
        camposRequeridos += guiaDHLCase+'-'+ultimoEstado;  
          
         var action = component.get("c.createCaseClosedGuia");
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
                   console.log('caso creado con éxito');
                   component.set("v.newCaseGuia", result.folioCaso );
                    component.set("v.successfulCase", true);
                    component.set("v.casoCompletado", true);
                } else {
                     component.set("v.successfulCase", true);
                    console.log('Algo falló en la creación del caso1');
                }
             } else {
                  component.set("v.successfulCase", true);
                console.log('Algo falló en la creación del caso2');
             }
         });
         $A.enqueueAction(action);
    },
    
    detailDHL : function(component,guiaDHL){
        var CURP = component.get("v.CURP");
        var action = component.get("c.getDetailDHL");        
        action.setParams({
            "guiaDHL" : guiaDHL,
            "CURP" :CURP
		});
		action.setCallback(this, function(response) {       
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result ',result);
                if (result.success) {
                    if(undefined !== result.resultGuiaDHL.TrackingResponse){
                        component.set("v.HayRespuesta",true);
                        if(undefined !== result.resultGuiaDHL.TrackingResponse.response.serviceheader.MessageTime){
                            var fecha = result.resultGuiaDHL.TrackingResponse.response.serviceheader.MessageTime;
                            if(undefined !== fecha && fecha != ''){
                                var fechaS = fecha.substring(8,10) + '-'+fecha.substring(5,7)+ '-'+fecha.substring(0,4)+ ' '+fecha.substring(11, 16);
                                component.set("v.Fecha",fechaS);
                            }
                        }
                        if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo){
                            component.set("v.GuiaDHL",result.resultGuiaDHL.TrackingResponse.awbinfo.AWBNumber);
                            if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.originservicearea){
                                if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.originservicearea.Description){
                                    component.set("v.Origen",result.resultGuiaDHL.TrackingResponse.awbinfo.originservicearea.Description);
                                }
                            }
                            if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.originservicearea){
                                if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.destinationservicearea.Description){
                                    component.set("v.Destino",result.resultGuiaDHL.TrackingResponse.awbinfo.destinationservicearea.Description);
                                }
                            }
                            if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.Pieces){
                                component.set("v.Piezas",result.resultGuiaDHL.TrackingResponse.awbinfo.Pieces);
                            }

                            if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent) {

                                //var data = [];
                                var ultimoEstado;
                                var tamaño = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent.length;

                                for(var i=0; i<result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent.length;i++) {

                                    component.set("v.FirmadoPor",result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Signatory);

                                    if(component.get("v.FirmadoPor") != null) {

                                        result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Description = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].serviceevent.Description + ': '+ result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Signatory;
                                    
                                    } else {

                                        result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Description = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].serviceevent.Description;
                                    }

                                    result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Location = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].servicearea.Description;
                                    var datex = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Datex;
                                    var datex2 = datex.substring(8,10) + '-'+datex.substring(5,7)+ '-'+datex.substring(0,4);
                                    result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[i].Datex2 = datex2;
                                }

                                ultimoEstado = result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent[tamaño-1].Description;
                                var lastStatus = ultimoEstado.replace(":", "");
                                console.log('lastStatus ',lastStatus);
                                component.set("v.ultimoEstado",lastStatus);
                                component.set("v.data",result.resultGuiaDHL.TrackingResponse.awbinfo.shipmentevent.reverse());

                                /// Se busca el ultimo estatus de la Guia DHL para actualizar el campo Estatus del caso
                                /*var currentEstatus = component.get("v.currentEstatus");

                                if( component.get("v.blnRecordCase") && currentEstatus != lastStatus ) {

                                    ///
                                    this.updateEstatus(component, lastStatus);
                                }*/
                            }

                            if(undefined !== result.resultGuiaDHL.TrackingResponse.awbinfo.status){
                                console.log('data ',component.get("v.data"));
                                if(component.get("v.data") == null){
                                    component.set("v.ultimoEstado",result.resultGuiaDHL.TrackingResponse.awbinfo.status.ActionStatus);
                                    component.set("v.guiaNoEncontrada",true);
                                }
                                console.log('envio ',result.resultGuiaDHL.TrackingResponse.awbinfo.status.ActionStatus);
                            }
                        }
                    }
                }
            } else {
            }

            ///
            component.set("v.dhlDetailLoaded", true);
        });
        $A.enqueueAction(action);
    },

    detailEstafeta : function(component, guiaEstafeta) {

        var action = component.get("c.getWayBillEstafeta");

        action.setParams({
            "wayBill" : guiaEstafeta
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state detailEstafeta: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result detailEstafeta', result);

                if (result.success) { 

					var responseBody = JSON.parse(result.responseBody);

                    console.log("responseBody: ", responseBody);

                    /// Guia 
                    component.set("v.GuiaDHL", guiaEstafeta);

                    /// Origen
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.pickupData &&
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.pickupData.originName ) {

                            component.set("v.Origen", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.pickupData.originName);
                    }

                    /// Destino
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData &&
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData.destinationName ) {

                            component.set("v.Destino", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData.destinationName);
                    }

                    /// Estatus
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.statusSPA ) {

                            component.set("v.statusSPA", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.statusSPA);
                    }

                    /// Piezas
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.packageType ) {

                            component.set("v.Piezas", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.packageType);
                        }                    

                    /// Firmado por
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData &&
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData.receiverName ) {
                    
                        component.set("v.FirmadoPor", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.deliveryData.receiverName);
                    }

                    /// Clave de rastreo
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.shortWaybillId ) {

                        component.set("v.shortWaybillId", responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.shortWaybillId);
                    }


                    /// Tracking
                    if( responseBody.ExecuteQueryResponse && responseBody.ExecuteQueryResponse.ExecuteQueryResult && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData && 
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData && responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.history &&
                        responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.history.History ) {

                        var history = responseBody.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData.history.History;
                        var ultimoEstado;

                        if( history.length && history.length > 0 ) {

                            history = history.reverse();

                            for(var i = 0; i < history.length; i ++ ) {

                                var dateTime = history[i].eventDateTime;

                                history[i].Datex2 = dateTime.substring(0, dateTime.indexOf(' '));
                                history[i].Description = history[i].eventDescriptionSPA;
                                history[i].Exception = history[i].exceptionCodeDescriptionSPA;
                                history[i].Timex = dateTime.substring(dateTime.indexOf(' ') + 1, dateTime.length);
                                history[i].Location = history[i].eventPlaceName;
                            }

                            ultimoEstado = history[0].eventDescriptionSPA;
                            ultimoEstado = ultimoEstado.replace(/,/g,'.');

                            component.set("v.ultimoEstado", ultimoEstado);
                            component.set("v.data", history);

                        } else {

                            var dateTime = history.eventDateTime;

                            var data = [{
                                Datex2: dateTime.substring(0, dateTime.indexOf(' ')),
                                Description: history.eventDescriptionSPA,
                                Exception: history.exceptionCodeDescriptionSPA,
                                Timex: dateTime.substring(dateTime.indexOf(' ') + 1, dateTime.length),
                                Location: history.eventPlaceName
                            }];

                            ultimoEstado = history.eventDescriptionSPA;
                            ultimoEstado = ultimoEstado.replace(/,/g,'.');

                            component.set("v.ultimoEstado", ultimoEstado);
                            component.set("v.data", data);
                        }

                        /// Se busca el ultimo estatus de la Guia Estafeta para actualizar el campo Estatus del caso
                        /*var currentEstatus = component.get("v.currentEstatus");

                        if( component.get("v.blnRecordCase") && currentEstatus != ultimoEstado ) {

                            ///
                            this.updateEstatus(component, ultimoEstado);
                        }*/

                    } else {

                        ///
                        component.set("v.ultimoEstado", 'No se encontraron envíos para esta Guía');
                        component.set("v.guiaNoEncontrada",true);
                    }
                }
            }
            
            component.set("v.dhlDetailLoaded", true);
        });

        $A.enqueueAction(action);
    },

    detailEstafetaV2 : function(component, guiaEstafeta) {
        
        var action = component.get("c.getWayBillEstafetaV2");

        action.setParams({
            "wayBill" : guiaEstafeta
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state detailEstafeta: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result detailEstafeta', result);

                if (result.success) { 

					var responseBody = JSON.parse(result.responseBody);

                    console.log("responseBody: ", responseBody);

                    /// Guia 
                    component.set("v.GuiaDHL", guiaEstafeta);

                    var item = responseBody && responseBody.items && responseBody.items.length > 0 ? responseBody.items[0]: null;


                    if (item) {

                        // Origen
                        if (item.pickupDetails && item.pickupDetails.warehouseName) {
                            component.set("v.Origen", item.pickupDetails.warehouseName);
                        }

                        // Destino (no aplica en este API)
                        component.set("v.Destino", "No aplica");

                        // Estatus
                        if (item.statusCurrent && item.statusCurrent.spanishName) {
                            component.set("v.statusSPA", item.statusCurrent.spanishName);
                        }

                        // Piezas
                        if (item.package && item.package.nameType) {
                            component.set("v.Piezas", item.package.nameType);
                        }

                        // Firmado por
                        if (item.deliveryDetails && item.deliveryDetails.receiverName) {
                            component.set("v.FirmadoPor", item.deliveryDetails.receiverName);
                        }

                        // Clave de rastreo
                        if (item.information && item.information.trackingCode) {
                            component.set("v.shortWaybillId", item.information.trackingCode);
                        }

                        // Tracking
                        if (item.status) {

                            var history = item.status;

                            // Normalizar a array
                            if (!Array.isArray(history)) {
                                history = [history];
                            }

                            if (history.length > 0) {

                                // Ordenar por fecha reciente primero
                                history.sort(function(a, b) {
                                    return new Date(b.eventDateTime || 0) - new Date(a.eventDateTime || 0);
                                });

                                // Transformar estructura para Aura
                                history.forEach(function(itemHist) {

                                    var dateTime = itemHist.eventDateTime || '';

                                    itemHist.Datex2 = dateTime.split(' ')[0] || '';
                                    itemHist.Timex = dateTime.split(' ')[1] || '';
                                    itemHist.Description = itemHist.spanishName;
                                    itemHist.Exception = itemHist.reasonCodeDescription;
                                    itemHist.Location = itemHist.warehouseName;
                                });

                                var ultimoEstado = history[0].spanishName || '';
                                ultimoEstado = ultimoEstado.replace(/,/g, '.');

                                component.set("v.ultimoEstado", ultimoEstado);
                                component.set("v.data", history);

                            } else {

                                // Caso: sí hay nodo pero sin eventos
                                component.set("v.ultimoEstado", 'Sin eventos de seguimiento');
                                component.set("v.data", []);
                            }

                        } else {

                            // Caso: no viene tracking
                            component.set("v.ultimoEstado", 'No se encontraron envíos para esta Guía');
                            component.set("v.guiaNoEncontrada", true);
                        }

                    }

                }
            }
            
            component.set("v.dhlDetailLoaded", true);
        });

        $A.enqueueAction(action);
    },


    openDetailDHL : function (component) {

        ///
        var guiaDHL = component.get("v.guiaCaso");

        if( guiaDHL.length >= 20 || guiaDHL == '0550655621' || guiaDHL == '405590338061170A01KM0X') {

            component.set('v.columns', [
                {label: 'Fecha', fieldName: 'Datex2', type: 'text', initialWidth: 120},
                {label: 'Descripción', fieldName: 'Description', type: 'text', initialWidth: 300},
                {label: 'Excepción', fieldName: 'Exception', type: 'text', initialWidth: 800},
                {label: 'Hora', fieldName: 'Timex', type: 'text', initialWidth: 120},
                {label: 'Locación', fieldName: 'Location', type: 'text', initialWidth: 200}
            ]);


            component.set("v.blnWayBillEstafeta", true);
            //Switch para el servicio de estafeta actual y la nueva versión V2
            //this.detailEstafeta(component, guiaDHL);
            this.detailEstafetaV2(component, guiaDHL);

        } else {
        
            component.set('v.columns', [
                {label: 'Fecha', fieldName: 'Datex2', type: 'text', initialWidth: 120},
                {label: 'Descripción', fieldName: 'Description', type: 'text', initialWidth: 800}, 
                {label: 'Hora', fieldName: 'Timex', type: 'text', initialWidth: 120},
                {label: 'Locación', fieldName: 'Location', type: 'text'}
             ]);


            component.set("v.blnWayBillEstafeta", false);
            this.detailDHL(component, guiaDHL);

        }

        component.set("v.isOpen", true);
    }

    /*updateEstatus : function(component, lastEstatus) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.updateEstatus");

        action.setParams({
            "recordId" : recordId,
            "lastEstatus" : lastEstatus
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("updateEstatus - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                console.log("updateEstatus - result: ", result);

                if( result ) {

                    ///
                    this.showToast("", "Se actualizó el Estatus con éxito", "success");

                    component.set("v.currentEstatus", lastEstatus);

                    /// Refresh View
                    $A.get('event.force:refreshView').fire();

                } else {

                    this.showToast("Ha ocurrido un error", "No se actualizó el Estatus. Favor de reportarlo con su administrador", "warning");
                }
            } else {

                this.showToast("Ha ocurrido un error", "No se actualizó el Estatus. Favor de reportarlo con su administrador", "warning");
            }
        });

        $A.enqueueAction(action);

    }*/
})