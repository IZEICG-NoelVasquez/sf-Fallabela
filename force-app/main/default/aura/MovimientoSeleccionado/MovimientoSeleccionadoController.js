({
	doInit : function (component, event, helper) {
		var productos = component.get("v.productos");
        var productIdx = component.get("v.productIdx");
		var tarjetaSeleccionada = productos[productIdx].tarjetaCredito.identificadorProducto;
		component.set("v.tarjetaSeleccionada", tarjetaSeleccionada);

		var movimientosListObject = component.get("v.movimientosListObject");

		console.log("Movimientos Seleccionados. movimientosListObject:  ", movimientosListObject);

		var montoTotal = 0;

		if( movimientosListObject.length > 0 ) {

			component.set("v.cantidadMovimientos", movimientosListObject.length);

			for(var i = 0; i < movimientosListObject.length; i ++ ) {
				///montoTotal += movimientosList[i].montoMovimientoTC.montoLocal;
				/// Ajuste Tipificaciones desde Movimientos
				montoTotal += movimientosListObject[i].montoLocal;
			}

			component.set("v.montoTotal", montoTotal);
		}
	}

})