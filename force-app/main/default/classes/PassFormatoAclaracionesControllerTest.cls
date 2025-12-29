@isTest
public class PassFormatoAclaracionesControllerTest {
    
    /**
	 * setup
	 */
	@testSetup
    static void setupData() {
        APIKey__c APIKey = new APIKey__c();
        APIKey.Name = 'PDFKey';
        APIKEy.cryptoKey__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        insert APIKey;

        String recordTypeId =  [SELECT Id FROM RecordType where ispersontype=true and sobjectType='account' limit 1].Id;
        Account newPersonAccount = new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678',
            CURP__c='TEST123TEST123TEST',
            Cliente_Soriban__c=true
        );

        insert newPersonAccount;
        
        List<Case> caseLst = new List<Case>();
        
        Case c = new Case();
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cargo no reconocido').getRecordTypeId();
        c.Categor_a__c = 'Cargo no reconocido';
        c.Status = 'Documentación requerida';
        c.AccountId = newPersonAccount.Id;
        caseLst.add(c);
        
        insert caseLst;
    }
    
    /**
	 * TO DO
	 * sendEmail
	 * This is a mock test
	 */
    @isTest
    public static void validarTest() {
        //Case
        Case c = [SELECT Id FROM Case LIMIT 1];
        
        //Encode tarjeta
        String tarjeta = '1111222233334444';
        Blob cryptoKey;
        Blob data = Blob.valueOf(tarjeta);
        
        if(APIKey__c.getAll().containsKey('PDFKey') && APIKey__c.getInstance('PDFKey').cryptoKey__c != null) {
            cryptoKey = EncodingUtil.base64Decode(APIKey__c.getInstance('PDFKey').cryptoKey__c);
        }
        
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encodeBase64encrypData = EncodingUtil.base64Encode(encryptedData);
        //String urlBase64encrypData = EncodingUtil.urlEncode(encodeBase64encrypData, 'UTF-8');
        
        Test.startTest();
        //Attributes
        PageReference testPage = new pagereference('/apex/PassFormatoAclaraciones');
        Map<String, String> params = ApexPages.currentPage().getParameters();
       	params.put('id', c.id );
        params.put('t', encodeBase64encrypData );
        
        //Error
        PassFormatoAclaracionesController passFormAclaCont1 = new PassFormatoAclaracionesController();        
        passFormAclaCont1.inputValue='6666';
        PageReference pageref1 = passFormAclaCont1.validar();
        
        //Validado
        PassFormatoAclaracionesController passFormAclaCont2 = new PassFormatoAclaracionesController(); 
        passFormAclaCont2.inputValue='4444';
        PageReference pageref2 = passFormAclaCont2.validar();

        Test.stopTest();
        
        System.assertEquals(true, passFormAclaCont1.error, 'Not Success');
        System.assertEquals(false, passFormAclaCont2.error, 'Success');
    }
    
}