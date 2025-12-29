/**
* Nombre: CrearCasosGestorBackOfficeTest
* Autor
* Descripcion: Test Method de la Clase CrearCasosGestorBackOffice
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           01/12/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           02/03/2021      Mauricio Rosales            Se activan los Comentarios del Caso ligados a los Motivos de Pendiente cuando se reenvia la Solicitud a Salesforce
* 4.0           04/10/2021      Mauricio Rosales            Re factor del API creacion de casos Back Office
* --------------------------------------------------------------------------
*/
@isTest
public class CrearCasosGestorBackOfficeTest {

	@testSetup
    static void setupData () {

        Case case1 = new Case();
        case1.ID_Solicitud__c = '110';
        case1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        case1.Total_a_Condonar__c = 0;
        insert case1;

        Respuesta_Motor__c respuesta = new Respuesta_Motor__c();
        respuesta.Name = 'anexo1';
        respuesta.Caso__c = case1.Id;
        insert respuesta;

        Codigo_de_dudas__c codigoDuda = new Codigo_de_dudas__c();
        codigoDuda.Name = '5006';
        codigoDuda.Caso__c = case1.Id;
        insert codigoDuda;

        Validaciones_del_Caso__c validacion = new Validaciones_del_Caso__c();
        validacion.Name = 'Test';
        validacion.Case__c = case1.Id;
        insert validacion;

        CaseComment comentario = new CaseComment();
        comentario.IsPublished = false;
        comentario.CommentBody = 'Motivo de Prueba';
        comentario.ParentId = case1.Id;
        insert comentario;
    }

    @isTest static void casoCreacion() {

        WSCreateDataBO createData = new WSCreateDataBO('TEST', 'TEST', 'TEST', 'ABCD112233HDFABC00', 110, 1, '02');

        Test.startTest();
        
        Map<String, Object> mapCreacion = CrearCasosGestorBackOffice.casoUpsertCreacion(createData, '110');

        Test.stopTest();

        System.assertEquals( mapCreacion.get('success') , true);
    }

    @isTest static void casoRestantes() {

        String jsonResponse =  generaJsonGestor();
        SolicitudGestorJSON recCaso = SolicitudGestorJSON.parse(jsonResponse);

        Test.startTest();

        CrearCasosGestorBackOffice crearCasosGestor = new CrearCasosGestorBackOffice();
        crearCasosGestor.loadCatalogCM();
        crearCasosGestor.loadCaseInfo( new List<String>{'110'} );
        
        Map<String, Object> mapRestantes = crearCasosGestor.casoUpsertRestantes(recCaso, '110', true);

        Test.stopTest();

        System.assertEquals( mapRestantes.get('success') , true);
    }

