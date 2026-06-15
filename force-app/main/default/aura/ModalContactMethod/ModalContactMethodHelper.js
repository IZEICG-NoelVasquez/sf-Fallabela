({
	fireCloseModalEvent : function(component) {
		
		var evt = component.getEvent("ContactMethodSelected");

        console.log("Event ContactMethodSelected");
        evt.setParams({
            "blnContactMethodSelected" : true
        });

        evt.fire();
	}
})