/************************************************************************************************
Apex Class Name	:	UploadImageControllerTest 
Version			:	1.0
Created Date    :	23/10/2019 09:36
Function 		: 	Cubrir a la clase controladora del componente UploadImage
Cover Class		:	UploadImageController
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     23/10/2019 	 Original Version
*************************************************************************************************/
@isTest
public class UploadImageControllerTest {
    @isTest static void test_uploadImage() {
        //Creamos una cuenta del cliente
        List<ContentVersion> cvList = new List<ContentVersion>();
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = blob.valueof('Test Content Data'),
            IsMajorVersion = true
        );
        cvList.add(cv);
        ContentVersion cv2 = new ContentVersion(
            Title = 'Test2',
            PathOnClient = 'Test2.jpg',
            VersionData = blob.valueof('Test2 Content Data'),
            IsMajorVersion = true
        );
        cvList.add(cv2);
        insert cvList;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        List<ContentDocument> docs = UploadImageController.getPhotos(documents[0].Id);
        Boolean borrarImagen = UploadImageController.deleteImage(documents[0].Id);
        UploadImageController.deletePhoto(documents[1].Id);
        
        
        
    }
    
}