@isTest
public class MicroServicioActualizacionCelularTest {

    static void init() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de Celular').getRecordTypeId();
        caso.Categor_a__c = 'Actualizar Datos';
        insert caso;

        Tarjeta__c tarjeta = new Tarjeta__c();
        tarjeta.Account__c = acc.Id;
        tarjeta.BIN__c = '111222';
        tarjeta.ltimos_4_d_gitos_tarjeta__c = '1234';
        tarjeta.D_a_Fecha_de_corte__c = '10';
        tarjeta.Donde_pag_su_tarjeta__c = 'Otro Medio';
        tarjeta.Cuando_realiz_el_pago_de_tarjeta__c = '10';
        tarjeta.Compra_diferida__c = 'Si';
        insert tarjeta;

        Validacion_Incorrecta__c validacion = new Validacion_Incorrecta__c();
        validacion.Tarjeta__c = tarjeta.Id;
        validacion.Account__c = acc.Id;
        insert validacion;
    }

    @isTest static void test_method_1() {
        
        init();

        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Celular').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos;
        camposRequeridos = 'Autenticaci_n_exitosa__c:Sí';
        camposRequeridos += ',';
        camposRequeridos += 'Celular_Nuevo__c:5511223344';
        camposRequeridos += ',';
        camposRequeridos += 'Actualizac_on_de_Celular_en_SAT__c:true';

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('movilAccount', '5511223344');

        ///
        Id idValidacion = [SELECT Id FROM Validacion_Incorrecta__c WHERE Account__r.CURP__c = 'ABCD112233HDFABC00' LIMIT 1].Id;
        Id idCaso = [SELECT Id FROM Case WHERE Account.CURP__c = 'ABCD112233HDFABC00' LIMIT 1].Id;

        Test.startTest();

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Map<String, Object> crearCasoActualizarCorreo = MicroServicioActualizacionCelular.createCaseClosedMobile(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );
    
        Account accUpdateSelected = MicroServicioActualizacionCelular.updateSelectedAccount(customer.Id, campos);

        MicroServicioActualizacionCelular.actualizaValidacionPreguntas(idValidacion, idCaso);

        MicroServicioActualizacionCelular.sendSMSmedioAltoRiesgo(customer);

        Test.stopTest();

        System.assertEquals( crearCasoActualizarCorreo.get('success'), true);
        Account accUpdate = [SELECT PersonMobilePhone, Send_SMS__c FROM Account WHERE Id =: customer.Id LIMIT 1];
        System.assertEquals( accUpdate.PersonMobilePhone, '5511223344');
        Validacion_Incorrecta__c validacionUpdate = [SELECT Caso__c FROM Validacion_Incorrecta__c WHERE Account__c =: customer.Id LIMIT 1];
        System.assertEquals( validacionUpdate.Caso__c, idCaso);
        System.assertEquals( accUpdate.Send_SMS__c, true);
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('numeroTelefonoMovil', '5511223344');
        campos.put('numeroDocumento', 'numeroDocumento');

        Test.startTest();

        Map<String, Object> actualizaCelular = MicroServicioActualizacionCelular.actualizarCelular(campos);

        Test.stopTest();

        System.assertEquals( actualizaCelular.get('success'), true);
    }
}