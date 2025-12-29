@isTest
public class MicroServicioCrearCasoSaldosCntrllrTest {
    
    @testSetup
    static void setupData () {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }
    @isTest static void test_method_1() {

        //
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';
        String camposRequeridos = 'Tipodeconsulta__c:Saldos;Movimientos';

        Map<String, Object> testCrearCasoSaldos = MicroServicioCrearCasoSaldosCntrllr.createCaseClosedSaldos( recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

    }
}