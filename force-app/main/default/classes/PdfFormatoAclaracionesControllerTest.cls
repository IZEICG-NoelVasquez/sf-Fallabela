/**
* Nombre: PdfFormatoAclaracionesControllerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase PdfFormatoAclaracionesController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/01/2021       Mauricio Rosales           Creación
* --------------------------------------------------------------------------
*/
@isTest
public class PdfFormatoAclaracionesControllerTest {

    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso1 = new Case();
        caso1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        caso1.Categor_a__c = 'Cargo no reconocido';
        caso1.Status = 'Documentación requerida';
        caso1.AccountId = acc.Id;

        insert caso1;
    }

    @isTest static void pdfFormatoAclaraciones() {

        Case caso = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1];

        ApexPages.currentPage().getParameters().put('id', caso.Id);
        ApexPages.currentPage().getParameters().put('t', '1234567890123456');

        Test.startTest();

        PdfFormatoAclaracionesController pdf = new PdfFormatoAclaracionesController();

        Test.stopTest();

        System.assertEquals( pdf.caso.Id, caso.Id);
    }
}