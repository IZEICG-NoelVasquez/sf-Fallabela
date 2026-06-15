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

    validateEmptyField : function(field) {

        if( field == undefined || field == null || field == '' ) {

            return true;

        } else {
            
            return false;
        }
    },

    validateCurp : function(curp) {

        var regex = /^([A-Z]{4}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[A-Z]{3}[A-Z\d])(\d)$/,
                validate = curp.match(regex);

        return validate;
    },

    validateIdRequest : function(idReq) {

        var regex = /^([0-9])*$/,
            validate = idReq.match(regex);

        return validate;
    },

    getDocumentsList : function(component) {

		var action = component.get("c.getDocumentsList");

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getDocumentsList - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getDocumentsList - result: ", result);
                
                if (result.success) { 

					var wistonDataOptions = [];
					var wistonDataAdditionalOptions = [];
                    var blobStorageOptions = [];

					for(var i = 0; i < result.lstExpedientes.length; i ++ ) {

						/// Documentos Wiston Data
						if( result.lstExpedientes[i].Micro_Servicio__c === 'WistonData' ) {

                            if( !result.lstExpedientes[i].WD_Adicionales__c ) {

                                wistonDataOptions.push({
                                                        label:result.lstExpedientes[i].Nombre_del_Documento__c,
                                                        value:result.lstExpedientes[i].Parametro_Micro_Servicio__c,
                                                        disabled:true
                                                    });
                            } else {

                                wistonDataAdditionalOptions.push({
                                                                label:result.lstExpedientes[i].Nombre_del_Documento__c,
                                                                value:result.lstExpedientes[i].Parametro_Micro_Servicio__c,
                                                                disabled:true
                                                            });
                            }

                        /// Documentos Blob Storage
						} else if( result.lstExpedientes[i].Micro_Servicio__c === 'BlobStorage' ) {

                            ///
                            blobStorageOptions.push({
                                                    label:result.lstExpedientes[i].Nombre_del_Documento__c,
                                                    value:result.lstExpedientes[i].Parametro_Micro_Servicio__c,
                                                    disabled:true
                                                });
                        }
					}

					component.set("v.wistonDataOptions", wistonDataOptions);
					component.set("v.wistonDataAdditionalOptions", wistonDataAdditionalOptions);
					component.set("v.blobStorageOptions", blobStorageOptions);

					component.set("v.listDocumentsLoaded", true);
					component.set("v.listDocumentsSuccess", true);

                } else {

                    component.set("v.listDocumentsLoaded", true);
					component.set("v.listDocumentsSuccess", false);
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                }

            } else {

                component.set("v.listDocumentsLoaded", true);
				component.set("v.listDocumentsSuccess", false);
                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }

        });

        $A.enqueueAction(action);

	},

    getIdRequest : function(component, curp, validateIdRequest) {

        component.set("v.documentsAvailableLoaded", false);

        var idRequest =  component.get("v.idRequest");

        var action = component.get("c.getIdRequest");

        action.setParams({
            "numeroIdentificacion" : curp,
            "tipoIdentificacion" : "1"
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getIdRequest - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getIdRequest - result: ", result);
                
                if (result.success) { 

                    if( result.idRequest && result.idRequest.data && result.idRequest.data.length > 0 && result.idRequest.data[0].numero ) {

                        if( validateIdRequest ) {

                            /// Se valida que el CURP este relacionado con el Id Solicitud, para la busqueda de Documentos Adicionales
                            if( result.idRequest.data[0].numero == idRequest ) {

                                this.getContractNumber(component, curp);

                            } else {

                                component.set("v.blnAdditionalDocuments", false);
                                component.set("v.documentsAvailableLoaded", true);
                                this.showToast("", "Revisa que el CURP corresponda al Id Solicitud", "warning");
                            }

                        } else { 

                            /// Busqueda inicial por CURP
                            component.set("v.idRequest", result.idRequest.data[0].numero);
                            this.getDocumentsAvailable(component, result.idRequest.data[0].numero);
                        }                        

                    /// El MS getIdRequest NO regreso un Id Solicitud
                    } else {                        

                        if( validateIdRequest ) {

                            component.set("v.blnAdditionalDocuments", false);
                            component.set("v.documentsAvailableLoaded", true);
                            this.showToast("", "Revisa que el CURP corresponda al Id Solicitud", "warning");

                        } else {

                            this.getContractNumber(component, curp);
                        }                        
                    }
                   
                /// ERROR - MS getIdRequest 
                } else {                    

                    if( validateIdRequest ) {

                        component.set("v.blnAdditionalDocuments", false);
                        component.set("v.documentsAvailableLoaded", true);
                        this.showToast("", "Revisa que el CURP corresponda al Id Solicitud", "warning");
                        
                    } else {

                        this.getContractNumber(component, curp);
                    }                    
                }

            } else {

                component.set("v.documentsAvailableLoaded", true);
                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }

        });

        $A.enqueueAction(action);
    },

    getDocumentsAvailable : function(component, idRequestCURP) {

        component.set("v.documentsAvailableLoaded", false);

		/// Documentos Blob Storage
		var blobStorageOptions = component.get("v.blobStorageOptions");        
        this.getDocumentsAvailableBS(component, idRequestCURP, blobStorageOptions, 0, false);


        /// PDF Reporte de Buro de Credito
        this.getPdfCreditReport(component, idRequestCURP);
    },

    getPdfCreditReport : function(component, idRequestCURP) {

        var reportType = 'B';
        var mapParams = {};
        mapParams['idSolicitud'] = idRequestCURP;
        mapParams['tipoReporte'] = reportType;

        var action = component.get("c.getPdfCreditReport");

        action.setParams({
            "params" : mapParams
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getPdfCreditReport - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getPdfCreditReport - result: ", result);

                if( result && result.code && result.code == 'ok' ) {

                    ///
                    component.set("v.pdfCreditReportAvailable", true);

                    var urlCreditReport = '/apex/PDFReporteDeCredito' + '?idSolicitud=' + idRequestCURP + '&tipoReporte=' + reportType;
                    component.set("v.urlCreditReport", urlCreditReport);
                }

            } 
        });

        $A.enqueueAction(action);
    },

    getDocumentsAvailableBS : function(component, idRequest, blobStorageOptions, index, documentAvailable) {

        console.log('----------------------------------------');
        console.log('blobStorageOptions[index].value:  ', blobStorageOptions[index].value);
        console.log('index:  ', index);
        
		var action = component.get("c.getDocumentBlobStorage");

        action.setParams({
            "idSolicitud" : idRequest,
            "link" : blobStorageOptions[index].value,
            "microServicio" : "BlobStorage"
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getDocumentsAvailableBS - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getDocumentsAvailableBS - result: ", result);
                
                if (result.success) { 

                    /// Documentos Blob Storage
                    blobStorageOptions[index].disabled = false;

                    documentAvailable = true;
                }

                /// Se valida el siguiente Documento de Blob Storage
                if( (index + 1) < blobStorageOptions.length ) {

                    this.getDocumentsAvailableBS(component, idRequest, blobStorageOptions, index + 1, documentAvailable);

                } else {

                    component.set("v.blobStorageOptions", blobStorageOptions);

                    var wistonDataOptions = component.get("v.wistonDataOptions");

                    this.getDocumentsAvailableWD(component, idRequest, wistonDataOptions, 0, false, documentAvailable);
                }

            } else {

                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }
        });

        $A.enqueueAction(action);
    },

	getDocumentsAvailableWD : function(component, idRequest, wistonDataOptions, index, blnAdditionalDocuments, documentWDAvailable) {

        console.log('----------------------------------------');
        console.log('wistonDataOptions[index].value:  ', wistonDataOptions[index].value);
        console.log('idRequest:  ', idRequest);
        console.log('index:  ', index);

		var action = component.get("c.getDocumentApiGee");

		action.setParams({
            "documentSubTypeId" : wistonDataOptions[index].value,
            "idRequest" : idRequest
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getDocumentsAvailableWD - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getDocumentsAvailableWD - result: ", result);
                
                if (result.success) { 

                    /// Documentos Wiston Data 
                    wistonDataOptions[index].disabled = false;

                    documentWDAvailable = true;
                }

                /// Se valida el siguiente Documento de Wiston Data
                if( (index + 1) < wistonDataOptions.length ) {

                    if( wistonDataOptions[index + 1].value === '12' ) {

                        idRequest = '01' + idRequest.substr(-8);
                    }

                    this.getDocumentsAvailableWD(component, idRequest, wistonDataOptions, index + 1, blnAdditionalDocuments, documentWDAvailable);

                } else {

                    /// Documentos Wiston Data (1 al 7)
                    if( !blnAdditionalDocuments ) {
                        
                        if( documentWDAvailable ) {

                            component.set("v.wistonDataOptions", wistonDataOptions);
                            component.set("v.stepNumberExpedientes", 2);

                            ///
                            component.set("v.documentAvailable", true);
                        }                        

                        if( component.get("v.isCurp") ) {

                            /// Busqueda por CURP
                            this.getContractNumber(component, component.get("v.idRequestCURP"));

                        } else {                            

                            /// Busqueda por Id Solicitud
                            component.set("v.documentsAvailableLoaded", true);

                            if( !documentWDAvailable ) {

                                this.clearVariables(component);
                                this.showToast("No se han encontrado documentos por Id de Solicitud.", "Intenta nuevamente mediante búsqueda de CURP", "warning");
                            }
                        }

                    /// Documentos Adicionales Wiston Data (8 al 12) 
                    } else {

                        /// NO se encontro Ningun Documento
                        if( !component.get("v.documentAvailable") && !documentWDAvailable ) {

                            ///
                            this.clearVariables(component);
                            this.showToast("No se han encontrado documentos.", "Revise que el cliente titular haya sido originado en Onboarding", "warning");

                        /// Busqueda Inicial Exitosa, NO se encontraron Adicionales
                        } else if( component.get("v.documentAvailable") && !documentWDAvailable ) {

                            if( !component.get("v.isCurp") ) {

                                this.showToast("", "No se encontraron mas documentos para su búsqueda", "warning");
                            }                            

                            component.set("v.blnAdditionalDocuments", true);

                            component.set("v.wistonDataAdditionalOptions", wistonDataOptions);
                            component.set("v.showAdditionalDocumentsAvailable", true);

                        /// Se encontro al menon un Documento
                        } else if( documentWDAvailable ) {

                            component.set("v.stepNumberExpedientes", 2);
                            component.set("v.blnAdditionalDocuments", true);

                            component.set("v.wistonDataAdditionalOptions", wistonDataOptions);
                            component.set("v.showAdditionalDocumentsAvailable", true);
                        }

                        component.set("v.documentsAvailableLoaded", true);
                    }
                }

            } else {

                ///
                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }
        });

        $A.enqueueAction(action);
	},

    getContractNumber : function(component, curp) {

        component.set("v.documentsAvailableLoaded", false);

        var action = component.get("c.getContractNumber");

		action.setParams({
            "curp" : curp
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getContractNumber - state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();

                console.log("getContractNumber - result: ", result);
                
                if (result.success) { 

                    var products = result.productos.message.tarjetaCredito;

                    if( products.length > 0 ) {

                        var contractNumber = products[0].cuentaTarjetaCredito.identificador.substr(-12);

                        component.set("v.contractNumber", contractNumber);

                        this.additionalDocuments(component, contractNumber);

                    } else {

                        ///
                        component.set("v.blnAdditionalDocuments", false);
                        component.set("v.documentsAvailableLoaded", true);
                        this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "warning");
                    }

                } else {

                    ///
                    component.set("v.blnAdditionalDocuments", false);
                    component.set("v.documentsAvailableLoaded", true);
                    this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "warning");
                }

            } else {

                component.set("v.blnAdditionalDocuments", false);
                component.set("v.documentsAvailableLoaded", true);
                this.showToast("Ha ocurrido un error en el MS Productos", "Favor de reportar a su administrador", "info");
            }

        });

        $A.enqueueAction(action);
    },

    additionalDocuments : function(component, contractNumber) {

		/// Wiston Data Documentos Adicionales (8 al 12)
		var wistonDataAdditionalOptions = component.get("v.wistonDataAdditionalOptions");

        this.getDocumentsAvailableWD(component, contractNumber, wistonDataAdditionalOptions, 0, true, false);

		component.set("v.disabledAdditionalButtons", true);
    },

    openDocumentApiGee : function(idRequest, link, imageName) {

        var evt = $A.get("e.force:navigateToComponent");

        evt.setParams({
            componentDef : "c:MicroServicioModalImagenesBO",
            componentAttributes: {
                idSolicitud : idRequest,
                link : link,
                nombreImagen : imageName,
                blnReporteBuro : false,
                blnDocumentApiGee : true
            }
        });
        evt.fire();
    },

    newSearch : function(component) {

        component.set("v.idRequestCURP", '');
        this.clearVariables(component);

        ///
        var workspaceAPI = component.find("workspace");

		workspaceAPI.getAllTabInfo().then(function(response) {

			for(var i = 0; i < response.length; i++) {

				var tabId = response[i].tabId; 
				workspaceAPI.closeTab({tabId: tabId});
			}
		})
		.catch(function(error) {
			console.log(error);
		});
    },

    clearVariables : function(component) {

        component.set("v.stepNumberExpedientes", 1);
        component.set("v.idRequest", '');
        component.set("v.curp", '');
        component.set("v.isCurp", false);
        component.set("v.showCurpField", false);
        component.set("v.contractNumber", '');
        component.set("v.urlCreditReport", '');
        component.set("v.blnAdditionalDocuments", false);
        component.set("v.showAdditionalDocumentsAvailable", false);
        component.set("v.disabledAdditionalButtons", false);
        component.set("v.requiredCurpField", false);
        component.set("v.documentAvailable", false);

        ///
        component.set("v.pdfCreditReportAvailable", false);
    }

})