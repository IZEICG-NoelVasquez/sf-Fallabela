/**
* Nombre: MicroServicioActualizacionDomicilioTest
* Autor: ---
* Descripcion: Test Method de la Clase MicroServicioActualizacionDomicilio
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     ---
* 2.0           21/07/2021      Mauricio Rosales        Manejo de Error devuelto por el MicroServicio
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioActualizacionDomicilioTest {

    static void init() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Estado__c estado = new Estado__c();
        estado.Name = 'Estado';
        estado.Codigo__c = 'TST';
        insert estado;

        Municipio__c municipio = new Municipio__c();
        municipio.Name = 'Municipio';
        municipio.Estado_Lookup__c = estado.Id;
        insert municipio;

        Colonia__c colonia = new Colonia__c();
        colonia.Name = 'Colonia';
        colonia.Municipio_Lookup__c = municipio.Id;
        colonia.C_digo_Postal__c = '12345';
        insert colonia;
    }

    @isTest static void test_method_1() {
        
        init();

        ///
        Estado__c edo = MicroServicioActualizacionDomicilio.obtenerEstado('Estado');

        ///
        Municipio__c mun = MicroServicioActualizacionDomicilio.obtenerMunicipio('Municipio', edo.Id);

        ///
        Colonia__c col = MicroServicioActualizacionDomicilio.obtenerColonia('Colonia', mun.Id);

        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Domicilio').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos;
        camposRequeridos = 'Estado_Direccion__c:';
        camposRequeridos += edo.Id;
        camposRequeridos += ',';
        camposRequeridos += 'Municipio_Direccion__c:';
        camposRequeridos += mun.Id;
        camposRequeridos += ',';
        camposRequeridos += 'Calle__c:Calle';
        camposRequeridos += ',';
        camposRequeridos += 'Exterior__c:123';
        camposRequeridos += ',';
        camposRequeridos += 'Colonia_Texto__c:Colonia';
        camposRequeridos += ',';
        camposRequeridos += 'C_digo_Postal_Texto__c:12345';
        
        Map<String, Object> crearCasoActualizarCorreo = MicroServicioActualizacionDomicilio.createCaseClosedDomicilio(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('tipoBarrio', 'tipoBarrio');
        campos.put('numeroVivienda', 'numeroVivienda');
        campos.put('nombreVia', 'nombreVia');
        campos.put('descripcionBarrio', 'descripcionBarrio');
        campos.put('codigoTipoVia', 'codigoTipoVia');
        campos.put('region', 'region');
        campos.put('codigoPostal', 'codigoPostal');

        Account accUpdate = MicroServicioActualizacionDomicilio.updateSelectedAccount(customer.Id, campos);
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('tipoBarrio', 'tipoBarrio');
        campos.put('numeroVivienda', 'numeroVivienda');
        campos.put('nombreVia', 'nombreVia');
        campos.put('descripcionBarrio', 'descripcionBarrio');
        campos.put('codigoTipoVia', 'codigoTipoVia');
        campos.put('codigoRegion', 'codigoRegion');
        campos.put('codigoPostal', 'codigoPostal');
        campos.put('numeroDocumento', 'numeroDocumento');

        Map<String, Object> actualizaDomicilio = MicroServicioActualizacionDomicilio.actualizarDomicilio(campos);

    }

    @isTest static void actualizarDomicilio_Error() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');
        mockMicroSer.setBody('{"code":"error","message":"Invalid request data"}');
        mockMicroSer.setStatusCode(400);

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Map<String, String> campos = new Map<String, String>();
        campos.put('tipoBarrio', 'tipoBarrio');
        campos.put('numeroVivienda', 'numeroVivienda');
        campos.put('nombreVia', 'nombreVia');
        campos.put('descripcionBarrio', 'descripcionBarrio');
        campos.put('codigoTipoVia', 'codigoTipoVia');
        campos.put('codigoRegion', 'codigoRegion');
        campos.put('codigoPostal', 'codigoPostal');
        campos.put('numeroDocumento', 'numeroDocumento');

        Test.startTest();

        Map<String, Object> actualizaDomicilio = MicroServicioActualizacionDomicilio.actualizarDomicilio(campos);

        Test.stopTest();

        System.assertEquals( actualizaDomicilio.get('success'), false);
    }

    @isTest static void actualizarDomicilio_Catch() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');
        mockMicroSer.setBody('');
        mockMicroSer.setStatusCode(200);

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        Map<String, String> campos = new Map<String, String>();
        campos.put('tipoBarrio', 'tipoBarrio');
        campos.put('numeroVivienda', 'numeroVivienda');
        campos.put('nombreVia', 'nombreVia');
        campos.put('descripcionBarrio', 'descripcionBarrio');
        campos.put('codigoTipoVia', 'codigoTipoVia');
        campos.put('codigoRegion', 'codigoRegion');
        campos.put('codigoPostal', 'codigoPostal');
        campos.put('numeroDocumento', 'numeroDocumento');

        Test.startTest();

        Map<String, Object> actualizaDomicilio = MicroServicioActualizacionDomicilio.actualizarDomicilio(campos);

        Test.stopTest();

        System.assertEquals( actualizaDomicilio.get('success'), false);
    }
}