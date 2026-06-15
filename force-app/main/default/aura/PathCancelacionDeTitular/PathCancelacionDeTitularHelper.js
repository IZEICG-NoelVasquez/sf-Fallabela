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

    getPickListValues : function(component) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.getPickListValues");

        action.setParams({
            "recordId" : recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getPickListValues: ", state);

            if (state === "SUCCESS") {

                var motivoCancelacionOptions = [];
                var continuarCancelacionOptions = [];
                var subgrupoOptions = [];
                var motivoRetencionOptions = [];

                var mapMotivoRetencionDependencias = {};

                motivoCancelacionOptions.push({label:'--Ninguno--', value:''});
                continuarCancelacionOptions.push({label:'--Ninguno--', value:''});
                subgrupoOptions.push({label:'--Ninguno--', value:''});
                motivoRetencionOptions.push({label:'--Ninguno--', value:''});

                var subgrupoValue = '';
                var motivoRetencionValue = '';

                var result = response.getReturnValue();

                if( result ) {                    

                    if( result.mapMotivoCancelacion ) {                        

                        for(var key in result.mapMotivoCancelacion ) {

                            motivoCancelacionOptions.push({label:key, value:result.mapMotivoCancelacion[key]});
                        }
                    }                    

                    if( result.mapContinuarCancelacion ) {                        

                        for(var key in result.mapContinuarCancelacion ) {

                            continuarCancelacionOptions.push({label:key, value:result.mapContinuarCancelacion[key]});
                        }
                    }                    

                    if( result.mapSubgrupo ) {                        

                        for(var key in result.mapSubgrupo ) {

                            subgrupoOptions.push({label:key, value:result.mapSubgrupo[key]});
                        }
                    }

                    if( result.mapMotivoRetencionDependencias ) {

                        for(var key in result.mapMotivoRetencionDependencias ) {

                            mapMotivoRetencionDependencias[key] = result.mapMotivoRetencionDependencias[key];
                        }
                    }                    
                    console.log('result.currentCase.Subgrupo__c'+result.currentCase.Subgrupo__c);

                    component.set("v.caseStatus", result.currentCase.Status);
                    component.set("v.motivoCancelacionValue", result.currentCase.Motivo_de_cancelaci_n_de_tarjeta__c);
                    component.set("v.continuarCancelacionValue", result.currentCase.Cliente_desea_continuar_con_la_cancelac__c);
                    component.set("v.subgrupoValue", result.currentCase.Subgrupo__c);


                    subgrupoValue = result.currentCase.Subgrupo__c;
                    motivoRetencionValue = result.currentCase.Motivo_de_la_Retenci_n__c;               
                }

                component.set("v.motivoCancelacionOptions", motivoCancelacionOptions);
                component.set("v.continuarCancelacionOptions", continuarCancelacionOptions);
                component.set("v.subgrupoOptions", subgrupoOptions);

                component.set("v.mapMotivoRetencionDependencias", mapMotivoRetencionDependencias);

                /// Visualizar Casos Cerrados
                if( result.currentCase.Status == 'Cancelado' || result.currentCase.Status == 'Cerrado' ) {

                    motivoRetencionOptions.push({label:result.currentCase.Motivo_de_la_Retenci_n__c, value:result.currentCase.Motivo_de_la_Retenci_n__c});
                    component.set("v.motivoRetencionOptions", motivoRetencionOptions);
                    component.set("v.motivoRetencionValue", result.currentCase.Motivo_de_la_Retenci_n__c);
                    component.set("v.caseClosed", true);

                } else {

                    this.setMotivoRetencionOptions(component, result.currentCase.Subgrupo__c, result.currentCase.Motivo_de_la_Retenci_n__c);
                }

                component.set("v.caseInfoLoaded", true);
            }
        });

        $A.enqueueAction(action);
    },

    setMotivoRetencionOptions : function(component, subgrupoValue, motivoRetencionValue) {

        var mapMotivoRetencionDependencias = component.get("v.mapMotivoRetencionDependencias");

        var motivoRetencionOptions = [];

        motivoRetencionOptions.push({label:'--Ninguno--', value:''});

        if( mapMotivoRetencionDependencias[subgrupoValue] ) {

            for(var i = 0; i < mapMotivoRetencionDependencias[subgrupoValue].length; i ++) {

                motivoRetencionOptions.push({label:mapMotivoRetencionDependencias[subgrupoValue][i], value:mapMotivoRetencionDependencias[subgrupoValue][i]});
            }
        }

        component.set("v.motivoRetencionOptions", motivoRetencionOptions);

        if( subgrupoValue ) {

            component.set("v.motivoRetencionValue", motivoRetencionValue);
        }
    },

    updateCase : function(component) {

        var recordId = component.get("v.recordId");
        var mapFields = {};

        var motivoCancelacionValue = component.find("motivoCancelacion");
        var continuarCancelacionValue = component.find("continuarCancelacion");
        var subgrupoValue = component.find("subgrupo");
        var motivoRetencionValue = component.find("motivoRetencion");
        console.log('motivoRetencionValue'+motivoRetencionValue);

        mapFields['Motivo_de_cancelaci_n_de_tarjeta__c'] = motivoCancelacionValue.get("v.value");        
        mapFields['Cliente_desea_continuar_con_la_cancelac__c'] = continuarCancelacionValue.get("v.value");
        mapFields['Subgrupo__c'] = subgrupoValue.get("v.value");    
        mapFields['Motivo_de_la_Retenci_n__c'] = motivoRetencionValue.get("v.value");

        var action = component.get("c.updateCaseByRT");

        action.setParams({
            "caseId" : recordId,
            "mapFields": mapFields
        });

        action.setCallback(this, function(response) {

            var state = response.getState(); 

            if (state === "SUCCESS") {
            
                var result = response.getReturnValue();

                console.log("result updateCase:  ", result );

                if ( !result.success ) {

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

            component.set("v.savingRecord", false);
        });

        $A.enqueueAction(action);
    }
})