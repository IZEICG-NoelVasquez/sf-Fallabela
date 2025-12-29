/**
* Nombre: ServiceSolicitudRiesgosTest
* Autor: ---
* Descripcion: Test Method de las clases ServiceSolicitudRiesgosHelper y ServiceSolicitudRiesgos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           20/12/2021      Mauricio Rosales            Consulta de campos al crear la solicitud y si la consulta no es exitosa crear el caso
* --------------------------------------------------------------------------
*/
@isTest
public class ServiceSolicitudRiesgosTest {

    @isTest static void error() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();        

        request.requestUri ='/riesgos/solicitudes/gestor/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof('');

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ServiceSolicitudRiesgos.create();

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c, CreatedDate FROM Error_Log__c WHERE ApexClass__c = 'ServiceSolicitudRiesgosHelper' LIMIT 1 ];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void caso_Gestor() {

        WSCreateDataBO createData = new WSCreateDataBO('test','test','test','ABCD112233HDFABC00',110,null,'02');

        String jsonData = JSON.serialize(createData);

        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();      
        mockGestor.setBody(generaJsonGestor());
        mockGestor.setMicroServicio('ConsultaSolicitudGestor');
        mockGestor.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockGestor);


        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();        

        request.requestUri ='/riesgos/solicitudes/gestor/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonData);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ServiceSolicitudRiesgos.create();

        Test.stopTest();

        List<Case> listCase = [SELECT ID_Solicitud__c FROM Case WHERE ID_Solicitud__c = '110'];
        System.assertEquals( listCase[0].ID_Solicitud__c, '110');
    }

    @isTest static void casoGestorErrorEnConsulta() {

        WSCreateDataBO createData = new WSCreateDataBO('test','test','test','ABCD112233HDFABC00',110,null,'02');        

        String jsonData = JSON.serialize(createData);

        ///
        MockHttpResponseGeneratorGestor mockGestor = new MockHttpResponseGeneratorGestor();
        mockGestor.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockGestor);

        ///
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();        

        request.requestUri ='/riesgos/solicitudes/gestor/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonData);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ServiceSolicitudRiesgos.create();

        Test.stopTest();

        List<Case> listCase = [SELECT ID_Solicitud__c FROM Case WHERE ID_Solicitud__c = '110'];
        System.assertEquals( listCase[0].ID_Solicitud__c, '110');
    }

    @isTest static void casoGestorParametrosNulos() {

        WSCreateDataBO createData = new WSCreateDataBO(null,null,null,null,null,null,null);
        String jsonData = JSON.serialize(createData);

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();        

        request.requestUri ='/riesgos/solicitudes/gestor/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonData);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ServiceSolicitudRiesgos.create();

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c, CreatedDate FROM Error_Log__c WHERE ApexClass__c = 'ServiceSolicitudRiesgosHelper' LIMIT 1 ];
        System.assertEquals( !listError.isEmpty() , true);
    }


    static String generaJsonGestor() {

       String json ='{"code":"002","message":"Petición Procesada","data":{"solicitud":{"id":"6813a33b-c890-4491-9d2a-d979db77a6b8","numero":110,"fecha_solicitud":"2020-06-26 15:12:39.283659237 +0000 UTC","tipo":1,"estado":2,"canal":3,"oficina_genera_solicitud":1,"fecha_actualizacion":"2020-07-28","fecha_creacion_gestor":"2020-06-26 15:12:39.283659237 +0000 UTC","fecha_actualizacion_estado":"2020-08-20 00:05:15.883594866 +0000 UTC","usuario":"brcortesm","codigo_promotor":"986","numero_empleado":"000000000000206","tipo_referido":4,"datos_identificacion":{"tipo":1,"numero":"VADL651113HDFZRN04","numero_serie":"N/I","bloqueo":1},"datos_contacto":{"email":"prueba@prueba.mx","telefonos":[{"id":"b88d61a9-230c-4e92-bfc8-6837837c11c7","tipo":3,"numero":"8119034578","codigo_area":521},{"id":"72c5ec6c-10f6-42b3-87bf-c8808a11e1e6","tipo":1,"numero":"8119035678","codigo_area":521},{"id":"b0465f0c-4f7e-488d-a978-d3f30bb33663","tipo":2,"numero":"8119031278","codigo_area":521}]},"datos_financieros":{"normativos":{"id":"c76d9c52-0b0c-43c9-90c5-a4f17f25b4c4","acepta_terminos":true,"aviso_privacidad":true,"acepta_publicidad":false,"numero_serie":"1234A567JO89LWO12345","origen_recursos":4,"destino_recursos":14,"promedio_gasto_tarjeta":1,"promedio_uso_tarjeta":1},"renta":{"id":"ed4bd249-9983-45b9-8668-372a9629e7bb","sueldo_bruto":"1200000"}},"evaluaciones":[{"id":"177af1ce-5181-4dd4-821b-f8a1d1df0105","monto_aprobado_motor":"100000","respuesta_motor":[302,300]}],"productos":[{"id":"d65b5f51-c39d-4c61-852a-4384c9725c22","tipo":1,"dia_facturacion":"11","envio_estado_cuenta":"Email"}],"observaciones":[{"id":"c3b17a70-65b2-43c4-870b-9a3251d4141f","glosa":" Solicitud - No se anexo","tipo":1,"codigo":"1.0","origen":"back-office"}],"medios_de_pago":[{"id":"25bcf1f6-6dbd-4005-b020-db93d05e44f3","tipo":1}],"identificaciones":[{"id":"2ce5b1bb-7234-477e-aa96-1040490bc737","tipo":1,"numero":"VADL651113HDFZRN04","numero_serie":"01","clave":"VADL6511131M100123","codigo1":"183657717","codigo2":"0747116375842"},{"id":"5ab3dbd0-de19-4d8f-af6b-a4440695c2bf","tipo":2,"numero":"VADL651113","clave":"123"}],"custom":{"id":"56f83c12-cb32-41c1-b894-9668af971a96","data":{"datos_autorizacion":{"2ce5b1bb-7234-477e-aa96-1040490bc737":{"acepta_autenticacion":true,"ejercido_credito_automotriz":true,"ejercido_credito_hipotecario":true,"tarjeta_credito":true,"ultimos_cuatro_digitos_tdc":"9147"}},"datos_contacto":{"direcciones":{"1":{"calle":"Canarias 798","codigo_postal":"03300","descripcion_barrio":"Narvarte Poniente","descripcion_ciudad":"Ciudad de Mexico","descripcion_region":"Estado de Mexico","direccion_distinta_ine":true,"numero_exterior":"0825","numero_interior":"07","otra_colonia":"Juarez","poblacion":"Nombre población","tipo":1},"2":{"calle":"palmas","numero_exterior":"0123","tipo":2},"direcciones":{"1":{"calle":"Canarias 798","codigo_postal":"03300","descripcion_barrio":"Narvarte Poniente","descripcion_ciudad":"Ciudad de Mexico","descripcion_region":"Estado de Mexico","direccion_distinta_ine":true,"numero_exterior":"0825","numero_interior":"07","otra_colonia":"Juarez","poblacion":"Nombre población","tipo":1}}}},"evaluaciones":{"177af1ce-5181-4dd4-821b-f8a1d1df0105":{"canal_actual":"WEB portal","canal_origen":"WEB portal","decision_motor":"B","empleado_falabella":true,"numero_llamada":2,"resultado_autenticacion_ine":0,"score_emailage":1}},"referencias":{"1":{"nombre_completo":"Fer cobos","telefono":"5585265917"},"2":{"nombre_completo":"Carlos mola ","telefono":"5525266510"}}}},"personales":[{"id":"175a0ca9-700a-4f34-a07e-c265edddfb45","nombres":"briseida","nombre1":"briseida","nombre2":"","apellido1":"Castillo","apellido2":"cortes","fecha_nacimiento":"1965-11-13","nacionalidad":1,"sexo":1,"estado_civil":1,"tipo_persona":1,"lugar_nacimiento":"DF","pais_nacimiento":1,"cantidad_dependientes":2,"parentesco":2}],"laborales":[{"id":"8756bdda-5199-41fc-b421-ad575267b3c9","nombre_empresa":"Empresa Cia Ltda","giro":1,"actividad":1,"fecha_ingreso":"2000-01-02","fecha_egreso":"2000-05-02","antiguedad":1,"actividad_empresarial":true}]}}}';
        
        return json;
    }
}