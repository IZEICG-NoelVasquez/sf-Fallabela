/**
* Nombre: MicroServicioGestorIdSolicitudTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioGestorIdSolicitud
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/06/2021      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioGestorIdSolicitudTest {

    @isTest static void getIdRequest_Success() {

        String body = '{"code":"002","message":"Petición Procesada","data":[{"numero":"123","tipo_solicitud":1,"estado":6,"fecha":"test","productos":[{"id":"test123","tipo":2}]}]}';

        MockHttpResponseGeneratorGestor mockMSGestorIdSolicitud = new MockHttpResponseGeneratorGestor();
        mockMSGestorIdSolicitud.setMicroServicio('ConsultaSolicitudGestor');
        mockMSGestorIdSolicitud.setBody(body);
        mockMSGestorIdSolicitud.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockMSGestorIdSolicitud);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioGestorIdSolicitud.getIdRequest( 'ABCD901201HDFBCD01', '1');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getIdRequest_Error() {

        MockHttpResponseGeneratorGestor mockMSGestorIdSolicitud = new MockHttpResponseGeneratorGestor();
        mockMSGestorIdSolicitud.setMicroServicio('ConsultaSolicitudGestor');
        mockMSGestorIdSolicitud.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockMSGestorIdSolicitud);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioGestorIdSolicitud.getIdRequest( 'ABCD901201HDFBCD01', '1');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }

    @isTest static void getIdRequest_Catch() {

        MockHttpResponseGeneratorGestor mockMSGestorIdSolicitud = new MockHttpResponseGeneratorGestor();
        mockMSGestorIdSolicitud.setBody('');
        Test.setMock(HttpCalloutMock.class, mockMSGestorIdSolicitud);

        Test.startTest();

        Map<String, Object> mapResult = MicroServicioGestorIdSolicitud.getIdRequest( 'ABCD901201HDFBCD01', '1');

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), false);
    }
}