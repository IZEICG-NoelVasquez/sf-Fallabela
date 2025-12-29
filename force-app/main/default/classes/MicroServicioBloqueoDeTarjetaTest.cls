/**
* Nombre: MicroServicioBloqueoDeTarjetaTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioBloqueoDeTarjeta
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           25/06/2021      Mauricio Rosales        Creación
* 2.0           10/08/2021      Mauricio Rosales        Bloqueo de tarjetas desde un registro de Casos
* 3.0           04/07/2022      Mauricio Rosales            Mapa con fechas de vencimiento de las tarjetas relacionadas a la cuenta
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioBloqueoDeTarjetaTest {

    @testSetup
    static void setupData () {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case case1 = new Case();
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        case1.AccountId = acc1.Id;
        case1.Categor_a__c = 'Consultas';
        insert case1;

        Tarjeta__c tarjeta = new Tarjeta__c();
        tarjeta.Account__c = acc1.Id;
        tarjeta.BIN__c = '111222';
        tarjeta.ltimos_4_d_gitos_tarjeta__c = '1234';
        tarjeta.D_a_Fecha_de_corte__c = '10';
        tarjeta.Donde_pag_su_tarjeta__c = 'Otro Medio';
        tarjeta.Cuando_realiz_el_pago_de_tarjeta__c = '10';
        tarjeta.Compra_diferida__c = 'Si';
        tarjeta.feccadtar__c = '202212';
        insert tarjeta;
    }

    @isTest static void cardLock_success() {

        String body = '{"code":"ok","message":{"estadoOperacion": {"codigoOperacion":"00","glosaOperacion":"[AZ7] OPERACIÓN REALIZADA CON ÉXITO"}}}';

        MockHttpResponseGeneratorMicroServicios mockMSBloqueo = new MockHttpResponseGeneratorMicroServicios();
        mockMSBloqueo.setMethod('POST');
        mockMSBloqueo.setEndpoint('block/tdc');
        mockMSBloqueo.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMSBloqueo);

        Map<String, String> mapRequestFields = new Map<String, String>();
        mapRequestFields.put('tipoPlastico', 'credito');
        mapRequestFields.put('identificadorProducto', '554412****1234');
        mapRequestFields.put('identificador', '00010123000000001234');
        mapRequestFields.put('numeroDocumento', 'ABCD901201HDFBCD01');
        mapRequestFields.put('tipoDocumento', '1');
        mapRequestFields.put('descripcionMotivoReq', 'Bloqueo por robo');
        mapRequestFields.put('codigoMotivoReq', '1');
        mapRequestFields.put('descripcionTipoReq', 'BLOQUEO');
        mapRequestFields.put('codigoTipoReq', '001');


        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.cardLock(mapRequestFields);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void cardLock_error() {

        String body = '{"code":"ok","message":"[AZ7][COD:02]ERROR: LA OPERACIÓN NO SE PUDO REALIZAR"}';

        MockHttpResponseGeneratorMicroServicios mockMSBloqueo = new MockHttpResponseGeneratorMicroServicios();
        mockMSBloqueo.setMethod('POST');
        mockMSBloqueo.setEndpoint('block/tdc');
        mockMSBloqueo.setBody(body);
        mockMSBloqueo.setStatusCode(409);
        Test.setMock(HttpCalloutMock.class, mockMSBloqueo);

        Map<String, String> mapRequestFields = new Map<String, String>();
        mapRequestFields.put('tipoPlastico', 'credito');
        mapRequestFields.put('identificadorProducto', '554412****1234');
        mapRequestFields.put('identificador', '00010123000000001234');
        mapRequestFields.put('numeroDocumento', 'ABCD901201HDFBCD01');
        mapRequestFields.put('tipoDocumento', '1');
        mapRequestFields.put('descripcionMotivoReq', 'Bloqueo por robo');
        mapRequestFields.put('codigoMotivoReq', '1');
        mapRequestFields.put('descripcionTipoReq', 'BLOQUEO');
        mapRequestFields.put('codigoTipoReq', '001');


        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.cardLock(mapRequestFields);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void cardLock_catch() {

        MockHttpResponseGeneratorMicroServicios mockMSBloqueo = new MockHttpResponseGeneratorMicroServicios();
        mockMSBloqueo.setMethod('POST');
        mockMSBloqueo.setEndpoint('block/tdc');
        mockMSBloqueo.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockMSBloqueo);

        Map<String, String> mapRequestFields = new Map<String, String>();
        mapRequestFields.put('tipoPlastico', 'credito');
        mapRequestFields.put('identificadorProducto', '554412****1234');
        mapRequestFields.put('identificador', '00010123000000001234');
        mapRequestFields.put('numeroDocumento', 'ABCD901201HDFBCD01');
        mapRequestFields.put('tipoDocumento', '1');
        mapRequestFields.put('descripcionMotivoReq', 'Bloqueo por robo');
        mapRequestFields.put('codigoMotivoReq', '1');
        mapRequestFields.put('descripcionTipoReq', 'BLOQUEO');
        mapRequestFields.put('codigoTipoReq', '001');


        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.cardLock(mapRequestFields);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void getCardLockValues() {

        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.getCardLockValues(lstAccounts[0].Id);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void createCaseOpenByRT() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        List<Account> lstAccounts = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        List<Contact> lstContacts = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Consultas';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '123456*****1234';

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.createCaseOpenByRT(recordTypeId, 
                                                                        lstAccounts[0].Id, 
                                                                        lstContacts[0].Id, 
                                                                        category, 
                                                                        altoRiesgo, 
                                                                        metodoContactoValue, 
                                                                        numeroDeTarjetaValue );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void closeCaseByRT() {

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();

        List<Case> lstCases = [SELECT Id FROM Case WHERE RecordTypeId = : recordTypeId];

        Map<String, Object> mapRequiredFields = new Map<String,Object>();
        mapRequiredFields.put('Tipodeconsulta__c', 'Saldos');

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.closeCaseByRT(lstCases[0].Id, mapRequiredFields );

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void updateCaseByRT() {

        List<Case> lstCases = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];

        Map<String, Object> mapFields = new Map<String, Object>();
        mapFields.put( 'TarjetaCaso__c', '555512******1234');

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioBloqueoDeTarjeta.updateCaseByRT( lstCases[0].Id, mapFields);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }
}