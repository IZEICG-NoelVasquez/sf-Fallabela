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

	validarCampoVacio : function(campo) {

        if( campo == undefined || campo == null || campo == '' ) {

            return true;
        } else {
            
            return false;
        }
    },
	
	obtenerImagenes : function(component) {

		var recordId = component.get("v.recordId");

		var action = component.get("c.obtenerListaImagenesWS");
		action.setParams({
			"recordId" : recordId
		});

		action.setCallback(this, function(response) {

            var state = response.getState();
            
            if (state === "SUCCESS") {

				var result =  response.getReturnValue();
				if(result.success) {

					/// Campos de la Solicitud
					var caso = result.caso;

					/// Motivos de Pendiente Seleccionados 
					var listMotivosCFSelec = [];

					/// Comentarios del Caso ligados a los Motivos de Pendiente
					if( caso && caso.CaseComments && caso.CaseComments.length > 0 ) {

						for(var i = 0; i < caso.CaseComments.length; i ++) {

							if( !this.validarCampoVacio(caso.CaseComments[i].CommentBody) && !listMotivosCFSelec.includes( caso.CaseComments[i].CommentBody ) ) {

								listMotivosCFSelec.push( caso.CaseComments[i].CommentBody );
							}
						}
					}

					/// PDF Reporte de Credito
					var tipoReporte = 'B';
					var urlReporteBuro = '/apex/PDFReporteDeCredito' + '?idSolicitud=' + caso.ID_Solicitud__c + '&tipoReporte=' + tipoReporte;
					component.set("v.urlReporteBuro", urlReporteBuro);

					/// Metadata para crear los Links de los Documentos
					var listMapDocumentos = result.listMapDocumentos;

					/// Lista para mostrar los documentos en el Componente
					var listDocumentos = [];

					for(var i = 0; i < listMapDocumentos.length; i++) {

						var mapDocumentos = {};
						mapDocumentos = listMapDocumentos[i];
						var mapDocumentosLink = mapDocumentos['espacioAlInicio'] ? ' ' + mapDocumentos['link'] : mapDocumentos['link'];
						
						if( mapDocumentos['mostrarSiempre'] && !mapDocumentos['solicitudRepetida'] ) {
							/// Mostrar Siempre - NO Solicitud Repetida

							var documento = {
								nombre : mapDocumentos['nombre'],
								link : mapDocumentosLink,
								microServicio : mapDocumentos['microServicio']
							}
							listDocumentos.push(documento);

						} else if( mapDocumentos['mostrarSiempre'] && mapDocumentos['solicitudRepetida'] && caso.Solicitud_Repetida__c ) {
							/// Mostrar Siempre - Solicitud Repetida

							var documento = {
								nombre : mapDocumentos['nombre'],
								link : mapDocumentosLink,
								microServicio : mapDocumentos['microServicio']
							}
							listDocumentos.push(documento);

						} else if( !mapDocumentos['mostrarSiempre'] ) {
							/// NO Mostrar Siempre - Solicitud con Motivos de Pendiente

							var cMetadataMotivosPendiente = mapDocumentos['motivosDePendiente'];
							var listCMetadataMotivosDePendiente = cMetadataMotivosPendiente ? cMetadataMotivosPendiente.split(";") : [];

							if( cMetadataMotivosPendiente && this.comparaListas(listCMetadataMotivosDePendiente, listMotivosCFSelec) ) {

								if( mapDocumentos['solicitudRepetida'] && caso.Solicitud_Repetida__c ) {
									/// Solicitud Repetida

									var documento = {
										nombre : mapDocumentos['nombre'],
										link : mapDocumentosLink,
										microServicio : mapDocumentos['microServicio']
									}
									listDocumentos.push(documento);

								} else if( !mapDocumentos['solicitudRepetida'] ) {
									/// NO Solicitud Repetida

									var documento = {
										nombre : mapDocumentos['nombre'],
										link : mapDocumentosLink,
										microServicio : mapDocumentos['microServicio']
									}
									listDocumentos.push(documento);

								}
							}
						}
					}

					component.set("v.linksImagenes", listDocumentos);
					component.set("v.cargandoLinks", false);
				}               
            }        
        });
        $A.enqueueAction(action);
	},

	comparaListas : function(listaDeMotivos, motivosCF) {

		var blnResult = false;

		for(var i = 0; i < listaDeMotivos.length; i++) {

			if( motivosCF.includes(listaDeMotivos[i]) ) {

				blnResult = true;
				break;
			}
		}

		return blnResult;
	}

})