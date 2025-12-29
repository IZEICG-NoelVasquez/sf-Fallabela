/**
* Nombre: MicroServicioDataUpdateGestorTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioDataUpdateGestor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/02/2022      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioDataUpdateGestorTest {
    
    @isTest static void actualizarTicket_Error() {

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(500);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('custom/1234567890');
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msActualizarTk = new MicroServicioDataUpdateGestor();

        Test.startTest();

        Map<String,Object> mapResult = msActualizarTk.actualizarTicket('', 'custom/1234567890', true);

        Test.stopTest();

        System.assertEquals(false, Boolean.valueOf(mapResult.get('isSuccess')));
    }

    @isTest static void actualizarTicket_Catch() {

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('custom/1234567890');
        mockGestor.setBody(null);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msActualizarTk = new MicroServicioDataUpdateGestor();

        Test.startTest();

        Map<String,Object> mapResult = msActualizarTk.actualizarTicket('', 'custom/1234567890', true);

        Test.stopTest();

        System.assertEquals(false, Boolean.valueOf(mapResult.get('isSuccess')));
    }

    @isTest static void validateResponse() {

        Map<String,Object> mapResponse = new Map<String,Object>();
        mapResponse.put('isSuccess', true);
        mapResponse.put('resultGenericResponseGestor', 'Test');
        mapResponse.put('currentClassName', 'ClassTest');
        mapResponse.put('error', '');

        Test.startTest();

        Map<String,Object> mapResult = MicroServicioDataUpdateGestor.validateResponse(mapResponse);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResult.get('success')));
    }
    
    @isTest static void validateResponse_Errores() {

        Map<String,Object> mapResponse = new Map<String,Object>();
        mapResponse.put('isSuccess', false);
        mapResponse.put('resultGenericResponseGestor', null);
        mapResponse.put('currentClassName', 'ClassTest');
        mapResponse.put('error', 'ErrorTest');

        Test.startTest();

        Map<String,Object> mapResult = MicroServicioDataUpdateGestor.validateResponse(mapResponse);

        Test.stopTest();

        System.assertEquals(false, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void updateGestorCustom_CreditLimit() {

        String customId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('custom/' + customId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('creditLimit', '15000');        
        mapFields.put('customId', customId);
        mapFields.put('evaluacionId', evaluacionId);

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateGestorCustom(msDataUpdate, mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }

    @isTest static void updateGestorCustom_CodigoOperacion() {

        String customId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';
        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('custom/' + customId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('codigoOperacion', '02');
        mapFields.put('glosaCodigoOperacion', 'TEST');
        mapFields.put('customId', customId);
        mapFields.put('evaluacionId', evaluacionId);

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateGestorCustom(msDataUpdate, mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }

    @isTest static void updateGestorCustom_MarcaDeSeguridad() {

        String customId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('custom/' + customId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('customId', customId);
        mapFields.put('back_office', 'back_office');

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateGestorCustom(msDataUpdate, mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }

    @isTest static void updateGestorEvaluaciones() {

        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('evaluaciones/' + evaluacionId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('creditLimit', '15000');        
        mapFields.put('evaluacionId', evaluacionId);

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateGestorEvaluaciones(msDataUpdate, mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }

    @isTest static void updateGestorTelefonos() {

        String telefonoId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('telefonos/' + telefonoId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Map<String, String> mapFields = new Map<String,String>();
        mapFields.put('mobilePhone', '5215511223344');        
        mapFields.put('telefonoId', telefonoId);

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateGestorTelefonos(msDataUpdate, mapFields);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }

    @isTest static void updateEvaluacionesMotor() {

        String evaluacionId = '1a2b3c4d-1a2b-1234-abcd-1a2b3c4d5e6f';

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(202);
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setEndpoint('evaluaciones/' + evaluacionId);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        MicroServicioDataUpdateGestor msDataUpdate = new MicroServicioDataUpdateGestor();

        Test.startTest();

        Map<String,Object> mapResponse = MicroServicioDataUpdateGestor.updateEvaluacionesMotor(evaluacionId, 13, msDataUpdate);

        Test.stopTest();

        System.assertEquals(true, Boolean.valueOf(mapResponse.get('isSuccess')));
    }
}