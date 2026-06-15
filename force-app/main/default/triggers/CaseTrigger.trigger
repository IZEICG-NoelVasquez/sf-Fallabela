trigger CaseTrigger on Case ( before insert, before update, before delete, after insert, after update, after delete, after undelete ) {

    if (TriggerConfig__c.getAll().containsKey('CaseTrigger') && TriggerConfig__c.getInstance('CaseTrigger').IsEnabled__c) {
        new CaseTriggerHandler().run();    
    }   
    
}