/**
* Nombre: ServiceSolicitudRiesgosHelper
* Autor: ---
* Descripcion: Clase Helper del API ServiceSolicitudRiesgos
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           20/09/2021      Mauricio Rosales            Re factor del API creacion de casos Back Office
* 3.0           20/12/2021      Mauricio Rosales            Consulta de campos al crear la solicitud y si la consulta no es exitosa crear el caso
* --------------------------------------------------------------------------
*/
public with sharing class ServiceSolicitudRiesgosHelper {
    
    private static final String  CURRENT_CLASS ='ServiceSolicitudRiesgosHelper';
    
    private static final String STATUS_OK = 'OK';
    private static final String STATUS_PARAMETRO = 'Falta parametro ';
    private static final String STATUS_TIEMPO_AGOTADO = 'Tiempo de Espera Agotado';

    public static Map<String, Object> WSCreateSolicitudGestor (String JSONsolicitud) {
        
        Map<String, Object> mapReturn = new Map<String, Object>();
        result r = new result(null,null,null,null,null,null);
        
        try {
            
            WSCreateDataBO createData = (WSCreateDataBO) JSON.deserialize(JSONsolicitud, WSCreateDataBO.class);
            String params;

            params = createData.cardapplicationid == null ? ' cardapplicationid' : '';

            if(String.isNotBlank(params)) {
                
                r.Respuesta = STATUS_PARAMETRO+' '+params;
                r.ID_Ticket = '';
                r.codigoOperacion = '01';
                r.glosaOperacion = 'Falla recepcion informacion';
                r.numeroSolicitud = createData.cardapplicationid;
                r.fechaSolicitud = System.now();
                mapReturn.put('success',false);
                ErrorLog.log(CURRENT_CLASS, System.JSON.serializePretty(r).length() > 255 ? System.JSON.serializePretty(r).substring(0, 254) : System.JSON.serializePretty(r) );

            } else {                

                ///
                String idSolicitud = String.valueOf(createData.cardapplicationid);
                String casoId;

                List<Error_Log__c> lstErrorLog = new List<Error_Log__c>();

                ///
                ActualizarRestanteTicketRiesgoGestor msRecuperarInfo = new ActualizarRestanteTicketRiesgoGestor();
                Map<String,Object> recuperarInfo = msRecuperarInfo.recuperarInfoSolicitudMicroS(idSolicitud);

                if( Boolean.valueOf(recuperarInfo.get('isSuccess')) && recuperarInfo.get('resultSolicitudGestor') != null ) {

                    /// Se eliminan las Observaciones del Gestor
                    Map<String,Object> resultEliminaCampos = EliminaCamposGestor.eliminaCampos((SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'));
                    
                    /// Errores al eliminar Observaciones en el Gestor
                    if( !Boolean.valueOf(resultEliminaCampos.get('success')) && Boolean.valueOf(resultEliminaCampos.get('createErrorLog')) ) {

                        for(Error_Log__c error: (List<Error_Log__c>)resultEliminaCampos.get('lstErrorLog') ) {

                            lstErrorLog.add(error);
                        }
                    }

                    /// Se crea la solicitud
                    Map<String, Object> mapResultCreacion = CrearCasosGestorBackOffice.casoUpsertCreacion(createData, idSolicitud);
                    casoId = String.valueOf( mapResultCreacion.get('idCaso') );

                    /// Se cargan los catalogos de los Custom Metadata y los registros relacionados al caso
                    CrearCasosGestorBackOffice crearCasosGestor = new CrearCasosGestorBackOffice();
                    crearCasosGestor.loadCatalogCM();
                    crearCasosGestor.loadCaseInfo( new List<String>{idSolicitud} );

                    /// Se actualizan los campos restantes del Caso
                    crearCasosGestor.casoUpsertRestantes( (SolicitudGestorJSON)recuperarInfo.get('resultSolicitudGestor'), idSolicitud, Boolean.valueOf(mapResultCreacion.get('blnCasoReenviado')) );

                } else if( !Boolean.valueOf(recuperarInfo.get('isSuccess')) ) {

                    /// Se crea el caso en la bandeja temporal 
                    Map<String,Object> resultCreacion = CrearCasosGestorBackOffice.casoUpsertCreacion(createData, idSolicitud);
                    casoId = String.valueOf( resultCreacion.get('idCaso') );                    

                    if( recuperarInfo.containsKey('currentClassName') && recuperarInfo.containsKey('error') ) {

                        /// Error al consultar el Micro Servicio ActualizarRestanteTicketRiesgoGestor
                        Error_Log__c errorLog = new Error_Log__c();
                        errorLog.ApexClass__c = String.valueOf( recuperarInfo.get('currentClassName') );
                        errorLog.Message__c = String.valueOf( recuperarInfo.get('error') );

                        lstErrorLog.add(errorLog);
                    }
                }

                if( lstErrorLog.size() > 0 ) {

                    insert lstErrorLog;
                }

                //En esta sección se obtinene el número de caso para retornar respuesta
                List<Case> casoLst = [SELECT CaseNumber FROM Case WHERE Id =: casoId];
            
                if(casoLst.size() > 0) {

                    r.Respuesta = STATUS_OK+' '+params;
                    r.ID_Ticket = casoLst.get(0).CaseNumber;
                    r.codigoOperacion = '00';
                    r.glosaOperacion = 'Consulta exitosa';
                    r.numeroSolicitud = createData.cardapplicationid;
                    r.fechaSolicitud = System.now();
                    mapReturn.put('success',true);
                }
            }  
            
        }catch(Exception ex){
            
            r.Respuesta = STATUS_TIEMPO_AGOTADO;
            r.ID_Ticket = '';
            r.codigoOperacion = '01';
            r.glosaOperacion = 'Falla recepcion informacion';
            r.numeroSolicitud = null;
            r.fechaSolicitud = System.now();
            
            System.debug('Excepcion ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber());
            ErrorLog.log(CURRENT_CLASS, ex.getMessage());
            mapReturn.put('success',false);            
        }
         
        mapReturn.put('message',r);
        return mapReturn;
    }
    
    //clase con campos a mostrar para debug [resultado]
    class result {
        
        String Respuesta;
        String ID_Ticket;
        String codigoOperacion;
        String glosaOperacion;
        Integer numeroSolicitud;
        DateTime fechaSolicitud;
        
        result(String Respuesta, String ID_Ticket, String codigoOperacion, String glosaOperacion, Integer numeroSolicitud, DateTime fechaSolicitud) {

            this.Respuesta = Respuesta;
            this.ID_Ticket = ID_Ticket;
            this.codigoOperacion = codigoOperacion;
            this.glosaOperacion = glosaOperacion;
            this.numeroSolicitud = numeroSolicitud;
            this.fechaSolicitud = fechaSolicitud;
        }        
    }
}