({
    closeModal : function(component, event, helper) {

        helper.closeModal(component);
    },

    guardarOtrosDatos :  function(component, event, helper) {

        component.set("v.noPasoRegulatoriosUpdate", 3);
        component.set("v.loadingRegulatoriosUpdate", true);

        helper.guardarDatosMapa(component);
    },

    handleOtrosDatos: function(component, event, helper) {

        ///
        component.set("v.enableOTPModal", true);
        
        // OTP     
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicoCamposRegulatorios && mapValidacionesOTP.MicroServicoCamposRegulatorios.otp ) {

            if( mapValidacionesOTP.MicroServicoCamposRegulatorios.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicoCamposRegulatorios.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicoCamposRegulatorios.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicoCamposRegulatorios.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP Campos Regulatorios:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP Campos Regulatorios:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;

        } else {

            component.set("v.blnOpenModalContactMethod", true);

        }        
    },

    regresarCampos: function(component, event, helper) {  

        component.set("v.noPasoRegulatoriosUpdate", 1);
    },

    limpiarCelular : function(component, event, helper) {

		var caracter = event.which;
        console.log("caracter:  ", caracter);
        
        /// Lista de Numeros [0-9]
        var listNumeros = component.get("v.listNumeros");

		if( !listNumeros.includes(caracter)  ) {
			event.preventDefault();
		}
	},

	borrarCampo : function(component, event, helper) {
		console.log("borrarCampo ");

		event.preventDefault();
    },
    
    limpiarRFC : function(component, event, helper) {

        var caracterRFC = event.which;
        console.log("caracterRFC:  ", caracterRFC);

        /// Lista de Numeros [0-9]
        var listNumeros = component.get("v.listNumeros");

        /// Lista de Mayusculas [A-Z]
        var listMayusculas = component.get("v.listMayusculas");
        
        if( !listNumeros.includes(caracterRFC) && !listMayusculas.includes(caracterRFC)  ) {
			event.preventDefault();
		}
    },

    handleGuardar: function(component, event, helper) {

        ///
        var accountComponnet = component.get("v.accountComponnet");
        var nacionalidad = component.get("v.nacionalidad");
        var actividad = component.get("v.actividad");
        var paisNacimiento = component.get("v.paisNacimiento");
        var profesion = component.get("v.profesion");
        var estadoNacimiento = component.get("v.estadoNacimiento");
        var fiel = component.get("v.fiel");
        var genero = component.get("v.genero");
        var estadoCivil = component.get("v.estadoCivil");
        var telefonoCasa = component.get("v.telefonoCasa");
        var telefonoTrabajo = component.get("v.telefonoTrabajo");
        var rfc = component.get("v.rfc");
        var publicidad = component.get("v.publicidad");

        console.log("accountComponnet:   ", accountComponnet);
        console.log("nacionalidad:   ", nacionalidad);
        console.log("actividad:   ", actividad);
        console.log("paisNacimiento:   ", paisNacimiento);
        console.log("profesion:   ", profesion);
        console.log("estadoNacimiento:   ", estadoNacimiento);
        console.log("fiel:   ", fiel);
        console.log("genero:   ", genero);
        console.log("estadoCivil:   ", estadoCivil);
        console.log("telefonoCasa:   ", telefonoCasa);
        console.log("telefonoTrabajo:   ", telefonoTrabajo);
        console.log("rfc:   ", rfc);
        console.log("publicidad:   ", publicidad);

        var contador = 0;

        /// Se verifica que campos fueron Editados 
        if( accountComponnet.Nacionalidad__c != undefined && accountComponnet.Nacionalidad__c != null && accountComponnet.Nacionalidad__c != '' ) {            
            if( accountComponnet.Nacionalidad__c != nacionalidad ) {
                if( helper.validarCampoVacio(component, nacionalidad) ) {
                    return;
                }
                component.set("v.nacionalidadCambio",true);
                contador ++;
            }
        } else if( nacionalidad != undefined && nacionalidad != null && nacionalidad != '' ) {
            component.set("v.nacionalidadCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Actividad_o_Giro_del_Negocio__c != undefined && accountComponnet.Actividad_o_Giro_del_Negocio__c != null && accountComponnet.Actividad_o_Giro_del_Negocio__c != '' ) {            
            if( accountComponnet.Actividad_o_Giro_del_Negocio__c != actividad ) {
                if( helper.validarCampoVacio(component, actividad) ) {
                    return;
                }
                component.set("v.actividadCambio",true);
                contador ++;
            }
        } else if( actividad != undefined && actividad != null && actividad != '' ) {
            component.set("v.actividadCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Pais_de_Nacimiento__c != undefined && accountComponnet.Pais_de_Nacimiento__c != null && accountComponnet.Pais_de_Nacimiento__c != '' ) {            
            if( accountComponnet.Pais_de_Nacimiento__c != paisNacimiento ) {
                if( helper.validarCampoVacio(component, paisNacimiento) ) {
                    return;
                }
                component.set("v.paisCambio",true);
                contador ++;
            }
        } else if( paisNacimiento != undefined && paisNacimiento != null && paisNacimiento != '' ) {
            component.set("v.paisCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Ocupacion_o_Profesion__c != undefined && accountComponnet.Ocupacion_o_Profesion__c != null && accountComponnet.Ocupacion_o_Profesion__c != '' ) {            
            if( accountComponnet.Ocupacion_o_Profesion__c != profesion ) {
                if( helper.validarCampoVacio(component, profesion) ) {
                    return;
                }
                component.set("v.ocupacionCambio",true);
                contador ++;
            }
        } else if( profesion != undefined && profesion != null && profesion != '' ) {
            component.set("v.ocupacionCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Entidad_Federativa_de_Nacimiento__c != undefined && accountComponnet.Entidad_Federativa_de_Nacimiento__c != null && accountComponnet.Entidad_Federativa_de_Nacimiento__c != '' ) {            
            if( accountComponnet.Entidad_Federativa_de_Nacimiento__c != estadoNacimiento ) {
                if( helper.validarCampoVacio(component, estadoNacimiento) ) {
                    return;
                }
                component.set("v.estadoCambio",true);
                contador ++;
            }
        } else if( estadoNacimiento != undefined && estadoNacimiento != null && estadoNacimiento != '' ) {
            component.set("v.estadoCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.FIEL__c != undefined && accountComponnet.FIEL__c != null && accountComponnet.FIEL__c != '' ) {            
            if( accountComponnet.FIEL__c != fiel ) {
                if( helper.validarCampoVacio(component, fiel) ) {
                    return;
                }
                component.set("v.fielCambio",true);
                contador ++;
            }
        } else if( fiel != undefined && fiel != null && fiel != '' ) {
            component.set("v.fielCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Genero__c != undefined && accountComponnet.Genero__c != null && accountComponnet.Genero__c != '' ) {            
            if( accountComponnet.Genero__c != genero ) {
                if( helper.validarCampoVacio(component, genero) ) {
                    return;
                }
                component.set("v.generoCambio",true);
                contador ++;
            }
        } else if( genero != undefined && genero != null && genero != '' ) {
            component.set("v.generoCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Estado_Civil__c != undefined && accountComponnet.Estado_Civil__c != null && accountComponnet.Estado_Civil__c != '' ) {            
            if( accountComponnet.Estado_Civil__c != estadoCivil ) {
                if( helper.validarCampoVacio(component, estadoCivil) ) {
                    return;
                }
                component.set("v.estadoCivilCambio",true);
                contador ++;
            }
        } else if( estadoCivil != undefined && estadoCivil != null && estadoCivil != '' ) {
            component.set("v.estadoCivilCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Telefono_Fijo_Casa__c != undefined && accountComponnet.Telefono_Fijo_Casa__c != null && accountComponnet.Telefono_Fijo_Casa__c != '' ) {            
            if( accountComponnet.Telefono_Fijo_Casa__c != telefonoCasa ) {
                if( helper.validarCampoVacio(component, telefonoCasa) ) {
                    return;
                }
                if( !helper.validaFormatoTelefono(telefonoCasa) ) {
                    helper.showToast("Debe ingresar un Teléfono Fijo Casa válido", " Por favor revisar el Numero Ingresado" ,"warning");
                    return;
                }
                component.set("v.telefonoFijoCasaCambio",true);
                contador ++;
            }
        } else if( telefonoCasa != undefined && telefonoCasa != null && telefonoCasa != '' ) {
            if( !helper.validaFormatoTelefono(telefonoCasa) ) {
                helper.showToast("Debe ingresar un Teléfono Fijo Casa válido", " Por favor revisar el Numero Ingresado" ,"warning");
                return;
            }
            component.set("v.telefonoFijoCasaCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.Telefono_Fijo_Trabajo__c != undefined && accountComponnet.Telefono_Fijo_Trabajo__c != null && accountComponnet.Telefono_Fijo_Trabajo__c != '' ) {            
            if( accountComponnet.Telefono_Fijo_Trabajo__c != telefonoTrabajo ) {
                if( helper.validarCampoVacio(component, telefonoTrabajo) ) {
                    return;
                }
                if( !helper.validaFormatoTelefono(telefonoTrabajo) ) {
                    helper.showToast("Debe ingresar un Teléfono Fijo Trabajo válido", " Por favor revisar el Numero Ingresado" ,"warning");
                    return;
                }
                component.set("v.telefonoFijoTrabajoCambio",true);
                contador ++;
            }
        } else if( telefonoTrabajo != undefined && telefonoTrabajo != null && telefonoTrabajo != '' ) {
            if( !helper.validaFormatoTelefono(telefonoTrabajo) ) {
                helper.showToast("Debe ingresar un Teléfono Fijo Trabajo válido", " Por favor revisar el Numero Ingresado" ,"warning");
                return;
            }
            component.set("v.telefonoFijoTrabajoCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////
        if( accountComponnet.RFC__c != undefined && accountComponnet.RFC__c != null && accountComponnet.RFC__c != '' ) {            
            if( accountComponnet.RFC__c != rfc ) {
                if( helper.validarCampoVacio(component, rfc) ) {
                    return;
                }                
                if( !helper.validaFormatoRFC(rfc) ) {
                    helper.showToast("Debe ingresar un RFC válido", " Por favor revisar el RFC Ingresado" ,"warning");
                    return;
                }
                component.set("v.rfcCambio",true);
                contador ++;
            }
        } else if( rfc != undefined && rfc != null && rfc != '' ) {
            if( !helper.validaFormatoRFC(rfc) ) {
                helper.showToast("Debe ingresar un RFC válido", " Por favor revisar el RFC Ingresado" ,"warning");
                return;
            }
            component.set("v.rfcCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////         
        if( accountComponnet.Publicidad__c != publicidad ) {
            component.set("v.publicidadCambio",true);
            contador ++;
        }
        ///// ///// ///// ///// /////

        
        if( contador > 0 ) {
            component.set("v.noPasoRegulatoriosUpdate", 2);
        } else {
            helper.showToast("Accion Requerida", "No se Actualizo ningún valor", "info");
        }
    },

    handleOTPValidated : function (component, event, helper) {
	
		var isValid = event.getParam("isValid");
		
        component.set("v.verificadoOTP", isValid);

        /// Validaciones OTP Dinamicas
        if( isValid ) {

            component.set("v.verificadoOTPGlobal", true);

            component.set("v.blnOpenModalContactMethod", true);
        }
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
			
            helper.openModalUpdate(component);
		}
	}
    
})