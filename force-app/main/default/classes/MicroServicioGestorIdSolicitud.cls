/**
* Nombre: MicroServicioGestorIdSolicitud
* Autor: Mauricio Rosales
* Descripcion: Llamado al MicroServicio GestorIdSolicitud
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           16/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class MicroServicioGestorIdSolicitud {

    private ClienteMicroServiciosGestor client;
    private static final String POST = 'POST';
    private static final String GET = 'GET';
    private static final String MICROSERVICIO = 'ConsultaSolicitudGestor';

    public MicroServicioGestorIdSolicitud() {

        client = new ClienteMicroServiciosGestor();
        client.setMicroServicio(MICROSERVICIO);
        client.setMethod(POST);
        client.generarToken();
    }
    

    /**
    * Llamado al MicroServicio GestorIdSolicitud para obtener el Id Solicitud relacionado con el CURP del cliente, en caso de exito se parsea la respuesta con la clase IdSolicitudGestorJSON
    * @return regresa un JSON con la respuesta del MicroServicio
    *
    * @param numeroIdentificacion: curp del cliente
    * @param tipoIdentificacion: parametro para identificar el tipo de document
    **/
    public IdSolicitudGestorJSON msGetIdRequest(String numeroIdentificacion, String tipoIdentificacion) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));

        HttpResponse res;
        client.setMethod(GET);
        client.setEndpoint('solicitudes/?numeroIdentificacion=' + numeroIdentificacion + '&tipoIdentificacion=' + tipoIdentificacion);
        HttpRequest req = client.doRequest(null);

        Boolean isSuccess = false;
        IdSolicitudGestorJSON result;

        try {   
			
            for (Integer i = 0; i < 3; i++) {

                res = client.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());
            
            if (isSuccess) {

                result = IdSolicitudGestorJSON.parse(res.getBody());

            } else {

                client.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

            ///result = IdSolicitudGestorJSON.parse('{"code":"002","message":"Petición Procesada","data":[{"numero":"3027123","tipo_solicitud":1,"estado":6,"fecha":"2020-12-31 12:30:00.427471 +0000 UTC","productos":[{"id":"0f91a357-8238-4b40-ae9b-62e44275857e","tipo":2}]}]}');
            
        } catch (Exception e) {
            
            client.logError(currentClassName, e.getMessage());        
        }

        return result;
    }


    /**
    * Llamado al MicroServicio GestorIdSolicitud para obtener el Id Solicitud relacionado con el CURP del cliente
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param numeroIdentificacion: curp del cliente
    * @param tipoIdentificacion: parametro para identificar el tipo de documento
    **/
    public static Map<String, Object> getIdRequest(String numeroIdentificacion, String tipoIdentificacion) {

        Map<String,Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        MicroServicioGestorIdSolicitud msIdRequest = new MicroServicioGestorIdSolicitud();
        IdSolicitudGestorJSON idRequest = msIdRequest.msGetIdRequest(numeroIdentificacion, tipoIdentificacion);

        if( idRequest != null ) {

            success = true;
        }

        mapResult.put('success', success);
        mapResult.put('idRequest', idRequest);

        return mapResult;
    }
}