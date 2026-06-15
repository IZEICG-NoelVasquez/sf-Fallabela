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
    
    obtenerEstado : function(component) {

        console.log("obtenerEstado");

        var selectedAccount = component.get("v.selectedAccount");
        var estado = selectedAccount.Regi_n__c;

        if( !(this.validarCampo(estado)) ) {

            var action = component.get("c.obtenerEstado");
            action.setParams({
                "estado": estado
            });

            action.setCallback(this, function(response) {
                
                var state = response.getState();            
                console.log("state obtenerEstado: ", state);
                if (state === "SUCCESS") {

                    var result = response.getReturnValue();
                    
                    console.log('result obtenerEstado', result);
                    if (result) { 

                        component.set("v.region", result.Name);
                        
                        component.set("v.lookUpIdEstado", result.Id);
                        component.set("v.lookUpObjEstado", result);

                        var lookUpCmpEstado = component.find("lookUpCmpEstado");
                        lookUpCmpEstado.set("v.selectedObjectDisplayName", result.Name);
                        lookUpCmpEstado.set("v.selectedObject", result);

                        /// Se busca el Municipio
                        this.obtenerMunicipio(component);
                    } else {

                        component.set("v.cargandoInfoDireccion", false);
                        console.log("Error obtenerEstado: ", result);                    
                    }

                } else {

                    component.set("v.cargandoInfoDireccion", false);
                    console.log("Error obtenerEstado: ", result);
                }
            });

            $A.enqueueAction(action);

        } else {

            component.set("v.cargandoInfoDireccion", false);
        }
    },

    obtenerMunicipio : function(component) {

        console.log("obtenerMunicipio");

        var selectedAccount = component.get("v.selectedAccount");
        var municipio = selectedAccount.Delegaci_n__c;
        var idEstado = component.get("v.lookUpIdEstado");

        if( !(this.validarCampo(municipio)) ) {

            var action = component.get("c.obtenerMunicipio");
            action.setParams({
                "municipio": municipio,
                "idEstado": idEstado
            });

            action.setCallback(this, function(response) {
                
                var state = response.getState();            
                console.log("state obtenerMunicipio: ", state);
                if (state === "SUCCESS") {

                    var result = response.getReturnValue();
                    
                    console.log('result obtenerMunicipio', result);
                    if (result) { 

                        component.set("v.delegacion", result.Name);
                        
                        component.set("v.lookUpIdMunicipio", result.Id);
                        component.set("v.lookUpObjMunicipio", result);

                        var lookUpCmpMunicipio = component.find("lookUpCmpMunicipio");
                        lookUpCmpMunicipio.set("v.selectedObjectDisplayName", result.Name);
                        lookUpCmpMunicipio.set("v.selectedObject", result);

                        /// Se busca la Colonia
                        this.obtenerColonia(component);
                    } else {

                        component.set("v.cargandoInfoDireccion", false);
                        console.log("Error obtenerMunicipio: ", result);
                    }

                } else {

                    component.set("v.cargandoInfoDireccion", false);
                    console.log("Error obtenerMunicipio: ", result);
                }
            });

            $A.enqueueAction(action);

        } else {

            component.set("v.cargandoInfoDireccion", false);
        }
    },

    obtenerColonia : function(component) {

        console.log("obtenerColonia");

        var selectedAccount = component.get("v.selectedAccount");
        var colonia = selectedAccount.Colonia__c;
        var idMunicipio = component.get("v.lookUpIdMunicipio");

        if( !(this.validarCampo(colonia)) ) {

            var action = component.get("c.obtenerColonia");
            action.setParams({
                "colonia": colonia,
                "idMunicipio": idMunicipio
            });

            action.setCallback(this, function(response) {
                
                var state = response.getState();            
                console.log("state obtenerColonia: ", state);
                if (state === "SUCCESS") {

                    var result = response.getReturnValue();
                    
                    console.log('result obtenerColonia', result);
                    if (result) { 

                        component.set("v.colonia", result.Name);
                        
                        component.set("v.lookUpIdColonia", result.Id);
                        component.set("v.lookUpObjColonia", result);

                        var lookUpCmpColonia = component.find("lookUpCmpColonia");
                        lookUpCmpColonia.set("v.selectedObjectDisplayName", result.Name);
                        lookUpCmpColonia.set("v.selectedObject", result);

                        /// Se asigna el Codigo Postal
                        component.set("v.codigoPostal", result.C_digo_Postal__c);

                        component.set("v.cargandoInfoDireccion", false);
                    } else {

                        component.set("v.cargandoInfoDireccion", false);
                        console.log("Error obtenerColonia: ", result);
                    }

                } else {

                    component.set("v.cargandoInfoDireccion", false);
                    console.log("Error obtenerColonia: ", result);
                }
            });

            $A.enqueueAction(action);

        } else {

            component.set("v.cargandoInfoDireccion", false);
        }
    }, 

    validarCampoVacio : function(component, campo) {

        if( campo == null || campo == undefined || campo == '' ) {
            this.showToast("Accion Requerida", "No se permite enviar campos vacios", "warning");
            return true;
        }
    },

    limpiarVaribles : function(component) {

        this.limpiarVariblesDeValidacion(component);
        /// Estado
        component.set("v.region", '');
        component.set("v.lookUpObjEstado", null);
        component.set("v.lookUpIdEstado", '');
        /// Municipio
        component.set("v.delegacion", '');
        component.set("v.lookUpObjMunicipio", null);
        component.set("v.lookUpIdMunicipio", '');
        /// Colonia
        component.set("v.colonia", '');
        component.set("v.lookUpObjColonia", null);
        component.set("v.lookUpIdColonia", '');
        /// Codigo Postal
        component.set("v.codigoPostal", '');

        component.set("v.mostrarColoniaCPTexto", false);

        component.set("v.creatingCase", false);
        component.set("v.newCaseAddress", '');

        component.set("v.mapCamposMicroS", {});

        ///
        component.set("v.enableOTPModal", false);
    },

    limpiarVariblesDeValidacion : function(component) {

        component.set("v.blnTipoDeVia", false);
        component.set("v.blnRegion", false);
        component.set("v.blnDelegacion", false);
        component.set("v.blnNombreVia", false);
        component.set("v.blnColonia", false);
        component.set("v.blnNumeroDeVia", false);
        component.set("v.blnCodigoPostal", false);
    },
    
    actualizarDireccion : function(component) {

        console.log("Actualizar Direccion Helper");
        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;

        /// Se agregan al Mapa los campos que se Actualizaron.
        var mapCamposMicroS = component.get("v.mapCamposMicroS");
        mapCamposMicroS["numeroDocumento"] = numeroDocumento;

        if( component.get("v.blnTipoDeVia") ) {
            mapCamposMicroS["codigoTipoVia"] = component.get("v.tipoDeVia");
        }
        if( component.get("v.blnNombreVia") ) {
            mapCamposMicroS["nombreVia"] = component.get("v.nombreVia");
        }
        if( component.get("v.blnNumeroDeVia") ) {
            mapCamposMicroS["numeroVivienda"] = component.get("v.numeroDeVia");
        }
        if( component.get("v.blnRegion") ) {
            mapCamposMicroS["codigoRegion"] = component.get("v.lookUpObjEstado").Codigo__c;
            mapCamposMicroS["region"] = component.get("v.region");
        }
        if( component.get("v.blnDelegacion") ) {
            mapCamposMicroS["tipoBarrio"] = component.get("v.delegacion");
        }
        if( component.get("v.blnColonia") ) {
            mapCamposMicroS["descripcionBarrio"] = component.get("v.colonia");
        }
        if( component.get("v.blnCodigoPostal") ) {
            mapCamposMicroS["codigoPostal"] = component.get("v.codigoPostal");
        }
        //nuevo campo resto dirección se agrega al map 
        if( component.get("v.blnRestoDireccion") ) {
            mapCamposMicroS["restoDireccion"] = component.get("v.restoDireccion");
        }

        component.set("v.mapCamposMicroS", mapCamposMicroS);

        var action = component.get("c.actualizarDomicilio");
        action.setParams({
            "campos" : mapCamposMicroS
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state addressUpdate: ", state);
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result addressUpdate', result);

                if (result.success) { 
                    
                    component.set("v.addressUpdated", true);
                    component.set("v.loadingAddressUpdate", false);

                    this.crearCasoAddressUpdate(component);
                    component.set("v.creatingCase", true);

                } else {

                    if( result.domicilio && result.domicilio.message && (result.domicilio.message === 'Invalid request data') ) {

                        component.set("v.messageAddressUpdate", 'Ha ocurrido un error durante la actualización, por favor revise los valores enviados el campo Número solo admite digitos del 0 al 9');

                    } else {

                        component.set("v.messageAddressUpdate", 'Ha ocurrido un error, Favor de reportarlo a su administrador.');
                    }

                    component.set("v.addressUpdated", false);
                    component.set("v.loadingAddressUpdate", false);
                }

            } else {

                component.set("v.addressUpdated", false);     
                component.set("v.loadingAddressUpdate", false);     
            }
        });

        $A.enqueueAction(action);
    },

    crearCasoAddressUpdate : function(component) {

        /// Variables para la creacion del Caso Actualizacion de Domicilio
        var catSubSelected = 'Actualización de Domicilio'; // <-------------------------
        var caseRTypes = component.get("v.caseRTypes");
        var recordType = caseRTypes[catSubSelected];
        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;
        var selectedPerson = selectedAccount.PersonContactId;
        var category = 'Actualización de Datos'; // <-----------------------
        var altoRiesgo = component.get("v.altoRiesgo");
        var esAltoRiesgo = (altoRiesgo.indexOf(catSubSelected) > -1);
        var metodoContactoValue = component.get("v.contactMethodValue");
        var numeroDeTarjetaValue = '';

        var estado = component.get("v.lookUpIdEstado");
        var municipio = component.get("v.lookUpIdMunicipio");
        var colonia = component.get("v.lookUpIdColonia");
        var coloniaTexto = component.get("v.colonia");
        var codigoPostal = component.get("v.codigoPostal");
        var calle = component.get("v.tipoDeVia");
        calle += ' ';
        calle += component.get("v.nombreVia");
        var numeroExterior = component.get("v.numeroDeVia");
        var mostrarColoniaCPTexto = component.get("v.mostrarColoniaCPTexto");
        var restoDir = component.get("v.restoDireccion"); //nuevo campo resto dir

        // Campos requeridos para cerrar el Caso
        var camposRequeridos = 'Estado_Direccion__c:';
        camposRequeridos += estado;
        camposRequeridos += ',';
        camposRequeridos += 'Municipio_Direccion__c:';
        camposRequeridos += municipio;
        camposRequeridos += ',';
        camposRequeridos += 'Calle__c:';
        camposRequeridos += calle;
        camposRequeridos += ',';
        camposRequeridos += 'Exterior__c:';
        camposRequeridos += numeroExterior;
        //nuevo campo resto dir
        camposRequeridos += ',';    
        camposRequeridos += 'Resto_Direccion__c:';
        camposRequeridos += restoDir;
        
        // Campo para controlar Process Builder
        camposRequeridos += ',';
        camposRequeridos += 'Domicilio_Actualizado_en_MicroServicio__c:true';
        // Colonia LookUp 
        if( !mostrarColoniaCPTexto ) {
            camposRequeridos += ',';
            camposRequeridos += 'Colonia_Direccion__c:';
            camposRequeridos += colonia;
        } else {
            camposRequeridos += ',';
            camposRequeridos += 'Colonia_Texto__c:';
            camposRequeridos += coloniaTexto;
            camposRequeridos += ',';
            camposRequeridos += 'C_digo_Postal_Texto__c:';
            camposRequeridos += codigoPostal;
        }

        var action = component.get("c.createCaseClosedDomicilio");
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

                    console.log("result ", result );
                    component.set("v.newCaseAddress", result.folioCaso );
                    console.log("v.newCaseAddress:  ", component.get("v.newCaseAddress") );
                    this.loadAccountById(component, result.account);

                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", true);
                } else {

                    component.set("v.creatingCase", false);
                    component.set("v.successfulCase", false);
                }
            } else {

                component.set("v.creatingCase", false);
                component.set("v.successfulCase", false);
            }

        });

        $A.enqueueAction(action);
    },

    loadAccountById : function(component, isAcc) {

        console.log('loadAccountById');

        var campos = component.get("v.mapCamposMicroS");
        var action = component.get("c.updateSelectedAccount");        
        
        action.setParams({
            "idAcc" : isAcc, 
            "campos" : campos
        });
        
        action.setCallback(this, function(response) {
			
			var state = response.getState();            
			if (state === "SUCCESS") {

				var acc = response.getReturnValue();                
                if (acc) {      
                    
                    component.set("v.selectedAccount", acc);                    
                } else {
                    console.log("Error acc: ", acc);
                }
			} else {
				console.log("Error state: ", state);
			}

		});

		$A.enqueueAction(action);
    },

    setModalState : function (component, state) {
        
        var cmpModal = component.find("otpModalAddressUpdate");
        cmpModal.setState(state);
    },

    abrirModalDomicilio : function(component) {

        ///
        component.set("v.cargandoInfoDireccion", true);

        component.set("v.openModalAddressUpdate", true);
        component.set("v.noPasoAddressUpdate", 1);

        var selectedAccount = component.get("v.selectedAccount");
        component.set("v.tipoDireccion", selectedAccount.Tipo_Direcci_n__c);
        component.set("v.tipoDeVia", selectedAccount.Tipo_de_v_a__c);
        component.set("v.restoDireccion", selectedAccount.Resto_Direcci_n__c);
        component.set("v.nombreVia", selectedAccount.Nombre_v_a__c);
        component.set("v.numeroDeVia", selectedAccount.N_mero_de_v_a__c);

        ///
        var tipoDeVia = component.get("v.tipoDeVia");
        if(tipoDeVia) {
            var tipoViaUpperCase = tipoDeVia.toUpperCase();
            component.find("selectTipoVia").set("v.value", tipoViaUpperCase );
        }

        /// Se Carga Estado, Municipio y Colonia
        this.obtenerEstado(component);
    },

    validarCampo : function(campo) {

        var result = false;
        if( campo == null || campo == '' || campo == undefined ) {

            result = true;
        }

        return result;
    },

    openModalContactMethod : function(component) {

        component.set("v.blnOpenModalContactMethod", true);
    }

})