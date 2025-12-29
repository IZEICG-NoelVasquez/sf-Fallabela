/**
* Nombre: UtilitiesBatchCasesEmboceTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase UtilitiesBatchCasesEmboce
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           25/05/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class UtilitiesBatchCasesEmboceTest {
    
    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'AccTest1';
        acc.Caso_Emboce_Creado__c = true;
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;
    }
    
    @isTest 
    static void validateSaveResult() {

        List<Account> lstAccount = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1];

        List<Case> lstNewCases = new List<Case>();

        Case case1 = new Case();
        case1.AccountId = lstAccount[0].Id;
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case1.Categor_a__c = '';

        lstNewCases.add(case1);

        Database.SaveResult[] lstSaveResult = Database.update(lstNewCases, false);

        Map<String,String> mapErrors;

        Test.startTest();

        mapErrors = UtilitiesBatchCasesEmboce.validateSaveResult(lstSaveResult, true);

        Test.stopTest();

        System.assertEquals(true, !mapErrors.isEmpty());
    }

    @isTest 
    static void sendEmail() {

        String strBatchName = 'Batch de Prueba';

        Map<String,Object> mapErrors = new Map<String,Object>();

        Test.startTest();

        UtilitiesBatchCasesEmboce.sendEmail(strBatchName, mapErrors);

        Test.stopTest();
    }

    @isTest 
    static void createBodyHtml() {

        Map<String,String> mapErrorsAux = new Map<String,String>{'Error' => 'Mensaje'};
        List<String> lstErrorAccountIds = new List<String>{'Error123'};

        Map<String,Object> mapErrors = new Map<String,Object>();

        mapErrors.put('WebService', mapErrorsAux);
        mapErrors.put('WayBill', mapErrorsAux);
        mapErrors.put('DML', mapErrorsAux);
        mapErrors.put('Insert', mapErrorsAux);

        mapErrors.put('lstErrorAccountIds', lstErrorAccountIds);

        String strBodyHtml = null;

        Test.startTest();

        strBodyHtml = UtilitiesBatchCasesEmboce.createBodyHtml(mapErrors);

        Test.stopTest();

        System.assertEquals(true, String.isNotBlank(strBodyHtml));
    }
}