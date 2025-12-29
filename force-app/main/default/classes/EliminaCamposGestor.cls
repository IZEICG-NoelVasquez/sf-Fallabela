/**
* Nombre: EliminaCamposGestor
* Autor: ---
* Descripcion: Consumo de Micro Servicio para Eliminar las Observaciones en el Gestor
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           04/10/2021      Mauricio Rosales            Re factor del API creacion de casos Back Office
* --------------------------------------------------------------------------
*/
public class EliminaCamposGestor {

    private ClienteMicroServiciosGestor cliente;

    public EliminaCamposGestor() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServiciosGestor();
        cliente.setMethod('POST');
        cliente.generarToken();
    }
    
    public static Map<String, Object>  eliminaCampos(SolicitudGestorJSON rec) {

        Map<String, Object> result = new Map<String, Object>();
        EliminaCamposGestor el = new EliminaCamposGestor();
        Boolean success = false;
        Map<String,Object> mapResponse = new Map<String,Object>();

        List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

        try {

            if (rec.data.solicitud.observaciones != null) {

                for (SolicitudGestorJSON.Observaciones observaciones: rec.data.solicitud.observaciones) {
                    
                    String endpoint = 'observaciones/'+observaciones.id;
                    mapResponse = el.eliminaObservaciones(endpoint);
                    
                    if( Boolean.valueOf(mapResponse.get('isSuccess')) && mapResponse.get('resultGenericResponseGestor') != null ) {

                        success = true;

                    } else if( !Boolean.valueOf(mapResponse.get('isSuccess')) && mapResponse.containsKey('currentClassName') && mapResponse.containsKey('error') ) {

                        Error_Log__c errorLog = new Error_Log__c();
                        errorLog.ApexClass__c = String.valueOf( mapResponse.get('currentClassName') );
                        errorLog.Message__c = String.valueOf( mapResponse.get('error') );

                        lstErrorLog.add(errorLog);
                    }
                }            
            } 

        } catch (Exception ex) {

            System.debug('Error Eliminaobservaciones *******' + ex.getMessage());
        }

        result.put('success', success);
        result.put('deleteData', mapResponse.containsKey('resultGenericResponseGestor') ? mapResponse.get('resultGenericResponseGestor') : '');
        ///
        result.put('createErrorLog', lstErrorLog.size() > 0 ? true: false);
        result.put('lstErrorLog', lstErrorLog);

        return result;
    }

    public Map<String,Object> eliminaObservaciones(String endpoint) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse response;
        Boolean isSuccess = false;
        GenericResponseGestorJson resultGenericResponseGestor; 
        cliente.setMethod('DELETE'); // NO ADMITE PATCH SF
        cliente.setEndpoint(endpoint);
        HttpRequest req = cliente.doRequest(null);

        Map<String,Object> mapResult = new Map<String,Object>();
        String error = '';

        try {   
            
            for (Integer i = 0; i < 3; i++) {

                response = cliente.enviarRequest(req);

                if (response.getStatusCode() == 202) {

                    isSuccess = true;
                    break;
                }
            }
            
            if(isSuccess) {

                resultGenericResponseGestor = GenericResponseGestorJson.parse(response.getBody());  
                    
            } else {

                error = String.valueOf(response.getStatusCode());
            }
            
        } catch(Exception e) {

            error = e.getMessage();
            System.debug('ERROR:  ' + e.getMessage() + '  LINEA:  ' + e.getLineNumber() );
        }

        mapResult.put('resultGenericResponseGestor', resultGenericResponseGestor);
        mapResult.put('isSuccess', isSuccess);
        mapResult.put('error', error);
        mapResult.put('currentClassName', currentClassName);

        return mapResult;    
    }
}