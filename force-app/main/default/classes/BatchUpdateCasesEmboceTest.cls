/**
* Nombre: BatchUpdateCasesEmboceTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la clase BatchUpdateCasesEmboce
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           29/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class BatchUpdateCasesEmboceTest {
    
    @testSetup
    static void setupData() {

        List<Account> lstAccounts = new List<Account>();

        Account acc1 = new Account();
        acc1.LastName = 'AccTest1';
        acc1.Emboce_Centralizado__c = '15';
        acc1.Caso_Emboce_Creado__c = true;
        acc1.CURP__c = 'ABCD112233HDFABC01';
        lstAccounts.add(acc1);

        Account acc2 = new Account();
        acc2.LastName = 'AccTest2';
        acc2.Emboce_Centralizado__c = '15';
        acc2.Caso_Emboce_Creado__c = true;
        acc2.CURP__c = 'ABCD112233HDFABC02';
        lstAccounts.add(acc2);

        Account acc3 = new Account();
        acc3.LastName = 'AccTest3';
        acc3.Emboce_Centralizado__c = '15';
        acc3.Caso_Emboce_Creado__c = true;
        acc3.CURP__c = 'ABCD112233HDFABC03';
        lstAccounts.add(acc3);

        Account acc4 = new Account();
        acc4.LastName = 'AccTest4';
        acc4.Emboce_Centralizado__c = '15';
        acc4.Caso_Emboce_Creado__c = true;
        acc4.CURP__c = 'ABCD112233HDFABC04';
        lstAccounts.add(acc4);

        insert lstAccounts;


        List<Case> lstCases = new List<Case>();

        Case case1 = new Case();
        case1.AccountId = lstAccounts[0].Id;
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case1.Num_Folio_a_Consultar__c = '1234567890123456789012';
        case1.Fecha_de_Recepci_n__c = System.today().addDays(8);
        case1.Status = 'Asignada';
        case1.Categor_a__c = 'Información de Producto';
        lstCases.add(case1);

        Case case2 = new Case();
        case2.AccountId = lstAccounts[1].Id;
        case2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case2.Num_Folio_a_Consultar__c = '1234567890123456789111';
        case2.Fecha_de_Recepci_n__c = System.today().addDays(8);
        case2.Status = 'Asignada';
        case2.Categor_a__c = 'Información de Producto';
        lstCases.add(case2);

        insert lstCases;
    }

    @isTest 
    static void BatchUpdateCasesEmboce() {

        List<String> lstReturn = System.Label.EMBOCE_CENTRALIZADO_DEVOLUCION_DE_GUIAS.split(',');

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setEndpointToken('token');
        mockHttp.setBodyToken(createBodyToken());
        mockHttp.setBody(createBody('EN_TRANSITO', 'EN_TRANSITO', lstReturn[0]));
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        BatchUpdateCasesEmboce batchApex = new BatchUpdateCasesEmboce();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Case> lstCasesUpdated = [SELECT Estatus_final_de_tarjeta__c FROM Case WHERE Num_Folio_a_Consultar__c = '1234567890123456789012' LIMIT 1];
        System.assertEquals('EN_TRANSITO', lstCasesUpdated[0].Estatus_final_de_tarjeta__c);
    }

    @isTest 
    static void BatchUpdateCasesEmboce_ErrorWayBill() {

        List<Account> lstAccounts = [SELECT Id FROM Account WHERE CURP__c IN ('ABCD112233HDFABC03','ABCD112233HDFABC04') LIMIT 2];

        List<Case> lstCases = new List<Case>();

        Case case3 = new Case();
        case3.AccountId = lstAccounts[0].Id;
        case3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case3.Num_Folio_a_Consultar__c = '1234567890123456789222';
        case3.Categor_a__c = 'Información de Producto';
        lstCases.add(case3);

        Case case4 = new Case();
        case4.AccountId = lstAccounts[1].Id;
        case4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        case4.Num_Folio_a_Consultar__c = '1234567890123456789333';
        case4.Categor_a__c = 'Información de Producto';
        lstCases.add(case4);

        insert lstCases;

        List<String> lstStatusSPAClosed = System.Label.EMBOCE_CENTRALIZADO_STATUS_SPA_CERRAR_CASOS.split(',');
        List<String> lstStatusSPACanceled = System.Label.EMBOCE_CENTRALIZADO_STATUS_SPA_CANCELAR_CASOS.split(',');        

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setEndpointToken('token');
        mockHttp.setBodyToken(createBodyToken());
        mockHttp.setBody(createBody(lstStatusSPAClosed[0], lstStatusSPACanceled[0], 'TEST'));
        Test.setMock(HttpCalloutMock.class, mockHttp);        

        Test.startTest();

        BatchUpdateCasesEmboce batchApex = new BatchUpdateCasesEmboce();
        Database.executeBatch(batchApex);

        Test.stopTest();

        List<Case> lstCasesUpdated = [SELECT Estatus_final_de_tarjeta__c FROM Case WHERE Num_Folio_a_Consultar__c = '1234567890123456789012' LIMIT 1];
        System.assertEquals(lstStatusSPAClosed[0], lstCasesUpdated[0].Estatus_final_de_tarjeta__c);
    }

    @isTest 
    static void BatchUpdateCasesEmboce_ErrorToken() {

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setStatusCodeToken(401);
        mockHttp.setEndpointToken('token');
        mockHttp.setBodyToken(createBodyTokenError());
        mockHttp.setBody(createBodyError());        
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        BatchUpdateCasesEmboce batchApex = new BatchUpdateCasesEmboce();
        Database.executeBatch(batchApex);

        Test.stopTest();
    }

    @isTest 
    static void BatchUpdateCasesEmboce_ErrorCustShipmentTracking() {

        /// Http Mock
        MockHttpResponseGeneratorWithToken mockHttp = new MockHttpResponseGeneratorWithToken();
        mockHttp.setStatusCodeToken(200);
        mockHttp.setStatusCode(401);
        mockHttp.setEndpointToken('token');
        mockHttp.setBodyToken(createBodyToken());
        mockHttp.setBody(createBodyError());        
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();

        BatchUpdateCasesEmboce batchApex = new BatchUpdateCasesEmboce();
        Database.executeBatch(batchApex);

        Test.stopTest();
    }


    private static String createBodyToken() {

        String body = '{"access_token":"1234abcd-a12b-1a12-12ab-123456abcdef","token_type":"Bearer","expires_in":86400,"scope":"execute"}';

        return body;
    }

    private static String createBody(String strClosed, String strCanceled, String strReturn) {

        String body = '{"ExecuteQueryResponse":{"ExecuteQueryResult":{"errorCodeDescriptionSPA":"","errorCode":"0","errorCodeDescriptionENG":"","trackingData":{"TrackingData":[{"deliveryData":{"destinationAcronym":"MT2","zipCode":"66437","deliveryDateTime":"2/6/2023 1:34:00 PM","receiverName":"SOE: ' + strReturn + ' TEST","destinationName":"MONTERREY ZONA NORTE"},"multipleServiceData":{"nil":true},"additionalInformation":"","internationalData":{"nil":true},"signature":"abcdef1234567890","customerInfo":{"reference":"000000123456","costsCentre":""},"shortWaybillId":"3333123456","statusSPA":"' + strClosed + '","history":{"History":[{"exceptionCodeDetails":"","eventDateTime":"2/6/2023 8:58:00 AM","eventId":"SCON","eventPlaceName":"MONTERREY ZONA NORTE","eventDescriptionSPA":"Llegada a centro de distribución MONTERREY ZONA NORTE","exceptionCodeDescriptionSPA":"","eventDescriptionENG":"Exit of Container MONTERREY ZONA NORTE","eventPlaceAcronym":"MT2","exceptionCode":"","exceptionCodeDescriptionENG":""},{"exceptionCodeDetails":"","eventDateTime":"2/6/2023 11:27:00 AM","eventId":"ECON","eventPlaceName":"MONTERREY ZONA NORTE","eventDescriptionSPA":"En proceso para salir a reparto MONTERREY ZONA NORTE","exceptionCodeDescriptionSPA":"","eventDescriptionENG":"In process to delivery MONTERREY ZONA NORTE","eventPlaceAcronym":"MT2","exceptionCode":"","exceptionCodeDescriptionENG":""}]},"customerNumber":"5123456","packageType":"Sobre","serviceDescriptionENG":"terrestre consumo facturacion mensual","waybill":"1234567890123456789012","pickupData":{"pickupDateTime":"2/4/2023 12:23:00 PM","originAcronym":"MTY","originName":"Monterrey"},"returnDocumentData":{"nil":true},"statusENG":"DELIVERED","serviceDescriptionSPA":"terrestre consumo facturacion mensual","serviceId":"70","waybillReplaceData":{"nil":true},"dimensions":{"volumetricWeight":"0.00000","length":"0","width":"0","weight":"1.0","height":"0"}},{"deliveryData":{"destinationAcronym":"MTY","zipCode":"64349","deliveryDateTime":"2/7/2023 5:45:00 PM","receiverName":"SOE: TEST2 TEST2","destinationName":"Monterrey"},"multipleServiceData":{"nil":true},"additionalInformation":"","internationalData":{"nil":true},"signature":"abcdef1234567811","customerInfo":{"reference":"000000123411","costsCentre":""},"shortWaybillId":"3333123411","statusSPA":"' + strCanceled + '","history":{"History":[{"exceptionCodeDetails":"","eventDateTime":"2/6/2023 11:58:00 AM","eventId":"MLOC","eventPlaceName":"Monterrey","eventDescriptionSPA":"MOVIMIENTO LOCAL EN CENTRO DE DISTRIBUCION","exceptionCodeDescriptionSPA":"AUDITORIA","eventDescriptionENG":"LOCAL MOVEMENT IN DISTRIBUTION CENTER","eventPlaceAcronym":"MTY","exceptionCode":"C06","exceptionCodeDescriptionENG":"AUDIT"},{"exceptionCodeDetails":"","eventDateTime":"2/7/2023 12:06:00 PM","eventId":"ECON","eventPlaceName":"Monterrey","eventDescriptionSPA":"En proceso para salir a reparto Monterrey","exceptionCodeDescriptionSPA":"","eventDescriptionENG":"In process to delivery Monterrey","eventPlaceAcronym":"MTY","exceptionCode":"","exceptionCodeDescriptionENG":""}]},"customerNumber":"5123411","packageType":"Sobre","serviceDescriptionENG":"terrestre consumo facturacion mensual","waybill":"1234567890123456789111","pickupData":{"pickupDateTime":"2/4/2023 12:23:00 PM","originAcronym":"MTY","originName":"Monterrey"},"returnDocumentData":{"nil":true},"statusENG":"DELIVERED","serviceDescriptionSPA":"terrestre consumo facturacion mensual","serviceId":"70","waybillReplaceData":{"nil":true},"dimensions":{"volumetricWeight":"0.00000","length":"0","width":"0","weight":"1.0","height":"0"}}]}}}}';

        return body;
    }

    private static String createBodyTokenError() {

        String body = '{"error": "invalid_client","error_description": "The given client credentials were not valid"}';

        return body;
    }   
    
    private static String createBodyError() {

        String body = '{"error": "Invalid Token"}';

        return body;
    }    
}