({
	getUserInfo : function(component) {

        var action = component.get("c.getUserInfo");

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getUserInfo: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                
                if (result.success) { 

                    this.getContactMethod(component, result.userProfile);

                } else {

                    component.set("v.profileInfoContactMInfoLoaded", true);
                }

            } else {

                component.set("v.profileInfoContactMInfoLoaded", true);
            }
        });

        $A.enqueueAction(action);
    },

    getContactMethod : function(component, userProfile) {

        var action = component.get("c.getContactMethod");

        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log("state getContactMethod: ", state);

            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                var contactMethodOptions = [];

                var agentsProfiles = component.get("v.agentsProfiles");
                var supervisorsProfiles = component.get("v.supervisorsProfiles");
                var supervisorsIncludedValues = component.get("v.supervisorsIncludedValues");                              

                /// Perfiles de Agentes
                if( agentsProfiles.includes(userProfile) ) {

                    contactMethodOptions = this.addValueToList(component, result, contactMethodOptions, true);

                /// Perfiles de Supervisores
                } else if ( supervisorsProfiles.includes(userProfile) ) {

                    contactMethodOptions = this.addValueToList(component, result, contactMethodOptions, false);

                    /// Valores adicionales para los perfiles de supervisores
                    for(var i = 0; i < supervisorsIncludedValues.length; i++) {
                        
                        contactMethodOptions.push({label:supervisorsIncludedValues[i], value:supervisorsIncludedValues[i]});
                    }                    

                /// Otros Perfiles
                } else {

                    contactMethodOptions = this.addValueToList(component, result, contactMethodOptions, false);
                }                

                component.set("v.profileInfoContactMInfoLoaded", true);
                component.set("v.contactMethodOptions", contactMethodOptions);
                
            } else {

                component.set("v.profileInfoContactMInfoLoaded", true);
            }
        });

        $A.enqueueAction(action);
    },

    addValueToList : function(component, result, contactMethodOptions, agentProfile) {

        var agentsExcludedValues = component.get("v.agentsExcludedValues");

        for(var key in result) {

            /// Valores excluidos para los perfiles de Agentes
            if( (!agentProfile) || (agentProfile && !agentsExcludedValues.includes(key)) ) {
                
                contactMethodOptions.push({label:key, value:result[key]});
            }
        }

        return contactMethodOptions;
    }

})