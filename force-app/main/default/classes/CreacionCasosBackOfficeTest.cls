/**
* Nombre: CrearCasosGestorBackOfficeTest
* Autor
* Descripcion: Test Method de la Clase CrearCasosGestorBackOffice
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           17/01/2022      Mauricio Rosales            Integarcion con el Gestor de Solicitudes
* 3.0           28/02/2022      Mauricio Rosales            Validacion de Solicitudes con Rechazo de Fraudes
* --------------------------------------------------------------------------
*/
@isTest
public class CreacionCasosBackOfficeTest {

    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.ID_Solicitud__c = '300011223';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        insert caso;
    }

    @isTest static void crearCasoBackOffice_Exito() {

        Map<String, String> campos = new Map<String, String>();
        campos.put('cardapplicationid', '300012345');

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();      
        mockGestor.setBody(generaJsonGestor());
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Test.startTest();
        
        Map<String, Object> mapResult = CreacionCasosBackOffice.crearCasoBackOffice(campos);

        Test.stopTest();

        System.assertEquals( true, mapResult.get('success'));
    }

    @isTest static void crearCasoBackOffice_SinF2() {

        Map<String, String> campos = new Map<String, String>();
        campos.put('cardapplicationid', '300012345');

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();      
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Test.startTest();
        
        Map<String, Object> mapResult = CreacionCasosBackOffice.crearCasoBackOffice(campos);

        Test.stopTest();

        System.assertEquals( false, mapResult.get('success'));
        System.assertEquals( 'No_se_encontro_numero_llamada_f2', String.valueOf(mapResult.get('errorMessage')));
    }

    @isTest static void crearCasoBackOffice_NoSeEncontroSolicitud() {

        Map<String, String> campos = new Map<String, String>();
        campos.put('cardapplicationid', '300012345');

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();      
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setStatusCode(500);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Test.startTest();
        
        Map<String, Object> mapResult = CreacionCasosBackOffice.crearCasoBackOffice(campos);

        Test.stopTest();

        System.assertEquals( false, mapResult.get('success'));
        System.assertEquals( 'No_se_encontro_la_solicitud', String.valueOf(mapResult.get('errorMessage')));
    }

    @isTest static void validatePendings_Credito() {

        Map<String,Object> mapFields = new Map<String,Object>();
        mapFields.put('ownerCredito', false);
        mapFields.put('dataUpdateValue', 'Ambos');
        mapFields.put('commetsValue', 'Test');
        mapFields.put('queueFigital', false);

        List<Case> lstCases = [SELECT Id FROM Case WHERE ID_Solicitud__c = '300011223' LIMIT 1 ];

        mapFields.put('caseId', lstCases[0].Id);

        Test.startTest();

        Map<String, Object> mapResult = CreacionCasosBackOffice.validatePendings(mapFields);

        Test.stopTest();

        System.assertEquals( true, Boolean.valueOf(mapResult.get('success')));
    }

    @isTest static void crearCasoBackOffice_Formalizada() {

        Map<String, String> campos = new Map<String, String>();
        campos.put('cardapplicationid', '300012345');

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();      
        mockGestor.setBody(generaJsonGestorFormalizada());
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        Test.startTest();
        
        Map<String, Object> mapResult = CreacionCasosBackOffice.crearCasoBackOffice(campos);

        Test.stopTest();

        System.assertEquals( false, mapResult.get('success'));
        System.assertEquals( 'Solicitud_formalizada', String.valueOf(mapResult.get('errorMessage')));
    }

    static String generaJsonGestor() {

        String json ='{"code":"002","message":"Petición Procesada","data":{"solicitud":{"id":"5086f68f-cbcb-4951-934d-d50a96bf9c53","numero":300012345,"fecha_solicitud":"2021-09-30 16:15:13.989538629 +0000 UTC","tipo":1,"estado":3,"canal":1,"oficina_genera_solicitud":24,"fecha_creacion_gestor":"2021-09-30 16:15:13.989538629 +0000 UTC","fecha_actualizacion_estado":"2021-09-30 16:20:53.854078028 +0000 UTC","usuario":"usuariomonitoreo1@falabella.com.mx","datos_identificacion":{"tipo":1,"numero":"ABCD112233HDFABC00","numero_serie":"N/I","bloqueo":1},"datos_contacto":{"email":"y@e.com","telefonos":[{"id":"d392a7e4-08d0-4fd9-9b0e-0d1d73bb74a6","tipo":3,"numero":"5217611111111","codigo_area":521}]},"datos_financieros":{"normativos":{"id":"64378d3c-5f58-47ab-bc94-ca2871253a7a","acepta_terminos":true,"aviso_privacidad":true,"acepta_publicidad":true,"origen_recursos":4,"destino_recursos":2,"promedio_gasto_tarjeta":1,"promedio_uso_tarjeta":1},"renta":{"id":"11e9a95f-4429-4d84-ab0f-de975ba6c613","sueldo_bruto":"22000"}},"evaluaciones":[{"id":"2c780774-3b55-481d-a125-4ca26641eb89","respuesta_motor":[12]},{"id":"42afbb7c-e647-4882-9b1e-bbc9f9979d0c"},{"id":"3575b89b-f734-4fee-b93c-e52c51fa2091","respuesta_motor":[1]},{"id":"f5cd5fb0-55ab-4ef6-8ddf-5ab3e0ca27c9","monto_aprobado_motor":"150000.0","respuesta_motor":[3]},{"id":"6642fb01-8518-4850-9c86-7180637e4bd7","respuesta_motor":[14]}],"productos":[{"id":"fd989f21-9ae3-4d02-92c4-5f5bf576b91a","tipo":1,"dia_facturacion":"1","envio_estado_cuenta":"email"}],"medios_de_pago":[{"id":"f15f50df-d980-4c41-b2e6-d43effdea03b","tipo":2}],"identificaciones":[{"id":"91790e92-ec5f-4275-86f0-bbda21406509","tipo":2,"numero":"PEVM910204"},{"id":"61935ecb-4f3f-40be-a59e-adf70a88dcd4","tipo":1,"numero":"ABCD112233HDFABC00","numero_serie":"00","clave":"JRJ545J45J45J4J4J4","codigo1":"573573734","codigo2":"3473734735735"}],"custom":{"id":"b60edee8-fc65-4838-8539-ccdeead4e908","data":{"datos_contacto":{"direcciones":{"1":{"calle":"eer","codigo_postal":"64780","descripcion_barrio":"13 de Junio","descripcion_ciudad":"Monterrey","descripcion_region":"NL","direccion_distinta_ine":true,"numero_exterior":"242","numero_interior":"","poblacion":"Monterrey","tipo":1},"2":{"calle":"gjdt","numero_exterior":"485","tipo":2}}},"evaluaciones":{"2c780774-3b55-481d-a125-4ca26641eb89":{"numero_llamada":"F1"},"3575b89b-f734-4fee-b93c-e52c51fa2091":{"decision_motor":"B","empleado_falabella":true,"numero_llamada":"E1"},"42afbb7c-e647-4882-9b1e-bbc9f9979d0c":{"numero_llamada":"INE","resultado_autenticacion_ine":1},"6642fb01-8518-4850-9c86-7180637e4bd7":{"numero_llamada":"F2"},"f5cd5fb0-55ab-4ef6-8ddf-5ab3e0ca27c9":{"detalle_respuesta_motor":{"autenticacion":"false","bcscore":"0","codigoEvaluacion":{"0":"6050","1":"5006","2":"1000","3":"9001","4":"9002"},"codigoOperacion":"02","conexionCreditica":"0","cupoRecomendado":"150000.0","decisionMotor":"B","flagPreeva":"2","flagPreevaAuto":"1","flagPreevaHipo":"1","flagPreevaTc":"1","glosaOperacion":"Evaluacion Aceptada","idEmpleado":"1","scoreBuro":"-1","scoreSociodemografico":"466","valiPreeva":"2","webAgent":"ClienteWeb ClienteWeb"},"numero_llamada":"E2"}},"referencias":{"1":{"nombre_completo":"fhdfhd","telefono":"2423525252"},"2":{"nombre_completo":"gdfh","telefono":"3535336478"}}}},"personales":[{"id":"d73924bf-ae1d-4fdb-b31b-3a6a19032ee2","nombre1":"Juan","nombre2":"","apellido1":"PErez","apellido2":"Ramirez","fecha_nacimiento":"1991-02-04","nacionalidad":1,"sexo":1,"estado_civil":3,"lugar_nacimiento":"NL","cantidad_dependientes":0}],"laborales":[{"id":"47425818-c4dd-46e4-b8ca-11b5dd2a36d5","nombre_empresa":"Halloweenc","giro":50,"actividad":8,"fecha_ingreso":"2020-02-01","antiguedad":19,"actividad_empresarial":false}]}}}';
         
        return json;
    }

    static String generaJsonGestorFormalizada() {

        String json ='{"code":"002","message":"Petición Procesada","data":{"solicitud":{"id":"5086f68f-cbcb-4951-934d-d50a96bf9c53","numero":300012345,"fecha_solicitud":"2021-09-30 16:15:13.989538629 +0000 UTC","tipo":1,"estado":6,"canal":1,"oficina_genera_solicitud":24,"fecha_creacion_gestor":"2021-09-30 16:15:13.989538629 +0000 UTC","fecha_actualizacion_estado":"2021-09-30 16:20:53.854078028 +0000 UTC","usuario":"usuariomonitoreo1@falabella.com.mx","datos_identificacion":{"tipo":1,"numero":"ABCD112233HDFABC00","numero_serie":"N/I","bloqueo":1},"datos_contacto":{"email":"y@e.com","telefonos":[{"id":"d392a7e4-08d0-4fd9-9b0e-0d1d73bb74a6","tipo":3,"numero":"5217611111111","codigo_area":521}]},"datos_financieros":{"normativos":{"id":"64378d3c-5f58-47ab-bc94-ca2871253a7a","acepta_terminos":true,"aviso_privacidad":true,"acepta_publicidad":true,"origen_recursos":4,"destino_recursos":2,"promedio_gasto_tarjeta":1,"promedio_uso_tarjeta":1},"renta":{"id":"11e9a95f-4429-4d84-ab0f-de975ba6c613","sueldo_bruto":"22000"}},"evaluaciones":[{"id":"2c780774-3b55-481d-a125-4ca26641eb89","respuesta_motor":[12]},{"id":"42afbb7c-e647-4882-9b1e-bbc9f9979d0c"},{"id":"3575b89b-f734-4fee-b93c-e52c51fa2091","respuesta_motor":[1]},{"id":"f5cd5fb0-55ab-4ef6-8ddf-5ab3e0ca27c9","monto_aprobado_motor":"150000.0","respuesta_motor":[3]},{"id":"6642fb01-8518-4850-9c86-7180637e4bd7","respuesta_motor":[14]}],"productos":[{"id":"fd989f21-9ae3-4d02-92c4-5f5bf576b91a","tipo":1,"dia_facturacion":"1","envio_estado_cuenta":"email"}],"medios_de_pago":[{"id":"f15f50df-d980-4c41-b2e6-d43effdea03b","tipo":2}],"identificaciones":[{"id":"91790e92-ec5f-4275-86f0-bbda21406509","tipo":2,"numero":"PEVM910204"},{"id":"61935ecb-4f3f-40be-a59e-adf70a88dcd4","tipo":1,"numero":"ABCD112233HDFABC00","numero_serie":"00","clave":"JRJ545J45J45J4J4J4","codigo1":"573573734","codigo2":"3473734735735"}],"custom":{"id":"b60edee8-fc65-4838-8539-ccdeead4e908","data":{"datos_contacto":{"direcciones":{"1":{"calle":"eer","codigo_postal":"64780","descripcion_barrio":"13 de Junio","descripcion_ciudad":"Monterrey","descripcion_region":"NL","direccion_distinta_ine":true,"numero_exterior":"242","numero_interior":"","poblacion":"Monterrey","tipo":1},"2":{"calle":"gjdt","numero_exterior":"485","tipo":2}}},"evaluaciones":{"2c780774-3b55-481d-a125-4ca26641eb89":{"numero_llamada":"F1"},"3575b89b-f734-4fee-b93c-e52c51fa2091":{"decision_motor":"B","empleado_falabella":true,"numero_llamada":"E1"},"42afbb7c-e647-4882-9b1e-bbc9f9979d0c":{"numero_llamada":"INE","resultado_autenticacion_ine":1},"6642fb01-8518-4850-9c86-7180637e4bd7":{"numero_llamada":"F2"},"f5cd5fb0-55ab-4ef6-8ddf-5ab3e0ca27c9":{"detalle_respuesta_motor":{"autenticacion":"false","bcscore":"0","codigoEvaluacion":{"0":"6050","1":"5006","2":"1000","3":"9001","4":"9002"},"codigoOperacion":"02","conexionCreditica":"0","cupoRecomendado":"150000.0","decisionMotor":"B","flagPreeva":"2","flagPreevaAuto":"1","flagPreevaHipo":"1","flagPreevaTc":"1","glosaOperacion":"Evaluacion Aceptada","idEmpleado":"1","scoreBuro":"-1","scoreSociodemografico":"466","valiPreeva":"2","webAgent":"ClienteWeb ClienteWeb"},"numero_llamada":"E2"}},"referencias":{"1":{"nombre_completo":"fhdfhd","telefono":"2423525252"},"2":{"nombre_completo":"gdfh","telefono":"3535336478"}}}},"personales":[{"id":"d73924bf-ae1d-4fdb-b31b-3a6a19032ee2","nombre1":"Juan","nombre2":"","apellido1":"PErez","apellido2":"Ramirez","fecha_nacimiento":"1991-02-04","nacionalidad":1,"sexo":1,"estado_civil":3,"lugar_nacimiento":"NL","cantidad_dependientes":0}],"laborales":[{"id":"47425818-c4dd-46e4-b8ca-11b5dd2a36d5","nombre_empresa":"Halloweenc","giro":50,"actividad":8,"fecha_ingreso":"2020-02-01","antiguedad":19,"actividad_empresarial":false}]}}}';
         
        return json;
    }
}