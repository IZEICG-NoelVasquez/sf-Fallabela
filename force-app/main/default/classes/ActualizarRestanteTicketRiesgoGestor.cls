/**
* Nombre: ActualizarRestanteTicketRiesgoGestor
* Autor
* Descripcion: Clase controladora del Componente Lightning ActualizarRestanteTicketRiesgoCmp
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           17/03/2021      Mauricio Rosales            Ajustes para cargar la informacion del caso al abrir el componente
* 3.0           27/09/2021      Mauricio Rosales            Re factor del API creacion de casos Back Office
* --------------------------------------------------------------------------
*/
public  class ActualizarRestanteTicketRiesgoGestor {

    private ClienteMicroServiciosGestor cliente;
    
    public ActualizarRestanteTicketRiesgoGestor() {

       String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
       cliente = new ClienteMicroServiciosGestor();
       cliente.setMicroServicio('ConsultaSolicitudGestor');
       cliente.setMethod('POST');
       cliente.generarToken();
    }
    
    public Map<String,Object> recuperarInfoSolicitudMicroS(String idSolicutud) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse response;
        cliente.setMethod('GET');
        cliente.setEndpoint('solicitud/?numeroSolicitud='+idSolicutud);
        HttpRequest req = cliente.doRequest(null);
        Boolean isSuccess = false;
        SolicitudGestorJSON resultSolicitudGestor;        

        Map<String,Object> mapResult = new Map<String,Object>();
        String error = '';
       
