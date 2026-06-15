({
	getUserApp : function(component){
		var selectedAccount = component.get("v.selectedAccount");
		var numeroDocumento = selectedAccount.CURP__c;
		var tipoDocumento = 'INE';
		if(numeroDocumento != null && numeroDocumento != ''){
		var action = component.get("c.consulta_Get_User");        
        action.setParams({
            "tipoDocumento" : tipoDocumento,
            "numeroDocumento" : numeroDocumento
		});
		action.setCallback(this, function(response) {       
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.success) {
					if(result.resultGetUser.message.documentoIdentidad.numeroDocumento != null){
						console.log("result.esUsuarioAppWeb!!:  ");
						component.set("v.esUsuarioAppWeb", true );
						component.set("v.loadedGetUser", false );

					} 

                } else {
					component.set("v.esUsuarioAppWeb", false );
					component.set("v.loadedGetUser", false );


                }

            } else {
				component.set("v.esUsuarioAppWeb", false );
				component.set("v.loadedGetUser", false );
            }
        });

		$A.enqueueAction(action);
		}
	}
})