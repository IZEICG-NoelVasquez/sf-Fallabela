({
	openModalMultiPickList : function(component, event, helper) {

		var listTipoConsulta = component.get("v.listTipoConsulta");

		var items = [];
		for(var i = 0; i < listTipoConsulta.length; i ++) {

			var item = {
				"label": listTipoConsulta[i],
				"value": listTipoConsulta[i]
			};
			items.push(item);
		}

		component.set("v.options", items);

		var valuesSelected = component.get("v.valuesSelected");
		if( valuesSelected && valuesSelected.length > 0 ) {

			var values = valuesSelected.split(';');

			component.set("v.values", values);
		}
		
		component.set("v.openModalTipoDeConsulta", true);
	},

	closeModalMultiPickList : function(component, event, helper) {

		var valuesSelected = component.get("v.valuesSelected");

		component.set("v.values", []);

		if( valuesSelected && valuesSelected.length > 0 ) {

			var values = valuesSelected.split(';');

			component.set("v.values", values);
		}

		component.set("v.openModalTipoDeConsulta", false);
	}, 

	saveModalMultiPickList : function(component, event, helper) {

		var values = component.get("v.values");

		var valuesSelected = '';
		for(var i = 0; i < values.length; i ++) {

			if( i > 0 ) {
				valuesSelected += ';';
			}
			valuesSelected += values[i];
		}

		component.set("v.valuesSelected", valuesSelected);

		component.set("v.openModalTipoDeConsulta", false);
	}
})