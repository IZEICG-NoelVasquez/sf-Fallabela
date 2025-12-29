/************************************************************************************************
Apex Class Name	:	microServicioGetUser_Test 
Version			:	1.0
Created Date    :	15/08/2019 15:34
Function 		: 	Cubrir a la clase controladora del componente microServicioGetUser
Cover Class		:	microServicioGetUser
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     15/08/2019 	   Original Version
*************************************************************************************************/
@isTest
public class microServicioGetUser_Test {
     @isTest static void test_microservicio_get_user() {
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'SIMF831004HDFLGR06';
        insert acc1;
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/get/user');
        //mockMicroSer.generarToken();
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        
        String tipoDocumento = 'INE';
        String numeroDocumento = 'ABCD112233HDFABC00';

        Map<String, String> params = new Map<String, String>();
        params.put('tipoDocumento', tipoDocumento); 
        params.put('numeroDocumento', numeroDocumento);
		System.debug('params1 ' +params);
        MicroServicioGetUser msGetUserv = new MicroServicioGetUser();
        GetUserJSON MSgUser = msGetUserv.obtenerGetUser(params);
		GetUserJSON guserj = new GetUserJSON();
        String json = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Operación Exitosa\"}}}';
         
        GetUserJSON.parse(json);
        System.debug('MSgUser:  ' + MSgUser);

        Map<String, Object> testGetUser = MicroServicioGetUser.consulta_Get_User(tipoDocumento, numeroDocumento);

       

    }

}