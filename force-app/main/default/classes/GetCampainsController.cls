public with sharing class GetCampainsController {
  @AuraEnabled
  public static List<campainWrapper> getCampains(String accountId) {
    List<campainWrapper> campainWrapperList =  new List<campainWrapper>();
    system.debug('accountId+'+accountId);

    string accessToken = getAccessToken();
    Account account = [  SELECT Id, RFC__c, Name  FROM Account  WHERE Id = :accountId LIMIT 1   ];
    system.debug('accountId+'+account);

    
    // Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(
    //   res.getBody()
    // );
    HttpRequest reqGetCustomer = new HttpRequest();
    Blob textoBlob = Blob.valueOf(account.RFC__c + accessToken);
    // Blob textoBlob = Blob.valueOf('EEAC820617HVZSNR06' + accessToken);

    Blob hash = Crypto.generateDigest('SHA-256', textoBlob);

    // 2. Convertir a Hex o Base64
    String hashHex = EncodingUtil.convertToHex(hash);
    reqGetCustomer.setEndpoint(
      'callout:ApiGeeCustomers/customer-relationship-management/v2/customers/' +
        hashHex +
        '/offers'
    );

    reqGetCustomer.setHeader('X-Customer-Id', account.RFC__c);
    reqGetCustomer.setHeader('Authorization', 'Bearer ' + accessToken);
    reqGetCustomer.setHeader('X-Date-Time', '2025-10-30T10:42:05Z');

    reqGetCustomer.setMethod('GET');
    HttpResponse responseGetCustomer = new Http().send(reqGetCustomer);
    System.debug(reqGetCustomer);
    system.debug(responseGetCustomer);
    if(responseGetCustomer.getStatusCode() != 200){
       Error_Log__c errorLog = new Error_Log__c();
        errorLog.ApexClass__c = 'GetCampainsController.cls';
        errorLog.Message__c = responseGetCustomer.getBody() ;
        insert errorLog;

        return campainWrapperList;
        //  throw new AuraHandledException(responseGetCustomer.getBody());
      
      }

      List<CampainResponse> CampainResponseApiGeeList = (List<CampainResponse>) JSON.deserialize(responseGetCustomer.getBody(), List<CampainResponse>.class);
      for(CampainResponse CampainResponseWrapper :CampainResponseApiGeeList ){
        campainWrapper campainRecord = new campainWrapper();
        campainRecord.name = CampainResponseWrapper.campaign.campaignId;
        campainRecord.status = CampainResponseWrapper.campaign.campaignStatus.status.statusDescription.toUpperCase();
        campainWrapperList.add(campainRecord);
      }
    // if (responseGetCustomer.getStatusCode() != 200) {
    //   ErrorLog.log(apexClass, message);
    // }

    return campainWrapperList;
  }
  private static string getAccessToken(){

    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:ApiGeeAuth/oauth/cc/token');
    req.setMethod('POST');
    req.setBody('grant_type=client_credentials');
    System.debug(req);
    HttpResponse res = new Http().send(req);
    if (res.getStatusCode() != 200) {
      
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.ApexClass__c = 'GetCampainsController';
        errorLog.Message__c = res.getBody() ;
        insert errorLog;
      // throw new CalloutException('Error auth: ' + res.getBody());
    }
    AutenticateSuccessApiGee auth = (AutenticateSuccessApiGee) JSON.deserialize(
      res.getBody(),
      AutenticateSuccessApiGee.class
    );

    return auth.access_token;
  }
public class campainWrapper{
   @AuraEnabled public string name;
   @AuraEnabled public string status;
}
  public class AutenticateSuccessApiGee {
    public String access_token;
    public String token_type;
    public Integer expires_in;
  }

  public class CampainResponse{
      public campaignBody campaign;
  }
  public class campaignBody{
    public String campaignId;
    public campaignStatus campaignStatus;
  }
  public class campaignStatus{
    public status status;
  }
  public class status{
    public string statusId;
    public string statusDescription;
  }
}