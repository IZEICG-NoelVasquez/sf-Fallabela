({
	doInit : function(component, event, helper) {

		component.set("v.listDocumentsLoaded", false);
		component.set("v.listDocumentsSuccess", false);

		helper.getDocumentsList(component);

		helper.newSearch(component);
	},

	validateCharacter : function(component, event, helper) {

		var character = event.which;
		console.log("character:  ", character);

		var lstValidCharacters = component.get("v.lstValidCharacters");

		/// Lista Caracteres Permitidos [A-Z] y [0-9]
		if( !lstValidCharacters.includes(character) ) {

			event.preventDefault();
		}
	},

	searchDocumentsAvailable : function(component, event, helper) {
		
		var idRequestCURP = component.get("v.idRequestCURP");

		if( helper.validateEmptyField(idRequestCURP) ) {

			helper.showToast("", "Debe ingresar un Id Solicitud / CURP válido" ,"warning");
			return;

		} else if( (idRequestCURP.length === 18) && (helper.validateCurp(idRequestCURP)) ) {

			console.log('CURP Correcto');

			component.set("v.isCurp", true);
			component.set("v.curp", idRequestCURP);
			component.set("v.documentsAvailableLoaded", false);

			helper.getIdRequest(component, idRequestCURP, false);
			
		} else if( (idRequestCURP.length < 16) && (helper.validateIdRequest(idRequestCURP)) ) {

			console.log('IdRequest Correcto');

			component.set("v.idRequest", idRequestCURP);
			component.set("v.documentsAvailableLoaded", false);

			helper.getDocumentsAvailable(component, idRequestCURP);

		} else {

			helper.showToast("", "Debe ingresar un Id Solicitud / CURP válido" ,"warning");
			return;
		}
	},

	searchAdditionalDocumentsAvailable : function(component, event, helper) {

		var isCurp = component.get("v.isCurp");
		var showCurpField = component.get("v.showCurpField");
		var curp = component.get("v.curp");

		if( !isCurp ) {

			if( !showCurpField ) {

				component.set("v.blnAdditionalDocuments", false);
				component.set("v.showCurpField", true);
				component.set("v.requiredCurpField", true);
				return;

			} else if( helper.validateEmptyField(curp) ) {

				component.set("v.blnAdditionalDocuments", false);
				helper.showToast("", "Por favor ingresar un CURP válido" ,"warning");
				return;

			} else if( (curp.length === 18) && (helper.validateCurp(curp)) ) {

				console.log('CURP 2 Correcto');

				helper.getIdRequest(component, curp, true);

			} else {

				component.set("v.blnAdditionalDocuments", false);
				helper.showToast("", "Por favor ingresar un CURP válido" ,"warning");
				return;
			}

		} else {

			helper.getContractNumber(component, curp);
		}		
	},

	openDocumentApiGee : function(component, event, helper) {

		var idRequest = component.get("v.idRequest");

		var link = event.currentTarget.id;
		var imageName = event.currentTarget.name;

		helper.openDocumentApiGee(idRequest, link, imageName);
	},

	openDocumentApiGeeAdditional : function(component, event, helper) {

		var contractNumber = component.get("v.contractNumber");

		var link = event.currentTarget.id;
		var imageName = event.currentTarget.name;

		if( link === '12' ) {

			contractNumber = '01' + contractNumber.substr(-8);
		}

		helper.openDocumentApiGee(contractNumber, link, imageName);
	},

	openImageBS : function(component, event, helper) {

		var idRequest = component.get("v.idRequest");

		var link = event.currentTarget.id;
		var imageName = event.currentTarget.name;

		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "c:MicroServicioModalImagenesBO",
			componentAttributes: {
				idSolicitud : idRequest,
				link : link,
				microServicio : 'BlobStorage',
				nombreImagen : imageName,
				blnReporteBuro : false,
				blnExpedientesFalabella : true
			}
		});
		evt.fire();
	},

	openCreditReport : function(component, event, helper) {

		var urlCreditReport = component.get("v.urlCreditReport");

		var evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "c:MicroServicioModalImagenesBO",
			componentAttributes: {
				urlImagen : urlCreditReport,
				nombreImagen : 'ReporteDeCredito.pdf',
				blnReporteBuro : true
			}
		});
		evt.fire();
	},

	newSearch : function(component, event, helper) {

		$A.get('e.force:refreshView').fire();
	}

})