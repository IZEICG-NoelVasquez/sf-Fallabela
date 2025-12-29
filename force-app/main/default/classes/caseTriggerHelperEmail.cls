public class caseTriggerHelperEmail {
    public static void sendEmailNotification (List<Case> TriggerNew, Map<Id, Case> TriggerOldMap) {
        List<Id> CasosIds = new List<Id>();
        Id userChange = null;
		       
        

        for(Case caso : TriggerNew){
             Case caso_Old = TriggerOldMap.get(caso.Id);
            List<GroupMember> queuemember = [Select Group.Name
                      FROM GroupMember
                      WHERE UserOrGroupId =: caso_Old.OwnerId
    				  AND Group.Type = 'Queue'
    				  AND Group.Id =: caso.OwnerId]; 
          
            System.debug('caso.OwnerId '+caso.OwnerId);
            System.debug('caso_Old.OwnerId '+caso_Old.OwnerId);
            System.debug('queuemember '+queuemember);
            if(caso.OwnerId != caso_Old.OwnerId){
                CasosIds.add(caso.Id);        
            }    
            System.debug('old own 3 '+string.valueOf(caso_Old.OwnerId).startsWith('005'));
            System.debug(' own 3 '+string.valueOf(caso.OwnerId).startsWith('00G'));
            System.debug('current user '+UserInfo.getUserId());
            System.debug('quemembersize '+queuemember.size());
            if(string.valueOf(caso_Old.OwnerId).startsWith('005') &&
              string.valueOf(caso.OwnerId).startsWith('00G') &&
              caso_Old.OwnerId == UserInfo.getUserId() && 
              queuemember.size()>0){
                userChange = caso_Old.OwnerId;
            }
        }  
        if(CasosIds.size()>0){
        	caseTriggerHelperEmail.sendEmailCase(CasosIds, userChange);
            System.debug('CasosIds '+CasosIds);
        }
    }
    @future
	public static void sendEmailCase(List<Id> CasosIds, Id userChange){
        
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject 
                                                 from EmailTemplate 
                                                 where DeveloperName = 'Canales_Digitales'];
        List<Case> casosList = [Select Id,AccountId, OwnerId From Case Where Id IN: CasosIds];
        Set<Id> accountIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        List<Case> casosChangeOwner = new List<Case>();
        for(Case caso : casosList){
             System.debug('fu caso.OwnerId '+caso.OwnerId);
            System.debug('fu userChange '+userChange);
            if(string.valueOf(caso.OwnerId).startsWith('005') || userChange != null){
                casosChangeOwner.add(caso);
                             System.debug('caso start 005 '+caso.OwnerId);

                accountIds.add(caso.AccountId);
                ownerIds.add(caso.OwnerId);
            }
        }
        if(casosChangeOwner.size()>0){        
        	Map<Id,Id> accountContact = new Map<Id,Id>();
        	Map<Id,String> OwnerEmail = new Map<Id,String>();
            if(accountIds.size()>0){
            	List<Contact>  contactList = [Select Id, AccountId From Contact Where AccountId IN: accountIds];
                if(contactList.size()>0){
                    for(Contact con : contactList){
                        accountContact.put(con.AccountId, con.Id);
                    }
                }
            }
            if(ownerIds.size()>0 || userChange != null){
                List<User>  ownerList = new List<User>();
                if(userChange != null){
            		ownerList = [Select Email, Id From User Where Id =: userChange];
                }
                else{
                	ownerList = [Select Email, Id From User Where Id IN: ownerIds];
                }
                if(ownerList.size()>0){
                    for(User usr : ownerList){
                        OwnerEmail.put(usr.Id, usr.Email);
                    }
                }
            }
            if(accountContact.size()>0 && OwnerEmail.size()>0){
                for(Case caso : casosChangeOwner){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstEmailTemplates[0].Id);
                    mail.setSaveAsActivity(false);
                    mail.setTargetObjectId(accountContact.get(caso.AccountId));// Any contact or User id of your record
                    String correo;
                    if(userChange != null){
                        correo = OwnerEmail.get(userChange);
                    }else{
                        correo = OwnerEmail.get(caso.OwnerId);
                    }
                    System.debug('caso.OwnerId '+ caso.OwnerId);
                    System.debug('correo '+ correo);
                    mail.setToAddresses(new list<string>{'luis.sandoval@xertica.com',correo});
                    mail.setWhatId(caso.id); // Enter your record Id whose merge field you want to add in template
                    System.debug('mail  '+mail);
                    Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }
        
    }
}