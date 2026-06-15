({
    doInit : function (component, event, helper) {
        
        var productIdx = component.get("v.productIdx");
        var movimientoIdx = component.get("v.movimientoIdx");

        ///
        component.set("v.fechasEdoCta", true);

        if( productIdx != movimientoIdx ) {

            component.set("v.productIdx", movimientoIdx); 
            component.set("v.movimientoIdx", movimientoIdx);
        } else if( productIdx && movimientoIdx ) {

          if( productIdx == movimientoIdx ) {

                ///
                component.set("v.cargarFechasDeCorte", false);

                //Open Modal PDF EdoCta
                component.set("v.loadedPDFEdoCta", true);
                ///var resultFechasCorte = component.get("v.fechasCorteOptions");
                var resultFechasCorte = component.get("v.fechasCorteOptionsEdoCta");

                ///
                component.set("v.fechaCorteValue", resultFechasCorte[1].value );
                helper.cargarEstadoDeCuenta(component, movimientoIdx, resultFechasCorte[1].value );
            }
        }

        /// Mensaje de recordatorio para el uso de la APP
        var messageApp = "\n Invita al cliente a usar la App o Web si tiene usuario \n y contraseña y si no,\u00A0 ayúdalo a navegar o descargar \n la App. \n";
        messageApp += "Para su comodidad, \u00A0 usted puede revisar su último \n estado de cuenta\u00A0 en todo momento desde su app \n ";
        messageApp += "o\u00A0 solicitando\u00A0 en whatsapp\u00A0 un reenvío a su e-mail. \n O \u00A0 si\u00A0 prefiere \u00A0 más\u00A0 historial, \u00A0 en \u00A0 la \u00A0 web \u00A0 puede \n ";
        messageApp += "consultar los últimos 12.";
        
        helper.showToast( messageApp, " \n ", "success", "sticky");
    },

    changeFechaCortePDFEdoCta : function(component, event, helper) {

        var fechaAsignada = component.get("v.fechaAsignada");
        if( !fechaAsignada ) {
            ///
            var fechaCorteValue = component.get("v.fechaCorteValue");

            // Open pdfViewer
            component.set("v.showPDF", false);
            if( fechaCorteValue ) {

                var movimientoIdx = component.get("v.movimientoIdx");                        
                component.set("v.loadedPDFEdoCta", true);        
                helper.cargarEstadoDeCuenta(component, movimientoIdx, fechaCorteValue);
            } else {

                component.set("v.loadedPDFEdoCta", false);
                component.set("v.fechaAsignada", true);
            }
        }
    },

    closeModalEdoCta : function(component, event, helper) {
        
        component.set("v.isOpenEdoCta", false);
        component.set("v.cargarFechasDeCorte", false);

        ///
        component.set("v.fechasEdoCta", false);
    }
})