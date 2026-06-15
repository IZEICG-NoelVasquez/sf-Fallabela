public with sharing class SLAconfigurationController {
    public static void assingInitialSlaConfiguration(List<Case> caseCreatedList){
        Map<String,Map<String,String>> mapSlaConfig = new Map<String,Map<String,String>>();
         Map<String,InitialSLAconfiguration__mdt> slaMapRecord = InitialSLAconfiguration__mdt.getAll();
         set<String> subcategoriCaseCreated = new set<String>();
         

        for(Case caseInserted : caseCreatedList){
            subcategoriCaseCreated.add(caseInserted.Subcategor_a_Texto__c);
        }
            system.debug('subcategoriCaseCreated'+caseCreatedList[0]);

        for(InitialSLAconfiguration__mdt slaKey  :[ Select id,SLA_Values__c,Sub_Categoria__c,Sub_Categoria__r.Value__c  from InitialSLAconfiguration__mdt where  Sub_Categoria__r.Value__c  in :subcategoriCaseCreated]){
          mapSlaConfig.put(slaKey.Sub_Categoria__r.Value__c, (Map<String, String>) JSON.deserialize(slaKey.SLA_Values__c, Map<String, String>.class ));
        }
        system.debug(mapSlaConfig.keySet());
        for(Case caseInsert : caseCreatedList){
        system.debug(mapSlaConfig);

            if(mapSlaConfig.containsKey(caseInsert.Subcategor_a_Texto__c) && String.isNotBlank(caseInsert.Origin)){
                List<String> slaAndCloseDateList = mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin).contains(';')? mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin).split(';') : new list<String>{mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin)};
                system.debug('mapSlaConfig.containsKey(caseInsert.Subcategor_a_Texto__c)'+slaAndCloseDateList);
                system.debug('caseInsert.Origin'+caseInsert.Origin);
                system.debug('caseInsert.Origin'+mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin));
                caseInsert.SLA2__c = slaAndCloseDateList[0];
                if(slaAndCloseDateList.size() > 1){
                    String timeToAdd = slaAndCloseDateList[1] ;
                // system.debug('timeToAdd'+timeToAdd);
                caseInsert.Fecha_estimada_de_cierre__c = timeToAdd.contains('/') ? System.now().addMinutes(Integer.valueOf(timeToAdd.split('/')[0])) :  System.now().addDays(Integer.valueOf(timeToAdd));
                }
                
              system.debug('caseInsert.Fecha_estimada_de_cierre__c '+caseInsert.Fecha_estimada_de_cierre__c );
            }
        }

    }

//     public  void assignAdvanceSlaUpdate(List<Case> caseCreatedList){
//     for(Case caseInsert : caseCreatedList){
     
//     }
// }
}