/************************************************************************************************
Apex Class Name	:	MicroServicioSendNotification_Test 
Version			:	1.0
Created Date    :	02/09/2019 10:39
Function 		: 	Cubrir a la clase MSSendNotification
Cover Class		:	MicroServicioSendNotification
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     15/08/2019 	   Original Version
*************************************************************************************************/
@isTest
public class MicroServicioSendNotification_Test {
     @isTest static void test_microservicio_send_notification() {
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'SIMF831004HDFLGR06';
        insert acc1;
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/get/data');
        //mockMicroSer.generarToken();
            
       // Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        String tipoDocumento = 'INE';
        String numeroDocumento = 'ABCD112233HDFABC00';
        String tipo = 'SMS';
        String inicio = 'P';
        String mensaje = 'ERLA GABRIELA SANDRA CECILIA TORRES GONZALEZ VELAZCO su aclaracion 485706 se dictamino a favor. Validar en su siguiente edo de cuenta. FALABELLA SORIANA Dudas: 018007674262.';
        String numeroTelefono = '8129386103';
        String codigoArea = '00521';
        String curp = acc1.CURP__c;
        MicroServicioSendNotification.Casos caso = new MicroServicioSendNotification.Casos();
        caso.tipo = tipo;
        caso.inicio = inicio;
        caso.mensaje = mensaje;
        caso.numeroTelefono = numeroTelefono;
        caso.codigoArea = codigoArea;
        caso.curp = curp;
        List<MicroServicioSendNotification.Casos> listCasos = new List<MicroServicioSendNotification.Casos>();
        listCasos.add(caso);
        MicroServicioSendNotification.send_notification(listCasos);
        Map<String, String> params = new Map<String, String>();
        params.put('tipo', tipo); 
        params.put('inicio', inicio);
        params.put('mensaje', mensaje);
        params.put('numeroTelefono', numeroTelefono);
        params.put('codigoArea', codigoArea);
        params.put('curp', curp);
		System.debug('params1 ' +params);
        MicroServicioSendNotification msSendNotificationv = new MicroServicioSendNotification();
        SendNotificationJSON MSsNotification = msSendNotificationv.getSendNotification(params);
		SendNotificationJSON snotificationj = new SendNotificationJSON();
        String json = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Operación Exitosa\"}}}';
         
        SendNotificationJSON.parse(json);
        System.debug('MSsNotification:  ' + MSsNotification);

        MicroServicioSendNotification.send_notification_future(tipo, inicio, mensaje, numeroTelefono,codigoArea,curp);
    }

    @isTest
    static void getSendNotificationTest() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/send/message');
        mockMicroSer.setBody('{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"Operación Exitosa"}}}');
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Map<String,String> params = new Map<String,String>();

        SendNotificationJSON response;

        Test.startTest();

        MicroServicioSendNotification msSendNotification = new MicroServicioSendNotification();
        response = msSendNotification.getSendNotification(params);

        Test.stopTest();

        System.assertEquals('ok', response.code);
    }
}