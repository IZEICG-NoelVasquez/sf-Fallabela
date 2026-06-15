({
	initScriptC : function(component,tiempo,numero) {

		var divID = '';

		jQuery("document").ready(function(){

		divID = '#' + numero;

			var timer = new easytimer.Timer();
			timer.start({startValues: {seconds: tiempo}});
			timer.addEventListener('secondsUpdated', function (e) {
		    	$(divID + ' .days').html(timer.getTimeValues().days);
		    	$(divID + ' .hours').html(timer.getTimeValues().hours);
		    	$(divID + ' .minutes').html(timer.getTimeValues().minutes);
		    	$(divID + ' .seconds').html(timer.getTimeValues().seconds);
			});

			setTimeout(function(){ timer.stop(); }, 120000);
			
		});
	},

	initScriptA : function(component,tiempo,numero) {

		var date = new Date();
		var divID = '#' + numero + 'A';
		var diferencia = date.getTime() - Date.parse(tiempo);
		var segundos = Math.abs(parseInt(diferencia/1000));

		jQuery("document").ready(function(){

			var timer = new easytimer.Timer();
			timer.start({startValues: {seconds: segundos}});
			timer.addEventListener('secondsUpdated', function (e) {
		    	$(divID + ' .days').html(timer.getTimeValues().days);
		    	$(divID + ' .hours').html(timer.getTimeValues().hours);
		    	$(divID + ' .minutes').html(timer.getTimeValues().minutes);
		    	$(divID + ' .seconds').html(timer.getTimeValues().seconds);
			});
			
			setTimeout(function(){ timer.stop(); }, 10000);

		});
	},

	getCasos : function(component){

		var action = component.get("c.obtenerCasos");

		action.setCallback(this, function(response){

			var state = response.getState();

			if(state === "SUCCESS") {

				var result = response.getReturnValue();

				var rowsCasos = result.listaCasos;
				var date = new Date();

				var countNew = 0;
				var countAsignado = 0;
				var countAutorizado = 0;
				var countTotal = 0;
				var unicas = 0;
				var repetidas = 0;

				var fechaC = '';
				var dC =  '';
				var dayC = '';
				var monthC = '';
				var yearC = '';
				var hourC = '';
				var minC = '';
				var secC = '';
				var fechaCreacion = '';
				var fechaReenvio = '';

				var fechaA = '';
				var dA =  '';
				var dayA = '';
				var monthA = '';
				var yearA = '';
				var hourA = '';
				var minA = '';
				var secA = '';
				var fechaAnalisis = '';

				///
				var dataUpdateList = component.get("v.dataUpdateList");

				for(var i = 0; i<rowsCasos.length; i++){

					var row = rowsCasos[i];					

					countTotal++;
					component.set("v.totalCasos",countTotal);

					if(row.CreatedDate) {

						var fechaC = Date.parse(row.CreatedDate);
						var dC =  new Date(fechaC);
						var dayC = dC.getDate().toString().length == 1 ? '0'+dC.getDate().toString() : dC.getDate().toString();
						var monthC = (dC.getMonth()+1).toString().length == 1 ? '0'+(dC.getMonth()+1).toString() : (dC.getMonth()+1).toString();
						var yearC = dC.getFullYear();
						var hourC = dC.getHours().toString().length == 1 ? '0'+dC.getHours().toString() : dC.getHours().toString();
						var minC = dC.getMinutes().toString().length == 1 ? '0'+dC.getMinutes().toString() : dC.getMinutes().toString();
						var secC = dC.getSeconds().toString().length == 1 ? '0'+dC.getSeconds().toString() : dC.getSeconds().toString();
						var fechaCreacion = dayC+"/"+monthC+"/"+yearC+" "+hourC+":"+minC+":"+secC;
						row.fechaCreacion = fechaCreacion;
					}
					if(row.Fecha_y_hora_de_solicitud_en_Nuevo__c) { 

						var fechaN = Date.parse(row.Fecha_y_hora_de_solicitud_en_Nuevo__c);
						var dN =  new Date(fechaN);
						var dayN = dN.getDate().toString().length == 1 ? '0'+dN.getDate().toString() : dN.getDate().toString();
						var monthN = (dN.getMonth()+1).toString().length == 1 ? '0'+(dN.getMonth()+1).toString() : (dN.getMonth()+1).toString();
						var yearN = dN.getFullYear();
						var hourN = dN.getHours().toString().length == 1 ? '0'+dN.getHours().toString() : dN.getHours().toString();
						var minN = dN.getMinutes().toString().length == 1 ? '0'+dN.getMinutes().toString() : dN.getMinutes().toString();
						var secN = dN.getSeconds().toString().length == 1 ? '0'+dN.getSeconds().toString() : dN.getSeconds().toString();
						var fechaReenvio = dayN+"/"+monthN+"/"+yearN+" "+hourN+":"+minN+":"+secN;
						row.fechaReenvio = fechaReenvio;
						row.segundos = parseInt((date.getTime() - fechaN)/1000);
						this.initScriptC(component, row.segundos, row.CaseNumber);
					}
					if( row.Fecha_y_hora_de_solicitud_en_an_lisis__c && row.Status != 'New' ) {

						var fechaA = Date.parse(row.Fecha_y_hora_de_solicitud_en_an_lisis__c);
						var dA =  new Date(fechaA);
						var dayA = dA.getDate().toString().length == 1 ? '0'+dA.getDate().toString() : dA.getDate().toString();
						var monthA = (dA.getMonth()+1).toString().length == 1 ? '0'+(dA.getMonth()+1).toString() : (dA.getMonth()+1).toString();
						var yearA = dA.getFullYear();
						var hourA = dA.getHours().toString().length == 1 ? '0'+dA.getHours().toString() : dA.getHours().toString();
						var minA = dA.getMinutes().toString().length == 1 ? '0'+dA.getMinutes().toString() : dA.getMinutes().toString();
						var secA = dA.getSeconds().toString().length == 1 ? '0'+dA.getSeconds().toString() : dA.getSeconds().toString();
						var fechaAnalisis = dayA+"/"+monthA+"/"+yearA+" "+hourA+":"+minA+":"+secA;
						row.fechaAnalisis = fechaAnalisis;
						this.initScriptA(component, row.Fecha_y_hora_de_solicitud_en_an_lisis__c, row.CaseNumber);
					}
					if(row.Status == 'New'){

						countNew++;
						row.Status = 'Por asignar';

					}else if(row.Status == 'Asignada'){

						countAsignado++;
						

					}else if(row.Status == 'Autorización'){

						countAutorizado++;
						component.set("v.totalAutorizada",countAutorizado);

					}

					if(row.Solicitud_Repetida__c){

						repetidas++;

					}else{

						unicas++;

					}

					///
					row.dataUpdate = dataUpdateList.includes(row.C_digo_Postal_Direcci_n_Otros__c) ? true : false;
				}

				console.log(rowsCasos);
				component.set("v.totalNuevo",countNew);
				component.set("v.totalAsignada",countAsignado + countAutorizado);
				component.set("v.listaCasos",rowsCasos);
				component.set("v.repetidas",repetidas);
				component.set("v.unicas",unicas);

				/// Semaforos
				var lstSemaforoRiesgos = result.lstSemaforoRiesgos;
				var presencialAmarillo = 0;
				var presencialRojo = 0;
				var figitalAmarillo = 0;
				var figitalRojo = 0;

				for(var i = 0; i < lstSemaforoRiesgos.length; i ++ ) {

					if( lstSemaforoRiesgos[i].Canal_Origen__c == 'Presencial' ) {

						if( lstSemaforoRiesgos[i].Semaforo__c == 'Amarillo' ) {

							presencialAmarillo = lstSemaforoRiesgos[i].Segundos__c;

						} else if( lstSemaforoRiesgos[i].Semaforo__c == 'Rojo' ) {

							presencialRojo = lstSemaforoRiesgos[i].Segundos__c;
						}

					} else if( lstSemaforoRiesgos[i].Canal_Origen__c == 'Figital' ) {

						if( lstSemaforoRiesgos[i].Semaforo__c == 'Amarillo' ) {

							figitalAmarillo = lstSemaforoRiesgos[i].Segundos__c;

						} else if( lstSemaforoRiesgos[i].Semaforo__c == 'Rojo' ) {

							figitalRojo = lstSemaforoRiesgos[i].Segundos__c;
						}
					}
				}

				component.set("v.presencialAmarillo", presencialAmarillo);
				component.set("v.presencialRojo", presencialRojo);
				component.set("v.figitalAmarillo", figitalAmarillo);
				component.set("v.figitalRojo", figitalRojo);
			}

		});
		
		$A.enqueueAction(action);
	},


	getCasosToday : function(component){

		var action = component.get("c.obtenerCasosToday");

		action.setCallback(this, function(response){

			var state = response.getState();

			if(state === "SUCCESS"){

				var number = response.getReturnValue();

				component.set("v.totalToday",number);

			}

		});

		$A.enqueueAction(action);
	},

	getCasosCerrados : function(component){

		var action = component.get("c.obtenerCasosCerrados");
		var countCerrados = 0;

		action.setCallback(this, function(response){

			var state = response.getState();
			var pattern = '';
			var milis = 0;
			console.log(state);
			if(state === "SUCCESS"){

				var rowsCasosC = response.getReturnValue();
				var date = new Date();
				if(rowsCasosC == null || rowsCasosC == ''){

					pattern = "00" + ":" + "00" + ":" + "00";
				    component.set("v.tiempoPromedio",pattern);

				}else{
					for(var i = 0; i<rowsCasosC.length; i++){
						countCerrados++;
						var rows = rowsCasosC[i];
						milis += parseInt(Date.parse(rows.ClosedDate)) - parseInt(Date.parse(rows.CreatedDate));
						var promedio = milis/countCerrados;
						var segundos = promedio/1000;
						var hh = Math.floor(segundos / 3600);  
					 	segundos %= 3600;

					    var m = Math.floor(segundos / 60);

					    var s =  Math.floor(segundos % 60);
					 
					    var h = hh; 
					 
					 	h = h < 10 ? "0" + h : h;
					    m = m < 10 ? "0" + m : m; 
					    s = s < 10 ? "0" + s : s; 

					    pattern = h + ":" + m + ":" + s;
					    component.set("v.tiempoPromedio",pattern);

					} 
				}
			}

		});

		$A.enqueueAction(action);
	},

	intervalCasos : function(component){

		this.getCasos(component);
		this.getCasosToday(component);
		this.getCasosCerrados(component);
	}
})