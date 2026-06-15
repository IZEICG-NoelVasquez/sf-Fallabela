SLAconfigurationController.assingInitialSlaConfiguration();

CreacionUsuariosHelper.validateUserCreation();
Datetime nowTime =  System.now();
system.debug(nowTime);
system.debug(nowTime.addDays(20/144));

List<PermissionSetAssignment> psetList = new List<PermissionSetAssignment>();
// PermissionSetAssignment psa = new PermissionSetAssignment
// (PermissionSetId = myPermissionSetId, AssigneeId = myAssigneeId);
// insert psa;  
for(User usr : [select id , name from User where  isActive =  true]){
  PermissionSetAssignment psa = new PermissionSetAssignment
(PermissionSetId = '0PSRQ000000AaqD', AssigneeId = usr.Id);
psetList.add(psa);

}

insert psetList;  

 Map<String,Map<String,String>> mapSlaConfig = new Map<String,Map<String,String>>();
  Map<String,InitialSLAconfiguration__mdt> slaMapRecord = InitialSLAconfiguration__mdt.getAll();

set<String> subcategoiriaList = new set<String>();
for(Case ca:[select id, recordType.Name, createdDate, sla2__c,sla__c, origin,Fecha_estimada_de_cierre__c from case where createdDate = today and sla2__c = null and sla__c != null and status != 'Cerrado' and status != 'cancelado']){
subcategoiriaList.add(ca.recordType.Name);
}
 for(InitialSLAconfiguration__mdt slaKey  :[ Select id,SLA_Values__c,Sub_Categoria__c,Sub_Categoria__r.Value__c  from InitialSLAconfiguration__mdt where  Sub_Categoria__r.Value__c  in :subcategoiriaList]){
          mapSlaConfig.put(slaKey.Sub_Categoria__r.Value__c, (Map<String, String>) JSON.deserialize(slaKey.SLA_Values__c, Map<String, String>.class ));
        }
List<Case> caseToUpdate = new List<Case>();
for(Case caseInsert:[select id, recordType.Name,Subcategor_a_Texto__c, createdDate, sla2__c,sla__c, origin,Fecha_estimada_de_cierre__c from case where createdDate = today and sla2__c = null and sla__c != null and status != 'Cerrado' and status != 'cancelado' and Subcategor_a_Texto__c != 'APP']){

 if(mapSlaConfig.containsKey(caseInsert.Subcategor_a_Texto__c) && String.isNotBlank(caseInsert.Origin)){
Case newCase = new Case();

                List<String> slaAndCloseDateList = mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin).contains(';')? mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin).split(';') : new list<String>{mapSlaConfig.get(caseInsert.Subcategor_a_Texto__c).get(caseInsert.Origin)};
                
                newCase.SLA2__c = slaAndCloseDateList[0];
                if(slaAndCloseDateList.size() > 1){
                    String timeToAdd = slaAndCloseDateList[1] ;
                // system.debug('timeToAdd'+timeToAdd);
                newCase.Fecha_estimada_de_cierre__c = timeToAdd.contains('/') ? System.now().addMinutes(Integer.valueOf(timeToAdd.split('/')[0])) :  System.now().addDays(Integer.valueOf(timeToAdd));
                }

newCase.Id = caseInsert.Id;

caseToUpdate.add(newCase);
}
}

update caseToUpdate;