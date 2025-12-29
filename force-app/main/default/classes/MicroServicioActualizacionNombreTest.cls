@isTest
public class MicroServicioActualizacionNombreTest {

    static void init() {

        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
    }

    @isTest static void test_method_1() {

        init();

        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Correo').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos;
        camposRequeridos = 'Nombre_s__c:Nombre Paterno Materno';

        Map<String, Object> crearCasoActualizarCorreo = MicroServicioActualizacionNombre.createCaseClosedName(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('nombres', 'nombres');
        campos.put('apellidos', 'apellidos');

        Account accUpdate = MicroServicioActualizacionNombre.updateSelectedAccount(customer.Id, campos);
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioCustomerData');

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('nombres', 'nombres');
        campos.put('apellidoPaterno', 'apellidoPaterno');
        campos.put('apellidoMaterno', 'apellidoMaterno');
        campos.put('numeroDocumento', 'numeroDocumento');

        Map<String, Object> actualizaNombre = MicroServicioActualizacionNombre.actualizarNombre(campos);

    }
}