({
	doInit : function(component, event, helper) {
		
		var selectedAccount = component.get("v.selectedAccount");

		var numeroDocumento = selectedAccount.CURP__c;

		component.set("v.cargandoSaldoPuntos", true);
		helper.obtenerSaldoEnPuntos(component, numeroDocumento);
	}
})