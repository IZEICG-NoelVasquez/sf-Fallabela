/**
* Nombre: MicroServicioDataUpdateGestor
* Autor: Mauricio Rosales
* Descripcion: Llamado el Micro Servicio Actualizacion de Datos Gestor de Solicitudes
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           01/02/2022      Mauricio Rosales        Creación
* --------------------------------------------------------------------------
*/
public  class MicroServicioDataUpdateGestor {

    private ClienteMicroServiciosGestor cliente;

    public MicroServicioDataUpdateGestor() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServiciosGestor();
        cliente.setMethod('POST');
        cliente.generarToken();
    }

    /**
    * Llamado al MicroServicio para Actualizar la Solicitud. Se invoca la clase cliente 
    * Regresa la respuesta del MicroServicio, una variable de exito, el error y el nombre de la clase
    *
    * @param bodyrequest: parametros del MicroServicio
    * @param endpoint: endPoint del MicroServicio
    * @param banupdate: booleano para identificar si es un Metodo PATCH
    **/
    public Map<String, Object> actualizarTicket(String bodyrequest , String endpoint , Boolean banupdate) {
        
        Map<String, Object> mapResult = new Map<String, Object>();

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse response;
        Boolean isSuccess = false;
        GenericResponseGestorJson resultGenericResponseGestor = null; 
        cliente.setMethod('POST'); // NO ADMITE PATCH SF
		cliente.setEndpoint(endpoint);
        HttpRequest req = cliente.doRequest_2(bodyrequest, banUpdate);

        String error = '';

        try {   
			
            for (Integer i = 0; i < 3; i++) {

                response = cliente.enviarRequest(req);

                if (response.getStatusCode() == 202) {
                    isSuccess = true;
                    break;
                }
            }

            System.debug('**** response ' + response.getBody());
            
            if (isSuccess) {

                resultGenericResponseGestor = GenericResponseGestorJson.parse(response.getBody());
                
            } else {

                error = String.valueOf(response.getStatusCode());
            }
            
        } catch (Exception e) {

            error = e.getMessage();
            System.debug('ERROR:  ' + e.getMessage() + '  LINEA:  ' + e.getLineNumber() );
        }

        mapResult.put('resultGenericResponseGestor', resultGenericResponseGestor);
        mapResult.put('isSuccess', isSuccess);
        mapResult.put('error', error);
        mapResult.put('currentClassName', currentClassName);
        return mapResult;
    }

    /**
    * Validacion del Response de la metodo actualizarTicket (Actualizacion de Datos Gestor de Solicitudes)
    * Regresa la respuesta del metodo actualizarTicket
    *
    * @param mapResponse: mapa con la respuesta del llamado el MS Actualizacion de Datos Gestor 
    **/
    public static Map<String,Object> validateResponse(Map<String,Object> mapResponse) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;
        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

        if( Boolean.valueOf(mapResponse.get('isSuccess')) && mapResponse.get('resultGenericResponseGestor') != null ) {

            success = true;

        } else if( !Boolean.valueOf(mapResponse.get('isSuccess')) && mapResponse.containsKey('currentClassName') && mapResponse.containsKey('error') ) {

            Error_Log__c errorLog = new Error_Log__c();
            errorLog.ApexClass__c = String.valueOf( mapResponse.get('currentClassName') );
            errorLog.Message__c = String.valueOf( mapResponse.get('error') );

            lstErrorLog.add(errorLog);
        }

        mapResult.put('success', success);
        mapResult.put('lstErrorLog', lstErrorLog);
        return mapResult;
    }

    /**
    * Endpoint Custom para actualizar el cupoRecomendado y el codigoOperacion (Pendiente de Credito)
    * Regresa la respuesta del metodo actualizarTicket
    *
    * @param msDataUpdate: constructor MicroServicioDataUpdateGestor para el llamado del MS
    * @param mapFields: mapa con los parametros para la actualizacion
    **/
    public static Map<String,Object> updateGestorCustom(MicroServicioDataUpdateGestor msDataUpdate, Map<String, String> mapFields) {

        Map<String,Object> mapResponse = new Map<String,Object>();

        /// Actualizacion de Custom
        String endpoint = 'custom/' + mapFields.get('customId');
    
        Map<String,Object> mapRequest = new Map<String,Object>();

        Map<String,String> mapDetalleRespuestaMotor = new Map<String,String>();
        
        if( mapFields.containsKey('creditLimit') ) {

            mapDetalleRespuestaMotor.put('cupoRecomendado', mapFields.get('creditLimit'));

        } else if( mapFields.containsKey('codigoOperacion') && mapFields.containsKey('glosaCodigoOperacion') ) {

            mapDetalleRespuestaMotor.put('codigoOperacion', mapFields.get('codigoOperacion'));            
            mapDetalleRespuestaMotor.put('glosaOperacion', mapFields.get('glosaCodigoOperacion'));
        }

        Map<String,Object> mapData = new Map<String,Object>();

        /// Marca de Seguridad
        if( mapFields.containsKey('back_office') ) {

            Map<String,Object> mapBackOffice = new Map<String,Object>();

            mapBackOffice.put('updated_at', System.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS Z') );
            mapBackOffice.put('processed', true);            

            mapData.put('back_office', mapBackOffice);
        }

        if( mapFields.containsKey('creditLimit') || mapFields.containsKey('codigoOperacion') || mapFields.containsKey('glosaCodigoOperacion') ) {

            Map<String,Object> mapEvaluacionId = new Map<String,Object>();
            mapEvaluacionId.put('detalle_respuesta_motor', mapDetalleRespuestaMotor);

            Map<String,Object> mapEvaluaciones = new Map<String,Object>();
            mapEvaluaciones.put( mapFields.get('evaluacionId'), mapEvaluacionId);        

            mapData.put('evaluaciones', mapEvaluaciones);
        }        

        mapRequest.put('data', mapData);

        String bodyRequest = JSON.serialize(mapRequest);

        mapResponse = msDataUpdate.actualizarTicket(bodyrequest, endpoint, true);        

        return mapResponse;
    }

    /**
    * Endpoint Evaluaciones para actualizar el monto aprobado por motor
    * Regresa la respuesta del metodo actualizarTicket
    *
    * @param msDataUpdate: constructor MicroServicioDataUpdateGestor para el llamado del MS
    * @param mapFields: mapa con los parametros para la actualizacion
    **/
    public static Map<String,Object> updateGestorEvaluaciones(MicroServicioDataUpdateGestor msDataUpdate, Map<String, String> mapFields) {

        Map<String,Object> mapResponse = new Map<String,Object>();

        /// Actualizacion de Evaluaciones
        String endpoint = 'evaluaciones/' + mapFields.get('evaluacionId');

        Map<String,Object> mapRequest = new Map<String,Object>();
        mapRequest.put('monto_aprobado_motor', mapFields.get('creditLimit'));

        String bodyRequest = JSON.serialize(mapRequest);

        mapResponse = msDataUpdate.actualizarTicket(bodyrequest, endpoint, true);

        return mapResponse;
    }

    /**
    * Endpoint Telefonos para actualizar el telefono movil
    * Regresa la respuesta del metodo actualizarTicket
    *
    * @param msDataUpdate: constructor MicroServicioDataUpdateGestor para el llamado del MS
    * @param mapFields: mapa con los parametros para la actualizacion
    **/
    public static Map<String,Object> updateGestorTelefonos(MicroServicioDataUpdateGestor msDataUpdate, Map<String, String> mapFields) {

        Map<String,Object> mapResponse = new Map<String,Object>();

        /// Actualizacion del Telefono Mobil
        String endpoint = 'telefonos/' + mapFields.get('telefonoId');

        Map<String,Object> mapRequest = new Map<String,Object>();
        mapRequest.put('numero', mapFields.get('mobilePhone'));

        String bodyRequest = JSON.serialize(mapRequest);

        mapResponse = msDataUpdate.actualizarTicket(bodyrequest, endpoint, true);

        return mapResponse;
    }


    /**
    * Endpoint Evaluaciones para actualizar de las Respuestas del Motor
    * Regresa la respuesta del metodo actualizarTicket
    *
    * @param idEvaluacion: id de la Solicitud
    * @param respMotor: codigo para la actualizazion de la respuesta del motor
    * @param msActualizarTicket: constructor MicroServicioDataUpdateGestor para el llamado del MS
    **/
    public static Map<String,Object> updateEvaluacionesMotor(String idEvaluacion, Integer respMotor, MicroServicioDataUpdateGestor msActualizarTicket) {

        Map<String,Object> mapResponse = new Map<String,Object>();

        Map<String, List<Integer>> mapEvaluaciones =  new Map<String,List<Integer>>();

        String endpoint = 'evaluaciones/' + idEvaluacion;
        mapEvaluaciones.put('respuesta_motor', new List<Integer>{respMotor} );
        String bodyrequestEv = JSON.serialize(mapEvaluaciones);

        mapResponse = msActualizarTicket.actualizarTicket(bodyrequestEv, endpoint ,true);

        return mapResponse;
    }
}