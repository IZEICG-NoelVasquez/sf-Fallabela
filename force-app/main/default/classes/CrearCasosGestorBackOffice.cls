/**
* Nombre: CrearCasosGestorBackOffice
* Autor: 
* Descripcion: Clase para la creacion de Casos por medio del Servicio ServiceSolicitudRiesgos y 
* la actualizacion de Casos desde el componente ActualizarTicketRiesgosCmp
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           01/03/2021      Mauricio Rosales            Se activan los Comentarios del Caso ligados a los Motivos de Pendiente cuando se reenvia la Solicitud a Salesforce
* 3.0           25/08/2021      Mauricio Rosales            Se agrega validacion para codigos externos del gestor de solicitudes con pendientes de fraudes
* 4.0           20/09/2021      Mauricio Rosales            Re factor del API creacion de casos Back Office
* 5.0           25/02/2022      Mauricio Rosales            Validacion de Solicitudes con Rechazo de Fraudes
* --------------------------------------------------------------------------
*/
public without sharing class CrearCasosGestorBackOffice {

    private static final String RT_VT_GLOBAL = 'Verificacion Telefonica Global';
    private static final String RT_VT_VILLAGARCIA = 'Monto igual o mayores a $20,000 o Villa de Garcia';

    private static final String RECORDTYPE_CREDITO = 'Riesgos_Originaci_n';
    private static final String RECORDTYPE_FIGITAL = 'BackOffice_Figital';

    private static final String QUEUE_CREDITO = 'Riesgos_Falabella';
    private static final String QUEUE_FIGITAL = 'BackOffice_Figital';
    private static final String QUEUE_CREDITO_FRAUDES = 'BackOffice_Credito_Fraudes';

    private static final String VALIDACION_FRAUDES = 'VoBo Fraude';
    private static final String VALIDACION_INE = 'Validación INE';


    /// Catalogos Custom Metadata
    private Map<String,String> mapProductoTipoGestor;
    private Map<String,String> mapSexoGestor;
    private Map<String,String> mapEstadoCivilGestor;
    private Map<String,String> mapOrigenRecursosGestor;
    private Map<String,String> mapActividadGiroGestor;
    private Map<String,String> mapOcupacionGestor;
    private Map<String,String> mapEstadoSolicitudGestor;
    private Map<String,String> mapSucursalGestor;
    private Map<String, Resultado_Autenticacion_Ine__mdt> mapResultadoAutenIne;
    private Map<String,String> mapDestinoRecursosGestor;
    private Map<String,String> mapGastoPromedioGestor;
    private Map<String,String> mapCatalogoCodigosCM;
    private Map<String, List<Validaciones_de_Codigo_CM__mdt>> mapValidacionesDeCodigo;
    private Map<String,String> mapCanalOrigenGestor;

    /// Mapa Colas de Usuarios
    private Map<String, Id> mapGrupos;

    /// Mapa Info del Caso
    private Map<String,Case> mapCases;

    /// Mapa Id Caso, Set Respuestas de Motor
    private Map<Id, Set<String>> mapIdCaseRespuestasMotor;

    /// Mapa Id Caso, Set Codigos de Dudas
    private Map<Id, Set<String>> mapIdCaseCodigosDeDuda;

    /// Mapa Id Caso, Set Validaciones del Caso
    private Map<String, Set<String>> mapIdCaseValidacionesDelCaso;

    /// Mapa Id Caso, List CaseComment
    private Map<String, List<CaseComment>> mapIdCasoCometariosDelCaso;
    

    public static Map<String, Object> casoUpsertCreacion(WSCreateDataBO createData, String idSolicitud) {
 
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        /// Variable para identificar casos reenviados
        Boolean blnCasoReenviado = false;

        Case caso = new Case();

        try {

            caso.ID_Solicitud__c = idSolicitud;

            Id idQueueRiesgos = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'BackOffice_Credito_Fraudes'].Id;

            caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RECORDTYPE_CREDITO).getRecordTypeId();
            caso.OwnerId = idQueueRiesgos;
            
            /// Ajuste para crear el caso con estatus de Nuevo
            caso.Status = 'New';
            caso.Caso_Actualizado_por_WebService__c = true;

            /// Se actualiza campo para validacion de actualizacion en MS Admision
            caso.Actualizaci_n_Alta_en_SAT__c = false;
            caso.Actualizaci_n_de_domicilio_en_SAT__c = false;
            /// N intentos mapeo de campos, cuando la info de la solicitud no esta completa en el Gestor
            caso.Total_a_Condonar__c = 0;

            ///
            caso.Fecha_y_hora_de_solicitud_en_Nuevo__c = System.now();

            if( validateObjectNullValue(createData) ) {

                caso.CURP__c = validateStringField(createData.curp);
                caso.Nombre_s__c = validateStringField(createData.name);
                caso.Primer_Apellido__c = validateStringField(createData.surname);
                caso.Segundo_Apellido__c = validateStringField(createData.secondsurname);
                caso.Estatus__c = validateStringField(createData.evaluationResult);
            }

            Database.UpsertResult upsertCaso = Database.upsert(caso, Case.ID_Solicitud__c);

            if (upsertCaso.isSuccess()) {

                if (!upsertCaso.isCreated()) {

                    caso.Solicitud_Repetida__c = true;
                    caso.Cliente_Repetido__c = true;

                    blnCasoReenviado = true;

                    Database.upsert(caso, Case.ID_Solicitud__c);
                }

                success = true;
            }

        } catch (Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber());
        }

        result.put('success', success);
        result.put('blnCasoReenviado', blnCasoReenviado);
        result.put('idCaso', caso.Id);

        return result;
    }

    public static String validateStringField(String field) {

        return String.isNotBlank(field) ? field : '';
    }

    public static Boolean validateObjectNullValue(Object field) {

        return field != null ? true : false;
    }

    public void loadCatalogCM() {
   
        mapProductoTipoGestor = new Map<String,String>();

        for(Producto_Tipo_Gestor__mdt producto: [SELECT MasterLabel, glosa__c FROM Producto_Tipo_Gestor__mdt] ) {

            mapProductoTipoGestor.put(producto.MasterLabel, producto.glosa__c);
        }

        mapSexoGestor = new Map<String,String>();

        for(Sexo_Gestor__mdt sexo: [SELECT MasterLabel, glosa__c FROM Sexo_Gestor__mdt] ) {

            mapSexoGestor.put(sexo.MasterLabel, sexo.glosa__c);
        }

        mapEstadoCivilGestor = new Map<String,String>();

        for(Estado_Civil_Gestor__mdt edoCivil: [SELECT MasterLabel, glosa__c FROM Estado_Civil_Gestor__mdt] ) {

            mapEstadoCivilGestor.put(edoCivil.MasterLabel, edoCivil.glosa__c);
        }

        mapOrigenRecursosGestor = new Map<String,String>();

        for(Origen_Recursos_Gestor__mdt origen: [SELECT MasterLabel, glosa__c FROM Origen_Recursos_Gestor__mdt] ) {

            mapOrigenRecursosGestor.put(origen.MasterLabel, origen.glosa__c);
        }

        mapActividadGiroGestor = new Map<String,String>();

        for(Actividad_Giro_Gestor__mdt actividad: [SELECT MasterLabel, glosa__c FROM Actividad_Giro_Gestor__mdt] ) {

            mapActividadGiroGestor.put(actividad.MasterLabel, actividad.glosa__c);
        }

        mapOcupacionGestor = new Map<String,String>();

        for(ocupacion__mdt ocupacion: [SELECT MasterLabel, glosa__c FROM ocupacion__mdt] ) {

            mapOcupacionGestor.put(ocupacion.MasterLabel, ocupacion.glosa__c);
        }

        mapEstadoSolicitudGestor = new Map<String,String>();

        for(Estado_Solicitud_Gestor__mdt estadoSol: [SELECT MasterLabel, glosa__c FROM Estado_Solicitud_Gestor__mdt] ) {

            mapEstadoSolicitudGestor.put(estadoSol.MasterLabel, estadoSol.glosa__c);
        }

        mapSucursalGestor = new Map<String,String>();

        for(Sucursal_Gestor__mdt sucursal: [SELECT MasterLabel, glosa__c FROM Sucursal_Gestor__mdt]) {

            mapSucursalGestor.put(sucursal.MasterLabel, sucursal.glosa__c);
        }

        mapResultadoAutenIne = new Map<String, Resultado_Autenticacion_Ine__mdt>();

        for(Resultado_Autenticacion_Ine__mdt resAutIne: [SELECT MasterLabel, glosa__c, Bloqueo_de_Fraudes__c FROM Resultado_Autenticacion_Ine__mdt]) {

            mapResultadoAutenIne.put(resAutIne.MasterLabel, resAutIne);
        }

        mapDestinoRecursosGestor = new Map<String,String>();

        for(Destino_Recursos_Gestor__mdt destinoRec: [SELECT MasterLabel, glosa__c FROM Destino_Recursos_Gestor__mdt] ) {

            mapDestinoRecursosGestor.put(destinoRec.MasterLabel, destinoRec.glosa__c);
        }

        mapGastoPromedioGestor = new Map<String,String>();

        for(Gasto_Promedio_Gestor__mdt gastoProm: [SELECT MasterLabel, glosa__c FROM Gasto_Promedio_Gestor__mdt] ) {
            
            mapGastoPromedioGestor.put(gastoProm.MasterLabel, gastoProm.glosa__c);
        }

        mapCatalogoCodigosCM = new Map<String,String>();

        for(Catalogo_Codigos_CM__mdt catalogoCod: [SELECT MasterLabel, Descripci_n__c FROM Catalogo_Codigos_CM__mdt] ) {

            mapCatalogoCodigosCM.put(catalogoCod.MasterLabel, catalogoCod.Descripci_n__c);
        }

        mapValidacionesDeCodigo = new Map<String, List<Validaciones_de_Codigo_CM__mdt>>();

        for(Validaciones_de_Codigo_CM__mdt validacionCodigo: [SELECT Catalogo_Codigos_CM__r.Label, 
                                                                    Catalogo_Codigos_CM__r.Descripci_n__c, 
                                                                    Catalogo_Codigos_CM__r.Verificacion_Telefonica__c, 
                                                                    Catalogo_Validaciones_CM__r.Label 
                                                            FROM Validaciones_de_Codigo_CM__mdt ] ) {

            if( !mapValidacionesDeCodigo.containsKey(validacionCodigo.Catalogo_Codigos_CM__r.Label) ) {

                mapValidacionesDeCodigo.put(validacionCodigo.Catalogo_Codigos_CM__r.Label, new List<Validaciones_de_Codigo_CM__mdt>() );
            }

            mapValidacionesDeCodigo.get(validacionCodigo.Catalogo_Codigos_CM__r.Label).add(validacionCodigo);
        }

        mapCanalOrigenGestor = new Map<String,String>();

        for(Canal_Origen_Gestor__mdt canaOrigen: [SELECT MasterLabel, Descripcion__c FROM Canal_Origen_Gestor__mdt] ) {

            mapCanalOrigenGestor.put(canaOrigen.MasterLabel, canaOrigen.Descripcion__c);
        }
    }


    public void loadCaseInfo(List<String> lstIdSolicitud ) {

        List<String> lstIdCases = new List<String>();

        mapCases = new Map<String,Case>();

        for(Case caso: [SELECT ID_Solicitud__c, Evaluar__c, Total_a_Condonar__c FROM Case WHERE ID_Solicitud__c IN : lstIdSolicitud] ) {

            mapCases.put(caso.ID_Solicitud__c, caso);

            lstIdCases.add(caso.Id);
        }

        mapGrupos = new Map<String, Id>();

        List<String> listNombreGrupos = new List<String>{ QUEUE_CREDITO, QUEUE_CREDITO_FRAUDES, QUEUE_FIGITAL };

        for (Group grupo: [SELECT DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN : listNombreGrupos] ) {

            if (!mapGrupos.containsKey(grupo.DeveloperName)) {

                mapGrupos.put(grupo.DeveloperName, grupo.Id);
            }
        }

        mapIdCaseRespuestasMotor = new Map<Id, Set<String>> ();

        for(Respuesta_Motor__c respuestaMotor: [SELECT Name, Caso__c FROM Respuesta_Motor__c WHERE Caso__c IN : lstIdCases] ) {

            if( !mapIdCaseRespuestasMotor.containsKey(respuestaMotor.Caso__c) ) {

                mapIdCaseRespuestasMotor.put( respuestaMotor.Caso__c, new Set<String>() );
            }

            mapIdCaseRespuestasMotor.get(respuestaMotor.Caso__c).add(respuestaMotor.Name);
        }

        mapIdCaseCodigosDeDuda  = new Map<Id, Set<String>> ();

        for(Codigo_de_dudas__c codigoDudas: [SELECT Name, Caso__c FROM Codigo_de_dudas__c WHERE Caso__c IN : lstIdCases] ) {

            if( !mapIdCaseCodigosDeDuda.containsKey(codigoDudas.Caso__c) ) {

                mapIdCaseCodigosDeDuda.put( codigoDudas.Caso__c, new Set<String>() );
            }

            mapIdCaseCodigosDeDuda.get(codigoDudas.Caso__c).add(codigoDudas.Name);
        }

        mapIdCaseValidacionesDelCaso = new Map<String, Set<String>>();

        for(Validaciones_del_Caso__c validacion: [SELECT Name, Case__c FROM Validaciones_del_Caso__c WHERE Case__c IN : lstIdCases] ) {

            if( !mapIdCaseValidacionesDelCaso.containsKey(validacion.Case__c) ) {

                mapIdCaseValidacionesDelCaso.put(validacion.Case__c, new Set<String>() );
            }

            mapIdCaseValidacionesDelCaso.get(validacion.Case__c).add(validacion.Name);
        }

        mapIdCasoCometariosDelCaso = new Map<String, List<CaseComment>>();

        for(CaseComment comentario: [SELECT IsPublished, ParentId FROM CaseComment WHERE ParentId IN : lstIdCases AND IsPublished = FALSE] ) {

            if( !mapIdCasoCometariosDelCaso.containsKey(comentario.ParentId) ) {

                mapIdCasoCometariosDelCaso.put(comentario.ParentId, new List<CaseComment>() );
            }

            mapIdCasoCometariosDelCaso.get(comentario.ParentId).add(comentario);
        }
    }

    public Map<String, Object> casoUpsertRestantes(SolicitudGestorJSON rec, String idSolicitud, Boolean blnCasoReenviado) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        String idCaso = '';

        ///
        Boolean banCredito = false; //codigos de pendiente de credito
        Boolean banFraude = false; //codigos de pendiente de fraude 
        Boolean banFraudeIne = false; ///
        Boolean rechazoFraudes = false;
        Boolean ownerCredito = false;
        Boolean queueFigital = false;
        /// N intentos mapeo de campos, cuando la info de la solicitud no esta completa en el Gestor
        Boolean blnNumeroLlamadaF2 = false;
        Boolean withoutNumberCallF2 = false;
        Integer numberOfAttemps = 0;
        
        Case caso = new Case();

        try {

            ///
            String userLocal = UserInfo.getLocale();

            SolicitudGestorJSON.Personales personales;
            SolicitudGestorJSON.Evaluacion_ID evaluacionID;
            SolicitudGestorJSON.Productos productos;
            SolicitudGestorJSON.CustomReferenciasId customReferenciasId;
            SolicitudGestorJSON.CustomDatosAutorizacionId customDatosAutorizacionId;
            SolicitudGestorJSON.Detalle_respuesta_motor detalle_respuesta_motor;                 

            caso.ID_Solicitud__c = idSolicitud;

            if( validateObjectNullValue(rec.data) && validateObjectNullValue(rec.data.solicitud) ) {

                caso.Id_Solicitud_Gestor__c = validateStringField(rec.data.solicitud.id);

                if( validateObjectNullValue(rec.data.solicitud.canal) ) {

                    caso.Canal_origen__c = mapCanalOrigenGestor.containsKey(String.valueOf(rec.data.solicitud.canal)) ? mapCanalOrigenGestor.get(String.valueOf(rec.data.solicitud.canal)) : '';

                    if( rec.data.solicitud.canal == 2 ) {

                        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RECORDTYPE_FIGITAL).getRecordTypeId();
                        queueFigital = true;
                    }
                }

                /// Campo para guardar el exito de la consulta de WS Recuperar Informacion de la Solicitud
                caso.Actualizaci_n_de_domicilio_en_SAT__c = true;

                //En esta sección se da formato a la fecha recibida del campo [modifiedDate]
                String modifiedDateAux = validateStringField(rec.data.solicitud.fecha_actualizacion_estado);                

                if( String.isNotBlank(modifiedDateAux) ) {

                    modifiedDateAux = modifiedDateAux.length() > 10 ? modifiedDateAux.substring(0, 10) : modifiedDateAux;

                    String day = modifiedDateAux != '' ? modifiedDateAux.substringAfterLast('-') : '';
                    String month = modifiedDateAux != '' ? modifiedDateAux.substringBetween('-') : '';
                    String year = modifiedDateAux != '' ? modifiedDateAux.substringBefore('-') : '';

                    modifiedDateAux = userLocal == 'en_US' ? (month + '/' + day + '/' + year) : (day + '/' + month + '/' + year);

                    caso.Fecha_de_actualizaci_n__c = date.parse(modifiedDateAux);
                }

                //Se agregarán los campos obtenidos por el servicio al caso existente [Salesforce-JSON]
                caso.CURP__c = validateObjectNullValue(rec.data.solicitud.datos_identificacion) ? validateStringField(rec.data.solicitud.datos_identificacion.numero) : '';
                
                caso.Estatus__c = validateObjectNullValue(rec.data.solicitud.estado) && mapEstadoSolicitudGestor.containsKey(String.valueOf(rec.data.solicitud.estado)) ? mapEstadoSolicitudGestor.get(String.valueOf(rec.data.solicitud.estado)) : '';

                if ( validateObjectNullValue(rec.data.solicitud.identificaciones) ) {

                    for (SolicitudGestorJSON.Identificaciones ide: rec.data.solicitud.identificaciones) {

                        if( validateObjectNullValue(ide.tipo) ) {

                            if (ide.tipo == 1) {

                                caso.Identificacion_Id_Gestor__c = validateStringField(ide.id);

                            } else if (ide.tipo == 2) {

                                caso.Homoclave__c = validateStringField(ide.clave);
                                caso.RFC_Caso__c = validateStringField(ide.numero);

                            } else if (ide.tipo == 3) {

                                caso.N_Tarjeta_recompensas__c = validateStringField(ide.numero);
                            }
                        }

                        ///
                        if ( validateObjectNullValue(rec.data.solicitud.custom) && validateObjectNullValue(rec.data.solicitud.custom.data) && validateObjectNullValue(rec.data.solicitud.custom.data.Datos_autorizacion_custom) ) {

                            customDatosAutorizacionId = validateObjectNullValue(rec.data.solicitud.custom.data.Datos_autorizacion_custom.LisDatosAutorizacion) && validateObjectNullValue(ide.id) ? rec.data.solicitud.custom.data.Datos_autorizacion_custom.LisDatosAutorizacion.get(ide.id) : null;

                            if ( validateObjectNullValue(customDatosAutorizacionId) ) {

                                caso.Tarjeta_de_cr_dito__c = validateObjectNullValue(customDatosAutorizacionId.tarjeta_credito) && customDatosAutorizacionId.tarjeta_credito == true ? 'SI' : 'NO';
                                caso.Cr_dito_Automotriz__c = validateObjectNullValue(customDatosAutorizacionId.ejercido_credito_automotriz) && customDatosAutorizacionId.ejercido_credito_automotriz == true ? 'SI' : 'NO';
                                caso.Autorizaci_n_Bur_de_Cr_dito__c = validateObjectNullValue(customDatosAutorizacionId.acepta_autenticacion) && customDatosAutorizacionId.acepta_autenticacion == true ? 'SI' : 'NO';
                                caso.Cr_dito_Hipotecario__c = validateObjectNullValue(customDatosAutorizacionId.ejercido_credito_hipotecario) && customDatosAutorizacionId.ejercido_credito_hipotecario == true ? 'SI' : 'NO';
                                caso.ltimos_cuatro_d_gitos__c = validateStringField(customDatosAutorizacionId.ultimos_cuatro_digitos_tdc);
                                break;
                            }
                        }
                    }
                }
                
                if ( validateObjectNullValue(rec.data.solicitud.observaciones) ) {

                    for (SolicitudGestorJSON.Observaciones observaciones: rec.data.solicitud.observaciones) {

                        caso.Observacion_Id_Gestor__c = validateStringField(observaciones.id);
                    }

                }
                
                if ( (validateObjectNullValue(rec.data.solicitud.personales)) && (rec.data.solicitud.personales.size() > 0) ) {

                    personales = rec.data.solicitud.personales.get(0);

                    if( validateObjectNullValue(personales) ) {

                        caso.Nombre_s__c = validateStringField(personales.nombre1) + ' ' + validateStringField(personales.nombre2);
                        caso.Primer_Apellido__c = validateStringField(personales.apellido1);
                        caso.Segundo_Apellido__c = validateStringField(personales.apellido2);

                        String birthDateAux = validateStringField(personales.fecha_nacimiento);

                        if( String.isNotBlank(birthDateAux) ) {

                            String dayBirthD = birthDateAux.substringAfterLast('-');
                            String monthBirthD = birthDateAux.substringBetween('-');
                            String yearBirthD = birthDateAux.substringBefore('-');

                            birthDateAux = userLocal == 'en_US' ? (monthBirthD + '/' + dayBirthD + '/' + yearBirthD) : (dayBirthD + '/' + monthBirthD + '/' + yearBirthD);

                            caso.Fecha_de_nacimiento_riesgos__c = date.parse(birthDateAux);
                        }
                        
                        caso.G_nero__c = validateObjectNullValue(personales.sexo) && mapSexoGestor.containsKey(String.valueOf(personales.sexo)) ? mapSexoGestor.get(String.valueOf(personales.sexo)): '';

                        if ( validateObjectNullValue(personales.nacionalidad) && personales.nacionalidad == 1) {

                            caso.Nacionalidad__c = 'Mexicana';
                        }

                        caso.Pa_s_de_Nacionalidad__c = 'Mexico';

                        if ( validateObjectNullValue(personales.cantidad_dependientes) && personales.cantidad_dependientes > 0) {

                            caso.Dependientes_econ_micos_Si_No__c = 'SI';
                            caso.Dependientes_econ_micos_Cuantos__c = String.valueOf(personales.cantidad_dependientes);

                        } else {

                            caso.Dependientes_econ_micos_Si_No__c = 'NO';
                        }
                                               
                        caso.Estado_Civil__c = validateObjectNullValue(personales.estado_civil) && mapEstadoCivilGestor.containsKey(String.valueOf(personales.estado_civil)) ? mapEstadoCivilGestor.get(String.valueOf(personales.estado_civil)): '';
                    }
                }
                
                caso.Sucursal__c = validateObjectNullValue(rec.data.solicitud.oficina_genera_solicitud) && mapSucursalGestor.containsKey(String.valueOf(rec.data.solicitud.oficina_genera_solicitud)) ? rec.data.solicitud.oficina_genera_solicitud + ' - ' + mapSucursalGestor.get(String.valueOf(rec.data.solicitud.oficina_genera_solicitud)): '';
                caso.ID_Usuario__c = validateStringField(rec.data.solicitud.usuario);
                
                if ( validateObjectNullValue(rec.data.solicitud.tipo_referido) && rec.data.solicitud.tipo_referido == 4 ) {

                    caso.ID_Referido_Cajero__c = validateStringField(rec.data.solicitud.numero_empleado);

                } else {

                    caso.ID_Promotor__c = validateStringField(rec.data.solicitud.numero_empleado);
                }                

                /// LLENA CUSTOM
                if ( validateObjectNullValue(rec.data.solicitud.custom) && validateObjectNullValue(rec.data.solicitud.custom.data) ) {

                    ///Custom Id
                    caso.Nombre_s_Anonimo__c = validateStringField(rec.data.solicitud.custom.id);

                    /// DIRECCIONES
                    if ( validateObjectNullValue(rec.data.solicitud.custom.data.datos_contacto) && validateObjectNullValue(rec.data.solicitud.custom.data.datos_contacto.direcciones) ) {
                        System.debug('fer'+rec.data.solicitud.custom.data.datos_contacto.direcciones.Lisdirecciones );
                        for (String keyId: rec.data.solicitud.custom.data.datos_contacto.direcciones.Lisdirecciones.keySet()) {

                            SolicitudGestorJSON.CustomDireccionId customDireccionId = rec.data.solicitud.custom.data.datos_contacto.direcciones.Lisdirecciones.get(keyId);

                            if ( validateObjectNullValue(customDireccionId.tipo) && customDireccionId.tipo == 1) {                                

                                if ( validateObjectNullValue(customDireccionId.direccion_distinta_ine) && customDireccionId.direccion_distinta_ine) {

                                    caso.Direcci_n_Diferente_al_INE__c = 'SI';

                                } else {

                                    caso.Direcci_n_Diferente_al_INE__c = 'NO';
                                }

                                caso.Calle__c = validateStringField(customDireccionId.calle);
                                caso.Exterior__c = validateStringField(customDireccionId.numero_exterior);
                                caso.Interior__c = validateStringField(customDireccionId.numero_interior);
                                caso.Colonia_Texto__c = validateStringField(customDireccionId.descripcion_barrio);
                                caso.C_digo_Postal_Texto__c = validateStringField(customDireccionId.codigo_postal);
                                caso.Ciudad__c = validateStringField(customDireccionId.descripcion_ciudad);
                                caso.Poblaci_n_Delegaci_n_o_Municipio__c = validateStringField(customDireccionId.descripcion_region);
                                caso.Estado__c = validateStringField(customDireccionId.poblacion);
                                caso.Otra_Colonia__c = validateStringField(customDireccionId.otra_colonia);

                            } else if ( validateObjectNullValue(customDireccionId.tipo) && customDireccionId.tipo == 2) {

                                caso.Calle_Laboral__c = validateStringField(customDireccionId.calle);
                                caso.N_mero_exterior_laboral__c = validateStringField(customDireccionId.numero_exterior);
                            }
                        }
                    }
                    /// END DIRECCIONES                    

                    /// REFERENCIAS 
                    if ( validateObjectNullValue(rec.data.solicitud.custom.data.referencias) ) {

                        if ( rec.data.solicitud.custom.data.referencias.LisReferencias.size() > 0 ) {

                            customReferenciasId = rec.data.solicitud.custom.data.referencias.LisReferencias.get('1');
                            caso.N_mero_de_contacto_1__c = validateStringField(customReferenciasId.telefono);
                            caso.Nombre_completo_1__c = validateStringField(customReferenciasId.nombre_completo);

                            customReferenciasId = rec.data.solicitud.custom.data.referencias.LisReferencias.get('2');
                            caso.N_mero_de_contacto_2__c = validateStringField(customReferenciasId.telefono);
                            caso.Nombre_completo_2__c = validateStringField(customReferenciasId.nombre_completo);
                        }
                    }
                    /// END REFERENCIAS

                    /// EVALUACIONES
                    if ( validateObjectNullValue(rec.data.solicitud.custom.data.evaluaciones) ) {

                        ///
                        for (String keyEvaluacion: rec.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.keySet()) {

                            evaluacionID = rec.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.get(keyEvaluacion);

                            if ( validateObjectNullValue(evaluacionID.numero_llamada) ) {

                                if ( evaluacionID.numero_llamada == 'INE' ) {

                                    ///
                                    caso.Resultado_INE__c = mapResultadoAutenIne.containsKey(String.valueOf(evaluacionID.resultado_autenticacion_ine)) ? String.valueOf(evaluacionID.resultado_autenticacion_ine) + ' - ' + mapResultadoAutenIne.get(String.valueOf(evaluacionID.resultado_autenticacion_ine)).glosa__c : String.valueOf(evaluacionID.resultado_autenticacion_ine);
                                    banFraudeIne = mapResultadoAutenIne.containsKey(String.valueOf(evaluacionID.resultado_autenticacion_ine)) && mapResultadoAutenIne.get(String.valueOf(evaluacionID.resultado_autenticacion_ine)).Bloqueo_de_Fraudes__c ? true : false;
                                }

                                if (evaluacionID.numero_llamada == 'F2') {

                                    blnNumeroLlamadaF2 = true;

                                    for (SolicitudGestorJSON.Evaluaciones ev: rec.data.solicitud.evaluaciones) {

                                        if ( validateObjectNullValue(ev.id) && ev.id == keyEvaluacion) {

                                            /// Evaluacion Id Fraudes
                                            caso.Oficina_Anonimo__c = keyEvaluacion;

                                            if( (ev.respuesta_motor.get(0) == 14) || (ev.respuesta_motor.get(0) == 15) ) {

                                                banFraude = true;
                                                rechazoFraudes = ev.respuesta_motor.get(0) == 15 ? true : false;                                                
                                                break;
                                            }
                                        }
                                    }
                                }

                            } // No. llamada

                            if ( validateObjectNullValue(evaluacionID.detalle_respuesta_motor) ) {

                                detalle_respuesta_motor = evaluacionID.detalle_respuesta_motor;

                                caso.Cupo__c = validateObjectNullValue(evaluacionID.detalle_respuesta_motor.cupoRecomendado) ? Decimal.valueOf(evaluacionID.detalle_respuesta_motor.cupoRecomendado): null;

                                if ( validateObjectNullValue(evaluacionID.detalle_respuesta_motor.codigoOperacion) && evaluacionID.detalle_respuesta_motor.codigoOperacion == '02') {

                                    banCredito = true;                                    
                                }

                                /// Evaluacion Id Credito
                                caso.Apellido_s_Anonimo__c = keyEvaluacion;

                                // map respuesta Motor
                            }
                        }

                    } // end evaluacionesCUSTOM

                } // if custom                

                if ( validateObjectNullValue(rec.data.solicitud.productos) && rec.data.solicitud.productos.size() > 0 ) {

                    productos = rec.data.solicitud.productos.get(0);
                    caso.Producto_solicitado__c = validateObjectNullValue(productos.tipo) && mapProductoTipoGestor.containsKey(String.valueOf(productos.tipo)) ? mapProductoTipoGestor.get(String.valueOf(productos.tipo)): '';

                    caso.Fecha_de_Pago_Riesgos__c = validateStringField(productos.dia_facturacion);
                    caso.Env_o_de_estado_de_cuenta__c = validateStringField(productos.envio_estado_cuenta);
                }                

                if( validateObjectNullValue(rec.data.solicitud.datos_contacto) ) {

                    if ( validateObjectNullValue(rec.data.solicitud.datos_contacto.telefonos) ) {

                        for (SolicitudGestorJSON.Telefonos t: rec.data.solicitud.datos_contacto.telefonos) {

                            if( validateObjectNullValue(t.tipo) ) {

                                //personal
                                if (t.tipo == 1) {

                                    caso.N_mero_de_Tel_fono_Casa__c = validateStringField(t.numero);
                                }

                                //laboral
                                if (t.tipo == 2) {

                                    caso.N_mero_tel_fono_trabajo__c = validateStringField(t.numero);
                                }

                                //Movil
                                if (t.tipo == 3) {

                                    caso.N_mero_de_Tel_fono_M_vil__c = validateStringField(t.numero);
                                    /// Telefono Id
                                    caso.Contrato_Anonimo__c = validateStringField(t.id);
                                }
                            }
                        }
                    }

                    caso.Email__c = validateStringField(rec.data.solicitud.datos_contacto.email);
                }
                
                if ( validateObjectNullValue(rec.data.solicitud.laborales) ) {

                    for (SolicitudGestorJSON.Laborales laborales: rec.data.solicitud.laborales) {

                        // si tiene laborales.fecha_egreso es el empleo anterior
                        if ( laborales.fecha_egreso == null ) {

                            // laborales.antiguedad en meses viene trabajar  años
                            caso.Nombre_de_Empresa__c = validateStringField(laborales.nombre_empresa);

                            if( validateObjectNullValue(laborales.antiguedad) ) {

                                caso.Empleo_Actual_A_os__c = String.valueOf(laborales.antiguedad / 12);
                                caso.Empleo_Actual_Meses__c = String.valueOf(laborales.antiguedad);
                            }

                            caso.Actividad_o_giro_del_negocio__c = validateObjectNullValue(laborales.giro) && mapActividadGiroGestor.containsKey(String.valueOf(laborales.giro)) ? mapActividadGiroGestor.get(String.valueOf(laborales.giro)): '';

                            caso.Ocupaci_n_o_profesi_n__c = validateObjectNullValue(laborales.actividad) && mapOcupacionGestor.containsKey(String.valueOf(laborales.actividad)) ? mapOcupacionGestor.get(String.valueOf(laborales.actividad)): '';

                            caso.Persona_f_sica_con_actividad_empresarial__c = validateObjectNullValue(laborales.actividad_empresarial) && laborales.actividad_empresarial  == true ? 'SI' : 'NO';

                        } else {

                            caso.Empleo_Anterior_Nombre_de_la_Empresa__c = validateStringField(laborales.nombre_empresa);
                            caso.Empleo_Anterior_Fecha_de_Ingreso__c = validateStringField(laborales.fecha_ingreso);
                            caso.Empleo_Anterior_Fecha_de_Egreso__c = validateStringField(laborales.fecha_egreso);
                        }
                    }
                }

                if ( validateObjectNullValue(rec.data.solicitud.datos_financieros) ) {

                    if ( validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos) ) {                        

                        if ( validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos.acepta_publicidad) && rec.data.solicitud.datos_financieros.normativos.acepta_publicidad) {

                            caso.Aviso_de_privacidad__c = 'SI';
                            caso.Num_promedio_de_disposiciones_mensuales__c = 'SI';

                        } else {

                            caso.Aviso_de_privacidad__c = 'NO';
                            caso.Num_promedio_de_disposiciones_mensuales__c = 'NO';
                        }                        

                        if ( validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos.acepta_terminos) && rec.data.solicitud.datos_financieros.normativos.acepta_terminos) {

                            caso.Acept_t_rminos__c = 'SI';

                        } else {

                            caso.Acept_t_rminos__c = 'NO';
                        }
                        
                        caso.Origen_de_los_Recursos__c = validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos.origen_recursos) && mapOrigenRecursosGestor.containsKey(String.valueOf(rec.data.solicitud.datos_financieros.normativos.origen_recursos)) ? mapOrigenRecursosGestor.get(String.valueOf(rec.data.solicitud.datos_financieros.normativos.origen_recursos)) : '';

                        caso.Destino_de_los_Recursos__c = validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos.destino_recursos) && mapDestinoRecursosGestor.containsKey(String.valueOf(rec.data.solicitud.datos_financieros.normativos.destino_recursos)) ? mapDestinoRecursosGestor.get(String.valueOf(rec.data.solicitud.datos_financieros.normativos.destino_recursos)): '';

                        caso.Monto_promedio_de_disposici_n__c = validateObjectNullValue(rec.data.solicitud.datos_financieros.normativos.promedio_gasto_tarjeta) && mapGastoPromedioGestor.containsKey(String.valueOf(rec.data.solicitud.datos_financieros.normativos.promedio_gasto_tarjeta)) ? mapGastoPromedioGestor.get(String.valueOf(rec.data.solicitud.datos_financieros.normativos.promedio_gasto_tarjeta)): '';
                        
                        caso.Fiel__c = validateStringField(rec.data.solicitud.datos_financieros.normativos.numero_serie);

                    } // normativos

                    caso.Ingresos_mensuales__c = validateObjectNullValue(rec.data.solicitud.datos_financieros.renta) ? validateStringField(rec.data.solicitud.datos_financieros.renta.sueldo_bruto): '';
                }                

                if (banCredito || banFraude || banFraudeIne || (validateObjectNullValue(rec.data.solicitud.canal) && rec.data.solicitud.canal == 2) ) {

                    // Bandeja de Credito
                    caso.Publicidad__c = banFraude;
                    caso.Validar_Movimientos__c = banCredito;
                    caso.Bloqueo_de_Tarjeta_por_Cancelaci_n__c = banFraudeIne;
                    caso.OwnerId = validateObjectNullValue(rec.data.solicitud.canal) && rec.data.solicitud.canal == 2 ? mapGrupos.get(QUEUE_FIGITAL) : mapGrupos.get(QUEUE_CREDITO);
                    /// Se envio la Solicitud a la Bandeja de Credito
                    ownerCredito = true;                    
                }

                /// N intentos mapeo de campos, cuando la info de la solicitud no esta completa en el Gestor
                withoutNumberCallF2 = blnNumeroLlamadaF2
                                    ? (validateObjectNullValue(rec.data.solicitud.canal) && rec.data.solicitud.canal == 2 
                                        ? true 
                                        : (banCredito || banFraude || banFraudeIne ? true : false) ) 
                                    : false;
                numberOfAttemps = mapCases.containsKey(idSolicitud) ? Integer.valueOf(mapCases.get(idSolicitud).Total_a_Condonar__c) + 1 : 1;
                caso.Total_a_Condonar__c = numberOfAttemps;

                Database.UpsertResult upsertCaso = Database.upsert(caso, Case.ID_Solicitud__c);
                
                idCaso = caso.Id;

                /**********  Respuesta Motor Map   ************ */                

                Set<String> codigosV = new Set<String>();
                
                /// Se guarda en un Set los detalle_respuesta_motor para evitar duplicados
                if( validateObjectNullValue(detalle_respuesta_motor) ) {

                    // detalle_respuesta_motor
                    List<Respuesta_Motor__c> lstRespuestaMotor = new List<Respuesta_Motor__c>();

                    for (String item: detalle_respuesta_motor.mapRmotor.keySet()) {

                        if ( (blnCasoReenviado && mapIdCaseRespuestasMotor.containsKey(caso.Id) && !mapIdCaseRespuestasMotor.get(caso.Id).contains(item)) || (!blnCasoReenviado) ) {

                            Respuesta_Motor__c rmotor = new Respuesta_Motor__c();
                            rmotor.Caso__c = caso.Id;
                            rmotor.Name = item;
                            rmotor.Descripcion__c = detalle_respuesta_motor.mapRmotor.get(item);

                            lstRespuestaMotor.add(rmotor);
                        }
                    }

                    if (lstRespuestaMotor.size() > 0) {

                        insert lstRespuestaMotor;
                    }
                    /**********  Respuesta Motor Map  ************ */                    

                    // Crear objetos relacionados [Codigo_de_dudas__c]                    
                    List<Codigo_de_dudas__c> lstCodigoDuda = new List<Codigo_de_dudas__c>();

                    if( validateObjectNullValue(detalle_respuesta_motor.codigoEvaluacion) ) {

                        for (String item: detalle_respuesta_motor.codigoEvaluacion.mCodigoEvaluacion.keySet()) {          
                            
                            String code = detalle_respuesta_motor.codigoEvaluacion.mCodigoEvaluacion.get(item);

                            if ( (blnCasoReenviado && mapIdCaseCodigosDeDuda.containsKey(caso.Id) && !mapIdCaseCodigosDeDuda.get(caso.Id).contains(code)) || (!blnCasoReenviado) ) {                                

                                Codigo_de_dudas__c aux = new Codigo_de_dudas__c();
                                aux.Caso__c = caso.Id;
                                aux.Name = code;
                                aux.Descripci_n__c = mapCatalogoCodigosCM.containsKey(code) ? mapCatalogoCodigosCM.get(code): '';

                                lstCodigoDuda.add(aux);
                                codigosV.add(code);
                            }
                        }
                    }

                    if (lstCodigoDuda.size() > 0) {

                        insert lstCodigoDuda;
                    }

                } // DETEALLE RESPUESTA MOTOR

                //generar validaciones y verificación
                List<Validaciones_del_Caso__c> validacionesToInsert = new List<Validaciones_del_Caso__c>();
                List<Verificaci_n_Telef_nica__c> verificacionesTel = new List<Verificaci_n_Telef_nica__c>();

                for(String strCodigoV: codigosV) {

                    if( mapValidacionesDeCodigo.containsKey(strCodigoV) ) {

                        for(Validaciones_de_Codigo_CM__mdt validacionCodigo: mapValidacionesDeCodigo.get(strCodigoV) ) {

                            /// Se valida si es un caso reenviado y los registro de Validaciones del Caso para evitar duplicados
                            if( !mapIdCaseValidacionesDelCaso.containsKey(caso.Id) || 
                                (mapIdCaseValidacionesDelCaso.containsKey(caso.Id) && !mapIdCaseValidacionesDelCaso.get(caso.Id).contains(validacionCodigo.Catalogo_Validaciones_CM__r.Label)) ) {

                                Validaciones_del_Caso__c validAux = new Validaciones_del_Caso__c();
                                validAux.Case__c = caso.Id;
                                validAux.Name = validacionCodigo.Catalogo_Validaciones_CM__r.Label;

                                validacionesToInsert.Add(validAux);

                                if( !mapIdCaseValidacionesDelCaso.containsKey(caso.Id) ) {

                                    mapIdCaseValidacionesDelCaso.put(caso.Id, new Set<String>() );
                                }

                                mapIdCaseValidacionesDelCaso.get(caso.Id).add(validacionCodigo.Catalogo_Validaciones_CM__r.Label);
                            }
                        }
                    }
                }

                /// Siempre se crea la vaidacion telefonica
                Verificaci_n_Telef_nica__c veriAux = new Verificaci_n_Telef_nica__c();
                veriAux.Caso__c = caso.Id;

                if(caso.Cupo__c > 20000 || caso.Sucursal__c == 'Villa de García') {

                    veriAux.RecordTypeId = Schema.SObjectType.Verificaci_n_Telef_nica__c.getRecordTypeInfosByName().get(RT_VT_VILLAGARCIA).getRecordTypeId();

                } else {
                    
                    veriAux.RecordTypeId = Schema.SObjectType.Verificaci_n_Telef_nica__c.getRecordTypeInfosByName().get(RT_VT_GLOBAL).getRecordTypeId();
                }

                verificacionesTel.Add(veriAux);

                /// Validacion de Fraudes (Pendiente de F2, codigo 14)
                if( banFraude ) {

                    if( !mapIdCaseValidacionesDelCaso.containsKey(caso.Id) || 
                        (mapIdCaseValidacionesDelCaso.containsKey(caso.Id) && !mapIdCaseValidacionesDelCaso.get(caso.Id).contains(VALIDACION_FRAUDES)) ) {

                        Validaciones_del_Caso__c validAux = new Validaciones_del_Caso__c();
                        validAux.Case__c = caso.Id;
                        validAux.Name = VALIDACION_FRAUDES;

                        validacionesToInsert.Add(validAux);
                    }
                }

                /// Validacion de INE
                if( banFraudeIne ) {

                    if( !mapIdCaseValidacionesDelCaso.containsKey(caso.Id) || 
                        (mapIdCaseValidacionesDelCaso.containsKey(caso.Id) && !mapIdCaseValidacionesDelCaso.get(caso.Id).contains(VALIDACION_INE)) ) {

                        Validaciones_del_Caso__c validAux = new Validaciones_del_Caso__c();
                        validAux.Case__c = caso.Id;
                        validAux.Name = VALIDACION_INE;

                        validacionesToInsert.Add(validAux);
                    }
                }

                if (validacionesToInsert.size() > 0) {

                    insert validacionesToInsert;
                }

                if (verificacionesTel.size() > 0) {

                    insert verificacionesTel;
                }

                /// Motivos de Pendiente - Comentarios del Caso
                List<CaseComment> listCometariosCaso = new List<CaseComment>();

                if( mapIdCasoCometariosDelCaso.containsKey(caso.Id) ) {

                    for(CaseComment comentario: mapIdCasoCometariosDelCaso.get(caso.Id) ) {

                        comentario.IsPublished = true;

                        listCometariosCaso.add(comentario);
                    }
                }

                if( listCometariosCaso.size() > 0 ) {

                    update listCometariosCaso;
                }

                if (upsertCaso.isSuccess()) {

                    success = true;
                }

            } // FIN - if(validateObjectNullValue(rec.data) && validateObjectNullValue(rec.data.solicitud))

        } catch (Exception ex) {

            System.debug('ERROR UPDATE INFO:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber());
        }

        result.put('success', success);
        result.put('idCaso', idCaso);
        result.put('ownerCredito', ownerCredito);
        result.put('queueFigital', queueFigital);
        /// N intentos mapeo de campos, cuando la info de la solicitud no esta completa en el Gestor
        result.put('withoutNumberCallF2', withoutNumberCallF2);
        result.put('numberOfAttemps', numberOfAttemps);

        return result;
    }
}