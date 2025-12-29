public class POCAccountController {

    public POCAccountController () {
        
        for (String key : ApexPages.currentPage().getParameters().keySet()) {
            
            System.debug('key ' + key);
            System.debug('value ' + ApexPages.currentPage().getParameters().get(key));
            
            if (ApexPages.currentPage().getParameters().containsKey('key')) {
                String curp = ApexPages.currentPage().getParameters().get(key);
            }
            
        }
        
    }
}