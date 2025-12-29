public class UploadImageController {
     @AuraEnabled
    public static Boolean deleteImage(String documentId){
        System.debug('documentId '+documentId);
        ContentDocument  image = [SELECT Id
                                      FROM  ContentDocument 
                                      WHERE Id =: documentId
                                      LIMIT 1];
                System.debug('image '+image);
        delete image;
        return true;
    }
    @AuraEnabled  
    public static List<ContentDocument> getPhotos(string documentId){ 
      /*  Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId 
                                       FROM ContentDocumentLink 
                                       WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }  */    
        System.debug('documentId '+documentId);
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id =: documentId];  
    } 
   @AuraEnabled  
    public static void deletePhoto(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  

}