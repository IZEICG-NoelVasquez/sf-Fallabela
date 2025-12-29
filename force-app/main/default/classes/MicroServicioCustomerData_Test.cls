/************************************************************************************************
Apex Class Name	:	MicroServicioCustomerData_Test 
Version			:	1.0
Created Date    :	20/08/2019 12:55
Function 		: 	Cubrir a la clase controladora del componente MicroServicioCustomerData
Cover Class		:	MicroServicioCustomerData
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     20/08/2019 	   Original Version
*************************************************************************************************/
@isTest
public class MicroServicioCustomerData_Test {
     @isTest static void test_microservicio_customer_data() {
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'SIMF831004HDFLGR06';
        insert acc1;
        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/get/data');
        //mockMicroSer.generarToken();
            
        Test.setMock(HttpCalloutMock.class, mockMicroSer);
        String numeroDocumento = 'ABCD112233HDFABC00';

        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);
		System.debug('params1 ' +params);
        MicroServicioCustomerData msCustomerData = new MicroServicioCustomerData();
        CustomerDataJSON MSCD = msCustomerData.obtenerCustomerData(params);
		CustomerDataJSON customerDj = new CustomerDataJSON();
        String json = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"Operación Exitosa\"}}}';
         
        CustomerDataJSON.parse(json);
        System.debug('MSCD:  ' + MSCD);

        Map<String, Object> testCustomerData = MicroServicioCustomerData.consulta_Customer_Data(numeroDocumento);

       

    }

}