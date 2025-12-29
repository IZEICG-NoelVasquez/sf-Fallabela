@isTest
public class OtrosDatosControllerTest {

    static void init() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

    }

    @isTest static void test_method_1() {

        init();

        ///
        Map<String, String> mapNacionalidades = OtrosDatosController.getNacionalidades();

        ///
        List<String> listActividades = OtrosDatosController.getActividades();

        ///
        Map<String, String> mapProfesiones = OtrosDatosController.getProfesiones();

        ///
        Map<String, String> mapGeneros = OtrosDatosController.getSexos();

        ///
        Map<String, String> mapEstados = OtrosDatosController.getEstados();

        ///
        Map<String, String> mapEstadoCivil = OtrosDatosController.getEstadoCivil();

        ///
        Id idAcc = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'].Id;
        Account accOtrosDatos = OtrosDatosController.getOtrosDatos(idAcc);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('nacionalidadTexto', 'MEXICO');
        campos.put('actividadGiro', 'AUTOMOTRIZ');
        campos.put('codigoPaisNacimientoTexto', 'MEXICO');
        campos.put('profesionClienteTexto', 'INGENIERO');
        campos.put('entidadFedNacimientoTexto', 'AGUASCALIENTES');
        campos.put('fiel', 'FIEL01020304050607');
        campos.put('generoTexto', 'VARON');
        campos.put('estadoCivilTexto', 'CASADO/A');
        campos.put('numeroTelefonoCasa', '5511223344');
        campos.put('numeroTelefonoTrabajo', '5511221122');
        campos.put('rfc', 'ABCD112233ABC');
        campos.put('publicidad', 'true');

        Account accUpdate = OtrosDatosController.updateAccount(idAcc, campos);

        ///
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Campos_Regulatorios').getRecordTypeId();
        Account customer = [SELECT Id FROM Account WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        Contact person = [SELECT Id FROM Contact WHERE LastName = 'Test112233' AND CURP__c = 'ABCD112233HDFABC00'];
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos;
        camposRequeridos = 'Nacionalidad__c:MEXICO';
        camposRequeridos += ',';
        camposRequeridos += 'Actividad_o_giro_del_negocio__c:AUTOMOTRIZ';
        camposRequeridos += ',';
        camposRequeridos += 'Pa_s_Nacimiento__c:MEXICO';
        camposRequeridos += ',';
        camposRequeridos += 'Ocupaci_n_o_profesi_n__c:INGENIERO';
        camposRequeridos += ',';
        camposRequeridos += 'Entidad_Federativa_de_NacimientoCR__c:AGUASCALIENTES';
        camposRequeridos += ',';
        camposRequeridos += 'Fiel__c:FIEL01020304050607';
        camposRequeridos += ',';
        camposRequeridos += 'G_nero__c:VARON';
        camposRequeridos += ',';
        camposRequeridos += 'Estado_Civil__c:CASADO/A';
        camposRequeridos += ',';
        camposRequeridos += 'Tel_fono_fijo_casa__c:5511223344';
        camposRequeridos += ',';
        camposRequeridos += 'Tel_fono_fijo_oficina__c:5511221122';
        camposRequeridos += ',';
        camposRequeridos += 'RFC_Caso__c:ABCD112233ABC';
        camposRequeridos += ',';
        camposRequeridos += 'Publicidad__c:true';
        
        Map<String, Object> crearCasoRegulatorios = OtrosDatosController.createCaseClosedCamposReg(recordTypeId, customer.Id, person.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );
    }

    @isTest static void test_method_2() {

        MockHttpResponseGeneratorMicroServicios mockMicroSer = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSer.setMethod('POST');
        mockMicroSer.setEndpoint('client/information/update');
        mockMicroSer.setMicroServicio('MicroServicioActualizacionDatosCliente');

        Test.setMock(HttpCalloutMock.class, mockMicroSer);

        ///
        Map<String, String> campos = new Map<String, String>();
        campos.put('rfc', 'ABCD112233ABC');
        campos.put('publicidad', 'true');
        campos.put('numeroTelefonoCasa', '5511223344');
        campos.put('numeroTelefonoTrabajo', '5511221122');
        campos.put('profesionCliente', '031');
        campos.put('codigoPaisNacimiento', '484');
        campos.put('estadoCivil', '3');
        campos.put('nacionalidad', '484');
        campos.put('genero', 'V');
        campos.put('numeroDocumento', 'ABCD112233HDFABC00');

        Map<String, Object> actualizaRegulatorios = OtrosDatosController.otrosDatosF(campos);
    }

}