public class CuestionarioApexController {
    @AuraEnabled        
    public static Map<Id,String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Cuestionario__c.SObjectType.getDescribe().getRecordTypeInfos();    
        Map<Id, String> recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master')
            recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap;
    }
    @AuraEnabled
    public static List<String> getSucursales(String sucursalId){
        List<String> sucursales = new List<String>();
        List<Sucursal__mdt> sucList = [Select MasterLabel, DeveloperName,NamespacePrefix,Latitude__c,Longitude__c 
                                       From Sucursal__mdt
                                       ORDER BY MasterLabel];
        if(sucList.size()>0){
            for(Sucursal__mdt suc : sucList){
                sucursales.add(suc.MasterLabel);
            }
        }
        return sucursales;
    }
    @AuraEnabled
    public static Map<String,List<Double>> getLatitudeLongitude(String sucursal){
        System.debug('sucursal '+sucursal);
        Map<String,List<Double>> mapReturn = new Map<String,List<Double>>();
        List<Double> latlong = new List<Double>();
        Sucursal__mdt suc = [Select MasterLabel, DeveloperName,NamespacePrefix,Latitude__c,Longitude__c 
                                       From Sucursal__mdt
                                       Where MasterLabel =: sucursal];
         System.debug('suc '+suc);

        latlong.add(suc.Latitude__c);
        latlong.add(suc.Longitude__c);
		mapReturn.put(suc.MasterLabel,latlong);
        return mapReturn;   
    }
	@AuraEnabled
    public static String getNewRecordId(Double latitude, Double longitude){
 	System.debug('latitude1 '+latitude);
        System.debug('longitude2 '+longitude);
        Double latitudeMin = latitude-0.001;
        Double latitudeMax = latitude+0.001;
        Double longitudeMin = longitude-0.001;
        Double longitudeMax = longitude +0.001;
         Cuestionario__c cuest = [Select Id, CreatedDate
                                       From Cuestionario__C
                                 	   Where Latitude__c >=: latitudeMin AND
                    						 Latitude__c <=: latitudeMax AND
                                 			 Longitude__c >=: longitudeMin AND
                   							 Longitude__c <=: longitudeMax AND
                                 			 CreatedDate = TODAY 
                      				  ORDER BY CreatedDate DESC
                                      LIMIT 1];
        System.debug('cuest3 '+cuest);
        	return cuest.Id;
    }
}