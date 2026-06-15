({
	loadReasonReplacementList : function(component) {

		var reasonReplacementOptions = [];
		
		var reasonReplacementList = component.get("v.reasonReplacementList");		

		for(var i = 0; i < reasonReplacementList.length; i ++ ) {

			reasonReplacementOptions.push({label:reasonReplacementList[i], value:reasonReplacementList[i]});
		}

		component.set("v.reasonReplacementValue", reasonReplacementList[0]);
		component.set("v.reasonReplacementOptions", reasonReplacementOptions);
	},

	fireCloseModalEvent : function(component) {
		
		var evt = component.getEvent("ReasonReplacementSelected");

        evt.setParams({
            "blnReasonReplacementSelected" : true
        });

        evt.fire();
	}
})