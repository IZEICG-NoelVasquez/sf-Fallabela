({
	doInit : function(component, event, helper) {

        component.set("v.callingMSIncode", true);

		var myPageRef = component.get("v.pageReference");
		var recordId = myPageRef.state.c__caseId;
        var externalId = myPageRef.state.c__idSolicitudGestor;

        if( !component.get("v.scoreAlreadyCreated") ) {

            helper.incodeStart(component, event, externalId, recordId);
        }
    },
	
	closeModalFigital : function(component, event, helper) {

		var workspaceAPI = component.find("workspace");

        workspaceAPI.getAllTabInfo().then(function(response) {

			for(var i = 0; i < response.length; i++) {

				var tabId = response[i].tabId; 
				workspaceAPI.refreshTab({
                    tabId: tabId,
                    includeAllSubtabs: true});
			}
		})
		.catch(function(error) {
			console.log(error);
		});

		workspaceAPI.getFocusedTabInfo().then(function(response) {
			
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
	}
})