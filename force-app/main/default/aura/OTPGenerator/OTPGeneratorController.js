({
	doInit : function(component, event, helper) {

        var recordId = component.get("v.recordId");
        var customer = component.get("v.customer");
        /// Ajuste para forzar la consulta de CURP
        var numeroDocumento = component.get("v.numeroDocumento");
        if (recordId && !customer) {
          helper.loadCustomerByCaseId(component);    
        }else if( recordId && !numeroDocumento ) {
          helper.loadCustomerByCaseId(component);
        }

        // Se carga configuracion OTP
        component.set("v.configServicioLoaded", false);
        helper.configuracionServicioOTP(component);
		
	},
    
    goToMain : function (component, event, helper) {
        
		component.set("v.step", 1);
        
    },
    
    doSetState : function (component, event, helper) {
        
		var params = event.getParam('arguments');
        if (params) {
            
            var state = params.state;
            
            if (state === 'open') {
                
                helper.openModal(component);
                
            } else {
                
                helper.closeModal(component);
                
            }
        }
        
    },
    
    doSetMode : function (component, event, helper) {
        
		var params = event.getParam('arguments');
        if (params) {
            
      component.set("v.mode", params.mode);
			
        }
        
    },
    
    doSetPhone : function (component, event, helper) {
        
		var params = event.getParam('arguments');
        if (params) {
            
      component.set("v.phone", params.phone);
			
        }
        
    },
    
	goToSendOTP : function (component, event, helper) {
        
		component.set("v.step", 2);
        
    },
    
    goToValidateOTP : function (component, event, helper) {
        
		component.set("v.step", 3);
        
    },
    
    doSend : function (component, event, helper) {

      component.set("v.otpEnviadoValidado", false);
    
      var configServicio = component.get("v.configServicio");

      if( configServicio == 'Microservicio' ) {

        helper.sendCodeMicroServicio(component);
      } else if( configServicio == 'Twilio' ) {

        helper.sendCodeTwilio(component);
      }

    },
    
    doValidate : function (component, event, helper) {      
    
      var configServicio = component.get("v.configServicio");

      ///
      var codigo = component.find("codigo_verificacion").get("v.value");

      if( codigo ) {

        component.set("v.otpEnviadoValidado", false);

        if( configServicio == 'Microservicio' ) {

          helper.validateCodeMicroServicio(component);

        } else if( configServicio == 'Twilio' ) {

          helper.validateCodeTwilio(component);

        }
      } else {

        helper.showToast("Accion Requerida", "Ingrese por favor el código de validación", "warning");

      }
        
    },
    
    closeModal : function (component, event, helper) {

		helper.closeModal(component);

    /// Se detona Evento para cerrar Modal en Flujo Actualizacion de Celular
    helper.fireOTPCloseEvent(component, true);

  },
  /******************************************************************************************
    Método que maneja el Evento que se ejecuta desde el componente MicroServicioCustomerData
    Obtiene el telefono del microservicio
  *******************************************************************************************/
   handleCustomerDataPhoneE : function(component, event, helper){

    var phoneCustomerData = event.getParam("phoneCustomerData");
    component.set("v.phoneCustomerData", phoneCustomerData);
  }
})