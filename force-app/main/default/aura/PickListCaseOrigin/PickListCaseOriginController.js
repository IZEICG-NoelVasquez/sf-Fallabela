({
	doInit : function (component, event, helper) {

        component.set("v.profileInfoContactMInfoLoaded", false);

        component.set("v.contactMethodValue", '');
        
        helper.getUserInfo(component);
    }
})