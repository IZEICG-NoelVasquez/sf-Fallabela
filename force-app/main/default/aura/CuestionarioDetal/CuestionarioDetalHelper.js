({
    getRecordTypes : function(component) {
         var action = component.get("c.fetchRecordTypeValues");
      action.setCallback(this, function(response) {
          var custs = [];
                var conts = response.getReturnValue();
                for(var key in conts){
                    console.log('key ',key);
                    console.log('conts[key] ',conts[key]);
                    if(conts[key] == 'Arqueo de Tarjetas'){
                    	custs.push({value:conts[key], key:key});
                    }
                }
                component.set("v.recordTypes", custs);
      });
      $A.enqueueAction(action);
    },
    doInit : function(component) {
          console.log('lRecordTypeId i ', component.get("v.simpleNewCuestionario.RecordTypeId"));
                console.log('lRecordType i ', component.get("v.simpleNewCuestionario.RecordType"));
        var action = component.get("c.getSucursales");
        action.setParams({
            "sucursalId": "sucursalId"
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var sucursales = response.getReturnValue();
                console.log('sucursales helper',sucursales);
                component.set("v.sucursales",sucursales);
            }
        });
        $A.enqueueAction(action);  
        component.find("cuestionarioRecordCreator").getNewRecord(
            "Cuestionario__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newCuestionario");
                var error = component.get("v.newCuestinarioError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );
        var output = document.getElementById("out");
        
        if (!navigator.geolocation){
            //   output.innerHTML = "<p>Geolocation is not supported by your browser</p>";
            return;
        }
        
        function success(position) {
            var latitude  = position.coords.latitude;
            var longitude = position.coords.longitude;
            var accuracy = position.coords.accuracy;
            component.set("v.latitude", (Math.round(latitude * 10000000000) / 10000000000));
            component.set("v.longitude",  (Math.round(longitude * 10000000000) / 10000000000));
            console.log('accuracy2  ', accuracy);
            console.log('latitude init ', component.get("v.latitude"));
            console.log('longitude init ', component.get("v.longitude"));
            
        };
        
        function error() {
            //  output.innerHTML = "Unable to retrieve your location";
        };
        
        navigator.geolocation.getCurrentPosition(success, error,{maximumAge:60000, timeout:5000, enableHighAccuracy:true});
        
    },
    handleSave : function(component){
        var sucursal = component.get("v.simpleNewCuestionario.Sucursal__c");
        console.log('sucursal helper ',sucursal);
        var action = component.get("c.getLatitudeLongitude");
        action.setParams({
            "sucursal": sucursal
        });
        action.setCallback(this, function(response) {
            console.log('response ',response);
            console.log('response getState ',response.getState());
            
            if (response.getState() === "SUCCESS") {
                var latitudeLongitud = response.getReturnValue();
                console.log('latitudeLongitud ',latitudeLongitud);
                var latitudelongitudList = latitudeLongitud[sucursal];
                var latitudesuc = latitudelongitudList[0];
                var latitudeMin = latitudesuc - 0.001;
                var latitudemax = latitudesuc + 0.001;
                var longitudesuc = latitudelongitudList[1];
                var longitudeMin = longitudesuc - 0.001;
                var longitudeMax = longitudesuc + 0.001;
                
                console.log('latitudelongitud  ',latitudelongitudList);
                console.log('latitudesuc',latitudesuc);
                console.log('longitudesuc',longitudesuc);
                console.log('latitude aqui ',component.get("v.latitude"));
                console.log('longitude aqui ',component.get("v.longitude"));
                if(component.get("v.latitude") > latitudeMin &&
                   component.get("v.latitude") < latitudemax &&
                   component.get("v.longitude") > longitudeMin &&
                   component.get("v.longitude") < longitudeMax){
                    this.createCuestionario(component);
                }
                else{
                    this.showToast("Error", "No te encuentras dentro de la sucursal seleccionada", "error");
                }
            } 
        });
        $A.enqueueAction(action);  
        
    },
    createCuestionario : function(component){
                console.log('lRecordTypeId ', component.get("v.simpleNewCuestionario.RecordTypeId"));
                console.log('lRecordType ', component.get("v.simpleNewCuestionario.RecordType"));

        console.log('creator',component.get("v.cuestionarioRecordCreator")); 
        component.set("v.simpleNewCuestionario.Latitude__c", component.get("v.latitude"));
        component.set("v.simpleNewCuestionario.Longitude__c", component.get("v.longitude"));
        component.set("v.simpleNewCuestionario.Status__c", "Pendiente");
        console.log('latitude init ', component.get("v.simpleNewCuestionario.Latitude__c"));
        console.log('longitude init ', component.get("v.simpleNewCuestionario.Longitude__c"));
        var recordtypes = component.get("v.recordTypes");
        console.log('recordtypes2 ',recordtypes);
        var rtIdSelect = component.get("v.simpleNewCuestionario.RecordTypeId");
        console.log('rtIdSelect ', rtIdSelect);
        var rtSelect;
        if(recordtypes != undefined && recordtypes != null){
        var len = 0;
    	for (var count in recordtypes) {
            len++;
    	}
        console.log('size ',len);
            for(var i=0;i<len;i++){
                console.log('key ',recordtypes[i].key);
                console.log('value ',recordtypes[i].value);
                if(recordtypes[i].key == rtIdSelect){
                    rtSelect = recordtypes[i].value;
                }
            }
       }
        console.log('rtSelect1 ',rtSelect);

        component.find("cuestionarioRecordCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log('saveResult1 ',saveResult.recordId);
                // record is saved successfully
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Guardado",
                    "message": "El cuestionario se guardó correctamente."
                });
                resultsToast.fire();
                var delay=2000; //4 seconds
                setTimeout(function() {
                    var action = component.get("c.getNewRecordId");
                    action.setParams({
                        "latitude": component.get("v.latitude"),
                        "longitude": component.get("v.longitude")
                    });
                    action.setCallback(this, function(response) {
                        console.log('response',response);
                        console.log('response.getState() ',response.getState());
                        if (response.getState() === "SUCCESS") {
                            var newRecordId = response.getReturnValue();
                            component.set("v.displayComponent",false);
                            component.set("v.IdCuestionario",newRecordId);
                            if(rtSelect == 'Zonales'){
                            	component.set("v.FlujoCrear",true);
                            }
                            else if(rtSelect == 'Arqueo de Tarjetas'){
                                component.set("v.ArqueoCrear",true);
                            }
                            console.log('newRecordId get1 ',newRecordId);
                        }
                    });
                    $A.enqueueAction(action);  
                }, delay);
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problemas guardando cuestionario, error: ' + JSON.stringify(saveResult.error));
                var resultsToast2 = $A.get("e.force:showToast");
                resultsToast2.setParams({
                    "title": "No se puede guardar Cuestionario",
                    "message": "No puede crear un nuevo Cuestionario sin antes haber completado el anterior.",
                    "type": "error"
                });
                resultsToast2.fire();
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
    },
    openCrearFlujoComponent : function(component){
    },
    openNewRecord : function(newRecordId){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": newRecordId,
            "slideDevName": "Cuestionario__c"
        });
        navEvt.fire();
    },
    showToast : function(title, message, type) {  
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({        
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})