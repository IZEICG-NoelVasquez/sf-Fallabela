public class PureCloudProxyController {
    
    public PageReference pureCloudProxyEvent() {
        if (ApexPages.currentPage().getParameters().containsKey('key')) {
            String curp = ApexPages.currentPage().getParameters().get('key');
            System.debug('curp: ' + curp);
            
            if (String.isNotBlank(curp)) {
                return new PageReference('/lightning/cmp/c__AuthenticateCustomer?c__authCurp='+curp );    
                /*

                String userId = UserInfo.getUserId();
                List<Database.SaveResult> results = EventBus.publish(new List<MyEvent__e>{new MyEvent__e(Message__c='fireAuthenticate', value__c=curp, RecordId__c=userId )});
                System.debug('results: ' + results);               
                // Inspect publishing results
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            System.debug('Error returned: ' +
                                         error.getStatusCode() +' - '+
                                         error.getMessage());
                        }
                    }
                }
			*/
            }
        	
        }
        return new PageReference('/lightning/cmp/c__AuthenticateCustomer');    
    }
    
}