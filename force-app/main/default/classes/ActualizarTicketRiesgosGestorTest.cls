/**
* Nombre: ActualizarTicketRiesgosGestorTest
* Autor
* Descripcion: Test Method de la Clase ActualizarTicketRiesgosGestor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           26/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           12/03/2021      Mauricio Rosales            Ajustes para cerrar el caso al actualizar la Solicitud
* 4.0           30/08/2021      Mauricio Rosales            Validacion para codigos externos del gestor de solicitudes con pendientes de fraudes
* 5.0           22/02/2022      Mauricio Rosales            Actualizacion de Datos Gestor de Solicitudes, se mueve el llamado del Micro Servicio a la clase MicroServicioDataUpdateGestor
* --------------------------------------------------------------------------
*/
@isTest
public  class ActualizarTicketRiesgosGestorTest {
    
    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        List<Case> lstCases = new List<Case>();

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.ID_Solicitud__c = '110';
        caso.Id_Solicitud_Gestor__c = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        caso.Status = 'Autorización';
        caso.Evaluar__c = 'Aprobar';
        lstCases.add(caso);

        Case caso2 = new Case();
        caso2.AccountId = acc.Id;
        caso2.ID_Solicitud__c = '111';
        caso2.Id_Solicitud_Gestor__c = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        caso2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();
        caso2.Status = 'Autorización';
        caso2.Evaluar__c = 'Aprobar';
        caso2.CURP__c = 'ABCD112233HDFABC00';
        caso2.Fecha_de_actualizaci_n__c = System.today();
        caso2.N_mero_de_Tel_fono_M_vil__c = '5511223344';
        lstCases.add(caso2);

        insert lstCases;
    }
    
    @isTest 
    static void actualizarTicket_Aprobar() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Aprobar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('statusChangeRequest', 'true');
        mapCampos.put('requestStatus', 'APROBADA');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Aprobar_2() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Aprobar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'false');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Aprobar_2Error() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Aprobar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'false');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Aprobar_3() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', null);
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'false');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }
    
    @isTest 
    static void actualizarTicket_Aprobar_3Error() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', null);
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'false');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Aprobar_Figital() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '111' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', null);
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'false');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('recordTypeDevName', 'BackOffice_Figital');
        mapCampos.put('curp', 'ABCD112233HDFABC00');
        mapCampos.put('numTelefonoMovil', '5511223344');
        mapCampos.put('fechaActualizacion', '2022-06-16');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_PendienteFraudes() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Pendiente');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('statusChangeRequest', 'true');
        mapCampos.put('blnPendientesCredito', 'false');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_PendienteCredito() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Pendiente');
        mapCampos.put('motivoDePendiete', '7.0.- Comprobante de Domicilio - No se anexo;7.1.- Comprobante de Domicilio - Esta ilegible;27.0.-Cliente en programación de Visita de Campo- Tiempo de respuesta promedio: 1 semana a partir de cita confirmada con el cliente');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('statusChangeRequest', 'true');
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_PendienteFraudesError() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Pendiente');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('statusChangeRequest', 'true');
        mapCampos.put('blnPendientesCredito', 'false');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_PendienteCreditoError() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Pendiente');
        mapCampos.put('motivoDePendiete', '7.0.- Comprobante de Domicilio - No se anexo;7.1.- Comprobante de Domicilio - Esta ilegible');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('statusChangeRequest', 'true');
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Rechazar() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Rechazar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_RechazarError() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Rechazar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_RechazarFraudes() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud='1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Rechazar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(true, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_RechazarFraudesError() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud='1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Rechazar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest 
    static void actualizarTicket_Error() {

        String recordId = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ].Id;
        String idSolicitud = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setBody('');
        mockGestor.setStatusCode(500);
        mockGestor.setEndpoint('solicitud/' + idSolicitud);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Map<String, String> mapCampos = new Map<String, String>();
        mapCampos.put('recordId', recordId);
        mapCampos.put('evaluar', 'Aprobar');
        mapCampos.put('motivoDePendiete', '');
        mapCampos.put('IdSolicitud', idSolicitud);
        ///
        mapCampos.put('blnPendientesCredito', 'true');
        mapCampos.put('blnPendientesFraudes', 'true');
        mapCampos.put('idEvaluacionesC', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idEvaluacionesF', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');
        mapCampos.put('idCustom', '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f');

        Test.startTest();

        Map<String, Object> mapActualizarTicket = ActualizarTicketRiesgosGestor.actualizarTicketGestor(mapCampos);

        Test.stopTest();

        System.assertEquals(false, mapActualizarTicket.get('success'));
    }

    @isTest
    static void getUserInfoTest() {

        List<Case> listCasos = [SELECT Id FROM Case WHERE ID_Solicitud__c = '110' LIMIT 1 ];

        Test.startTest();

        Map<String, Object> mapResult = ActualizarTicketRiesgosGestor.getUserInfo(listCasos[0].Id);

        Test.stopTest();

        System.assertEquals(true, mapResult.get('success'));
    }
}