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

	loadCanalOrigenList : function(component) {

		var canalOrigenOptions = [];
		var canalOrigenList = component.get("v.canalOrigenList");

		for(var i = 0; i < canalOrigenList.length; i ++) {

			canalOrigenOptions.push({label:canalOrigenList[i], value:canalOrigenList[i]});
		}

		component.set("v.canalOrigenValue", canalOrigenList[0]);
		component.set("v.canalOrigenOptions", canalOrigenOptions);
	},

	validarCampo : function(component, campo) {

		if( campo == undefined || campo == null || campo == '' ) {

			return true;
		}
	},

	cargarData : function(component, curp, descargarCSV, offSetCount) {

		var fechaInicio = component.get("v.fechaInicio");
		var fechaFin = component.get("v.fechaFin");

		var canalOrigenValue = component.get("v.canalOrigenValue");
		var canalOrigen = this.validarCampo(component, canalOrigenValue) ? component.get("v.canalOrigenList")[0] : canalOrigenValue;
		var recordTypeDevName = canalOrigen == 'Presencial' ? 'Riesgos_Originaci_n' : 'BackOffice_Figital';

		var colapsarCasos = component.get("v.colapsarCasos");
		
		var action = component.get("c.getCasosBOCredito");

		action.setParams({
			"fechaInicio" : fechaInicio,
			"fechaFin" : fechaFin,
			"colapsar" : colapsarCasos,
			"curp" : curp,
			"recordTypeDevName" : recordTypeDevName,
			"offset" : offSetCount,
			"allRecords" : descargarCSV
        });

		action.setCallback(this, function(response) {

			console.log('response.getState() --> ', response.getState());

			if (response.getState() === "SUCCESS") {
				
				var result = response.getReturnValue();

				///
				if( descargarCSV ) {

					var csv = this.generaCSV(component,result.listCasosBackOffice);   
					if (csv == null) {
						return;
					} 

					var hiddenElement = document.createElement('a');
					hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
					hiddenElement.target = '_self';
					hiddenElement.download = 'ReporteBackOffice.csv';
					document.body.appendChild(hiddenElement);
					hiddenElement.click();

				} else {
				
					component.set("v.data", result.listCasosBackOffice);
					component.set("v.listaDeCasos", result.listCasosBackOffice);

					this.columasCredito(component);

					/// Paginacion
					var totalRecords = result.numberOfCases;
					var recordsPerPage = result.caseLimit;

					console.log('---------------------------------------->');
					console.log('result.numberOfCases', result.numberOfCases);
					console.log('totalRecords:  ', totalRecords);
					console.log('recordsPerPage:  ', recordsPerPage);
					console.log('offSetCount:  ', offSetCount);

					if( (offSetCount) > 0 ) {
						
						component.set("v.disablePreviousButton", false);

					} else {

						component.set("v.disablePreviousButton", true);
					}


					if( totalRecords > (offSetCount + recordsPerPage) ) {
						
						component.set("v.disableNextButton", false);

					} else {

						component.set("v.disableNextButton", true);
					}

					///
					component.set("v.offSet", offSetCount);
					component.set("v.recordsPerPage", recordsPerPage);
				}

				component.set("v.cargandoDatos", false);
				
			} else {

				component.set("v.cargandoDatos", false);
			}
		});

		$A.enqueueAction(action);
	},

	generaCSV: function(component,records) {

		var stringResult;
		var contador;

		var keys = [];
		var recordKeys = [];
		
		/// Reporte de Credito
		keys = ['CANAL ORIGEN','SUCURSAL','ID','RANGO MAYOR AL ANALISTA','CURP','NOMBRE DEL CLIENTE','CUPO','ESTATUS','CODIGO DE RECHAZO','ANALISTA','NOTAS PENDIENTES POR CATALAGO',
					'NOTAS PENDIENTES LIBRES','CODIGO DE DUDA','BURO','TELEFONICA','HORA DE INGRESO','HORA DE ATENCION','HORA DE RESPUESTA','TIEMPO DE RESOLUCION','TIEMPO TOTAL DE RESOLUCION','TIPO DE TARJETA','TIPO DE CREDITO',
					'ACTUALIZACION TELEFONO CELULAR','ACTUALIZACION LIMITE DE CREDITO','CAMBIO DE ESTADO'];
		
		recordKeys = ['canalOrigen','sucursal','idSolicitud','aprobador','curp','nombreDelCliente','cupo','estatus','codigoDeRechazo','analista','notasPendientesPorCatalogo','notasPendientesLibres',
							'codigoDeDuda','buro','telefonica','horaDeIngreso','horaDeAceptacion','horaDeRespuesta','tiempoDeResolucion','tiempoTotalDeResolucion','tipoDeTarjeta','tipoDeCredito','actualizacionMovil',
							'actualizacionCupo','cambioDeEstado'];


		var columnDivider = ',';
		var lineDivider =  '\n';

		if (records == null || !records.length) {
            return null;
		}
		
		stringResult = '';
		stringResult += keys.join(columnDivider);
		stringResult += lineDivider;

		for(var i=0; i < records.length; i++){   
            contador = 0;
           
            for(var tempkey in recordKeys) {
                var skey = recordKeys[tempkey];
 
				if(contador > 0){ 
					stringResult += columnDivider; 
				}   
			   
				if( records[i][skey] != null && records[i][skey] != undefined ) {
					stringResult += '"'+ records[i][skey]+'"'; 
				} else {
					stringResult += '""';
				}				
               
				contador++;
			}
			// Final de la Fila
            stringResult += lineDivider;
        }

		return stringResult;
	},

	columasCredito : function(component) {

		component.set('v.columns', [

            {label: 'CANAL ORIGEN', fieldName: 'canalOrigen', initialWidth: 150, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'SUCURSAL', fieldName: 'sucursal', initialWidth: 120, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'ID', fieldName: 'idSolicitud', initialWidth: 80, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'RANGO MAYOR AL ANALISTA', fieldName: 'aprobador', initialWidth: 225, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'CURP', fieldName: 'curp', initialWidth: 180, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'NOMBRE DEL CLIENTE', fieldName: 'nombreDelCliente', initialWidth: 200, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'CUPO', fieldName: 'cupo', initialWidth: 120, type: 'currency', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
            {label: 'ESTATUS', fieldName: 'estatus', initialWidth: 96, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'CODIGO DE RECHAZO', fieldName: 'codigoDeRechazo', initialWidth: 200, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'ANALISTA', fieldName: 'analista', initialWidth: 200, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'NOTAS PENDIENTES POR CATALOGO', fieldName: 'notasPendientesPorCatalogo', initialWidth: 270, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'NOTAS PENDIENTES LIBRES', fieldName: 'notasPendientesLibres', initialWidth: 220, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'CODIGO DE DUDA', fieldName: 'codigoDeDuda', initialWidth: 160, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'BURO', fieldName: 'buro', initialWidth: 80, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'TELEFONICA', fieldName: 'telefonica', initialWidth: 120, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'HORA DE INGRESO', fieldName: 'horaDeIngreso', initialWidth: 180, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }} },
			{label: 'HORA DE ATENCION', fieldName: 'horaDeAceptacion', initialWidth: 180, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }} },
			{label: 'HORA DE RESPUESTA', fieldName: 'horaDeRespuesta', initialWidth: 180, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }} },			
			{label: 'TIEMPO DE RESOLUCION', fieldName: 'tiempoDeResolucion', initialWidth: 200, type: 'Integer', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'TIEMPO TOTAL DE RESOLUCION', fieldName: 'tiempoTotalDeResolucion', initialWidth: 240, type: 'Integer', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'TIPO DE TARJETA', fieldName: 'tipoDeTarjeta', initialWidth: 190, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'TIPO DE CREDITO', fieldName: 'tipoDeCredito', initialWidth: 155, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'ACTUALIZACION TELEFONO CELULAR', fieldName: 'actualizacionMovil', initialWidth: 275, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'ACTUALIZACION LIMITE DE CREDITO', fieldName: 'actualizacionCupo', initialWidth: 270, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}},
			{label: 'CAMBIO DE ESTADO', fieldName: 'cambioDeEstado', initialWidth: 170, type: 'text', cellAttributes: { class: { fieldName: 'backgroundCSSClass' }}}
		]);
	}
})