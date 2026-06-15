({
	cargarParametrosFechasCorte: function(component, movimientoIdx, fechaCorte) {

        var action = component.get("c.obtenerParametrosFechasCorte");

        action.setCallback(this, function(response) {
            var state = response.getState();
            
            console.log("state", state);

            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();

                component.set("v.sumAniosMovimientosConFecha", result.SumMovimientosFecha);
                
                /// 
                this.cargarFechasCorte(component, movimientoIdx, fechaCorte, result.fechaInicio, result.fechaFin, result.SumMovimientosFecha); // Fecha corte
            }
        });
        $A.enqueueAction(action);

	},
	
	cargarFechasCorte: function(component, movimientoIdx, fechaCorte, fechaInicio, fechaFin, SumMovimientosFecha) {
        
        var d = new Date(fechaCorte);
        var pastYear = d.getFullYear() - fechaInicio;  // (-3)
        var fechaDesdeObj = d;
        fechaDesdeObj.setFullYear(pastYear);
        
        var month = fechaDesdeObj.getUTCMonth() + 1;
        var day = fechaDesdeObj.getUTCDate();
        var year = fechaDesdeObj.getUTCFullYear();
        
        var dH = new Date(fechaCorte);
        var monthH = dH.getUTCMonth() + 1;
        var dayH = dH.getUTCDate() + 1; // Se agrega un dia a la Fecha Fin
        var yearH = dH.getUTCFullYear() - fechaFin; // (-2)
        
		var fechaDesde = year + "-" + (month <= 9 ? '0' + month : month) + "-" + (day <= 9 ? '0' + day : day);
        var fechaHasta = yearH + "-" + (monthH <= 9 ? '0' + monthH : monthH) + "-" + (dayH <= 9 ? '0' + dayH : dayH);
        
        console.log('fechaDesde:  ', fechaDesde);        
        console.log('fechaHasta:  ', fechaHasta);

        // Ajuste a Fechas de Corte 24 Julio 2019
        var dTerminoFac = new Date(fechaCorte);
        var monthTerminoFac = dTerminoFac.getUTCMonth() + 1;
        var dayTerminoFac = dTerminoFac.getUTCDate();
        var yearTerminoFac = dTerminoFac.getUTCFullYear() - fechaFin;

        var fechaTerminoFacturacion = yearTerminoFac + "-" + (monthTerminoFac <= 9 ? '0' + monthTerminoFac : monthTerminoFac) + "-" + (dayTerminoFac <= 9 ? '0' + dayTerminoFac : dayTerminoFac);
        
        console.log('fechaTerminoFacturacion:  ', fechaTerminoFacturacion);

        var selectedAccount = component.get("v.selectedAccount");        
        
        var action = component.get("c.obtenerFechasCorteCliente");

        action.setParams({
            "curp" : selectedAccount.CURP__c,
            "fechaDesde" : fechaDesde,
            "fechaHasta" : fechaHasta, 
            "fechaTerminoFacturacion" : fechaTerminoFacturacion
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 

                    /// Se ordenan las Fechas de Corte

                    /// Listado de Fechas para Movimientos
                    var resultFechasCorte = result.fechasCorteOptions;
                    /// Listado de Fechas para Estados de Cuenta
                    var resultFechasCorteEdoCta = JSON.parse( JSON.stringify(resultFechasCorte) );

                    var indexObj = resultFechasCorte.map(function(e) { return e.value; }).indexOf(fechaTerminoFacturacion);
                    if( !(indexObj > -1) ) {
                        resultFechasCorte.push({label: fechaTerminoFacturacion, value: fechaTerminoFacturacion});
                    }

                    resultFechasCorte.sort(function(a, b) {
                        var dateA = new Date(a.value) , dateB = new Date(b.value);
                        return dateB - dateA;  // dateA - dateB ---> Fecha reciente al final
                    });
                    /// Se suman X anios a las Fechas que devuelve el WS para pruebas en QA
                    var dateTMP, yearTMP, monthTMP, dayTMP, numYear;
                    for(var i = 0; i < resultFechasCorte.length; i ++ ) {
                        if( resultFechasCorte[i].value != '' && resultFechasCorte[i].value != null && resultFechasCorte[i].value != undefined ) {
                            ///
                            dateTMP = resultFechasCorte[i].value.split("-");
                            yearTMP = dateTMP[0]; 
                            numYear = parseInt(yearTMP) + parseInt(SumMovimientosFecha); // Se suman anios para pruebas en UAT
                            yearTMP = numYear;
                            monthTMP = dateTMP[1]; 
                            dayTMP = dateTMP[2];                            
                            // Se cambia el Formato de Salida a Dia, Mes, Anio
                            resultFechasCorte[i].value = dayTMP + "-" + monthTMP + "-" + yearTMP ;
                            resultFechasCorte[i].label = dayTMP + "-" + monthTMP + "-" + yearTMP ;
                        }
                    }
                    component.set("v.fechasCorteOptions", resultFechasCorte);

                    /// Ajuste para Mostrar Listado de Fechas de Corte en Estados de Cuenta
                    resultFechasCorteEdoCta.sort(function(a, b) {
                        var dateA = new Date(a.value) , dateB = new Date(b.value);
                        return dateB - dateA;  // dateA - dateB ---> Fecha reciente al final
                    });
                    /// Se suman X anios a las Fechas que devuelve el WS para pruebas en QA
                    var dateEdoCta, yearEdoCta, monthEdoCta, dayEdoCta, numYearEdoCta;
                    for(var i = 0; i < resultFechasCorteEdoCta.length; i ++ ) {
                        if( resultFechasCorteEdoCta[i].value != '' && resultFechasCorteEdoCta[i].value != null && resultFechasCorteEdoCta[i].value != undefined ) {
                            ///
                            dateEdoCta = resultFechasCorteEdoCta[i].value.split("-");
                            yearEdoCta = dateEdoCta[0]; 
                            numYearEdoCta = parseInt(yearEdoCta) + parseInt(SumMovimientosFecha); // Se suman anios para pruebas en UAT
                            yearEdoCta = numYearEdoCta;
                            monthEdoCta = dateEdoCta[1]; 
                            dayEdoCta = dateEdoCta[2];                            
                            // Se cambia el Formato de Salida a Dia, Mes, Anio
                            resultFechasCorteEdoCta[i].value = dayEdoCta + "-" + monthEdoCta + "-" + yearEdoCta ;
                            resultFechasCorteEdoCta[i].label = dayEdoCta + "-" + monthEdoCta + "-" + yearEdoCta ;
                        }
                    }
                    component.set("v.fechasCorteOptionsEdoCta", resultFechasCorteEdoCta);

                    ///
                    var fechasCorte = component.find("fechasCorte");
                    if( fechasCorte ) {
                        component.find("fechasCorte").set("v.value", resultFechasCorte[1].value );						
						///
						component.set("v.fechaAsignada", false);
                    }
                    ///
                    var fechasCorteEdoCta = component.find("fechasCorteEdoCta");
                    if( fechasCorteEdoCta ) {
                        component.find("fechasCorteEdoCta").set("v.value", resultFechasCorteEdoCta[1].value );						
						///
						component.set("v.fechaAsignada", false);
                    }
                    
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                }                
                
            } else if (state === "INCOMPLETE") {
                
                console.log("Unknown error");
                
            } else if (state === "ERROR") {
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        
        $A.enqueueAction(action);
	}
	
})