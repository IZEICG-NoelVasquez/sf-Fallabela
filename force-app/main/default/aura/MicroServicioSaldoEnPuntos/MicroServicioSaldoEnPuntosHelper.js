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
	
	obtenerSaldoEnPuntos : function(component, numeroDocumento) {
		
		var action = component.get("c.obtenerSaldoEnPuntos");
		action.setParams({
			"numeroDocumento": numeroDocumento
		});

		action.setCallback(this, function(response) {
			
			var state = response.getState();

			console.log("obtenerSaldoEnPuntos - state:  ", state);

			if( state == "SUCCESS" ) {

				var result = response.getReturnValue();
				console.log("obtenerSaldoEnPuntos - result:  ", result);

				if( result.success ) {

					console.log("result.saldoPuntos:  ", result.saldoPuntos);
					console.log("result.saldoPuntos.message:  ", result.saldoPuntos.message);

					component.set("v.totalPuntosDisponibles", result.saldoPuntos.message.puntosCMR.totalPuntosDisponibles.totalPuntosDisponibles );

					if( result.saldoPuntos.message && result.saldoPuntos.message.puntosCMR && result.saldoPuntos.message.puntosCMR.puntosAcumuladosPeriodo && 
						result.saldoPuntos.message.puntosCMR.puntosAcumuladosPeriodo.resumenPeriodo && result.saldoPuntos.message.puntosCMR.puntosAcumuladosPeriodo.resumenPeriodo.saldoInicialPeriodo ) {

						component.set("v.resumenPeriodo", result.saldoPuntos.message.puntosCMR.puntosAcumuladosPeriodo.resumenPeriodo.saldoInicialPeriodo );
					} else {

						this.showToast("Ha ocurrido un error MS Saldo en Puntos", "Favor de reportar a su administrador", "warning");
					}				

					component.set("v.cargandoSaldoPuntos", false);
				} else {

					component.set("v.cargandoSaldoPuntos", false);
					this.showToast("Ha ocurrido un error MS Saldo en Puntos", "Favor de reportar a su administrador", "warning");
				}
			} else {

				component.set("v.cargandoSaldoPuntos", false);
				this.showToast("Ha ocurrido un error MS Saldo en Puntos", "Favor de reportar a su administrador", "warning");
			}
		});

		$A.enqueueAction(action);
	}
})