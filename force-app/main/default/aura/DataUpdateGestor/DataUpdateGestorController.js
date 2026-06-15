({
	doInit : function (component, event, helper) {

        component.set("v.updatingInformation", true);
		component.set("v.allowedDataUpdate", false);
		component.set("v.allowedUpdateMobile", false);
		component.set("v.allowedStatus", false);

		component.set("v.recordInApproval", false);
		component.set("v.approvalRejected", false);

        helper.getCaseInfo(component);
    },
	
	closeModalDataUpdate : function(component, event, helper) {
		
		component.set("v.openModalDataUpdate", false);
	},

	clearField : function(component, event, helper) {

		var character = event.which;
		console.log("caracter:  ", character);

		var allowedCharacters = component.get("v.allowedCharacters");

		if( !allowedCharacters.includes(character) ) {

			event.preventDefault();
		}
	},

	dataUpdate : function(component, event, helper) {

		var caseRecord = component.get("v.caseRecord");
		var mobilePhone = component.get("v.mobilePhone");
		var creditLimit = component.get("v.creditLimit");

		var changedMobilePhone = false;
		var changedCreditLimit = false;

		if( caseRecord.N_mero_de_Tel_fono_M_vil__c != mobilePhone ) {

			changedMobilePhone = true;			
		}

		if( caseRecord.Cupo__c != creditLimit ) {

			changedCreditLimit = true;			
		}

		///
		component.set("v.changedMobilePhone", changedMobilePhone);
		component.set("v.changedCreditLimit", changedCreditLimit);


		if( changedMobilePhone || changedCreditLimit ) {

			if( changedMobilePhone && (!helper.validateNumber(mobilePhone) || mobilePhone.length !== 13) ) {

				helper.showToast("", "Favor de ingresar un Teléfono celular Válido" ,"warning");
				return;
			}

			if( changedCreditLimit && (!helper.validateNumber(creditLimit) || helper.validateEmptyField(creditLimit)) ) {

				helper.showToast("", "Favor de ingresar un Límite de crédito Válido" ,"warning");
				return;
			}

			component.set("v.stepNumberDataUpdate", 2);
			
		} else {

			helper.showToast("", "No se actualizo ningún valor" ,"warning");
		}
	},

	confirmDataUpdate : function(component, event, helper) {

		component.set("v.updatingInformation", true);
		component.set("v.stepNumberDataUpdate", 3);

		helper.dataUpdate(component);
	},

	backDataUpdate : function(component, event, helper) {

		component.set("v.stepNumberDataUpdate", 1);
	},

	submitApprovalUpdateMobile : function(component, event, helper) {

		component.set("v.updatingInformation", true);
		helper.submitForApprovalJS(component);
	}
})