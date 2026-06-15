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

	validateField : function(field) {

		if( field == undefined || field == null || field == '' ) {

			return true;
		}
	},
	
	getUsersJS : function(component) {
		
		var lstProfiles = component.get("v.lstProfiles");

		var action = component.get("c.getUsers");

		action.setParams({
			"lstProfiles" : lstProfiles
        });

		action.setCallback(this, function(response) {

			console.log('getUsersJS - response ', response.getState());

			if (response.getState() === "SUCCESS") {
				
				var result = response.getReturnValue();

				if( result.success ) {

					///
					var userOptions = [];
					userOptions.push({label:'Todos', value:'All'});

					///
					var mapUsers = {};

					for(var i = 0; i < result.lstUsers.length; i++ ) {

						userOptions.push({label:result.lstUsers[i].Name, value:result.lstUsers[i].Id});

						mapUsers[result.lstUsers[i].Id] = result.lstUsers[i].Name;
					}

					component.set("v.userValue", 'All');
					component.set("v.userOptions", userOptions);
					component.set("v.mapUsers", mapUsers);

					/// Cargar Data
					this.getOmniReportJS(component, mapUsers);

				} else {

					component.set("v.loadedData", true);
				}			
				
			} else {

				component.set("v.loadedData", true);
			}
			
		});

		$A.enqueueAction(action);
	},

	getOmniReportJS : function(component, mapUsers) {

		///
		var startDate = component.get("v.startDate");
		var endDate = component.get("v.endDate");

		var action = component.get("c.getOmniReport");

		action.setParams({
			"mapUsers" : mapUsers,
			"startDate" : startDate,
			"endDate" : endDate
        });

		action.setCallback(this, function(response) {

			console.log('getOmniReportJS - response ', response.getState());

			if (response.getState() === "SUCCESS") {
				
				var result = response.getReturnValue();

				console.log('getOmniReportJS - result ', result);

				component.set("v.data", result);
				
				this.setColumns(component);
			} 

			component.set("v.loadedData", true);
		});

		$A.enqueueAction(action);
	},

	generateCSV : function(component, records) {

		var stringResult;
		var contador;

		var keys = [];
		var recordKeys = [];

		keys = ['NOMBRE','INICIOS DE SESION','TIEMPO CONECTADO','APROBADOS','RECHAZADOS','PENDIENTES','PROMEDIO DE EVALUACION'];

		recordKeys = ['userName','numberOfLogins','connectedTime','approvedCases','rejectedCases','pendingCases','averageEvaluationTime'];

		var columnDivider = ',';
		var lineDivider =  '\n';

		if (records == null || !records.length) {

			this.showToast( "","No se encontraron registros" ,"warning");
            return null;
		}
		
		stringResult = '';
		stringResult += keys.join(columnDivider);
		stringResult += lineDivider;

		for(var i=0; i < records.length; i++) {
			
            contador = 0;
           
            for(var tempkey in recordKeys) {

                var skey = recordKeys[tempkey];
 
				if(contador > 0) {
					
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

	setColumns : function(component) {

		component.set('v.columns', [

			{label: 'NOMBRE', fieldName: 'userName', type: 'text'},
            {label: 'INICIOS DE SESION', fieldName: 'numberOfLogins', type: 'text'},
            {label: 'TIEMPO CONECTADO', fieldName: 'connectedTime', type: 'text'},
            {label: 'APROBADOS', fieldName: 'approvedCases', initialWidth: 150, type: 'text'},
            {label: 'RECHAZADOS', fieldName: 'rejectedCases', initialWidth: 150, type: 'text'},
            {label: 'PENDIENTES', fieldName: 'pendingCases', initialWidth: 150, type: 'text'},
            {label: 'PROMEDIO DE EVALUACION', fieldName: 'averageEvaluationTime', type: 'text'}
		]);
	}
})