        try {
            
            for (Integer i = 0; i < 3; i++) {

                response = cliente.enviarRequest(req);

                if (response.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('response ' + response.getBody());
            
            if (isSuccess) {

                resultSolicitudGestor = SolicitudGestorJSON.parse(response.getBody());
                
                ///isSuccess = true;
                ///resultSolicitudGestor = SolicitudGestorJSON.parse('{"code":"002","message":"Petición Procesada","data":{"solicitud":{"id":"c9caf2ad-6c50-40dd-8f9e-eb79ea70fa82","numero":300000702,"fecha_solicitud":"2021-10-27 20:22:59.67146384 +0000 UTC","tipo":1,"estado":4,"canal":1,"oficina_genera_solicitud":3,"fecha_creacion_gestor":"2021-10-27 20:22:59.67146384 +0000 UTC","fecha_actualizacion_estado":"2022-01-18 19:22:01.248567273 +0000 UTC","usuario":"usuariomonitoreo1@falabella.com.mx","datos_identificacion":{"tipo":1,"numero":"WUQS931031HDFFMH65","numero_serie":"N/I","bloqueo":1},"datos_contacto":{"email":"qa@qa.com","telefonos":[{"id":"6e293ea7-b391-4aa3-8655-b7abc68d7f6c","tipo":3,"numero":"5213111111111","codigo_area":521}]},"datos_financieros":{"normativos":{"id":"0c5f215c-01d8-4746-8f29-1e50b0c50bbf","acepta_terminos":true,"aviso_privacidad":true,"acepta_publicidad":true,"origen_recursos":8,"destino_recursos":9,"promedio_gasto_tarjeta":3,"promedio_uso_tarjeta":1},"renta":{"id":"ea8f33d4-3cf4-43e0-92f0-ec0aacaffbd8","sueldo_bruto":"45435"}},"evaluaciones":[{"id":"c8de390e-a171-4118-abcd-a1555abab0b0","respuesta_motor":[12]},{"id":"4ee66124-1fdf-41b1-bd06-46e0e03447bf"},{"id":"dd5c9579-54cc-4bb8-9a6e-5c81bccde0cf","respuesta_motor":[1]},{"id":"b0213e2b-4018-44e4-9718-c3a23d828671","monto_aprobado_motor":"150000.0","respuesta_motor":[3]},{"id":"e4e5a64f-0d71-41f4-beef-f3adaa67461b","respuesta_motor":[14]}],"productos":[{"id":"8ecb898c-a678-4116-a6a4-c71ea7ca793e","tipo":1,"dia_facturacion":"1","envio_estado_cuenta":"email"}],"medios_de_pago":[{"id":"445e97d5-35f5-42ec-910b-dfc06e72a491","tipo":2}],"identificaciones":[{"id":"5e94b726-34aa-496e-88f2-9e02befca6bc","tipo":2,"numero":"WUQS931031"},{"id":"dcd50285-8bf5-4fda-8d8c-a196504e6d9d","tipo":1,"numero":"WUQS931031HDFFMH65","numero_serie":"12","clave":"GMVLMR80070501M426","codigo1":"","codigo2":"3423423424234"}],"custom":{"id":"ecdf8e9d-5193-49b4-be2b-b705a09b7aa3","data":{"datos_contacto":{"direcciones":{"1":{"calle":"fsdf","codigo_postal":"26554","descripcion_barrio":"Alfonso Valdez","descripcion_ciudad":"Allende","descripcion_region":"COA","direccion_distinta_ine":false,"numero_exterior":"343","numero_interior":"","poblacion":"Allende","tipo":1},"2":{"calle":"hfgh","numero_exterior":"54","tipo":2}}},"evaluaciones":{"4ee66124-1fdf-41b1-bd06-46e0e03447bf":{"numero_llamada":"INE","resultado_autenticacion_ine":43},"b0213e2b-4018-44e4-9718-c3a23d828671":{"detalle_respuesta_motor":{"autenticacion":"false","bcscore":"0","codigoEvaluacion":{"0":"6050","1":"5006","2":"1000","3":"9001","4":"9002"},"codigoOperacion":"02","conexionCreditica":"0","cupoRecomendado":"150000.0","decisionMotor":"B","flagPreeva":"2","flagPreevaAuto":"1","flagPreevaHipo":"1","flagPreevaTc":"1","glosaOperacion":"Evaluacion Aceptada","idEmpleado":"1","scoreBuro":"-1","scoreSociodemografico":"466","valiPreeva":"2","webAgent":"ClienteWeb ClienteWeb"},"numero_llamada":"E2"},"c8de390e-a171-4118-abcd-a1555abab0b0":{"numero_llamada":"F1"},"dd5c9579-54cc-4bb8-9a6e-5c81bccde0cf":{"decision_motor":"B","empleado_falabella":true,"numero_llamada":"E1"},"e4e5a64f-0d71-41f4-beef-f3adaa67461b":{"numero_llamada":"F2"}},"referencias":{"1":{"nombre_completo":"hfghfh","telefono":"5654654664"},"2":{"nombre_completo":"hgfhfgh","telefono":"4543576576"}}}},"personales":[{"id":"d92e7148-4356-4c74-bb76-a4b69aa42aaf","nombre1":"fdsfs","nombre2":"","apellido1":"fds","apellido2":"fdsf","fecha_nacimiento":"1993-10-31","nacionalidad":1,"sexo":1,"estado_civil":7,"lugar_nacimiento":"df","cantidad_dependientes":0}],"laborales":[{"id":"3f5234e8-4689-4968-b3e0-d28a70d1a2c1","nombre_empresa":"hfghgf","giro":37,"actividad":3,"fecha_ingreso":"1990-01-01","antiguedad":381,"actividad_empresarial":false}]}}}');
                
            } else {

                error = String.valueOf(response.getStatusCode());
            }

        } catch (Exception ex) {

            System.debug('Error: ' + ex);
            error = String.valueOf(ex);
        }

        mapResult.put('resultSolicitudGestor', resultSolicitudGestor);
        mapResult.put('isSuccess', isSuccess);
        mapResult.put('error', error);
        mapResult.put('currentClassName', currentClassName);

      return mapResult;
    }

    @AuraEnabled
    public static Map<String, Object> recuperarInformacionSolicitud(String idSolicutud, Boolean blnComponente) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        Map<String,Object> resultRestantes;

        ActualizarRestanteTicketRiesgoGestor  msRecuperarInfo = new ActualizarRestanteTicketRiesgoGestor();
        Map<String,Object> recuperarInfo = msRecuperarInfo.recuperarInfoSolicitudMicroS(idSolicutud);
        
        if ( Boolean.valueOf(recuperarInfo.get('isSuccess')) && recuperarInfo.get('resultSolicitudGestor') != null) {

            ///
            List<Case> casoReenviado = [SELECT Solicitud_Repetida__c FROM Case WHERE ID_Solicitud__c =: idSolicutud LIMIT 1];

            CrearCasosGestorBackOffice crearCasosGestor = new CrearCasosGestorBackOffice();
            crearCasosGestor.loadCatalogCM();
            crearCasosGestor.loadCaseInfo( new List<String>{idSolicutud} );
            
            if( casoReenviado.size() > 0 && (casoReenviado[0].Solicitud_Repetida__c) ) {

                resultRestantes = crearCasosGestor.casoUpsertRestantes( (SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'), idSolicutud, true);

            } else {

                resultRestantes = crearCasosGestor.casoUpsertRestantes( (SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'), idSolicutud, false);
            }
            
            if( Boolean.valueOf( resultRestantes.get('success') ) ) {

                success = true;
            }
        }

        System.debug('Recuperar Informacion Solicitud Success: ' + success);
        result.put('success', success);
        result.put('recuperarInfo', recuperarInfo);
        
        return result;
    }
    
    /*
    * Obtiene el registro de Casos
    * Regresa un Mapa con una variable booleana de exito y el registro del Caso
    *
    * @param recordId: id de la Solicitud
    */
    @AuraEnabled
    public static Map<String, Object> getCaseInfo(String recordId) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        System.debug('recordId:  ' + recordId);

        List<Case> lstCases = [SELECT ID_Solicitud__c, Actualizaci_n_de_domicilio_en_SAT__c FROM Case WHERE Id =: recordId];

        System.debug('lstCases:  ' + lstCases);

        if( lstCases.size() > 0 ) {

            mapResult.put('caseInfo', lstCases[0]);

            success = true;
        }

        mapResult.put('success', success);

        return mapResult;
    }
}