    static String generaJsonGestor() {

       String json ='{'+
                        '"code":"002",'+
                        '"message":"Petición Procesada",'+
                        '"data":{'+
                            '"solicitud":{'+
                                '"id":"6813a33b-c890-4491-9d2a-d979db77a6b8",'+
                                '"numero":110,'+
                                '"fecha_solicitud":"2020-06-26 15:12:39.283659237 +0000 UTC",'+
                                '"tipo":1,'+
                                '"estado":2,'+
                                '"canal":2,'+
                                '"oficina_genera_solicitud":1,'+
                                '"fecha_actualizacion":"2020-07-28",'+
                                '"fecha_creacion_gestor":"2020-06-26 15:12:39.283659237 +0000 UTC",'+
                                '"fecha_actualizacion_estado":"2020-08-20 00:05:15.883594866 +0000 UTC",'+
                                '"usuario":"brcortesm",'+
                                '"codigo_promotor":"986",'+
                                '"numero_empleado":"000000000000206",'+
                                '"tipo_referido":4,'+
                                '"datos_identificacion":{'+
                                    '"tipo":1,'+
                                    '"numero":"VADL651113HDFZRN04",'+
                                    '"numero_serie":"N/I",'+
                                    '"bloqueo":1'+
                                '},'+
                                '"datos_contacto":{'+
                                    '"email":"prueba@prueba.mx",'+
                                    '"telefonos":[{'+
                                        '"id":"b88d61a9-230c-4e92-bfc8-6837837c11c7",'+
                                        '"tipo":3,'+
                                        '"numero":"8119034578",'+
                                        '"codigo_area":521'+
                                    '},{'+
                                        '"id":"72c5ec6c-10f6-42b3-87bf-c8808a11e1e6",'+
                                        '"tipo":1,'+
                                        '"numero":"8119035678",'+
                                        '"codigo_area":521'+
                                    '},{'+
                                        '"id":"b0465f0c-4f7e-488d-a978-d3f30bb33663",'+
                                        '"tipo":2,'+
                                        '"numero":"8119031278",'+
                                        '"codigo_area":521'+
                                    '}]'+
                                '},'+
                                '"datos_financieros":{'+
                                    '"normativos":{'+
                                        '"id":"c76d9c52-0b0c-43c9-90c5-a4f17f25b4c4",'+
                                        '"acepta_terminos":true,'+
                                        '"aviso_privacidad":true,'+
                                        '"acepta_publicidad":false,'+
                                        '"numero_serie":"1234A567JO89LWO12345",'+
                                        '"origen_recursos":4,'+
                                        '"destino_recursos":14,'+
                                        '"promedio_gasto_tarjeta":1,'+
                                        '"promedio_uso_tarjeta":1'+
                                    '},'+
                                    '"renta":{'+
                                        '"id":"ed4bd249-9983-45b9-8668-372a9629e7bb",'+
                                        '"sueldo_bruto":"1200000"'+
                                    '}'+
                                '},'+
                                '"evaluaciones":[{'+
                                    '"id":"177af1ce-5181-4dd4-821b-f8a1d1df0105",'+
                                    '"monto_aprobado_motor":"100000",'+
                                    '"respuesta_motor":['+
                                        '302,'+
                                        '300'+
                                    '],'+

                                    '"id":"177af1ce-5181-4dd4-821b-f8a1d1df0666",'+
                                    '"monto_aprobado_motor":"100000",'+
                                    '"respuesta_motor":['+
                                        '14'+
                                    ']'+

                                '}],'+
                                '"productos":[{'+
                                    '"id":"d65b5f51-c39d-4c61-852a-4384c9725c22",'+
                                    '"tipo":1,'+
                                    '"dia_facturacion":"11",'+
                                    '"envio_estado_cuenta":"Email"'+
                                '}],'+
                                '"observaciones":[{'+
                                    '"id":"c3b17a70-65b2-43c4-870b-9a3251d4141f",'+
                                    '"glosa":" Solicitud - No se anexo",'+
                                    '"tipo":1,'+
                                    '"codigo":"1.0",'+
                                    '"origen":"back-office"'+
                                '}],'+
                                '"medios_de_pago":[{'+
                                    '"id":"25bcf1f6-6dbd-4005-b020-db93d05e44f3",'+
                                    '"tipo":1'+
                                '}],'+
                                '"identificaciones":[{'+
                                    '"id":"2ce5b1bb-7234-477e-aa96-1040490bc737",'+
                                    '"tipo":3,'+
                                    '"numero":"VADL651113HDFZRN04",'+
                                    '"numero_serie":"01",'+
                                    '"clave":"VADL6511131M100123",'+
                                    '"codigo1":"183657717",'+
                                    '"codigo2":"0747116375842"'+
                                '},{'+
                                    '"id":"5ab3dbd0-de19-4d8f-af6b-a4440695c2bf",'+
                                    '"tipo":2,'+
                                    '"numero":"VADL651113",'+
                                    '"clave":"123"'+
                                '}],'+
                                '"custom":{'+
                                    '"id":"56f83c12-cb32-41c1-b894-9668af971a96",'+
                                    '"data":{'+
                                        '"datos_autorizacion":{'+
                                            '"2ce5b1bb-7234-477e-aa96-1040490bc737":{'+
                                                '"acepta_autenticacion":true,'+
                                                '"ejercido_credito_automotriz":true,'+
                                                '"ejercido_credito_hipotecario":true,'+
                                                '"tarjeta_credito":true,'+
                                                '"ultimos_cuatro_digitos_tdc":"9147"'+
                                            '}'+
                                        '},'+
                                        '"datos_contacto":{'+
                                            '"direcciones":{'+
                                                '"1":{'+
                                                    '"calle":"Canarias 798",'+
                                                    '"codigo_postal":"03300",'+
                                                    '"descripcion_barrio":"Narvarte Poniente",'+
                                                    '"descripcion_ciudad":"Ciudad de Mexico",'+
                                                    '"descripcion_region":"Estado de Mexico",'+
                                                    '"direccion_distinta_ine":true,'+
                                                    '"numero_exterior":"0825",'+
                                                    '"numero_interior":"07",'+
                                                    '"otra_colonia":"Juarez",'+
                                                    '"poblacion":"Nombre población",'+
                                                    '"tipo":1'+
                                                '},'+
                                                '"2":{'+
                                                    '"calle":"palmas",'+
                                                    '"numero_exterior":"0123",'+
                                                    '"tipo":2'+
                                                '},'+
                                                '"direcciones":{'+
                                                    '"1":{'+
                                                        '"calle":"Canarias 798",'+
                                                        '"codigo_postal":"03300",'+
                                                        '"descripcion_barrio":"Narvarte Poniente",'+
                                                        '"descripcion_ciudad":"Ciudad de Mexico",'+
                                                        '"descripcion_region":"Estado de Mexico",'+
                                                        '"direccion_distinta_ine":true,'+
                                                        '"numero_exterior":"0825",'+
                                                        '"numero_interior":"07",'+
                                                        '"otra_colonia":"Juarez",'+
                                                        '"poblacion":"Nombre población",'+
                                                        '"tipo":1'+
                                                    '}'+
                                                '}'+
                                            '}'+
                                        '},'+
                                        '"evaluaciones":{'+
                                            '"177af1ce-5181-4dd4-821b-f8a1d1df0105":{'+
                                                '"canal_actual":"WEB portal",'+
                                                '"canal_origen":"WEB portal",'+
                                                '"decision_motor":"B",'+
                                                '"empleado_falabella":true,'+
                                                '"numero_llamada":"INE",'+
                                                '"resultado_autenticacion_ine":4,'+
                                                '"score_emailage":1'+
                                            '},'+

                                            '"177af1ce-5181-4dd4-821b-f8a1d1df0666":{'+
                                                '"canal_actual":"WEB portal",'+
                                                '"canal_origen":"WEB portal",'+
                                                '"decision_motor":"B",'+
                                                '"empleado_falabella":true,'+
                                                '"numero_llamada":"F2",'+
                                                '"resultado_autenticacion_ine":2,'+
                                                '"score_emailage":1'+
                                            '},'+

                                            '"177af1ce-5181-4dd4-821b-f8a1d1df0777":{'+
                                                '"detalle_respuesta_motor":{'+
                                                    '"anexo1":"TEST",'+
                                                    '"anexo2":"TEST",'+
                                                    '"anexo3":"TEST",'+
                                                    '"anio":"2000",'+
                                                    '"autenticacion":"false",'+
                                                    '"bcscore":"0",'+
                                                    '"codigoEvaluacion":{'+
                                                        '"0":"5006",'+
                                                        '"1":"6052",'+
                                                        '"2":"1000",'+
                                                        '"3":"9002"'+
                                                    '},'+
                                                    '"codigoOperacion":"02",'+
                                                    '"coeficiente":"0.00000000000000000",'+
                                                    '"conTdc":"1",'+
                                                    '"conexionCreditica":"0",'+
                                                    '"cupoRecomendado":"3000.0",'+
                                                    '"decisionMotor":"B",'+
                                                    '"flag":"-3",'+
                                                    '"flagPreeva":"2",'+
                                                    '"flagPreevaAuto":"1",'+
                                                    '"flagPreevaHipo":"1",'+
                                                    '"flagPreevaTc":"1",'+
                                                    '"glosaOperacion":"Evaluacion Pendiente",'+
                                                    '"grupoRfm":"TEST",'+
                                                    '"idEmpleado":"0",'+
                                                    '"nombre":"YANET",'+
                                                    '"promedioMensualCompra":"902.42",'+
                                                    '"scoreBuro":"-1",'+
                                                    '"scoreSociodemografico":"447",'+
                                                    '"tarjetaAprecio":"0001018010908802",'+
                                                    '"valiPreeva":"2",'+
                                                    '"variable1":"0.00",'+
                                                    '"variable2":"1.00",'+
                                                    '"webAgent":"ClienteWeb ClienteWeb"'+
                                                '}'+
                                            '}'+

                                        '},'+
                                        '"referencias":{'+
                                            '"1":{'+
                                                '"nombre_completo":"Fer cobos",'+
                                                '"telefono":"5585265917"'+
                                            '},'+
                                            '"2":{'+
                                                '"nombre_completo":"Carlos mola ",'+
                                                '"telefono":"5525266510"'+
                                            '}'+
                                        '}'+
                                    '}'+
                                '},'+
                                '"personales":[{'+
                                    '"id":"175a0ca9-700a-4f34-a07e-c265edddfb45",'+
                                    '"nombres":"briseida",'+
                                    '"nombre1":"briseida",'+
                                    '"nombre2":"",'+
                                    '"apellido1":"Castillo",'+
                                    '"apellido2":"cortes",'+
                                    '"fecha_nacimiento":"1965-11-13",'+
                                    '"nacionalidad":1,'+
                                    '"sexo":1,'+
                                    '"estado_civil":1,'+
                                    '"tipo_persona":1,'+
                                    '"lugar_nacimiento":"DF",'+
                                    '"pais_nacimiento":1,'+
                                    '"cantidad_dependientes":2,'+
                                    '"parentesco":2'+
                                '}],'+
                                '"laborales":[{'+
                                    '"id":"8756bdda-5199-41fc-b421-ad575267b3c9",'+
                                    '"nombre_empresa":"Empresa Cia Ltda",'+
                                    '"giro":1,'+
                                    '"actividad":1,'+
                                    '"fecha_ingreso":"2000-01-02",'+
                                    '"fecha_egreso":"2000-05-02",'+
                                    '"antiguedad":1,'+
                                    '"actividad_empresarial":true'+
                                    '},{'+
                                    '"id":"8756bdda-5199-41fc-b421-ad575267b3c9",'+
                                    '"nombre_empresa":"Empresa Cia Ltda",'+
                                    '"giro":1,'+
                                    '"actividad":1,'+
                                    '"fecha_ingreso":"2000-05-02",'+
                                    '"fecha_egreso":null,'+
                                    '"antiguedad":1,'+
                                    '"actividad_empresarial":true'+
                                '}]'+
                            '}'+
                        '}'+
                    '}';
        
        return json;
    }
}