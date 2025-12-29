/**
* Nombre: CardLockButtonsTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase CardLockButtons
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           10/08/2021      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class CardLockButtonsTest {
    
    @testSetup
    static void setupData () {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Tarjeta_por_Fallecimiento').getRecordTypeId();
        case1.AccountId = acc1.Id;
        case1.Categor_a__c = 'Cancelación de Tarjeta';
        case1.TarjetaCaso__c = '555512******1234';
        case1.Bloqueo_de_Tarjeta_por_Cancelaci_n__c = true;
        insert case1;
    }

    @isTest static void getCaseInfo() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];


        Test.startTest();

        Map<String, Object> mapResult = CardLockButtons.getCaseInfo(lstCases[0].Id);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void cardLocked_catch() {

        Test.startTest();

        Boolean result = CardLockButtons.cardLocked( 'Error__c', '123456789012345');

        Test.stopTest();

        System.assertEquals( result, false);
    }

    @isTest static void getProducts() {

        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();  
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapResult = CardLockButtons.getProducts('ABCD112233HDFABC00');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }
}