({
	cargarMovimientosSinFechaCorte : function(component, movimientoIdx, identificadorPrimerRegistro, identificadorUltimoRegistro, primeraLlamada){
        
        var productos = component.get("v.productos");
        
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
        
        var action = component.get("c.obtenerMovSinFechaCorteCliente");
        
        action.setParams({
            "codigo" : "1",
            "identificador" : identificador,
            "identificadorPrimerRegistro" : identificadorPrimerRegistro,
            "identificadorUltimoRegistro" : identificadorUltimoRegistro
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) {                     
                    
                    if (result.movimientos.message.informacionPaginacion.totalPaginas == 0) {
                        if( primeraLlamada ) {
                            this.showToast("No se encontraron Movimientos", "No se encontraron Ultimos movimientos", "warning");
                            component.set("v.loadedMovSinFechaCorte", false);
                            this.resetCmpValuesSinFechaCorte(component);
                        } else {
                            
                            var oRes = result.movimientos.message.tarjetaCredito.movimiento;
                            component.set("v.movimientosSinFechaCorte", oRes);

                            var PaginationLst = [];
                            component.set('v.PaginationList', PaginationLst);

                            ///
                            this.showToast("No se encontraron Movimientos", "No se encontraron mas movimientos", "warning");
                            component.set("v.loadedMovSinFechaCorte", false);

                            /// Paginacion v2
                            component.set("v.idPrimerRegistroMovSinFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro);
                            component.set("v.idUltimoRegistroMovSinFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro);
                            if( !(result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro) ) {
                                component.set("v.movimientosSinFechaUltimaPagina", true);
                            }
                        }
                        

                    } else {
                        result.movimientos.message.tarjetaCredito.movimiento.isChecked = false;
                        
                        component.set("v.tarjetaCredito", result.movimientos.message.tarjetaCredito.tarjetaCredito);
                        
                        // Paginacion v2
                        var oRes, oResTmp, allRes;
                        oRes = result.movimientos.message.tarjetaCredito.movimiento;
                        oRes.sort(function(a, b) {
                            var dateA = new Date(a.transaccion.fechaHoraTransaccion), dateB = new Date(b.transaccion.fechaHoraTransaccion);
                            return dateB - dateA;
                        });
                        ///
                        console.log('oRes --> ', oRes);

                        /// Se agrega caracter al final de la descripcion
                        for(var i=0; i < oRes.length; i++) {

                            /// Validacion para identificar Movimientos No Facturados (A - Por Autorizar, E - Autorizado)
                            if( oRes[i].estadoMovimiento.codigo == 'A' ) {
                                oRes[i].transaccion.estadoTransaccion.descripcion = oRes[i].transaccion.estadoTransaccion.descripcion + ' *';
                            }
                        }

                        if( primeraLlamada ) {                            
                            component.set("v.movimientosSinFechaCorte", oRes);
                            component.set("v.movimientosSinFechaTodos", oRes);
                        } else {
                            oResTmp = component.get("v.movimientosSinFechaTodos");
                            allRes = oResTmp.concat(oRes);
                            component.set("v.movimientosSinFechaTodos", allRes);
                            component.set("v.movimientosSinFechaCorte", oRes);
                        }                  
                        
                        var pageSize = result.numRegistros; //
                        component.set("v.pageSize", result.numRegistros );
                        
                        // Paginacion v2
                        var movimientosSinFechaTodos = component.get("v.movimientosSinFechaTodos");
                        var totalLength = movimientosSinFechaTodos.length;
                        component.set("v.totalRecordsCountMovSinFechaCorte", totalLength);                        

                        component.set("v.startPage",0);
                        component.set("v.endPage",pageSize-1);

                        // Paginacion v2
                        if( (identificadorPrimerRegistro === '') && (identificadorUltimoRegistro === '') ) {
                            component.set("v.currentPage", 1);
                        }
                        
                        var PaginationLst = [];
                        for(var i=0; i < pageSize; i++){
                            if(component.get("v.movimientosSinFechaCorte").length > i){
                                PaginationLst.push(oRes[i]);    
                            } 
                        }                       

                        component.set('v.PaginationList', PaginationLst);
                        component.set("v.selectedCountMovSinFechaCorte" , 0);
                        component.set("v.selectedCountMovSinFechaCorteBackUp", 0);
                        //use Math.ceil() to Round a number upward to its nearest integer
                        component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));
                        
                        // Clone movimientos
                        var movimientosSinFechaCorteBackUp = JSON.parse(JSON.stringify(oRes));
                        component.set("v.movimientosSinFechaCorteBackUp", movimientosSinFechaCorteBackUp);

                        // Paginacion v2
                        component.set("v.idPrimerRegistroMovSinFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro);
                        component.set("v.idUltimoRegistroMovSinFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro);
                        if( !(result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro) ) {
                            component.set("v.movimientosSinFechaUltimaPagina", true);
                        }
                        component.set("v.loadedMovSinFechaCorte", false);
                    }
                    
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                    component.set("v.loadedMovSinFechaCorte", false);
                    this.resetCmpValuesSinFechaCorte(component);
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
	},
    
    cargarMovimientosConFechaCorte : function(component, movimientoIdx, fechaCorte, identificadorPrimerRegistro, identificadorUltimoRegistro, primeraLlamada){
        
        ///
        var fechaAjusteFormato, dateTMP, yearTMP, monthTMP, dayTMP;
        dateTMP = fechaCorte.split("-");

        dayTMP = dateTMP[0];
        monthTMP = dateTMP[1];
        yearTMP = dateTMP[2];

        fechaAjusteFormato = yearTMP + "-" + monthTMP + "-" + dayTMP;
        ///
        
        if (!fechaCorte) {
            ///
            component.set("v.fechaAsignada", true);

            component.set("v.loadedMovConFechaCorte", false);
            component.set("v.movimientosConFechaCorte", null);
            component.set("v.totalRecordsCountMovConFechaCorte", null);
            component.set("v.startPageMovConFechaCorte",0);
            component.set("v.endPageMovConFechaCorte",0);
            component.set('v.PaginationListMovConFechaCorte', null);
            component.set("v.selectedCountMovConFechaCorte" , 0);
            component.set("v.selectedCountMovConFechaCorteBackUp", 0);
            component.set("v.totalPagesCountMovConFechaCorte", 0);
            component.set("v.movimientosConFechaCorteBackUp", null);
            component.set("v.selectAllMovConFechaCorteCheck", false);
            return;
        }
        
        component.set("v.loadedMovConFechaCorte", true);
        
        var productos = component.get("v.productos");
        
        var identificador = productos[movimientoIdx].cuentaTarjetaCredito.identificador;
        
        var action = component.get("c.obtenerMovConFechaCorteCliente");
        
        action.setParams({
            "codigo" : "0",
            "identificador" : identificador,
            "fechaCorte" : fechaAjusteFormato,
            "identificadorPrimerRegistro" : identificadorPrimerRegistro,
            "identificadorUltimoRegistro" : identificadorUltimoRegistro
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 
         
                    if (result.movimientos.message.informacionPaginacion.totalPaginas == 0) {
                        if( primeraLlamada ) {
                            this.showToast("No se encontraron Movimientos", "No se encontraron movimientos al corte", "warning");
                            component.set("v.loadedMovConFechaCorte", false);
                            this.resetCmpValuesConFechaCorte(component);
                        } else {

                            /// La Ultima pagina no contiene Movimientos 
                            var oRes = result.movimientos.message.tarjetaCredito.movimiento;
                            component.set("v.movimientosConFechaCorte", oRes);

                            var PaginationLst = []; 
                            component.set('v.PaginationListMovConFechaCorte', PaginationLst);

                            ///
                            this.showToast("No se encontraron Movimientos", "No se encontraron mas movimientos al corte", "warning");
                            component.set("v.loadedMovConFechaCorte", false);

                            // Paginacion v2
                            component.set("v.idPrimerRegistroMovConFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro);
                            component.set("v.idUltimoRegistroMovConFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro);
                            if( !(result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro) ) {
                                component.set("v.movimientosConFechaUltimaPagina", true);
                            }

                            /// Guardar Movimientos de distintas Fechas
                            var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");
                            var totalLength = movimientosConFechaTodos.length;
                            var infoPaginacion = [];
                            infoPaginacion.push({
                                idPrimerRegistroMovConFecha: result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro,
                                idUltimoRegistroMovConFecha: result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro,
                                totalRecordsCountMovConFechaCorte: totalLength
                            });

                            var mapaFechaCortePaginacion = component.get("v.mapaFechaCortePaginacion");
                            mapaFechaCortePaginacion[fechaAjusteFormato] = infoPaginacion;
                            component.set("v.mapaFechaCortePaginacion", mapaFechaCortePaginacion ); 
                        }
                        
                    } else {
                        result.movimientos.message.tarjetaCredito.movimiento.isChecked = false;

                        component.set("v.tarjetaCredito", result.movimientos.message.tarjetaCredito.tarjetaCredito);
                        
                        /// Paginacion v2
                        var oRes, oResTmp, allRes;
                        oRes = result.movimientos.message.tarjetaCredito.movimiento;
                        oRes.sort(function(a, b) {
                            var dateA = new Date(a.transaccion.fechaHoraTransaccion), dateB = new Date(b.transaccion.fechaHoraTransaccion);
                            return dateB - dateA;
                        });
                        ///
                        console.log('oRes --> ', oRes);

                        if( primeraLlamada ) {                            
                            component.set("v.movimientosConFechaCorte", oRes);
                            component.set("v.movimientosConFechaTodos", oRes);
                        } else {
                            oResTmp = component.get("v.movimientosConFechaTodos");
                            allRes = oResTmp.concat(oRes);
                            component.set("v.movimientosConFechaTodos", allRes);
                            component.set("v.movimientosConFechaCorte", oRes);
                        }               

                        var pageSize = result.numRegistros; //
                        component.set("v.pageSizeMovConFechaCorte", result.numRegistros );

                        /// Paginacion v2
                        var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");
                        var totalLength = movimientosConFechaTodos.length;
                        component.set("v.totalRecordsCountMovConFechaCorte", totalLength);

                        component.set("v.startPageMovConFechaCorte",0);
                        component.set("v.endPageMovConFechaCorte",pageSize-1);                        

                        // Paginacion v2
                        if( (identificadorPrimerRegistro === '') && (identificadorUltimoRegistro === '') ) {

                            component.set("v.currentPageMovConFechaCorte", 1);
                        }
                        
                        var PaginationLst = [];
                        for(var i=0; i < pageSize; i++){
                            if(component.get("v.movimientosConFechaCorte").length > i){
                                PaginationLst.push(oRes[i]);    
                            } 
                        }   

                        component.set('v.PaginationListMovConFechaCorte', PaginationLst);
                        component.set("v.selectedCountMovConFechaCorte" , 0);
                        component.set("v.selectedCountMovConFechaCorteBackUp", 0);
                        //use Math.ceil() to Round a number upward to its nearest integer
                        component.set("v.totalPagesCountMovConFechaCorte", Math.ceil(totalLength / pageSize));
                        
                        // Clone movimientos
                        var movimientosConFechaCorteBackUp = JSON.parse(JSON.stringify(oRes));
                        component.set("v.movimientosConFechaCorteBackUp", movimientosConFechaCorteBackUp);
                        component.set("v.selectAllMovConFechaCorteCheck", false);

                        ///
                        component.set("v.loadedMovConFechaCorte", false);

                        // Paginacion v2
                        component.set("v.idPrimerRegistroMovConFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro);
                        component.set("v.idUltimoRegistroMovConFecha", result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro);
                        if( !(result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro) ) {
                            component.set("v.movimientosConFechaUltimaPagina", true);
                        }

                        /// Guardar Movimientos de distintas Fechas
                        var mapaMomimientosConFecha = component.get("v.mapaMomimientosConFecha");
                        mapaMomimientosConFecha[fechaAjusteFormato] = ( component.get("v.movimientosConFechaTodos") );
                        component.set("v.mapaMomimientosConFecha", mapaMomimientosConFecha); 

                        var contador = 0;
                        for (var key in mapaMomimientosConFecha){
                            contador++;
                        }

                        var infoPaginacion = [];
                        infoPaginacion.push({
                            idPrimerRegistroMovConFecha: result.movimientos.message.informacionPaginacion.paginaActual.identificadorPrimerRegistro,
                            idUltimoRegistroMovConFecha: result.movimientos.message.informacionPaginacion.paginaActual.identificadorUltimoRegistro,
                            totalRecordsCountMovConFechaCorte: totalLength
                        });

                        var mapaFechaCortePaginacion = component.get("v.mapaFechaCortePaginacion");
                        mapaFechaCortePaginacion[fechaAjusteFormato] = infoPaginacion;
                        component.set("v.mapaFechaCortePaginacion", mapaFechaCortePaginacion );
                    }
                    
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                    component.set("v.loadedMovConFechaCorte", false);
                    this.resetCmpValuesConFechaCorte(component);                    
                }
                ///
                component.set("v.fechaAsignada", true);
                
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
    },

    resetCmpValuesSinFechaCorte: function(component) {
        
        component.set("v.selectedCountMovSinFechaCorte", 0);
        component.set("v.selectAllMovSinFechaCorteCheck", false);
        
        component.set("v.movimientosSinFechaCorte", null);
        component.set("v.movimientosSinFechaCorteBackUp", null);
        
        component.set("v.PaginationList", null);
        
        component.set("v.startPage", 0);
        
        component.set("v.endPage", 0);
        
        component.set("v.totalRecordsCountMovSinFechaCorte", 0);
        
        component.set("v.currentPage", 0);
        
        component.set("v.totalPagesCount", 0);

        ///
        component.set("v.movimientosSinFechaTodos", null);
        component.set("v.movimientosSinFechaUltimaPagina", false);
	},

    resetCmpValuesConFechaCorte: function(component) {
        
        component.set("v.selectedCountMovConFechaCorte", 0);
        component.set("v.selectAllMovConFechaCorteCheck", false);
        
        component.set("v.movimientosConFechaCorte", null);
        component.set("v.movimientosConFechaCorteBackUp", null);

        component.set("v.PaginationListMovConFechaCorte", null);
        
        component.set("v.startPageMovConFechaCorte", 0);
        
        component.set("v.endPageMovConFechaCorte", 0);
        
        component.set("v.totalRecordsCountMovConFechaCorte", 0);
        
        component.set("v.currentPageMovConFechaCorte", 0);
        
        component.set("v.totalPagesCountMovConFechaCorte", 0);
        
        ///
        component.set("v.movimientosConFechaTodos", null);
        component.set("v.movimientosConFechaUltimaPagina", false);
	},

    cargarDetallesMovSinFechaCorte : function(component, movDetailIdx) {
        component.set("v.movimientoDetalle", null);
        
        var PaginationList = component.get("v.PaginationList");
        var tarjetaCredito = component.get("v.tarjetaCredito");
            
        var movSinFechaCorte = PaginationList[movDetailIdx];
        var numeroExtracto = movSinFechaCorte.detalleInternoMovimiento.numeroExtracto;
		var numeroMovimientoExtracto = movSinFechaCorte.detalleInternoMovimiento.numeroMovimientoExtracto;
        var numeroOperacionCuota = movSinFechaCorte.detalleInternoMovimiento.numeroOperacionCuota;
        var numeroFinanciacion = movSinFechaCorte.detalleInternoMovimiento.numeroFinanciacion;
        var titularidad = movSinFechaCorte.titularidad;
        var contrato = tarjetaCredito.identificadorProducto;
        
        
        
        var action = component.get("c.obtenerDetalleMovimientoCliente");
        
        action.setParams({
            "numeroExtracto": numeroExtracto,
            "numeroMovimientoExtracto": numeroMovimientoExtracto,
            "numeroOperacionCuota": numeroOperacionCuota,
            "numeroFinanciacion": numeroFinanciacion,
            "titularidad": titularidad,
            "contrato": contrato 
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 

                    component.set("v.movimiento", movSinFechaCorte);
                    component.set("v.movimientoDetalle", result.detalleMovimientos.message.movimientoDetalle );
                    ///
                    var cmpDetalleMovimientos = component.find("cmpDetalleMovimientos");
                    cmpDetalleMovimientos.set("v.movimiento", movSinFechaCorte);
                    cmpDetalleMovimientos.set("v.movimientoDetalle", result.detalleMovimientos.message.movimientoDetalle);
                    
                } else if( (!result.success) && result.detalleMovimientos && result.detalleMovimientos.message && (result.detalleMovimientos.message == 'Transaction Detail service error') ) {
                    this.showToast("Accion Requerida", "El movimiento seleccionado aún no ha sido procesado", "warning");
                    component.set("v.loadedDetalles", false);
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                    component.set("v.loadedDetalles", false);
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
        
    },

    cargarDetallesMovConFechaCorte : function(component, movDetailIdx) {
        component.set("v.movimientoDetalle", null);
        
        var PaginationList = component.get("v.PaginationListMovConFechaCorte");
        var tarjetaCredito = component.get("v.tarjetaCredito");
            
        var movSinFechaCorte = PaginationList[movDetailIdx];
        var numeroExtracto = movSinFechaCorte.detalleInternoMovimiento.numeroExtracto;
		var numeroMovimientoExtracto = movSinFechaCorte.detalleInternoMovimiento.numeroMovimientoExtracto;
        var numeroOperacionCuota = movSinFechaCorte.detalleInternoMovimiento.numeroOperacionCuota;
        var numeroFinanciacion = movSinFechaCorte.detalleInternoMovimiento.numeroFinanciacion;
        var titularidad = movSinFechaCorte.titularidad;
        var contrato = tarjetaCredito.identificadorProducto;
        
        
        
        var action = component.get("c.obtenerDetalleMovimientoCliente");
        
        action.setParams({
            "numeroExtracto": numeroExtracto,
            "numeroMovimientoExtracto": numeroMovimientoExtracto,
            "numeroOperacionCuota": numeroOperacionCuota,
            "numeroFinanciacion": numeroFinanciacion,
            "titularidad": titularidad,
            "contrato": contrato 
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 

                    component.set("v.movimiento", movSinFechaCorte);
                    component.set("v.movimientoDetalle", result.detalleMovimientos.message.movimientoDetalle );
                    ///
                    var cmpDetalleMovimientos = component.find("cmpDetalleMovimientos");
                    cmpDetalleMovimientos.set("v.movimiento", movSinFechaCorte);
                    cmpDetalleMovimientos.set("v.movimientoDetalle", result.detalleMovimientos.message.movimientoDetalle);
                    
                } else {
                    this.showToast("Ha ocurrido un error", "Favor de reportar a su administrador", "info");
                    component.set("v.loadedDetalles", false);
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
        
    },

    cargarDetallesMovimientos: function(component, selectedRecords, reclamoId, isMovimiento) {
        var movimientosList = [];
        
        var tarjetaCredito = component.get("v.tarjetaCredito");

        var saldos = component.get("v.saldos");
        var productos = component.get("v.productos");
        var productIdx = component.get("v.productIdx");
        
        var action = component.get("c.obtenerDetalleMovimientoClienteList");
        
        for(var i=0; i < selectedRecords.length; i++){
            
            var movimiento = {
                numeroExtracto : selectedRecords[i].detalleInternoMovimiento.numeroExtracto,
                numeroMovimientoExtracto: selectedRecords[i].detalleInternoMovimiento.numeroMovimientoExtracto,
                numeroOperacionCuota: selectedRecords[i].detalleInternoMovimiento.numeroOperacionCuota,
                numeroFinanciacion: selectedRecords[i].detalleInternoMovimiento.numeroFinanciacion,
                titularidad: selectedRecords[i].titularidad,
                contrato: tarjetaCredito.identificadorProducto,
                fechaHoraTransaccion: selectedRecords[i].transaccion.fechaHoraTransaccion,
                montoLocal: selectedRecords[i].montoMovimientoTC.montoLocal,
                pagoMinimo: saldos[0].resumenFacturacion.resumenUltimaFacturacion.pagoMinimo,
                fechaLimiteDePago: saldos[0].resumenFacturacion.resumenUltimaFacturacion.fechaVencimiento,
                proximaFechaDeCorte: saldos[0].resumenFacturacion.resumenProximaFacturacion.fechaProximaFacturacion,
                estatusFinalDeTarjeta: productos[productIdx].situacion.glosa,
                descripcionMovimiento: this.limpiaDescripcion(component, selectedRecords[i].descripcion),
                movimientoPorAutorizar: selectedRecords[i].estadoMovimiento.codigo == 'A' ? true : false
            }
            movimientosList.push(movimiento);
            
        } // final for

        console.log('movimientosList: ', movimientosList);

        action.setParams({
            "movimientosList": JSON.stringify(movimientosList)
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state", state);
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if (result.success) { 
                    
                    /// Ajuste para Tipificacion de Casos desde Movimientos
                    component.set("v.movimientosListObject", result.movWithDetallesList );
                    component.set("v.movimientosList", JSON.stringify(result.movWithDetallesList) );
                    component.set("v.numeroDeTarjetaValueProducto", reclamoId);
                    component.set("v.movimientosSeleccionados", true);
                    ///
                    component.set("v.consultaMovimientosExitosa", true);
                    component.set("v.mensajeErrorConsulta", '');
                } else if( (!result.success) && result.error && result.error.message && (result.error.message == 'Transaction Detail service error') ) {

                    /// Variable para detener el spinner
                    component.set("v.movimientosSeleccionados", true);
                    /// Se muestra mensaje por consulta de Movimientos sin informacion en el MS DetalleMovimientos
                    component.set("v.consultaMovimientosExitosa", false);
                    component.set("v.mensajeErrorConsulta", "No es posible generar el caso ya que existen movimientos seleccionados que aún no han sido procesados");
                } else {

                    component.set("v.movimientosSeleccionados", true);
                    component.set("v.consultaMovimientosExitosa", false);
                    component.set("v.mensajeErrorConsulta", '');
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
        
        
    },

    limpiaDescripcion : function(component, valor) {

        var limpiarNombreComercio = component.get("v.limpiarNombreComercio");
        for(var i = 0; i < limpiarNombreComercio.length; i++) {

            valor = valor.replace(limpiarNombreComercio[i], '');
        }

        return valor;
    },

    resetCmpValues : function(component) {
        
        
        
        component.set("v.selectedCountMovSinFechaCorte", 0);
        component.set("v.selectAllMovSinFechaCorteCheck", false);
        
        component.set("v.selectedCountMovConFechaCorte", 0);        
        component.set("v.selectAllMovConFechaCorteCheck", false);
        
        component.set("v.movimientosSinFechaCorte", null);
        component.set("v.movimientosSinFechaCorteBackUp", null);
        
        component.set("v.movimientosConFechaCorte", null);
        component.set("v.movimientosConFechaCorteBackUp", null);
        
        component.set("v.PaginationList", null);
        component.set("v.PaginationListMovConFechaCorte", null);
        
        component.set("v.startPage", 0);
        component.set("v.startPageMovConFechaCorte", 0);
        
        component.set("v.endPage", 0);
        component.set("v.endPageMovConFechaCorte", 0);
        
        component.set("v.totalRecordsCountMovSinFechaCorte", 0);
        component.set("v.totalRecordsCountMovConFechaCorte", 0);
        
        component.set("v.currentPage", 1);
        component.set("v.currentPageMovConFechaCorte", 0);
        
        component.set("v.totalPagesCount", 0);
        component.set("v.totalPagesCountMovConFechaCorte", 0);
        
        component.set("v.movimiento", null);
        
        
        
        component.set("v.loadedMovSinFechaCorte", true); //spinners
        component.set("v.loadedMovConFechaCorte", true); //spinners
        
        ///
        component.set("v.movimientosSinFechaTodos", null);
        component.set("v.movimientosSinFechaUltimaPagina", false);

        component.set("v.movimientosConFechaTodos", null);
        component.set("v.movimientosConFechaUltimaPagina", false);

        component.set("v.mapaMomimientosConFecha", {});
        component.set("v.mapaFechaCortePaginacion", {});
        
    },

    showToast : function(title, message, type, mode) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            
            "title": title,
            "message": message,
            "type": type,
            "mode": mode
        });
        toastEvent.fire();
    },
    
    ////
    validarCasoConsultaSaldos : function(component) {

        var selectedAccount = component.get("v.selectedAccount");
        var selectedAccountID = selectedAccount.Id;

        var action = component.get("c.casoCreadoConsultaSaldos");
		action.setParams({

			"customerId": selectedAccountID
        });
        
        action.setCallback(this, function(response) {

            var state = response.getState(); 
             if (state === "SUCCESS") {
				
				var result = response.getReturnValue();
                if (result) {

                    console.log("CasoConsultaSaldos result --> ", result );
                    component.set("v.casoConsultaSaldosCreado", true);
                }
             }
             component.set("v.loadingCasoConsultaDeSaldos", false);
         });
 
         $A.enqueueAction(action);
    }/*, 

    validaFecha90Dias : function (component, event, fechaMovimiento) {

        var dateToday = new Date();

        var fechaHoraTransaccion;
        if( !fechaMovimiento ) {
            var recordItem = event.getSource().get("v.name");
            fechaHoraTransaccion = recordItem.transaccion.fechaHoraTransaccion;
        } else {
            fechaHoraTransaccion = fechaMovimiento;
        }
      
        var dateFechaSeleccionada = new Date(fechaHoraTransaccion);

        var sumAniosMovimientosConFecha = component.get("v.sumAniosMovimientosConFecha");
        var fechaCorteValor = component.get("v.fechaCorteValue");
        var dateTMP, monthTMP;
        dateTMP = fechaCorteValor.split("-");        
        monthTMP = dateTMP[1];

        var dateSeleccionada = new Date(dateFechaSeleccionada.getUTCFullYear() - sumAniosMovimientosConFecha, monthTMP - 1, dateFechaSeleccionada.getUTCDate(), dateToday.getHours(), dateToday.getMinutes(), dateToday.getSeconds() );

        var diferencia = (dateToday - dateSeleccionada) / (1000*60*60*24);
        console.log("diferencia:  ", diferencia );

        if( diferencia >= 91 ) {
            this.showToast("Movimiento mayor a 90 dias", "No se puede seleccionar un Movimiento mayor a 90 dias", "warning");
            event.getSource().set("v.value", false);
            if( fechaMovimiento ) {
                return true;
            }
        }
    }*/

})