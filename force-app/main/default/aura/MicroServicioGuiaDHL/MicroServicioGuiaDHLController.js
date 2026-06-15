({
   doInit : function (component, event, helper) {

      ///
		helper.doInitHelper(component);
   },

   openDetailDHL : function (component, event, helper) {
      
      var guiaDHL = component.get("v.GuiaDHL");
      component.set("v.guiaCaso", guiaDHL);

      var blnRecordCase = component.get("v.blnRecordCase");

      ///
      component.set("v.dhlDetailLoaded", false);

      if( blnRecordCase ) {

         helper.openDetailDHL(component);

      } else {

         component.set("v.blnOpenModalContactMethod", true);
      }
   },

   openDetailDHLGuias : function (component, event, helper) {

      var guiaDHL = event.target.dataset.guia; 
      component.set("v.guiaCaso", guiaDHL);

      var blnRecordCase = component.get("v.blnRecordCase");

      ///
      component.set("v.dhlDetailLoaded", false);

      if( blnRecordCase ) {

         helper.openDetailDHL(component);

      } else {

         component.set("v.blnOpenModalContactMethod", true);
      }
   },

   closeModel: function(component, event, helper) {

      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        
      var blnRecordCase = component.get("v.blnRecordCase");

      if( !blnRecordCase ) {

         helper.createCase(component);
         component.set("v.creatingCase", false);
      }
      
      component.set("v.Fecha",null);
      component.set("v.Origen",null);
      component.set("v.HayRespuesta",false);
      component.set("v.Destino",null);
      component.set("v.Piezas",null);
      component.set("v.FirmadoPor",null);
      component.set("v.data",null);
      component.set("v.ultimoEstado",null);
      component.set("v.guiaNoEncontrada",false);
      component.set("v.isOpen", false);
      ///
      component.set("v.blnWayBillEstafeta", false);
      component.set("v.shortWaybillId", '');
   },

   closeModalGuiaDHL: function(component, event, helper) {
    
      component.set("v.creatingCase", true);
      component.set("v.successfulCase", false);

   },

   handleCloseModalContactMethod : function(component, event, helper) {

		var blnCloseModal = event.getParam("blnContactMethodSelected");

		if( blnCloseModal ) {

         component.set("v.blnOpenModalReasonReplacement", true);
		}
	},

   handleCloseModalReasonReplacement : function(component, event, helper) {

      var blnCloseModalReasonReplacement = event.getParam("blnReasonReplacementSelected");

		if( blnCloseModalReasonReplacement ) {
			
         helper.openDetailDHL(component);
		}
   }

})