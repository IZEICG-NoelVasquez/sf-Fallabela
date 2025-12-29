/**
* Nombre: CasosRiesgosCustomButtonsTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase CasosRiesgosCustomButtons
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           28/03/2022      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class CasosRiesgosCustomButtonsTest {
    
    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        String rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        Case case1 = new Case();
        case1.AccountId = acc.Id;
        case1.ID_Solicitud__c = '12345678';
        case1.Cupo__c = 100;
        case1.RecordTypeId = rtCredito;
        case1.Solicitud_de_cancelaci_n__c = true;
        case1.Comentarios__c = 'Test';

        insert case1;
    }

    @isTest static void getCaseInfo() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '12345678' LIMIT 1];

        Test.startTest();

        Map<String,Object> mapResult = CasosRiesgosCustomButtons.getCaseInfo(lstCases[0].Id);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }
}