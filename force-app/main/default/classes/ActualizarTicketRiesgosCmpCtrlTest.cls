@isTest
public class ActualizarTicketRiesgosCmpCtrlTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.ID_Solicitud__c = '1521122';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Riesgos/Originación').getRecordTypeId();
        insert caso;
    } 

    @isTest static void custom_Metadata() {

        Test.startTest();

        String strMensaje = ActualizarTicketRiesgosCmpCtrl.obtenerMensajeMotivoDeRechazo();

        Test.stopTest();

        List<Cadena__mdt> listCustomMetadata= [SELECT Cadena__c FROM Cadena__mdt WHERE DeveloperName = 'RiesgosMotivoDeRechazoWS' LIMIT 1];
        System.assertEquals( listCustomMetadata[0].Cadena__c, strMensaje);
    }

    @isTest static void actualizarTicket_Aprobar() {


        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1 ].Id;
        String estatus = '';
        String evaluar = 'Aprobar';
        String motivoDePendiete = '';
        String motivoDeRechazo = '';
        String idSolicitud = '1521122';
        String curp = 'ABCD112233HDFABC00';

        String body = generaJson();
        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosCmpCtrl.actualizarTicketAdminsion(recordId, estatus, evaluar, motivoDePendiete, motivoDeRechazo, idSolicitud, curp);

        Test.stopTest();

        List<Case> listCasos = [SELECT Actualizaci_n_Alta_en_SAT__c FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1];
        System.assertEquals( listCasos[0].Actualizaci_n_Alta_en_SAT__c, true);
    }

    @isTest static void actualizarTicket_Pendiente() {


        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1 ].Id;
        String estatus = '';
        String evaluar = 'Pendiente';
        String motivoDePendiete = 'Prueba';
        String motivoDeRechazo = '';
        String idSolicitud = '1521122';
        String curp = 'ABCD112233HDFABC00';

        String body = generaJson();
        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosCmpCtrl.actualizarTicketAdminsion(recordId, estatus, evaluar, motivoDePendiete, motivoDeRechazo, idSolicitud, curp);

        Test.stopTest();

        List<Case> listCasos = [SELECT Actualizaci_n_Alta_en_SAT__c FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1];
        System.assertEquals( listCasos[0].Actualizaci_n_Alta_en_SAT__c, true);
    }

    @isTest static void actualizarTicket_Rechazar() {


        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1 ].Id;
        String estatus = '';
        String evaluar = 'Rechazar';
        String motivoDePendiete = '';
        String motivoDeRechazo = 'Prueba';
        String idSolicitud = '1521122';
        String curp = 'ABCD112233HDFABC00';

        String body = generaJson();
        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosCmpCtrl.actualizarTicketAdminsion(recordId, estatus, evaluar, motivoDePendiete, motivoDeRechazo, idSolicitud, curp);

        Test.stopTest();

        List<Case> listCasos = [SELECT Actualizaci_n_Alta_en_SAT__c FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1];
        System.assertEquals( listCasos[0].Actualizaci_n_Alta_en_SAT__c, true);
    }

    @isTest static void actualizarTicket_Error() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521122' LIMIT 1 ].Id;
        String estatus = '';
        String evaluar = 'Aprobar';
        String motivoDePendiete = '';
        String motivoDeRechazo = '';
        String idSolicitud = '1521122';
        String curp = 'ABCD112233HDFABC00';

        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setStatusCode(404);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        ActualizarSolicitudJSON solicitudJson = ActualizarSolicitudJSON.parse(generaActualizarSolicitudJson());

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosCmpCtrl.actualizarTicketAdminsion(recordId, estatus, evaluar, motivoDePendiete, motivoDeRechazo, idSolicitud, curp);

        Test.stopTest();

        System.assertEquals( mapActualizarTicket.get('success'), false);
    }

    static String generaJson() {

        String json = '{'+
            '\"cardApplicationId\": 1521122,'+
            '\"codigoOperacion\": \"13\",'+
            '\"descCodigoOperacion\": \"Solicitud Actualizada\",'+
            '\"result\": \"La solicitud se ha actualizado de forma correcta\",'+
            '\"queueType\": \"2\"'+
            '}';

        return json;
    }

    static String generaActualizarSolicitudJson() {

        String json = '{'+
            '\"cardApplicationId\": 1521122,'+
            '\"reasonRejected\": \"Prueba\",'+
            '\"reasonPending\": \"Prueba\",'+
            '\"codigoStatusEvaluacion\": \"01\",'+
            '\"curp\": \"ABCD112233HDFABC00\",'+
            '\"callNumber\": \"3\"'+
            '}';

        return json;
    }
}