({
    doInit : function (component, event, helper) {

        ///
        component.set("v.loadingCasoConsultaDeSaldos", true);

        var productIdx = component.get("v.productIdx");
        var movimientoIdx = component.get("v.movimientoIdx");

        var productos = component.get("v.productos");

        /// SEPARACION
        /*component.set("v.cargarMicroServicioSaldos", true);
        component.set("v.mostrarTablaSaldos", true);
        var cmpSaldos = component.find("msSaldos");
        console.log("cmpSaldos:  ", cmpSaldos);*/
        //cmpSaldos.set("v.cargarMicroServicioSaldos", true);
        //cmpSaldos.set("v.mostrarTablaSaldos", true);
        
        // Movimiento Sin Fecha Corte
        var movimientosSinFechaCorte = component.get("v.movimientosSinFechaTodos");
        var movimientosSinFechaCorteBackUp = component.get("v.movimientosSinFechaCorteBackUp");
        
        if (movimientosSinFechaCorte!= null && movimientosSinFechaCorte.length > 0) {
            movimientosSinFechaCorteBackUp = JSON.parse(JSON.stringify(movimientosSinFechaCorte));
            component.set("v.movimientosSinFechaCorteBackUp", movimientosSinFechaCorteBackUp);
        }
        
        // Movimiento Con Fecha Corte
        var movimientosConFechaCorte = component.get("v.movimientosConFechaTodos");
        var movimientosConFechaCorteBackUp = component.get("v.movimientosConFechaCorteBackUp");
       
        if (movimientosConFechaCorte!=null && movimientosConFechaCorte.length > 0) {
            movimientosConFechaCorteBackUp = JSON.parse(JSON.stringify(movimientosConFechaCorte));
            component.set("v.movimientosConFechaCorteBackUp", movimientosConFechaCorteBackUp);
        }        
        
        if (productIdx != movimientoIdx) {
            ///
            component.set("v.movimientoIdxMovSinFecha", movimientoIdx);

            component.set("v.productIdx", movimientoIdx);
            helper.resetCmpValues(component);
            helper.cargarMovimientosSinFechaCorte(component, movimientoIdx, '', '', true);
        } else if( productIdx && movimientoIdx ) {
        
            if( productIdx == movimientoIdx ) {

                /// Se valida si ya se cargaron Ultimos Movimientos
                var movimientoIdxMovSinFecha = component.get("v.movimientoIdxMovSinFecha");
                
                    component.set("v.movimientoIdxMovSinFecha", movimientoIdx);
                    helper.cargarMovimientosSinFechaCorte(component, movimientoIdx, '', '', true);

                var resultFechasCorte = component.get("v.fechasCorteOptions");

                ///
                component.set("v.fechaCorteValue", resultFechasCorte[1].value );
                component.set("v.fechaAsignada", false);
            }
        }
        
        // Componente Movimientos Seleccionados
        component.set("v.movimientosSeleccionados", false);

        /// Se carga validacion para crear caso de Consulta de Saldos y Movimientos
        helper.validarCasoConsultaSaldos(component);

        /// MultiPickList Tipo de Consulta
        component.set("v.valuesSelected", '');

        /// Tipo de Producto 
        component.set("v.glosaCodigoSubProducto", productos[movimientoIdx].glosaCodigoSubProducto );

        /// Mensaje de recordatorio para el uso de la APP
        var messageApp = "\n Invita al cliente a usar la App o Web si tiene usuario \n y contraseña y si no,\u00A0 ayúdalo a navegar o descargar \n la App. \n";
        messageApp += "Para su\u00A0 comodidad,\u00A0 usted puede\u00A0 revisar\u00A0 su saldo \n y\u00A0 movimientos\u00A0 en todo\u00A0 momento\u00A0 desde\u00A0 su\u00A0 app \n ";
        messageApp += "o en la web,\u00A0 también puede\u00A0 solicitar los últimos 5 \n movimientos por whatsapp.";

        helper.showToast( messageApp, " \n ", "success", "sticky");
    },
    
    closeModel: function(component, event, helper) {

        ///
        var loadedMovSinFechaCorte = component.get("v.loadedMovSinFechaCorte");
        var loadingCasoConsultaDeSaldos = component.get("v.loadingCasoConsultaDeSaldos");
        if( loadedMovSinFechaCorte || loadingCasoConsultaDeSaldos ) {
            return;
        }
        var loadedMovConFechaCorte = component.get("v.loadedMovConFechaCorte");
        if( loadedMovConFechaCorte ) {
            helper.showToast("Accion Requerida", "Es necesario seleccionar la pestaña de movimientos al corte para poder continuar", "warning");
            return;
        }

        /// Validacion en campo MultiPickList Tipo de Consulta
        var valuesSelected = component.get("v.valuesSelected");

        if( (!valuesSelected) || (valuesSelected && valuesSelected.length < 1) ) {

            helper.showToast("Accion Requerida", "Es necesario seleccionar al menos un Tipo de Consulta", "warning");
            return;
        }
        
        // movimientos Sin Fecha Corte
        var movimientosSinFechaCorteBackUp = component.get("v.movimientosSinFechaCorteBackUp");
        var movimientosSinFechaTodos = component.get("v.movimientosSinFechaTodos");
        var movimientosSinFechaCorteBackUpCloned = JSON.parse(JSON.stringify(movimientosSinFechaCorteBackUp));
        movimientosSinFechaTodos = movimientosSinFechaCorteBackUpCloned;
        component.set("v.movimientosSinFechaTodos", movimientosSinFechaTodos);
       
        var pageSize = component.get("v.pageSize");
        var PaginationLst = [];
        if(movimientosSinFechaTodos!=null) {
            for(var i=0; i < pageSize; i++){
                if(component.get("v.movimientosSinFechaTodos").length > i){
                    PaginationLst.push(movimientosSinFechaTodos[i]);    
                } 
            }
        }
        
        component.set('v.PaginationList', PaginationLst);
        
        var getSelectedNumberSin = component.get("v.selectedCountMovSinFechaCorteBackUp");
        if (getSelectedNumberSin!=0) {
            if (getSelectedNumberSin == component.get("v.totalRecordsCountMovSinFechaCorte")) {
                component.set("v.selectAllMovSinFechaCorteCheck", true);
            } else {
                component.set("v.selectAllMovSinFechaCorteCheck", false);
            }
        }
        
        component.set("v.selectedCountMovSinFechaCorte", getSelectedNumberSin);
        
        // movimientos Con Fecha Corte
        var movimientosConFechaCorteBackUp = component.get("v.movimientosConFechaCorteBackUp");
        var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");
        var movimientosConFechaCorteBackUpCloned = JSON.parse(JSON.stringify(movimientosConFechaCorteBackUp));
        movimientosConFechaTodos = movimientosConFechaCorteBackUpCloned;
        component.set("v.movimientosConFechaTodos", movimientosConFechaTodos);
        
        var pageSizeMovConFechaCorte = component.get("v.pageSizeMovConFechaCorte");
        var PaginationLstCon = [];

        if (movimientosConFechaTodos!=null) {
            for(var i=0; i < pageSizeMovConFechaCorte; i++){
                if(component.get("v.movimientosConFechaTodos").length > i){
                    PaginationLstCon.push(movimientosConFechaTodos[i]);    
                } 
            }
        }
        
        component.set('v.PaginationListMovConFechaCorte', PaginationLstCon);
        
        var getSelectedNumberCon = component.get("v.selectedCountMovConFechaCorteBackUp");
        if (getSelectedNumberCon!=0) {
            if (getSelectedNumberCon == component.get("v.totalRecordsCountMovConFechaCorte")) {
                component.set("v.selectAllMovConFechaCorteCheck", true);
            } else {
                component.set("v.selectAllMovConFechaCorteCheck", false);
            }
        }
        
        component.set("v.selectedCountMovConFechaCorte", getSelectedNumberCon);
        
        component.set("v.isOpen", false);

        ///
        component.set("v.cargarFechasDeCorte", false);

        /// Modal Crear Caso Consulta de Saldos
        var casoConsultaSaldosCreado = component.get("v.casoConsultaSaldosCreado");
        if( !casoConsultaSaldosCreado ) {

            component.set("v.blnOpenModalContactMethod", true);
            component.set("v.blnBalancesCase", true);
        }        
	},

	navigation: function(component, event, helper) {
        var sObjectList = component.get("v.movimientosSinFechaCorte");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // Paginacion v2
        var movimientoIdx = component.get("v.movimientoIdx");
        var identificadorPrimerRegistro = component.get("v.idPrimerRegistroMovSinFecha");
        var identificadorUltimoRegistro = component.get("v.idUltimoRegistroMovSinFecha");

        ///
        var movimientosSinFechaUltimaPagina = component.get("v.movimientosSinFechaUltimaPagina");
        var currentPage = component.get("v.currentPage"); 
        var pageStart = 0;
        var pageEnd = pageSize - 1;
        var movimientosSinFechaTodos = component.get("v.movimientosSinFechaTodos");
        var totalRecordsCountMovSinFechaCorte = component.get("v.totalRecordsCountMovSinFechaCorte");

        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {

            if( totalRecordsCountMovSinFechaCorte > (currentPage * pageSize) ) {
                currentPage = currentPage + 1;
                pageStart = (currentPage * pageSize) - pageSize;
                pageEnd = (currentPage * pageSize) - 1;
                var PaginationLst = [];
                for(var i = pageStart; i <= pageEnd; i++) {
                    if( movimientosSinFechaTodos.length > i ) {
                        PaginationLst.push(movimientosSinFechaTodos[i]);
                    }
                }
                component.set('v.PaginationList', PaginationLst);
            } else {
                currentPage = currentPage + 1;
                component.set("v.loadedMovSinFechaCorte", true);
                helper.cargarMovimientosSinFechaCorte(component, movimientoIdx, '', identificadorUltimoRegistro, false);
            }

            component.set("v.currentPage", currentPage);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {

            /// Paginacion v2
            currentPage = currentPage - 1;
            component.set("v.currentPage", currentPage );
            pageStart = (currentPage * pageSize) - pageSize;
            pageEnd = (currentPage * pageSize) - 1;
            var PaginationLst = [];
            for(var i = pageStart; i <= pageEnd; i++) {
                PaginationLst.push(movimientosSinFechaTodos[i]);
            }
            component.set('v.PaginationList', PaginationLst);
        }
	},
	
	navigationMovConFechaCorte: function(component, event, helper) {
        var sObjectList = component.get("v.movimientosConFechaCorte");
        var end = component.get("v.endPageMovConFechaCorte");
        var start = component.get("v.startPageMovConFechaCorte");
        
        var pageSize = component.get("v.pageSizeMovConFechaCorte");
        var whichBtn = event.getSource().get("v.name");

        // Paginacion v2
        var movimientoIdx = component.get("v.movimientoIdx");
        var identificadorPrimerRegistro = component.get("v.idPrimerRegistroMovConFecha");
        var identificadorUltimoRegistro = component.get("v.idUltimoRegistroMovConFecha");
        var fechaCorteValue = component.get("v.fechaCorteValue");
        ///
        var movimientosConFechaUltimaPagina = component.get("v.movimientosConFechaUltimaPagina");
        var currentPageMovConFechaCorte = component.get("v.currentPageMovConFechaCorte"); 
        var pageStart = 0;
        var pageEnd = pageSize - 1;
        var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");
        var totalRecordsCountMovConFechaCorte = component.get("v.totalRecordsCountMovConFechaCorte");

        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            
            if( totalRecordsCountMovConFechaCorte > (currentPageMovConFechaCorte * pageSize) ) {
                currentPageMovConFechaCorte = currentPageMovConFechaCorte + 1;
                pageStart = (currentPageMovConFechaCorte * pageSize) - pageSize;
                pageEnd = (currentPageMovConFechaCorte * pageSize) - 1;
                var PaginationLst = [];
                for(var i = pageStart; i <= pageEnd; i++) {
                    if( movimientosConFechaTodos.length > i ) {
                        PaginationLst.push(movimientosConFechaTodos[i]);
                    }
                }
                component.set('v.PaginationListMovConFechaCorte', PaginationLst);
            } else {
                currentPageMovConFechaCorte = currentPageMovConFechaCorte + 1;
                helper.cargarMovimientosConFechaCorte(component, movimientoIdx, fechaCorteValue, '', identificadorUltimoRegistro, false);
            }

            component.set("v.currentPageMovConFechaCorte", currentPageMovConFechaCorte );
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {            

            /// Paginacion v2
            currentPageMovConFechaCorte = currentPageMovConFechaCorte - 1;
            component.set("v.currentPageMovConFechaCorte", currentPageMovConFechaCorte );
            pageStart = (currentPageMovConFechaCorte * pageSize) - pageSize;
            pageEnd = (currentPageMovConFechaCorte * pageSize) - 1;
            var PaginationLst = [];
            for(var i = pageStart; i <= pageEnd; i++) {
                PaginationLst.push(movimientosConFechaTodos[i]);
            }
            component.set('v.PaginationListMovConFechaCorte', PaginationLst);

        }
    },

	selectAllCheckboxMovSinFechaCorte: function(component, event, helper) {
        var movimientoText = event.getSource().getLocalId();
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var movimientos = component.get("v.movimientosSinFechaCorte");
        var PaginationList = component.get("v.PaginationList");
        
        for (var i = 0; i < movimientos.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                movimientos[i].isChecked = true;
                component.set("v.selectedCountMovSinFechaCorte", movimientos.length);
            } else {
                movimientos[i].isChecked = false;
                component.set("v.selectedCountMovSinFechaCorte", 0);
                
            }
            updatedAllRecords.push(movimientos[i]);
        }
        
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        
        component.set("v.movimientosSinFechaCorte", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
	},

	selectAllCheckboxMovConFechaCorte: function(component, event, helper) {
        var movimientoText = event.getSource().getLocalId();
        
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var movimientos = component.get("v.movimientosConFechaCorte");
        var PaginationList = component.get("v.PaginationListMovConFechaCorte");

        for (var i = 0; i < movimientos.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                /// Validar movimientos mayores a 90 dias
                /*var result = helper.validaFecha90Dias(component, event, movimientos[i].transaccion.fechaHoraTransaccion );
                if( result ) {
                    return;
                }*/
                movimientos[i].isChecked = true;
                component.set("v.selectedCountMovConFechaCorte", movimientos.length);
            } else {
                movimientos[i].isChecked = false;
                component.set("v.selectedCountMovConFechaCorte", 0);
                
            }
            updatedAllRecords.push(movimientos[i]);
        }
        
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        
        component.set("v.movimientosConFechaCorte", updatedAllRecords);
        component.set("v.PaginationListMovConFechaCorte", updatedPaginationList);
    },
	
	checkboxSelectMovSinFechaCorte: function(component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCountMovSinFechaCorte");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--; 
            component.set("v.selectAllMovSinFechaCorteCheck", false);
        }
        component.set("v.selectedCountMovSinFechaCorte", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountMovSinFechaCorte")) {
            component.set("v.selectAllMovSinFechaCorteCheck", true);
        }
	},

	checkboxSelectMovConFechaCorte: function(component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        
        /// Validar movimientos mayores a 90 dias
        /*if( selectedRec ) {
            helper.validaFecha90Dias(component, event);
        }        
        selectedRec = event.getSource().get("v.value");*/
        
        var getSelectedNumber = component.get("v.selectedCountMovConFechaCorte");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--; 
            component.set("v.selectAllMovConFechaCorteCheck", false);
        }
        component.set("v.selectedCountMovConFechaCorte", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountMovConFechaCorte")) {
            component.set("v.selectAllMovConFechaCorteCheck", true);
        }
	}, 
	
	getSelectedRecords: function(component, event, helper) {

        var movimientosSinFechaTodos = component.get("v.movimientosSinFechaTodos");
        var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");

        /// Movimientos No Facturados
        var movNoFacturado = false;
        console.log('movimientosSinFechaTodos --> ', movimientosSinFechaTodos);
        if( movimientosSinFechaTodos != null ) {
            for(var i=0; i < movimientosSinFechaTodos.length; i++) {
                if( movimientosSinFechaTodos[i].isChecked && movimientosSinFechaTodos[i].estadoMovimiento.codigo == 'A' ) {
                    movNoFacturado = true;
                    break;
                }
            }
        }

        /// Guardar Movimientos de distintas Fechas
        var mapaMomimientosConFecha = component.get("v.mapaMomimientosConFecha");
        var movimientosConFechaTodasLasFechas = null;
        var contador = 0;
        for (var key in mapaMomimientosConFecha){

            if( contador == 0 ) {
                movimientosConFechaTodasLasFechas = mapaMomimientosConFecha[key];
            } else {
                movimientosConFechaTodasLasFechas = movimientosConFechaTodasLasFechas.concat( mapaMomimientosConFecha[key] );
            }
            contador ++;
        }        

        if (movimientosConFechaTodasLasFechas!=null) {
            if( movimientosSinFechaTodos != null ) {
                var allRecords = movimientosSinFechaTodos.concat(movimientosConFechaTodasLasFechas);
            } else {
                var allRecords = movimientosConFechaTodasLasFechas;
            }
        } else {
            var allRecords = movimientosSinFechaTodos;
        }
        
        var selectedRecords = [];

        if (allRecords != null) {
            for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].isChecked) {
                    selectedRecords.push(allRecords[i]);
                }
            }
        }

        var blnSoloMovsNoFacturados = false;
        /// Se recorren Todos los movimientos para el flujo Liberar Saldo Retenido
        if( movNoFacturado && selectedRecords != null ) {

            for (var i = 0; i < selectedRecords.length; i++) {
                if ( selectedRecords[i].estadoMovimiento.codigo == 'E' ) {
                    
                    blnSoloMovsNoFacturados = false;
                    break;
                } else {

                    blnSoloMovsNoFacturados = true;
                }
            }
        }
        component.set("v.blnSoloMovsNoFacturados", blnSoloMovsNoFacturados);

        var productos = component.get("v.productos");
        var productIdx = component.get("v.productIdx");
        var reclamoId = productos[productIdx].tarjetaCredito.identificadorProducto;
        ///
        var blnPlanDePagos = component.get("v.blnPlanDePagos");

        if( selectedRecords.length > 20 ) {

            helper.showToast("Accion Requerida", "No se pueden Seleccionar mas de 20 Movimientos", "warning");
            return;
        } else if ( movNoFacturado && !blnSoloMovsNoFacturados ) {
            
            helper.showToast("Accion Requerida", "No es posible generar el caso ya que existen movimientos seleccionados que aún no han sido procesados", "warning");
            return;
        } else if (selectedRecords.length > 0 && selectedRecords.length <= 20) {
            
            var isMovimiento = component.get("v.isMovimiento");

            /// MS Movimientos Creacion de Casos con Movimientos
            component.set("v.casoSinSeleccionarMovimientos", false);
            
            helper.cargarDetallesMovimientos(component, selectedRecords, reclamoId, isMovimiento);
            
        } else if ( (selectedRecords.length == 0) && blnPlanDePagos ) {

            var movimientosList = [];
            var movimiento = {
                estatusFinalDeTarjeta: productos[productIdx].situacion.glosa,
                blnPlanPagosConMovs: false
            }
            movimientosList.push(movimiento);

            component.set("v.movimientosList", JSON.stringify(movimientosList) );
            component.set("v.numeroDeTarjetaValueProducto", reclamoId);
            component.set("v.movimientosSeleccionados", true);
            ///
            component.set("v.consultaMovimientosExitosa", true);
            component.set("v.mensajeErrorConsulta", '');

        } else if( (selectedRecords.length == 0) && !blnPlanDePagos ) {

            /// MS Movimientos Creacion de Casos sin Seleccionar Movimientos
            component.set("v.casoSinSeleccionarMovimientos", true);

            component.set("v.movimientosSeleccionados", true);
            component.set("v.consultaMovimientosExitosa", true);

            //Comentar cuando se haga el pase de los productos
            //helper.showToast("Accion Requerida", "Debes seleccionar uno o mas movimientos (max 20) para poder crear un caso", "warning");
            //return;
        }
        
        // Selected numbers of records
        var getSelectedNumberSin = component.get("v.selectedCountMovSinFechaCorte"); 
        component.set("v.selectedCountMovSinFechaCorteBackUp", getSelectedNumberSin);
        var getSelectedNumberCon = component.get("v.selectedCountMovConFechaCorte");
        component.set("v.selectedCountMovConFechaCorteBackUp", getSelectedNumberCon);

        /// Modal Guardar Movimientos
        component.set("v.openGuardarMovimientos", true);
    },
	
	detalleMovSinFechaCorte: function(component, event, helper) {

        ///
        var movDetailIdx = event.getSource().get("v.value");
        var PaginationList = component.get("v.PaginationList");
        if( PaginationList && PaginationList[movDetailIdx] && PaginationList[movDetailIdx].estadoMovimiento.codigo == 'A' ) {

            helper.showToast("Accion Requerida", "El movimiento seleccionado aún no ha sido procesado", "warning");
            return;
        } else {

            component.set("v.loadedDetalles", true);
            var detailMove = component.find("detailMove");
            ///var movDetailIdx = event.getSource().get("v.value");        
            
            $A.util.addClass(detailMove, "slds-backdrop slds-backdrop_open");
            component.set("v.isOpen2", true);

            helper.cargarDetallesMovSinFechaCorte(component, movDetailIdx);
        }
	},
	
	detalleMovConFechaCorte: function(component, event, helper) {

        component.set("v.loadedDetalles", true);
        var detailMove = component.find("detailMove");
        var movDetailIdx = event.getSource().get("v.value");
        
        $A.util.addClass(detailMove, "slds-backdrop slds-backdrop_open");
        component.set("v.isOpen2", true);
        
        helper.cargarDetallesMovConFechaCorte(component, movDetailIdx);
    },
    
    changeFechaCorte: function(component, event, helper) {

        ///
        var fechaAsignada = component.get("v.fechaAsignada");
        if( !fechaAsignada ) {
            ///
            var fechaCorteValor = component.get("v.fechaCorteValue");

            /// Guardar Movimientos de distintas Fechas
            var fechaAjusteFormato, dateTMP, yearTMP, monthTMP, dayTMP;
            dateTMP = fechaCorteValor.split("-");

            dayTMP = dateTMP[0];
            monthTMP = dateTMP[1];
            yearTMP = dateTMP[2];

            fechaAjusteFormato = yearTMP + "-" + monthTMP + "-" + dayTMP;

            var mapaMomimientosConFecha = component.get("v.mapaMomimientosConFecha");

            var pageStart = 0;
            var pageEnd = pageSize - 1;
            var pageSize = component.get("v.pageSizeMovConFechaCorte");
            var currentPageMovConFechaCorte = component.get("v.currentPageMovConFechaCorte"); 

            if( mapaMomimientosConFecha[fechaAjusteFormato] ) {

                component.set("v.movimientosConFechaTodos", mapaMomimientosConFecha[fechaAjusteFormato] );

                var movimientosConFechaTodos = component.get("v.movimientosConFechaTodos");
                currentPageMovConFechaCorte = 1;
                component.set("v.currentPageMovConFechaCorte", currentPageMovConFechaCorte );
                pageStart = (currentPageMovConFechaCorte * pageSize) - pageSize;
                pageEnd = (currentPageMovConFechaCorte * pageSize) - 1;
                var PaginationLst = [];
                for(var i = pageStart; i <= pageEnd; i++) {
                    if( movimientosConFechaTodos.length > i ) {
                        PaginationLst.push(movimientosConFechaTodos[i]);
                    }
                }
                component.set('v.PaginationListMovConFechaCorte', PaginationLst);

                ///
                component.set("v.movimientosConFechaCorte", PaginationLst);

                var mapaFechaCortePaginacion = component.get("v.mapaFechaCortePaginacion");

                if( mapaFechaCortePaginacion[fechaAjusteFormato] ) {

                    var listTmp = mapaFechaCortePaginacion[fechaAjusteFormato];
                    var idPrimerRegistroMovConFecha = listTmp[0].idPrimerRegistroMovConFecha;
                    var idUltimoRegistroMovConFecha = listTmp[0].idUltimoRegistroMovConFecha;
                    var totalRecordsCountMovConFechaCorte = listTmp[0].totalRecordsCountMovConFechaCorte;

                    component.set("v.idPrimerRegistroMovConFecha", idPrimerRegistroMovConFecha);
                    component.set("v.idUltimoRegistroMovConFecha", idUltimoRegistroMovConFecha);
                    component.set("v.totalRecordsCountMovConFechaCorte", totalRecordsCountMovConFechaCorte);
                }
                ///
                component.set("v.fechaAsignada", true);

            } else {
                var movimientoIdx = component.get("v.movimientoIdx");
                component.set("v.loadedMovConFechaCorte", true);

                ///
                helper.resetCmpValuesConFechaCorte(component);

                // Se envian las variables vacias para hacer la primer llamada al microservicio
                var identificadorPrimerRegistro = '';
                var identificadorUltimoRegistro = '';
                helper.cargarMovimientosConFechaCorte(component, movimientoIdx, fechaCorteValor, identificadorPrimerRegistro, identificadorUltimoRegistro, true);
            }
        }
    },

    changePlanDePagos : function (component, event, helper) {

        var idUltimoRegistroMovSinFecha = component.get("v.idUltimoRegistroMovSinFecha");
        console.log("idUltimoRegistroMovSinFecha:  ", idUltimoRegistroMovSinFecha);

        var movimientosSinFechaTodos = component.get("v.movimientosSinFechaTodos");
        var paginationList = component.get("v.PaginationList");

        if( idUltimoRegistroMovSinFecha ) {

            helper.showToast("Accion Requerida", "Por favor cargar todos los movimientos", "warning");
            event.getSource().set("v.value", false);
        } else {

            console.log("MOV Cargados");
            /// Se marcan los movimientos de la pagina actual (al corte)
            if( paginationList ) {
                for(var i = 0; i < paginationList.length; i++) {

                    if(paginationList[i].tipoAccionContable.descripcion == 'Abono') {

                        if( event.getSource().get("v.value") ) {

                            paginationList[i].isChecked = true;
                        } else {

                            paginationList[i].isChecked = false;
                        }
                    }
                }
                /// Se marcan todos los movimientos al corte
                for(var i = 0; i < movimientosSinFechaTodos.length; i++) {

                    if(movimientosSinFechaTodos[i].tipoAccionContable.descripcion == 'Abono') {

                        if( event.getSource().get("v.value") ) {

                            movimientosSinFechaTodos[i].isChecked = true;
                        } else {

                            movimientosSinFechaTodos[i].isChecked = false;
                        }
                    } else {

                        if( event.getSource().get("v.value") ) {

                            movimientosSinFechaTodos[i].isChecked = false;
                        }
                    }
                }

                component.set("v.PaginationList", paginationList);
                component.set("v.movimientosSinFechaTodos", movimientosSinFechaTodos);
            }

            /// Movientos con Fecha de Corte
            var mapaMomimientosConFecha = component.get("v.mapaMomimientosConFecha");
            console.log('mapaMomimientosConFecha -->  ', mapaMomimientosConFecha);

            if( (event.getSource().get("v.value")) && (Object.keys(mapaMomimientosConFecha).length > 0) ) {

                var movimientosConFechaTMP = null;
                for (var key in mapaMomimientosConFecha) {

                    movimientosConFechaTMP = mapaMomimientosConFecha[key];
                    for(var i = 0; i < movimientosConFechaTMP.length; i++  ) {

                        movimientosConFechaTMP[i].isChecked = false;
                    }

                    mapaMomimientosConFecha[key] = movimientosConFechaTMP;
                }
                ///
                var paginationListMovConFechaCorte = component.get("v.PaginationListMovConFechaCorte");
                for(var i = 0; i < paginationListMovConFechaCorte.length; i++) {

                    paginationListMovConFechaCorte[i].isChecked = false;
                }

                component.set("v.mapaMomimientosConFecha", mapaMomimientosConFecha);
                component.set("v.PaginationListMovConFechaCorte", paginationListMovConFechaCorte);
            }
            
        }
    }

})