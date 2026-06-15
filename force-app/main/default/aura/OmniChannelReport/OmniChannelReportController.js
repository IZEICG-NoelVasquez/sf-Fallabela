({
	init : function(component, event, helper) {
		
		component.set("v.loadedData", false);

		var startDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		var endDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");

		component.set("v.startDate", startDate);
		component.set("v.endDate", endDate);

		helper.getUsersJS(component);
	},

	updateReport : function(component, event, helper) {

		///
		var startDate = component.get("v.startDate");
		var endDate = component.get("v.endDate");

		if( helper.validateField(startDate) || helper.validateField(endDate) ) {

			helper.showToast( "","Debe ingresar la Fecha de Inicio y la Fecha Fin" ,"warning");

		} else {

			component.set("v.loadedData", false);

			var userValue = component.get("v.userValue");
			var mapUsers = component.get("v.mapUsers");

			console.log('userValue:  ', userValue);

			if( userValue == 'All' ) {

				///
				console.log('mapUsers:  ', JSON.stringify(mapUsers) );

				helper.getOmniReportJS(component, mapUsers);

			} else {

				var mapselectedUser = {};
				mapselectedUser[ userValue ] = mapUsers[userValue];

				///
				console.log('mapselectedUser:  ', mapselectedUser);

				helper.getOmniReportJS(component, mapselectedUser);
			}
		}
	},

	downloadCSV : function(component, event, helper) {

		var records = component.get("v.data");

		var csv = helper.generateCSV(component,records);
		
		if (csv == null) {

			return;
		} 

		var hiddenElement = document.createElement('a');
		hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
		hiddenElement.target = '_self';
		hiddenElement.download = 'ReporteOmniChannel.csv';
		document.body.appendChild(hiddenElement);
		hiddenElement.click();
	}
})