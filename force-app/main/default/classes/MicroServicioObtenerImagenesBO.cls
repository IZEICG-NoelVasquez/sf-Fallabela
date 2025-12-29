/**
* Nombre: MicroServicioObtenerImagenesBO
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning MicroServicioObtenerImagenesBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           13/11/2020      Mauricio Rosales            Ajustes para consumir los MicroServicios de Falabella. Se elimina codigo para los servicios de Admision
* 3.0           18/01/2021      Mauricio Rosales            Al agregar nuevos archivos en Custom Metadata, los Motivos de Pendiente y Solicitud Repetida se configuran en Metadata
* 4.0           26/02/2021      Mauricio Rosales            Se regresa la lista de Comentario del Caso Activos ligados a los Motivos de Pendiente
* --------------------------------------------------------------------------
*/
public class MicroServicioObtenerImagenesBO {

    /**
    * Regresa un Mapa con una variable booleana de exito, la lista de documentos en base a la informacion del Custom Metadata MS_Imagenes_BlobS_WistonD__mdt
    * Y la informacion del caso de acuerdo al recordId
    *
    * @param recordId: Id del registro de Casos
    **/
    @AuraEnabled
    public static Map<String, Object> obtenerListaImagenesWS (String recordId) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        System.debug('recordId:  ' + recordId);

        ///
        List<Case> listCase = [SELECT ID_Solicitud__c, 
                                    Solicitud_Repetida__c, 
                                    RecordType.DeveloperName, 
                                    (SELECT CommentBody FROM CaseComments WHERE IsPublished = TRUE)
                            FROM Case WHERE Id =: recordId ];

        if( listCase.size() > 0 ) {

            result.put('caso', listCase[0]);
        }

        List<Map<String, Object>> listMapDocumentos = new List<Map<String, Object>>();

        List<MS_Imagenes_BlobS_WistonD__mdt> listDocs = [SELECT MasterLabel, 
                                                                Archivo__c, 
                                                                Micro_Servicio__c, 
                                                                Motivos_de_Pendiente__c, 
                                                                Solicitud_Repetida__c, 
                                                                Mostrar_siempre__c,
                                                                Espacio_al_inicio__c
                                                        FROM MS_Imagenes_BlobS_WistonD__mdt ORDER BY MasterLabel];

        for(MS_Imagenes_BlobS_WistonD__mdt doc: listDocs) {

            if( (listCase[0].RecordType.DeveloperName != 'BackOffice_Figital') || (listCase[0].RecordType.DeveloperName == 'BackOffice_Figital' && doc.Micro_Servicio__c != 'BlobStorage') ) {

                Map<String, Object> mapDocumentos = new Map<String, Object>();

                mapDocumentos.put('nombre', doc.MasterLabel);
                mapDocumentos.put('link', doc.Archivo__c);
                mapDocumentos.put('microServicio', doc.Micro_Servicio__c);
                mapDocumentos.put('motivosDePendiente', doc.Motivos_de_Pendiente__c);
                mapDocumentos.put('solicitudRepetida', doc.Solicitud_Repetida__c);
                mapDocumentos.put('mostrarSiempre', doc.Mostrar_siempre__c);
                mapDocumentos.put('espacioAlInicio', doc.Espacio_al_inicio__c);

                listMapDocumentos.add(mapDocumentos);
                success = true;
            }
        }

        result.put('success', success);
        result.put('listMapDocumentos', listMapDocumentos);
        
        return result;
    }

}