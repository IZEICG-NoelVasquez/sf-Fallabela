({
    init: function (component, event, helper) { 
        var idcuest = component.get("v.record").Id;
        console.log('idcuest',idcuest);
                var name = component.get("v.record").Name;

        var latitude1 = component.get("v.record").Latitude__c;
        var longitude1 = component.get("v.record").Longitude__c;
                console.log('latitude map market ',name);

        console.log('latitude map market ',latitude1);
        console.log('longitude map market ',longitude1);
        component.set('v.mapMarkers', [
                        {
                            location: {
                               Latitude:  ''+latitude1+'',
                                Longitude :  ''+longitude1+''
                            },
                            title: 'Ubicación de Cuestionario',
                            description: 'Sucursal en la que se realizó el cuestionario.'
                        }
                    ]);
                    console.log('mapmarkets2 ', component.get('v.mapMarkers'));
                    component.set('v.zoomLevel', 15);
    }
});