({
    handleCustomerDataPhoneE : function(component, event, helper){
        var phoneCustomerData = event.getParam("phoneCustomerData");
        component.set("v.phoneCustomerData", phoneCustomerData);
        var phone4digitos = phoneCustomerData.slice(phoneCustomerData.length-4,phoneCustomerData.length);
        component.set("v.phone4digitos", phone4digitos);
        if(phoneCustomerData != null){
            component.set("v.phoneCustomerNotNull", true);
        }

    },
    doInit : function(component, event, helper) {
        var customer = component.get("v.customer");
        var phoneCustomer = component.get("v.customer.PersonMobilePhone");
        if(phoneCustomer != undefined){
            var phoneCustomer4digitos = phoneCustomer.slice(phoneCustomer.length-4,phoneCustomer.length);
            component.set("v.PersonMobilePhone", phoneCustomer4digitos);
        }
        var phone = component.get("v.phone");
        if(phone != undefined){
            var phone2 = phone.slice(phone.length-4,phone.length);
            component.set("v.phone", phone2);
        }
	}
})