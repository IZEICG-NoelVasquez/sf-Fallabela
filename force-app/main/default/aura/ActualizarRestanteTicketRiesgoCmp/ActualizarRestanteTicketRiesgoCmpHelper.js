({
    
    consultarDatos : function(component) {
        
        var idSolicutud = component.get("v.caseInfo.ID_Solicitud__c");
        
        var action = component.get("c.recuperarInformacionSolicitud");
        action.setParams({

            "idSolicutud": idSolicutud,
            "blnComponente": true
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state ConsultarTicket: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result consultarTicket', result);
                if (result.success) { 
                    
                    component.set("v.mensaje", component.get("v.msjExitoConsulta"));
                    component.set("v.consultaRealizadaEnMicroS", true);


                    ///
                    $A.get('event.force:refreshView').fire();

                } else {

                    component.set("v.mensaje", component.get("v.msjErrorConsulta"));
                }

            } else {

                component.set("v.mensaje", component.get("v.msjErrorConsulta"));
            }

            component.set("v.consultando", false);
        });

        $A.enqueueAction(action);

    },

    getCaseInfo : function(component) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.getCaseInfo");
        action.setParams({

            "recordId": recordId
        });


        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getCaseInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result getCaseInfo', result);

                if (result.success) { 

                    component.set("v.caseInfo", result.caseInfo);

                    this.setValidations(component);

                } else {

                    component.set("v.cargandoRecordData", false);
                    component.set("v.mensaje", component.get("v.msjErrorCargaInfo"));

                    component.set("v.consultaRealizadaEnMicroS", true);
                }

            } else {

                component.set("v.cargandoRecordData", false);
                component.set("v.mensaje", component.get("v.msjErrorCargaInfo"));

                component.set("v.consultaRealizadaEnMicroS", true);
            }
            
        });

        $A.enqueueAction(action);
    },

    setValidations : function(component) {

        var consultaRealizadaEnMicroS = component.get("v.caseInfo.Actualizaci_n_de_domicilio_en_SAT__c");

        if(consultaRealizadaEnMicroS) {

            component.set("v.consultaRealizadaEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjConsultaRealizada"));
        }

        ///
        component.set("v.cargandoRecordData", false);
    }
})