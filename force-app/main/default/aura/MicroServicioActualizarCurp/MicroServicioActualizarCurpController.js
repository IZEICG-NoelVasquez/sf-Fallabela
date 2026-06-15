({
     handleModalCURPUpdate : function (component, event, helper) { 
        ///
        component.set("v.enableOTPModal", true);
        
        // OTP 
        var verificadoOTP = component.get("v.verificadoOTP");

        var esAltoRiesgo;

        /// Validaciones OTP Dinamicas
        var mapValidacionesOTP = component.get("v.mapValidacionesOTP");

        if( mapValidacionesOTP && mapValidacionesOTP.MicroServicioActualizarCurp && mapValidacionesOTP.MicroServicioActualizarCurp.otp ) {

            if( mapValidacionesOTP.MicroServicioActualizarCurp.otp == 'Una vez' ) {

                esAltoRiesgo = true;

            } else if( mapValidacionesOTP.MicroServicioActualizarCurp.otp == 'Siempre' ) {

                esAltoRiesgo = true;
                verificadoOTP = false;

            } else if( mapValidacionesOTP.MicroServicioActualizarCurp.otp == 'Global' ) {
            
                esAltoRiesgo = true;
                verificadoOTP = component.get("v.verificadoOTPGlobal");

            } else if( mapValidacionesOTP.MicroServicioActualizarCurp.otp == 'Sin validacion' ) {

                esAltoRiesgo = false;

            }
        }

        console.log("esAltoRiesgo OTP:  ", esAltoRiesgo);
        console.log("verificadoOTP OTP:  ", verificadoOTP);

        if (esAltoRiesgo && !verificadoOTP) {

            helper.showToast("Accion Requerida", "Se requiere validacion adicional", "warning");
            helper.setModalState(component, "open");
            return;
        } else {

            helper.openModalContactMethod(component);
        }

    },
    RevisaCaracteres : function(component, event, helper) {
        var curpUpdate = component.find("curpUpdateId_1").get('v.value');
        var re = /[^A-Za-z 0-9]/g;
        var retorno = re.test(String(curpUpdate));
        if(retorno){
            var comp = component.find("curpUpdateId_1");
            if(comp != null){
            comp.set('v.value',curpUpdate.substring(0,(curpUpdate.length-1)));
            }
        }
    },
    actualizarCurp : function (component, event, helper) {
        var strCurpUpdate = component.get("v.strCurpUpdate");
		helper.actualizarCurp(component,strCurpUpdate);
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
    confirmarCurpUpdate : function (component, event, helper) {
        var curpUpdate = component.find("curpUpdateId_1").get("v.value");
        console.log("curpUpdate", curpUpdate);
        helper.validaCurp(component, curpUpdate); 
        console.log("v.strCurpUpdate 1", component.get("v.strCurpUpdate") );
    },
    guardarCurpUpdate : function (component, event, helper) {
        console.log("v.strCurpUpdate 2", component.get("v.strCurpUpdate") );
        component.set("v.noPasoCurpUpdate", 3);
        component.set("v.loadingCurpUpdate", true);
        var strCurpUpdate = component.get("v.strCurpUpdate");
        helper.actualizarCurp(component, strCurpUpdate);
    },
    closeModalCurpUpdate : function(component) {
        component.set("v.openCurpUpdate", false);
        ///
        component.set("v.enableOTPModal", false);
    },
    handleCloseModalOTP : function(component, event, helper) {

		var closeModal = event.getParam("closeModal");
		if( closeModal ) {
			component.set("v.enableOTPModal", false);
		}
	},

    regresarModalCurpUpdate : function(component, event, helper) {

        component.set("v.noPasoCurpUpdate", 1);
    },

    handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");
		if( blnCloseModal ) {
			
            ///
            helper.openModalCurpUpdate(component);
		}
	}
})