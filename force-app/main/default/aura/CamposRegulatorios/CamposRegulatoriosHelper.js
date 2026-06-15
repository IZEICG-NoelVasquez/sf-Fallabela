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

    closeModal : function(component) {

        component.set("v.otrosDatos",false);
        this.limpiarVaribles(component);
    },

    limpiarVaribles : function(component) {

        component.set("v.nacionalidadCambio", false);
        component.set("v.actividadCambio", false);

        component.set("v.paisCambio", false);
        component.set("v.ocupacionCambio", false);

        component.set("v.estadoCambio", false);
        component.set("v.fielCambio", false);

        component.set("v.generoCambio", false);
        component.set("v.estadoCivilCambio", false);

        component.set("v.telefonoFijoCasaCambio", false);
        component.set("v.telefonoFijoTrabajoCambio", false);

        component.set("v.rfcCambio", false);
        component.set("v.publicidadCambio", false);
    },

    getOtrosDatos : function(component){

        var selectedaccount = component.get("v.selectedAccount");
        var idacc = selectedaccount.Id;

        var action = component.get("c.getOtrosDatos");
        action.setParams({
            "accId" : idacc
        });  

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var acc = response.getReturnValue();
                console.log('acc ',acc);

                ///
                component.set("v.accountComponnet", acc);

                component.set("v.nacionalidad", acc.Nacionalidad__c);
                component.set("v.actividad", acc.Actividad_o_Giro_del_Negocio__c);
                component.set("v.paisNacimiento", acc.Pais_de_Nacimiento__c);
                component.set("v.profesion", acc.Ocupacion_o_Profesion__c);
                component.set("v.estadoNacimiento", acc.Entidad_Federativa_de_Nacimiento__c);
                component.set("v.fiel", acc.FIEL__c);
                component.set("v.genero", acc.Genero__c);
                component.set("v.estadoCivil", acc.Estado_Civil__c);
                component.set("v.telefonoCasa", acc.Telefono_Fijo_Casa__c);
                component.set("v.telefonoTrabajo", acc.Telefono_Fijo_Trabajo__c);
                component.set("v.rfc", acc.RFC__c);
                component.set("v.publicidad", acc.Publicidad__c);

                this.getNacionalidades(component);
                this.getActividades(component);
                //
                this.getProfesiones(component);
                this.getEstados(component);
                //
                this.getSexos(component);
                this.getEstadoCivil(component);
                //
            }
        });
        $A.enqueueAction(action); 
        
    },

    getNacionalidades : function(component){

        var listNacionalidades = [];
        var mapNacionalidades = component.get("v.mapNacionalidades");

        var action = component.get("c.getNacionalidades");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var conts = response.getReturnValue();                
                for ( var key in conts ) {

                    listNacionalidades.push({value:conts[key]});
                    mapNacionalidades[conts[key]] = key;
                }

                /// Se ordena la Lista de Paises
                listNacionalidades.sort(function(a, b) {
                    if (a.value < b.value)
                        return -1;
                    if (a.value > b.value)
                        return 1;
                    return 0;
                });

                ///
                component.set("v.listNacionalidades", listNacionalidades);
                component.set("v.mapNacionalidades", mapNacionalidades);
            }
        });
        $A.enqueueAction(action); 
    },

    getActividades : function(component){

        var action = component.get("c.getActividades");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var actividades = response.getReturnValue();

                /// Se ordena la Lista de Actividades
                actividades.sort();

                component.set("v.listActividades", actividades);
            }
        });
        $A.enqueueAction(action); 
    },

    getProfesiones : function(component){

        var listProfesiones = [];
        var mapProfesiones = component.get("v.mapProfesiones");

        var action = component.get("c.getProfesiones");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var conts = response.getReturnValue();
                for ( var key in conts ) {

                    listProfesiones.push({value:conts[key]});
                    mapProfesiones[conts[key]] = key;
                }

                /// Se ordena la Lista de Profesiones
                listProfesiones.sort(function(a, b) {
                    if (a.value < b.value)
                        return -1;
                    if (a.value > b.value)
                        return 1;
                    return 0;
                });

                ///
                component.set("v.listProfesiones", listProfesiones);
                component.set("v.mapProfesiones", mapProfesiones);
            }
        });
        $A.enqueueAction(action);
    },

    getEstados : function(component){

        var listEstadoNacimiento = [];
        var mapEstadoNacimiento = component.get("v.mapEstadoNacimiento");

        var action = component.get("c.getEstados");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var conts = response.getReturnValue();
                for ( var key in conts ) {

                    listEstadoNacimiento.push({value:conts[key]});
                    mapEstadoNacimiento[conts[key]] = key;
                }

                /// Se ordena la Lista de Estados
                listEstadoNacimiento.sort(function(a, b) {
                    if (a.value < b.value)
                        return -1;
                    if (a.value > b.value)
                        return 1;
                    return 0;
                });

                ///
                component.set("v.listEstadoNacimiento", listEstadoNacimiento);
                component.set("v.mapEstadoNacimiento", mapEstadoNacimiento);
            }
        });
        $A.enqueueAction(action); 
    },

    getSexos : function(component){

        var listGeneros = [];
        var mapGeneros = component.get("v.mapGeneros");

        var action = component.get("c.getSexos");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var conts = response.getReturnValue();
                for ( var key in conts ) {

                    listGeneros.push({value:conts[key]});
                    mapGeneros[conts[key]] = key;
                }

                ///
                component.set("v.listGeneros", listGeneros);
                component.set("v.mapGeneros", mapGeneros);
            }
        });
        $A.enqueueAction(action); 
    },
    
    getEstadoCivil : function(component){

        var listEstadoCivil = [];
        var mapEstadoCivil = component.get("v.mapEstadoCivil");

        var action = component.get("c.getEstadoCivil");

        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                var conts = response.getReturnValue();
                for ( var key in conts ) {
                    
                    listEstadoCivil.push({value:conts[key]});
                    mapEstadoCivil[conts[key]] = key;
                }

                ///
                component.set("v.listEstadoCivil", listEstadoCivil);
                component.set("v.mapEstadoCivil", mapEstadoCivil);
            }
        });
        $A.enqueueAction(action); 
    },    

    validarCampoVacio : function(component, campo) {

        if( campo == undefined || campo == null || campo == '' ) {
            this.showToast("Accion Requerida", "No se permite enviar campos vacios", "warning");
            return true;
        }
    },

    validaFormatoTelefono : function(telefono) {

		var formato = /^[0-9]{10}$/;
		return formato.test(telefono);
    },
    
    validaFormatoRFC : function(telefono) {

		var formato = /^[A-Z0-9]+$/;
		return formato.test(telefono);
	},

    guardarDatosMapa : function(component) {

        console.log("Actualizar Campos Regulatorios Helper");

        ///
        var mapNacionalidades = component.get("v.mapNacionalidades");
        var nacionalidad = component.get("v.nacionalidad");        
        var actividad = component.get("v.actividad");
        var paisNacimiento = component.get("v.paisNacimiento");
        var mapProfesiones = component.get("v.mapProfesiones");
        var profesion = component.get("v.profesion");
        var mapEstadoNacimiento = component.get("v.mapEstadoNacimiento");
        var estadoNacimiento = component.get("v.estadoNacimiento");
        var fiel = component.get("v.fiel");
        var mapGeneros = component.get("v.mapGeneros");
        var genero = component.get("v.genero");
        var mapEstadoCivil = component.get("v.mapEstadoCivil");
        var estadoCivil = component.get("v.estadoCivil");
        var telefonoCasa = component.get("v.telefonoCasa");
        var telefonoTrabajo = component.get("v.telefonoTrabajo");
        var rfc = component.get("v.rfc");
        var publicidad = component.get("v.publicidad");


        var selectedAccount = component.get("v.selectedAccount");
        var numeroDocumento = selectedAccount.CURP__c;

        /// Se agregan al Mapa los campos que se Actualizaron.
        var mapCamposMicroS = component.get("v.mapCamposMicroS");
        mapCamposMicroS["numeroDocumento"] = numeroDocumento;

        if( component.get("v.nacionalidadCambio") ) {
            mapCamposMicroS["nacionalidad"] = mapNacionalidades[nacionalidad];
            mapCamposMicroS["nacionalidadTexto"] = nacionalidad;
        }

        if( component.get("v.actividadCambio") ) {
            mapCamposMicroS["actividadGiro"] = actividad;
        }

        if( component.get("v.paisCambio") ) {
            mapCamposMicroS["codigoPaisNacimiento"] = mapNacionalidades[paisNacimiento];
            mapCamposMicroS["codigoPaisNacimientoTexto"] = paisNacimiento;
        }

        if( component.get("v.ocupacionCambio") ) {
            mapCamposMicroS["profesionCliente"] = mapProfesiones[profesion];
            mapCamposMicroS["profesionClienteTexto"] = profesion;
        }

        if( component.get("v.estadoCambio") ) {
            mapCamposMicroS["entidadFedNacimiento"] = mapEstadoNacimiento[estadoNacimiento];
            mapCamposMicroS["entidadFedNacimientoTexto"] = estadoNacimiento;
        }

        if( component.get("v.fielCambio") ) {
            mapCamposMicroS["fiel"] = fiel;
        }

        if( component.get("v.generoCambio") ) {
            mapCamposMicroS["genero"] = mapGeneros[genero];
            mapCamposMicroS["generoTexto"] = genero;
        }

        if( component.get("v.estadoCivilCambio") ) {
            mapCamposMicroS["estadoCivil"] = mapEstadoCivil[estadoCivil];
            mapCamposMicroS["estadoCivilTexto"] = estadoCivil;
        }

        if( component.get("v.telefonoFijoCasaCambio") ) {
            mapCamposMicroS["numeroTelefonoCasa"] = telefonoCasa;
        }
        if( component.get("v.telefonoFijoTrabajoCambio") ) {
            mapCamposMicroS["numeroTelefonoTrabajo"] = telefonoTrabajo;
        }
        if( component.get("v.rfcCambio") ) {
            mapCamposMicroS["rfc"] = rfc;
        }
        if( component.get("v.publicidadCambio") ) {
            mapCamposMicroS["publicidad"] = publicidad;
        }

        component.set("v.mapCamposMicroS", mapCamposMicroS);

        console.log("mapCamposMicroS:  ", mapCamposMicroS );

        var action = component.get("c.otrosDatosF");
        action.setParams({
            "campos" : mapCamposMicroS
        });

        action.setCallback(this, function(response) {
            
            var state = response.getState();            
            console.log("state regulatoriosUpdate: ", state);
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                console.log('result regulatoriosUpdate', result);
                if (result.success) { 

                    console.log("*** Regulatorios Exito ***");
                    
                    component.set("v.regulatoriosUpdated", true);
                    component.set("v.loadingRegulatoriosUpdate", false);

                    this.crearCasoRegulatoriosUpdate(component);
                    component.set("v.creatingCase", true);
                } else {

                    console.log("*** Regulatorios Error ***");

                    component.set("v.regulatoriosUpdated", false);
                    component.set("v.loadingRegulatoriosUpdate", false);
                }

            } else {

                console.log("*** Regulatorios Error ***");

                component.set("v.regulatoriosUpdated", false);     
                component.set("v.loadingRegulatoriosUpdate", false);
            }
        });

        $A.enqueueAction(action);

    },

    crearCasoRegulatoriosUpdate : function(component) {

        /// Variables para la creacion del Caso Actualizacion de Domicilio
        var catSubSelected = 'Campos Regulatorios'; // <-------------------------
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

        // Campos requeridos para cerrar el Caso
        var camposRequeridos = 'Nacionalidad__c:';
        camposRequeridos += component.get("v.nacionalidad");
        camposRequeridos += ',';
        camposRequeridos += 'Actividad_o_giro_del_negocio__c:';
        camposRequeridos += component.get("v.actividad");
        camposRequeridos += ',';
        camposRequeridos += 'Pa_s_Nacimiento__c:';
        camposRequeridos += component.get("v.paisNacimiento");
        camposRequeridos += ',';
        camposRequeridos += 'Ocupaci_n_o_profesi_n__c:';
        camposRequeridos += component.get("v.profesion");
        camposRequeridos += ',';
        camposRequeridos += 'Entidad_Federativa_de_NacimientoCR__c:';
        camposRequeridos += component.get("v.estadoNacimiento");
        camposRequeridos += ',';
        camposRequeridos += 'Fiel__c:';
        camposRequeridos += component.get("v.fiel");
        camposRequeridos += ',';
        camposRequeridos += 'G_nero__c:';
        camposRequeridos += component.get("v.genero");
        camposRequeridos += ',';
        camposRequeridos += 'Estado_Civil__c:';
        camposRequeridos += component.get("v.estadoCivil");
        camposRequeridos += ',';
        camposRequeridos += 'Tel_fono_fijo_casa__c:';
        camposRequeridos += component.get("v.telefonoCasa");
        camposRequeridos += ',';
        camposRequeridos += 'Tel_fono_fijo_oficina__c:';
        camposRequeridos += component.get("v.telefonoTrabajo");
        camposRequeridos += ',';
        camposRequeridos += 'RFC_Caso__c:';
        camposRequeridos += component.get("v.rfc");
        camposRequeridos += ',';
        camposRequeridos += 'Publicidad__c:';
        camposRequeridos += component.get("v.publicidad");

        var action = component.get("c.createCaseClosedCamposReg");
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
                    component.set("v.newCaseRegulatorios", result.folioCaso );
                    console.log("v.newCaseRegulatorios:  ", component.get("v.newCaseRegulatorios") );

                    this.updateCuenta(component);

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

    updateCuenta : function(component){

        var selectedAccount = component.get("v.selectedAccount");
        var idAcc = selectedAccount.Id;

        var mapCamposMicroS = component.get("v.mapCamposMicroS");

        var action = component.get("c.updateAccount");

        action.setParams({
            "idAcc" : idAcc,
            "campos" : mapCamposMicroS
        });  
        action.setCallback(this, function(response) {

            if (response.getState() === "SUCCESS") {

                console.log("*** Se Actualizo la Cuenta ***");

            }
        });
        $A.enqueueAction(action); 
    },

    setModalState : function (component, state) {
        
        var otpModalRegulatoriosUpdate = component.find("otpModalRegulatoriosUpdate");
        otpModalRegulatoriosUpdate.setState(state);        
    },

    openModalUpdate : function(component) {

        this.getOtrosDatos(component);

        component.set("v.otrosDatos",true);
        component.set("v.noPasoRegulatoriosUpdate", 1);

    }
    
})