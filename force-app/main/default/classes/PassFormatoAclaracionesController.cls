public class PassFormatoAclaracionesController {
    private String caseId;
    private String urlBase64encrypData;
    private String Base64Tarjeta;
    private String encondeBase64Tarjeta;
    private Blob encryptedData;
    private Blob cryptoKey;
    private Blob decryptedData;
    private String digTar;
    private String lastDigTar;
    public String inputValue {get;set;}
    public boolean error{get;set;}
    public String sldsHasError{get{
        if(sldsHasError==null){
                sldsHasError = '';
            }
            return sldsHasError;
        } set;
     }

    public PassFormatoAclaracionesController() {
        
        Map<String, String> params = ApexPages.currentPage().getParameters();
    	caseId = params.get('id');
        Base64Tarjeta = params.get('t');
        
        //Base64Tarjeta = EncodingUtil.urlDecode(urlBase64encrypData, 'UTF-8');
        encryptedData = EncodingUtil.base64Decode(Base64Tarjeta);
        if(APIKey__c.getAll().containsKey('PDFKey') && APIKey__c.getInstance('PDFKey').cryptoKey__c != null) {
            cryptoKey = EncodingUtil.base64Decode(APIKey__c.getInstance('PDFKey').cryptoKey__c);
        }
        
        decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData); 
        digTar = decryptedData.toString();
        lastDigTar = digTar.substring(digTar.length() - 4);

    }
        
    public PageReference validar() {
        PageReference pageRef;
         
        if(lastDigTar.equals(inputValue)) {
            System.debug('Validado');
            error = false;
            pageRef = Page.PDFFormatoAclaraciones;
       		Map<String, String> params = pageRef.getParameters();
        	params.put('id', caseId);
            params.put('t', digTar);
        	pageRef.setRedirect(false);
        	
        } else {
            error = true;
            sldsHasError='slds-has-error';
        }
        return pageRef;
    }
    
       
}