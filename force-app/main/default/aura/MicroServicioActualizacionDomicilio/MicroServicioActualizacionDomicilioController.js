({   
    toggleDireccion : function(component, event, helper) {
        
        var cmp = component.find("direccion");
        
        $A.util.toggleClass(cmp, "slds-is-open");
        
        var button = event.getSource();
        
        var iconName = button.get("v.iconName") === 'utility:chevronright' ? 'utility:chevrondown' : 'utility:chevronright';
        
        button.set("v.iconName", iconName);
    },

    handleSelectedEventLookUp : function (component, event, helper) {

        console.log("Selected EventLookUp Actualizacion de Domicilio");
        /// Se Valida el evento que detono el lookUp
        var lookUpSelected = [];
        lookUpSelected = event.getParam("selectedObject");
        var uniqueLookupIdentifier = event.getParam("uniqueLookupIdentifier");
        console.log("uniqueLookupIdentifier:  ", uniqueLookupIdentifier);
        if( uniqueLookupIdentifier == 'estado' ) {
            
            /// Estado
            component.set("v.region",  lookUpSelected.Name);
        } else if( uniqueLookupIdentifier == 'municipio' ) {
            
            /// Municipio
            component.set("v.delegacion", lookUpSelected.Name);
        } else if( uniqueLookupIdentifier == 'colonia' ) {

            /// Colonia
            component.set("v.colonia", lookUpSelected.Name);

            /// Codigo Postal
            component.set("v.codigoPostal", lookUpSelected.C_digo_Postal__c);
        }

    },
    
    handleRemovedEventLookUp : function (component, event, helper) {

        console.log("Removed EventLookUp Actualizacion de Domicilio");
        /// Se Valida el evento que detono el lookUp 
        var uniqueLookupIdentifier = event.getParam("uniqueLookupIdentifier");
        console.log("uniqueLookupIdentifier:  ", uniqueLookupIdentifier);
        var mostrarColoniaCPTexto = component.get("v.mostrarColoniaCPTexto");
        if( uniqueLookupIdentifier == 'estado' ) {
            
            /// Estado
            component.set("v.region", '');

            /// Municipio
            component.set("v.delegacion", '');
            component.set("v.lookUpObjMunicipio", null);
            component.set("v.lookUpIdMunicipio", '');
            var lookUpCmpMunicipio = component.find("lookUpCmpMunicipio");
            lookUpCmpMunicipio.set("v.selectedObjectDisplayName", '');
            lookUpCmpMunicipio.set("v.selectedObject", null);             
            
            /// Colonia
            component.set("v.colonia", '');
            if( !mostrarColoniaCPTexto ) {
                component.set("v.lookUpObjColonia", null);
                component.set("v.lookUpIdColonia", '');
                var lookUpCmpColonia = component.find("lookUpCmpColonia");
                lookUpCmpColonia.set("v.selectedObjectDisplayName", '');
                lookUpCmpColonia.set("v.selectedObject", null);  
            } else {
                component.set("v.mostrarColoniaCPTexto", false);
            }
            /// Codigo Postal
            component.set("v.codigoPostal", '');
        } else if( uniqueLookupIdentifier == 'municipio' ) {

            /// Municipio
            component.set("v.delegacion", '');

            
            /// Colonia
            component.set("v.colonia", '');
                if( !mostrarColoniaCPTexto ) {
                component.set("v.lookUpObjColonia", null);
                component.set("v.lookUpIdColonia", '');
                var lookUpCmpColonia = component.find("lookUpCmpColonia");
                lookUpCmpColonia.set("v.selectedObjectDisplayName", '');
                lookUpCmpColonia.set("v.selectedObject", null);
            } else {
                component.set("v.mostrarColoniaCPTexto", false);
            }
            /// Codigo Postal
            component.set("v.codigoPostal", '');
        } else if( uniqueLookupIdentifier == 'colonia' ) {

            /// Colonia
            component.set("v.colonia", '');

            /// Codigo Postal
            component.set("v.codigoPostal", '');
        }
    },

    handleModalAddressUpdate : function (component, event, helper) {

        ///
        component.set("v.enableOTPModal", true);
        
        /// Validacion OTP     
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizacionDomicilio && mapValidacionesOTP.MicroServicioActualizacionDomicilio.otp ) {

            if( mapValidacionesOTP.MicroServicioActualizacionDomicilio.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizacionDomicilio.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioActualizacionDomicilio.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioActualizacionDomicilio.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP AddressUpdate:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP AddressUpdate:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {
            
            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;

        } else {
        
            helper.openModalContactMethod(component);
        }
    },

    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
        component.set("v.verificadoOTP", isValid);

        /// Validaciones OTP Dinamicas
        if( isValid ) {

            component.set("v.verificadoOTPGlobal", true);
            
            helper.openModalContactMethod(component);
        }
    },

    confirmarAddressUpdate : function (component, event, helper) {

        var tipoDeVia = component.get("v.tipoDeVia");
        var region = component.get("v.region");
        var delegacion = component.get("v.delegacion");
        var nombreVia = component.get("v.nombreVia");
        var colonia = component.get("v.colonia");
        var numeroDeVia = component.get("v.numeroDeVia");
        var codigoPostal = component.get("v.codigoPostal");
        var restoDirecion = component.get('v.restoDireccion'); //Nuevo campo agregado para el caso de que el usuario quiera editar el resto de la direccion
        var selectedAccount = component.get("v.selectedAccount");

        var contador = 0;

        /// Se verifica que campos fueron Editados 
        if( selectedAccount.Tipo_de_v_a__c != undefined && selectedAccount.Tipo_de_v_a__c != null && selectedAccount.Tipo_de_v_a__c != '' ) {
            var selectAccTipoVia = selectedAccount.Tipo_de_v_a__c;
            selectAccTipoVia = selectAccTipoVia.toUpperCase();
            if( (tipoDeVia != selectAccTipoVia) ) {                
                if( helper.validarCampoVacio(component, tipoDeVia) ) {
                    return;
                }
                component.set("v.blnTipoDeVia", true);
                contador ++;
            }   
        } else if( tipoDeVia != undefined && tipoDeVia != null && tipoDeVia != '' ) {
            if( helper.validarCampoVacio(component, tipoDeVia) ) {
                return;
            }
            component.set("v.blnTipoDeVia", true);
            contador ++;
        }

        if( selectedAccount.Nombre_v_a__c != undefined && selectedAccount.Nombre_v_a__c != null && selectedAccount.Nombre_v_a__c != '' ) {
            if( nombreVia != selectedAccount.Nombre_v_a__c ) {
                if( helper.validarCampoVacio(component, nombreVia) ) {
                    return;
                }
                component.set("v.blnNombreVia", true);
                contador ++;                
            }
        } else if( nombreVia != undefined && nombreVia != null && nombreVia != '' ) {
            if( helper.validarCampoVacio(component, nombreVia) ) {
                return;
            }
            component.set("v.blnNombreVia", true);
            contador ++;  
        }
        
        if( selectedAccount.N_mero_de_v_a__c != undefined && selectedAccount.N_mero_de_v_a__c != null && selectedAccount.N_mero_de_v_a__c != '' ) {
            if( numeroDeVia != selectedAccount.N_mero_de_v_a__c ) {
                if( helper.validarCampoVacio(component, numeroDeVia) ) {
                    return;
                }
                component.set("v.blnNumeroDeVia", true);
                contador ++;                
            }
        } else if( numeroDeVia != undefined && numeroDeVia != null && numeroDeVia != '' ) {
            if( helper.validarCampoVacio(component, numeroDeVia) ) {
                return;
            }
            component.set("v.blnNumeroDeVia", true);
            contador ++;
        }
        
        if( selectedAccount.Regi_n__c != undefined && selectedAccount.Regi_n__c != null && selectedAccount.Regi_n__c != '' ) {
            if( region != selectedAccount.Regi_n__c ) {
                if( helper.validarCampoVacio(component, region) ) {
                    return;
                }
                component.set("v.blnRegion", true);
                contador ++;                
            }
        } else if( region != undefined && region != null && region != '' ) {
            if( helper.validarCampoVacio(component, region) ) {
                return;
            }
            component.set("v.blnRegion", true);
            contador ++;  
        }
        
        if( selectedAccount.Delegaci_n__c != undefined && selectedAccount.Delegaci_n__c != null && selectedAccount.Delegaci_n__c != '' ) {
            if( delegacion != selectedAccount.Delegaci_n__c ) {
                if( helper.validarCampoVacio(component, delegacion) ) {
                    return;
                }
                component.set("v.blnDelegacion", true);
                contador ++;                
            }
        } else if( delegacion != undefined && delegacion != null && delegacion != '' ) {
            if( helper.validarCampoVacio(component, delegacion) ) {
                return;
            }
            component.set("v.blnDelegacion", true);
            contador ++;  
        }        

        var mostrarColoniaCPTexto = component.get("v.mostrarColoniaCPTexto");
        if( selectedAccount.Colonia__c != undefined && selectedAccount.Colonia__c != null && selectedAccount.Colonia__c != '' ) {
            if( colonia != selectedAccount.Colonia__c ) {                       
                if( helper.validarCampoVacio(component, colonia) ) {
                    if( !mostrarColoniaCPTexto ) {
                        component.set("v.mostrarColoniaCPTexto", true);
                    }
                    return;
                }
                component.set("v.blnColonia", true);   
                contador ++;  
            }
        } else if( colonia != undefined && colonia != null && colonia != '' ) {
            if( helper.validarCampoVacio(component, colonia) ) {
                if( !mostrarColoniaCPTexto ) {
                    component.set("v.mostrarColoniaCPTexto", true);
                }
                return;
            }
            component.set("v.blnColonia", true);   
            contador ++;
        }        

        if( selectedAccount.C_digo_Postal__c != undefined && selectedAccount.C_digo_Postal__c != null && selectedAccount.C_digo_Postal__c != '' ) {
            if( codigoPostal != selectedAccount.C_digo_Postal__c ) {                
                if( helper.validarCampoVacio(component, codigoPostal) ) {
                    if( !mostrarColoniaCPTexto ) {
                        component.set("v.mostrarColoniaCPTexto", true);
                    }
                    return;
                }
                component.set("v.blnCodigoPostal", true);
                contador ++;
            }
        } else if( codigoPostal != undefined && codigoPostal != null && codigoPostal != '' ) {
            if( codigoPostal != selectedAccount.C_digo_Postal__c ) {                
                if( helper.validarCampoVacio(component, codigoPostal) ) {
                    if( !mostrarColoniaCPTexto ) {
                        component.set("v.mostrarColoniaCPTexto", true);
                    }
                    return;
                }
                component.set("v.blnCodigoPostal", true);
                contador ++;
            }
        }   
        //restoDireccion
        if( selectedAccount.Resto_Direcci_n__c != undefined && selectedAccount.Resto_Direcci_n__c != null && selectedAccount.Resto_Direcci_n__c != '' ) {
            if( restoDirecion != selectedAccount.Resto_Direcci_n__c ) {
                if( helper.validarCampoVacio(component, restoDirecion) ) {
                    return;
                }
                component.set("v.blnRestoDireccion", true);
                contador ++;                
            }
        } else if( restoDirecion != undefined && restoDirecion != null && restoDirecion != '' ) {
            if( helper.validarCampoVacio(component, restoDirecion) ) {
                return;
            }
            component.set("v.blnRestoDireccion", true);
            contador ++;  
        }else{
            if( helper.validarCampoVacio(component, restoDirecion) ) {
                return;
            }
        }
            
                        
        

        if( contador > 0) {
            component.set("v.noPasoAddressUpdate", 2);
        } else {
            helper.showToast("Accion Requerida", "No se Actualizo ningún valor", "info");
        }

    },

    guardarAddressUpdate : function (component, event, helper) {

        component.set("v.noPasoAddressUpdate", 3);
        component.set("v.loadingAddressUpdate", true);


        helper.actualizarDireccion(component);
    },

    closeModalAddressUpdate : function(component, event, helper) {

        helper.limpiarVaribles(component);

        component.set("v.openModalAddressUpdate", false);
    },

    regresarModalAddressUpdate : function(component, event, helper) {

        helper.limpiarVariblesDeValidacion(component);
        component.set("v.noPasoAddressUpdate", 1);
    },

    handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {
			component.set("v.enableOTPModal", false);
		}
	},

    handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.abrirModalDomicilio(component);
		}
	},

    validateNumber: function(component, event, helper) {
        let number = component.get('v.numeroDeVia');
        if(isNaN(number)){
            number = '';
            component.set('v.numeroDeVia', number);
            helper.showToast("Accion Requerida", "Solo se permiten números", "info");
        }
    }
        
})