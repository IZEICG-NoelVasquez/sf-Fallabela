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

    validateNumber : function(field) {

        var regex = /^([0-9])*$/,
            validate = field.match(regex);

        return validate;
    },

    validateEmptyField : function(field) {

        if( field == undefined || field == null || field == '' ) {

            return true;

        } else {
            
            return false;
        }
    },

    getCaseInfo : function(component) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.getCaseInfo");

        action.setParams({

            "recordId": recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("getCaseInfo state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('getCaseInfo result', result);

                if (result.success) { 
                    
                    ///
                    component.set("v.mobilePhone", result.caseInfo.N_mero_de_Tel_fono_M_vil__c);
                    component.set("v.creditLimit", result.caseInfo.Cupo__c);

                    component.set("v.caseRecord", result.caseInfo);

                    component.set("v.dataUpdateAttempts", result.dataUpdateAttempts);

                    component.set("v.recordInApproval", result.caseInfo.Se_bloqueo_la_tarjeta__c);

                    if( result.caseInfo.Se_bloqueo_la_tarjeta__c ) {

                        this.showToast("", "La solicitud se encuentra en proceso de aprobación.", "warning");
                    }

                    /// Se valida la seleccion del componente Cambio de Estado
                    var lstSelectedUpdateMobile = component.get("v.lstSelectedUpdateMobile");
                    var lstSelectedUpdateCreditLimit = component.get("v.lstSelectedUpdateCreditLimit");

                    if( lstSelectedUpdateMobile.includes(result.caseInfo.C_digo_Postal_Direcci_n_Otros__c) ) {

                        component.set("v.selectedUpdateMobile", true);
                    }

                    if( lstSelectedUpdateCreditLimit.includes(result.caseInfo.C_digo_Postal_Direcci_n_Otros__c) ) {

                        component.set("v.selectedUpdateCreditLimit", true);
                    }

                    var lstProfilesAllowedCredito = component.get("v.lstProfilesAllowedCredito");
                    var lstRolesWhoNeedApproval = component.get("v.lstRolesWhoNeedApproval");

                    if( lstProfilesAllowedCredito.includes(result.userProfile) ) {

                        component.set("v.allowedDataUpdate", true);

                        /// Roles que necesitan Aprobacion para actualizar el telefono movil
                        if( !lstRolesWhoNeedApproval.includes(result.userRole) ) {

                            component.set("v.allowedUpdateMobile", true);

                        } else if( lstRolesWhoNeedApproval.includes(result.userRole) && result.caseInfo.Cuenta_al_Corriente__c === 'No' ) {
                            
                            component.set("v.approvalRejected", true);
                            this.showToast("", "La solicitud de aprobación fue rechazada.", "warning");
                        
                        } else if( lstRolesWhoNeedApproval.includes(result.userRole) && result.caseInfo.Cuenta_al_Corriente__c === 'Sí' ) {

                            component.set("v.allowedUpdateMobile", true);
                        }

                        /// Numero de Intentos
                        var attemptNumberMobilePhone = 0;
                        var attemptNumberCreditLimit = 0;

                        if( result.caseInfo.Historial_de_Cambios__r && result.caseInfo.Historial_de_Cambios__r.length > 0 ) {

                            for(var i = 0; i < result.caseInfo.Historial_de_Cambios__r.length; i ++ ) {

                                if( (attemptNumberMobilePhone == 0) && (result.caseInfo.Historial_de_Cambios__r[i].API_Name__c == 'N_mero_de_Tel_fono_M_vil__c') ) {

                                    attemptNumberMobilePhone = result.caseInfo.Historial_de_Cambios__r[i].Numero_de_intento__c;
                                }

                                if( (attemptNumberCreditLimit == 0) && (result.caseInfo.Historial_de_Cambios__r[i].API_Name__c == 'Cupo__c') ) {

                                    attemptNumberCreditLimit = result.caseInfo.Historial_de_Cambios__r[i].Numero_de_intento__c;
                                }

                                if( attemptNumberMobilePhone > 0 && attemptNumberCreditLimit > 0 ) {

                                    break;
                                }
                            }
                        }

                        component.set("v.attemptNumberMobilePhone", attemptNumberMobilePhone);
                        component.set("v.attemptNumberCreditLimit", attemptNumberCreditLimit);                        

                        var lstStatusAllowed = component.get("v.lstStatusAllowed");

                        if( lstStatusAllowed.includes(result.caseInfo.Status) ) {

                            component.set("v.allowedStatus", true);
                        }
                    }

                    component.set("v.updatingInformation", false);
                } 

            }
        });

        $A.enqueueAction(action);
    },
	
	dataUpdate : function(component) {

        var changedMobilePhone = component.get("v.changedMobilePhone");
        var changedCreditLimit = component.get("v.changedCreditLimit");

        var mobilePhone = component.get("v.mobilePhone");
        var creditLimit = component.get("v.creditLimit");

        var caseRecord = component.get("v.caseRecord");
		
		var mapFields = {};

        if( changedMobilePhone ) {

            mapFields["mobilePhone"] = mobilePhone;
            mapFields["telefonoId"] = caseRecord.Contrato_Anonimo__c;
        }

        if( changedCreditLimit ) {

            mapFields["creditLimit"] = creditLimit;
            mapFields["evaluacionId"] = caseRecord.Apellido_s_Anonimo__c;
            mapFields["customId"] = caseRecord.Nombre_s_Anonimo__c;
        }

		var action = component.get("c.dataUpdateMS");

		action.setParams({
            "mapFields": mapFields
        });

		action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("dataUpdate state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('dataUpdate result: ', result);

                if ( result ) {

                    /// Actualizacion de Telefono Movil y Limite de Credito
                    if( changedMobilePhone && changedCreditLimit ) {

                        if( result.updateMobilePhone && result.updateCreditLimitEvaluaciones && result.updateCreditLimitCustom ) {

                            component.set("v.messageUpdateData", "Se actualizó la solicitud en Onboarding.");

                            var mapFieldsUpdateCase = this.createMapFieldsUpdateCase(component, true, true);
                            var lstMapFields = this.createMapFieldsHistory(component, true, true);
                            this.createCaseHistoryJS(component, lstMapFields, mapFieldsUpdateCase);

                        } else if( !result.updateMobilePhone && !result.updateCreditLimitEvaluaciones && !result.updateCreditLimitCustom ) {

                            component.set("v.messageUpdateData", "Ocurrió un error al actualizar la solicitud en Onboarding.");
                            component.set("v.updatingInformation", false);

                        } else {

                            if( result.updateCreditLimitEvaluaciones && result.updateCreditLimitCustom && !result.updateMobilePhone ) {

                                component.set("v.messageUpdateData", "Se actualizó el límite de crédito. Ocurrió un error al actualizar el teléfono móvil en Onboarding.");

                                var mapFieldsUpdateCase = this.createMapFieldsUpdateCase(component, false, true);
                                var lstMapFields = this.createMapFieldsHistory(component, false, true);
                                this.createCaseHistoryJS(component, lstMapFields, mapFieldsUpdateCase);

                            } else if( result.updateMobilePhone && (!result.updateCreditLimitEvaluaciones || !result.updateCreditLimitCustom) ) {

                                if( !result.updateCreditLimitEvaluaciones && !result.updateCreditLimitCustom ) {

                                    component.set("v.messageUpdateData", "Se actualizó el teléfono móvil. Ocurrió un error al actualizar el límite de crédito en Onboarding.");

                                } else if( !result.updateCreditLimitCustom ) {

                                    component.set("v.messageUpdateData", "Se actualizó el teléfono móvil. Ocurrió un error al actualizar el límite de crédito en Onboarding, no se actualizo el campo 'cupo recomendado'. ");

                                } else if( !result.updateCreditLimitEvaluaciones ) {

                                    component.set("v.messageUpdateData", "Se actualizó el teléfono móvil. Ocurrió un error al actualizar el límite de crédito en Onboarding, no se actualizo el campo 'monto aprobado motor'. ");
                                }

                                var mapFieldsUpdateCase = this.createMapFieldsUpdateCase(component, true, false);
                                var lstMapFields = this.createMapFieldsHistory(component, true, false);
                                this.createCaseHistoryJS(component, lstMapFields, mapFieldsUpdateCase);

                            } else if( !result.updateCreditLimitCustom ) {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el teléfono móvil. Ocurrió un error al actualizar el límite de crédito en Onboarding, no se actualizo el campo 'cupo recomendado'. ");
                                component.set("v.updatingInformation", false);

                            } else if( !result.updateCreditLimitEvaluaciones ) {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el teléfono móvil. Ocurrió un error al actualizar el límite de crédito en Onboarding, No se actualizo el campo 'monto aprobado motor'. ");
                                component.set("v.updatingInformation", false);
                            }
                        }

                    } else {
                    
                        /// Actualizacion solo de Telefono Movil
                        if( changedMobilePhone ) {

                            if( result.updateMobilePhone ) {

                                component.set("v.messageUpdateData", "Se actualizó el teléfono móvil en Onboarding.");

                                var mapFieldsUpdateCase = this.createMapFieldsUpdateCase(component, true, false);
                                var lstMapFields = this.createMapFieldsHistory(component, true, false);
                                this.createCaseHistoryJS(component, lstMapFields, mapFieldsUpdateCase);

                            } else {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el teléfono móvil en Onboarding.");
                                component.set("v.updatingInformation", false);
                            }
                        }

                        /// Actualizacion solo de Limite de Credito
                        if( changedCreditLimit ) {

                            if( result.updateCreditLimitEvaluaciones && result.updateCreditLimitCustom ) {

                                component.set("v.messageUpdateData", "Se actualizó el límite de crédito en Onboarding.");

                                var mapFieldsUpdateCase = this.createMapFieldsUpdateCase(component, false, true);
                                var lstMapFields = this.createMapFieldsHistory(component, false, true);
                                this.createCaseHistoryJS(component, lstMapFields, mapFieldsUpdateCase);

                            } else if( !result.updateCreditLimitEvaluaciones && !result.updateCreditLimitCustom ) {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el límite de crédito en Onboarding.");
                                component.set("v.updatingInformation", false);

                            } else if( !result.updateCreditLimitCustom ) {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el límite de crédito en Onboarding, no se actualizo el campo 'cupo recomendado'. ");
                                component.set("v.updatingInformation", false);

                            } else if( !result.updateCreditLimitEvaluaciones ) {

                                component.set("v.messageUpdateData", "Ocurrió un error al actualizar el límite de crédito en Onboarding, no se actualizo el campo 'monto aprobado motor'. ");
                                component.set("v.updatingInformation", false);
                            }
                        }
                    }

                } else {

                    component.set("v.messageUpdateData", "Ocurrió un error al actualizar la solicitud en Onboarding.");
                    component.set("v.updatingInformation", false);
                }

            } else {

                component.set("v.messageUpdateData", "Ha ocurrido un error, favor de reportar a su administrador.");
                component.set("v.updatingInformation", false);
            }

        });

        $A.enqueueAction(action);
	},

    createMapFieldsUpdateCase : function(component, updateMobile, updateCreditLimit) {

        var mobilePhone = component.get("v.mobilePhone");
        var creditLimit = component.get("v.creditLimit");

        var mapFieldsUpdateCase = {};

        if(updateMobile) {

            mapFieldsUpdateCase['N_mero_de_Tel_fono_M_vil__c'] = mobilePhone;                            
        }

        if(updateCreditLimit) {

            mapFieldsUpdateCase['Cupo__c'] = parseFloat(creditLimit);
        }

        return mapFieldsUpdateCase;
    },

    createMapFieldsHistory : function(component, updateMobile, updateCreditLimit) {

        var recordId = component.get("v.recordId");
        var mobilePhone = component.get("v.mobilePhone");
        var creditLimit = component.get("v.creditLimit");
        var caseRecord = component.get("v.caseRecord");
        var attemptNumberMobilePhone = component.get("v.attemptNumberMobilePhone");
        var attemptNumberCreditLimit = component.get("v.attemptNumberCreditLimit");

        var lstMapFields = [];

        if(updateMobile) {

            var mapFieldsMobile = {};
            mapFieldsMobile['Caso__c'] = recordId;
            mapFieldsMobile['Name'] = 'Número de Teléfono Móvil';
            mapFieldsMobile['Valor_nuevo__c'] = mobilePhone;
            mapFieldsMobile['Valor_original__c'] = caseRecord.N_mero_de_Tel_fono_M_vil__c;
            mapFieldsMobile['Numero_de_intento__c'] = attemptNumberMobilePhone + 1;
            mapFieldsMobile['API_Name__c'] = 'N_mero_de_Tel_fono_M_vil__c';
            lstMapFields.push(mapFieldsMobile);
        }

        if(updateCreditLimit) {

            var mapFieldsCreditLimit = {};
            mapFieldsCreditLimit['Caso__c'] = recordId;
            mapFieldsCreditLimit['Name'] = 'Cupo';
            mapFieldsCreditLimit['Valor_nuevo__c'] = creditLimit;
            mapFieldsCreditLimit['Valor_original__c'] = caseRecord.Cupo__c.toString();
            mapFieldsCreditLimit['Numero_de_intento__c'] = attemptNumberCreditLimit + 1;
            mapFieldsCreditLimit['API_Name__c'] = 'Cupo__c';
            lstMapFields.push(mapFieldsCreditLimit);
        }

        return lstMapFields;
    },

    createCaseHistoryJS : function(component, lstMapFields, mapFieldsUpdateCase) {

        var action = component.get("c.createCaseHistory");

        console.log('lstMapFields:  ', lstMapFields);

        action.setParams({
            "lstMapFields": lstMapFields
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("createCaseHistoryJS state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('createCaseHistoryJS result', result);

                if (result.success) { 
                    
                    this.showToast("", "Se actualizó el historial", "success");

                    this.updateCaseRecordJS(component, mapFieldsUpdateCase);

                } else if( result.error ) {

                    this.showToast("Ha ocurrido un error", result.error, "info");
                    component.set("v.updatingInformation", false);
                }

            } else {

                var errors = action.getError();

				if( errors && errors[0] && errors[0].message ) {

					this.showToast("Ha ocurrido un error", errors[0].message, "error");

				} else {
				
					this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
				}

                component.set("v.updatingInformation", false);
            }
        });

        $A.enqueueAction(action);
    },

    updateCaseRecordJS : function(component, mapFields) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.updateCaseRecord");

        action.setParams({
            "recordId": recordId,
            "mapFields": mapFields
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("updateCaseRecordJS state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('updateCaseRecordJS result', result);

                if (result.success) { 
                    
                    this.showToast("", "Se actualizó la solicitud", "success");

                    /// Refresh View
                    $A.get('event.force:refreshView').fire();

                } else if( result.error ) {

                    this.showToast("Ha ocurrido un error", result.error, "info");
                }

            } else {

                var errors = action.getError();

				if( errors && errors[0] && errors[0].message ) {

					this.showToast("Ha ocurrido un error", errors[0].message, "error");

				} else {
				
					this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
				}
            }

            component.set("v.updatingInformation", false);
        });

        $A.enqueueAction(action);
    },

    submitForApprovalJS : function(component) {

        var mapFields = {};
        mapFields['recordId'] = component.get("v.recordId");

        var action = component.get("c.submitForApproval");

        action.setParams({
            "mapFields": mapFields
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("submitForApprovalJS state: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('submitForApprovalJS result', result);

                if (result.success) { 

                    component.set("v.recordInApproval", true);
                    
                    this.showToast("", "La solicitud de aprobación fue enviada con éxito.", "success");

                } else {

                    this.showToast("Ha ocurrido un error", "Al enviar la solicitud de aprobación", "error");
                }

            } else {

                this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
            }

            component.set("v.updatingInformation", false);
        });

        $A.enqueueAction(action);
    }
})