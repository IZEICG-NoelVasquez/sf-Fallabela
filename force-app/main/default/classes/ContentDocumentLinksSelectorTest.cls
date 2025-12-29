/**
* Nombre: ContentDocumentLinksSelectorTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase ContentDocumentLinksSelector
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           09/02/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class ContentDocumentLinksSelectorTest {

    @testSetup
    static void setupData() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        case1.Status = 'Detalle del caso';
        case1.AccountId = acc1.Id;
        case1.Categor_a__c = 'Cargo no reconocido';
        insert case1;

        ///
        ContentVersion contVers = new ContentVersion();
        contVers.Title = 'TestDoc';
        contVers.VersionData = Blob.valueOf('TestDoc');
        contVers.PathOnClient = 'TestDoc.txt';
        insert contVers;

        List<ContentVersion> lstContVers = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contVers.Id];

        ContentDocumentLink contDocLnk = new ContentDocumentLink();
        contDocLnk.ContentDocumentId = lstContVers[0].ContentDocumentId;
        contDocLnk.LinkedEntityId = case1.Id;

        insert contDocLnk;
    }

    @isTest static void selectByListLinkedEntityId() {        

        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00'];

        List<String> lstRecordIds = new List<String>{lstCases[0].Id};

        List<ContentDocumentLink> lstContentDocLink;

        Test.startTest();

        lstContentDocLink = ContentDocumentLinksSelector.selectByListLinkedEntityId(lstRecordIds);

        Test.stopTest();

        System.assertEquals('txt', lstContentDocLink[0].ContentDocument.FileExtension);
    }
}