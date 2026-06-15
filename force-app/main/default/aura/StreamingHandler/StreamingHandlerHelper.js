({
	openTab : function(component, recordId) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            "recordId": recordId,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                  tabId: response
            }).then(function(tabInfo) {
	            console.log("The url for this tab is: " + tabInfo.url);
            });
        })
        .catch(function(error) {
               console.log(error);
        });
    },
    
    openOTP : function (component, phone, recordId) {

		var stepChangeEvent = component.getEvent("OTPState");
        
        stepChangeEvent.setParams({
            "state" : "open",
            "mode" : "case",
            "phone": phone,
            "recordId" : recordId
        });
        
        stepChangeEvent.fire();

	},
    openOTPPAN : function (component, phone, recordId) {

        var stepChangeEvent = component.getEvent("OTPState");
        
        stepChangeEvent.setParams({
            "state" : "open",
            "mode" : "casePAN",
            "recordId" : recordId
        });
        
        stepChangeEvent.fire();

    },
    
    openAuthenticate : function (component, curp) {
        var authByCurpAppEvent = $A.get("e.c:AuthByCurpState");
        
        authByCurpAppEvent.setParams({
            "curp" : curp
        });
        
        authByCurpAppEvent.fire();
        
    } 
})