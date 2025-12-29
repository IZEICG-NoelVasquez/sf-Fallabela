/**
* Nombre: AuthenticateCustomerControllerTest
* Autor
* Descripcion: Test Method de la Clase AuthenticateCustomerController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           15/01/2021      Mauricio Rosales            Filtrar Categorias para Casos sin Movimientos creados desde el MS Movimientos
* 3.0           10/02/2021      Mauricio Rosales            Validaciones OTP Dinamicas
* 4.0           16/04/2021      Mauricio Rosales            Se mueve la consulta de Metodo de Contacto a la clase PickListCaseOriginController
* 5.0           23/11/2021      Mauricio Rosales            Se agarega try catch en el metodo createCaseByRT() para regresar los errores al componente
* 6.0           10/11/2022      Mauricio Rosales            Catalogo Tipo de Productos, Custom Metadata Tipo_de_Producto__mdt
* --------------------------------------------------------------------------
*/
@isTest
public class AuthenticateCustomerControllerTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case caso = new Case();
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulta de Saldos y Movimientos').getRecordTypeId();
        caso.AccountId = acc1.Id;
        caso.Categor_a__c = 'Consultas';
        insert caso;
    }

    @isTest static void test_method_1() {

        init();
        
        Boolean blnIsCommunity = false;
        Boolean blnEsClienteAnonimo = false;
        Boolean blnEsSoriban = false;
        Boolean blnAuthSinCel = false;
        String strParentezco = 'BE';
        Boolean blnIsMovimiento = true;

        List<Object> listCategorias = new List<Object>();
        Map<String,List<Object>> mapSubCategorias = new Map<String,List<Object>>();

        String strCategoria = '';

        Boolean blnCasoSinMovimientos = false;

        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);
        ///
        strCategoria = 'Problema Transacción';
        mapSubCategorias = AuthenticateCustomerController.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);
        
        blnIsMovimiento = false;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);
        System.debug('listCategorias:  ' + listCategorias);
        strCategoria = 'Reporte de Tarjeta';
        mapSubCategorias = AuthenticateCustomerController.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        strParentezco = '';
        blnEsSoriban = true;
        blnAuthSinCel = true;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);
        System.debug('listCategorias:  ' + listCategorias);        
        strCategoria = 'Reporte de Tarjeta';
        mapSubCategorias = AuthenticateCustomerController.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);


        blnEsSoriban = false;
        blnAuthSinCel = false;
        blnEsClienteAnonimo = true;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);
        System.debug('listCategorias:  ' + listCategorias);        
        strCategoria = 'Reporte de Tarjeta';
        mapSubCategorias = AuthenticateCustomerController.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);


        blnIsCommunity = true;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        blnEsClienteAnonimo = false;
        blnIsCommunity = false;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        blnIsCommunity = true;
        listCategorias = AuthenticateCustomerController.getCategories(blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        ///
        Map<String, String> mapRecordTypes = AuthenticateCustomerController.getCaseRecordTypesByName();
        System.debug('mapRecordTypes:  ' + mapRecordTypes);

        String strRecordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cosulta_de_Saldos_y_Movimientos').getRecordTypeId();
        
        System.debug('strRecordType:  ' + strRecordType);

        ///
        User usr = AuthenticateCustomerController.getAgent();

        ///
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        System.debug('customer.Id:  ' + customer.Id);
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        System.debug('person.Id:  ' + person.Id);
        Boolean blnAltoRiesgo = true;
        blnEsClienteAnonimo = true;
        Map<String, Object> mapClienteAnonimo = new Map<String, Object>(); // <------------
        Boolean blnEsRetipificacion = true;
        String caseId = null; // <----------------
        String strMetodoContactoValue = '';
        String strNumeroDeTarjetaValue = '123456*****1234';
        //String strMovimientosList = null;
        String strMovimientosList = '[{"numeroExtracto":"4","numeroMovimientoExtracto":"2","numeroOperacionCuota":"0","numeroFinanciacion":"0","titularidad":"Titular","contrato":"00010252000000002915","fechaHoraTransaccion":"2019-05-05T00:00:00.000Z","montoLocal":173.33,"identificador":"1230012300","blnPlanPagosConMovs":true}]';

        String strCaseByRT = AuthenticateCustomerController.createCaseByRT( strRecordType, customer.Id, person.Id, strCategoria, blnAltoRiesgo, blnEsClienteAnonimo, mapClienteAnonimo, blnEsRetipificacion, caseId, strMetodoContactoValue, strNumeroDeTarjetaValue, strMovimientosList);

        ///
        Account AccountGetCustomer = AuthenticateCustomerController.getCustomer(customer.Id);

        ///
        Id idCaso1 = [SELECT Id FROM Case WHERE AccountId =: customer.Id LIMIT 1].Id;
        Account AccountgetCustomerByCaseId = AuthenticateCustomerController.getCustomerByCaseId(idCaso1);

        ///
        Map<String, Object> mapTest1 = AuthenticateCustomerController.getPortalFieldsConfig(idCaso1);

        ///
        AuthenticateCustomerController.actualizarNuevoCelular(idCaso1, true);

        ///
        AuthenticateCustomerController.actualizarPANCelular(idCaso1, true);

        ///
        Account AccountGetCustomerByCURP = AuthenticateCustomerController.getCustomerByCURP('ABCD112233HDFABC00');

        ///
        Account AccountGetCustomerByicAcc = AuthenticateCustomerController.getCustomerById(customer.Id);

        ///
        AuthenticateCustomerController.sendSMSmedioAltoRiesgo(customer);

        ///
        Map<String,List<Object>> mapListaRiesgos = AuthenticateCustomerController.getInfoAltoRiesgo();
    }

    @isTest static void test_method_2() {

        ///
        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();
        mockProductos.setMethod('POST');
        mockProductos.setEndpoint('products');        
        Test.setMock(HttpCalloutMock.class, mockProductos);
        Map<String, Object> mapProductos = AuthenticateCustomerController.obtenerProductosCliente('ABCD112233HDFABC00');

        ///
        MockHttpResponseGeneratorMicroServicios mockSaldos = new MockHttpResponseGeneratorMicroServicios();
        mockSaldos.setMethod('POST');
        mockSaldos.setEndpoint('product/balances');        
        Test.setMock(HttpCalloutMock.class, mockSaldos);
        Map<String, Object> mapSaldos = AuthenticateCustomerController.obtenerSaldosCliente( 'codigoProducto', 'codigoSubProducto', 'identificadorProducto', 'identificador');
    }

    @isTest static void test_MS_Error() {

        ///
        MockHttpResponseGeneratorMicroServicios mockProductos = new MockHttpResponseGeneratorMicroServicios();
        mockProductos.setMethod('POST');
        mockProductos.setEndpoint('products');
        mockProductos.setBody('{"code":"error","message":"the curp is not correct"}');
        mockProductos.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockProductos);

        Test.startTest();

        Map<String, Object> mapProductos = AuthenticateCustomerController.obtenerProductosCliente('ABCD112233HDFABC00');

        Test.stopTest();

        System.assertEquals( mapProductos.get('success'), false);
    }

    @isTest static void validacionesOTPDinamicasTest() {

        Test.startTest();

        Map<String, Object> mapValidaciones = AuthenticateCustomerController.validacionesOTPDinamicas();

        Test.stopTest();

        System.assertEquals( mapValidaciones.isEmpty(), false);
    }

    @isTest static void createCaseByRTTest_ErrorDml() {

        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'CaseTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        Account acc1 = new Account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;

        Case caseEmboce = new Case();
        caseEmboce.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        caseEmboce.Categor_a__c = 'Información de Producto';
        caseEmboce.AccountId = acc1.Id;
        caseEmboce.Tiene_la_tarjeta_en_su_poder__c = 'SI';
        caseEmboce.Tuvo_contacto_con_el_establecimiento__c = 'SI';
        insert caseEmboce;

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        List<Contact> person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String strCategoria = 'Cargo no reconocido';
        Boolean blnAltoRiesgo = false;
        Boolean blnEsClienteAnonimo = false;
        Map<String, Object> mapClienteAnonimo = new Map<String, Object>();
        Boolean blnEsRetipificacion = false;
        String caseId = null;
        String strMetodoContactoValue = '';
        String strNumeroDeTarjetaValue = '123456*****1234';
        String strMovimientosList = null;

        Test.startTest();

            try {

                AuthenticateCustomerController.createCaseByRT( recordTypeId, acc1.Id, person[0].Id, strCategoria, blnAltoRiesgo, blnEsClienteAnonimo, mapClienteAnonimo, blnEsRetipificacion, caseId, strMetodoContactoValue, strNumeroDeTarjetaValue, strMovimientosList);
            
            } catch(Exception ex) {

                System.debug('Error:  ' + ex);
            }

        Test.stopTest();
    }

    @isTest static void createCaseByRTTest_Error() {

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        String strCategoria = 'Cargo no reconocido';
        Boolean blnAltoRiesgo = false;
        Boolean blnEsClienteAnonimo = false;
        Map<String, Object> mapClienteAnonimo = new Map<String, Object>();
        Boolean blnEsRetipificacion = false;
        String caseId = null;
        String strMetodoContactoValue = '';
        String strNumeroDeTarjetaValue = '123456*****1234';
        String strMovimientosList = null;

        Test.startTest();

            try {
                
                AuthenticateCustomerController.createCaseByRT( recordTypeId, '123456789012345', '123456789012345', strCategoria, blnAltoRiesgo, blnEsClienteAnonimo, mapClienteAnonimo, blnEsRetipificacion, caseId, strMetodoContactoValue, strNumeroDeTarjetaValue, strMovimientosList);
            
            } catch(Exception ex) {

                System.debug('Error:  ' + ex);
            }

        Test.stopTest();
    }

    @isTest static void getMetadataProductTypeCatalog() {

        Map<String, Object> mapResult = new Map<String, Object>();

        Test.startTest();

        mapResult = AuthenticateCustomerController.getMetadataProductTypeCatalog();

        Test.stopTest();

        System.assertEquals( true, mapResult.get('success'));
    }
}