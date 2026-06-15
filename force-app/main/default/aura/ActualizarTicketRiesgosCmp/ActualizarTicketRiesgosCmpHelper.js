({
    actualizarTicket : function(component, event) {

        var mapCampos = {};
        mapCampos["recordId"] = component.get("v.recordId");
        mapCampos["evaluar"] = component.get("v.caso.Evaluar__c");
        mapCampos["motivoDePendiete"] = component.get("v.caso.Motivo_de_Pendiente__c");
        mapCampos["numeroSolicitud"] = component.get("v.caso.ID_Solicitud__c");
        mapCampos["IdSolicitud"] = component.get("v.caso.Id_Solicitud_Gestor__c");
        mapCampos["blnPendientesCredito"] = component.get("v.caso.Validar_Movimientos__c");
        mapCampos["blnPendientesFraudes"] = component.get("v.caso.Publicidad__c");
        mapCampos["idEvaluacionesC"] = component.get("v.caso.Apellido_s_Anonimo__c");
        mapCampos["idEvaluacionesF"] = component.get("v.caso.Oficina_Anonimo__c");
        mapCampos["idCustom"] = component.get("v.caso.Nombre_s_Anonimo__c");
        mapCampos["statusChangeRequest"] = component.get("v.caso.Solicitud_de_cancelaci_n__c");
        mapCampos["requestStatus"] = component.get("v.caso.Estatus__c");
        mapCampos["recordTypeDevName"] = component.get("v.caso.RecordType.DeveloperName");
        mapCampos["curp"] = component.get("v.caso.CURP__c");
        mapCampos["numTelefonoMovil"] = component.get("v.caso.N_mero_de_Tel_fono_M_vil__c");
        mapCampos["fechaActualizacion"] = component.get("v.caso.Fecha_de_actualizaci_n__c");

        var action = component.get("c.actualizarTicketGestor");

        action.setParams({

            "mapCampos": mapCampos
        });


        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state ActualizarTicket: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();                
                console.log('result actualizarTicket', result);

                if (result.success) { 
                    
                    component.set("v.mensaje", component.get("v.msjActExitosa"));
                    component.set("v.casoActualizadoEnMicroS", true);

                    /// Refresh View
                    $A.get('event.force:refreshView').fire();

                } else {

                    component.set("v.mensaje", component.get("v.msjErrorActualizacion"));
                }

            } else {

                component.set("v.mensaje", component.get("v.msjErrorActualizacion"));
            }

            component.set("v.actualizando", false);
        });

        $A.enqueueAction(action);
    },



    getUserInfo : function(component) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.getUserInfo");
        action.setParams({

            "recordId": recordId
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getUserInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result getUserInfo', result);
                if (result.success) { 

                    component.set("v.perfilUsuario", result.userProfile);
                    component.set("v.idUsuario", result.userId);

                    ///
                    component.set("v.caso", result.caso);

                    this.setValidations(component); 
                } else {

                    component.set("v.cargandoRecordData", false);
                    component.set("v.mensaje", component.get("v.msjErrorCargaInfo"));
                }

            } else {

                component.set("v.cargandoRecordData", false);
                component.set("v.mensaje", component.get("v.msjErrorCargaInfo"));
            }
            
        });

        $A.enqueueAction(action);
    },

    setValidations : function(component) {

        var casoActualizadoEnMicroS = component.get("v.caso.Actualizaci_n_Alta_en_SAT__c");
        var registroBloqueado = component.get("v.caso.Se_bloqueo_la_tarjeta__c");
        var recordTypeName = component.get("v.caso.RecordType.DeveloperName");
        var dictaminacion = component.get("v.caso.Evaluar__c");
        var ownerId = component.get("v.caso.OwnerId");        
        var perfilUsuario = component.get("v.perfilUsuario");
        var idUsuario = component.get("v.idUsuario");
        var listPerfilesCredito = component.get("v.listPerfilesCredito");

        if( casoActualizadoEnMicroS ) {

            /// El caso ya fue actualizado
            component.set("v.casoActualizadoEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjActualizado"));

        } else if(registroBloqueado) {

            /// Registro en aprobacion
            component.set("v.casoActualizadoEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjEnAprobacion"));

        } else if( (recordTypeName == 'Riesgos_Originaci_n' || recordTypeName == 'BackOffice_Figital') && this.validarCampoVacio(dictaminacion) ) {

            /// Sin Dictaminacon de Back Office
            component.set("v.casoActualizadoEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjDicCredito"));

        } else if ( ownerId.startsWith('00G') ) {

            /// El Propietario es una cola de usuarios
            component.set("v.casoActualizadoEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjSinPropietario"));

        } else if( recordTypeName == 'Riesgos_Originaci_n' && !this.validarCampoVacio(perfilUsuario) && !listPerfilesCredito.includes(perfilUsuario) && idUsuario != ownerId ) {

            /// No es el Propietario del Caso. Bandeja de Credito
            component.set("v.casoActualizadoEnMicroS", true);
            component.set("v.mensaje", component.get("v.msjNoEsPropietario"));
        }

        component.set("v.cargandoRecordData", false);
    },

    validarCampoVacio : function(campo) {

        if( campo == undefined || campo == null || campo == '' ) {

            return true;
        } else {
            
            return false;
        }
    }
    
})