/************************************************************************************************
Apex Class Name	:	MicroServicioActualizarCurp_Test 
Version			:	1.0
Created Date    :	26/09/2019 10:50
Function 		: 	Cubrir a la clase controladora del componente MicroServicioActualizarCurp
Cover Class		:	MicroServicioActualizarCurp
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     26/09/2019 	   Original Version
*************************************************************************************************/
@isTest
public class MicroServicioActualizarCurp_Test {

    @testSetup
    static void setupData() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_microservicio_actualizar_curp() {

        Account accTest = [SELECT CURP__c FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' ];

        Contact ctc = [SELECT Id FROM Contact WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];
        
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de CURP').getRecordTypeId();
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';

        String camposRequeridos = 'Actualizaci_n_Alta__c:Actualización,';
        camposRequeridos += 'CURP_texto__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Curp_Anterior__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Nombre_s__c:TEST,';
        camposRequeridos += 'Segundo_Apellido__c:TEST,';
        camposRequeridos += 'Primer_Apellido__c:TEST,';
        camposRequeridos += 'Actualizaci_n_de_CURP__c:CURP Duplicado,';
        camposRequeridos += 'Type:CURP Duplicado,';
        camposRequeridos += 'Actualizaci_n_de_nombre__c:No,';
        camposRequeridos += 'Actualizar_domicilio__c:No';

        Test.startTest();

        Account acc2 = MicroServicioActualizarCurp.updateSelectedAccount(accTest.Id, accTest.CURP__c);
        Map<String, Object> crearCasoCURP = MicroServicioActualizarCurp.createCaseClosedCurp(recordTypeId, accTest.Id, ctc.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        Test.stopTest();

        System.assertEquals( accTest.Id, accTest.Id);
        System.assertEquals( crearCasoCURP.get('success'), true);
    }

    @isTest static void test_MS_Curp() {
        
        Account accTest = [SELECT CURP__c FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' ];

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSCurp = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSCurp.setMethod('POST');
        mockMicroSCurp.setEndpoint('client/update/curp');
        Test.setMock(HttpCalloutMock.class, mockMicroSCurp);

        Test.startTest();

        Map<String, Object> testActualizaCurp = MicroServicioActualizarCurp.actualiza_Curp(accTest.CURP__c, 'ABCD112233HDFABC00');   
        
        Test.stopTest();

        System.assertEquals( testActualizaCurp.get('success'), true);
    }

    @isTest static void test_MS_Prod() {

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSProd = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSProd.setMethod('POST');
        mockMicroSProd.setEndpoint('products');
        Test.setMock(HttpCalloutMock.class, mockMicroSProd);
        
        Test.startTest();

        Map<String, Object> testObtienecliente = MicroServicioActualizarCurp.obtenerProductosCliente('ABCD112233HDFABC00');
        
        Test.stopTest();

        System.assertEquals( testObtienecliente.get('success'), true);
    }

    @isTest static void test_MS_Prod_Error() {

        ///
        MockHttpResponseGeneratorMicroServicios mockMicroSProd = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSProd.setMethod('POST');
        mockMicroSProd.setEndpoint('products');
        mockMicroSProd.setBody('{"code":"error","message":"the curp is not correct"}');
        mockMicroSProd.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockMicroSProd);
        
        Test.startTest();

        Map<String, Object> testObtienecliente = MicroServicioActualizarCurp.obtenerProductosCliente('ABCD112233HDFABC00');
        
        Test.stopTest();

        System.assertEquals( testObtienecliente.get('success'), false);
    }
}