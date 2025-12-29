/**
* Nombre: ExpedientesFalabella
* Autor: Mauricio Rosales
* Descripcion: Clase Controladora Apex del Componente Lightning ExpedientesFalabella
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           14/06/2021      Mauricio Rosales            Creación
* 2.0           13/08/2021      Mauricio Rosales        Validar disponibilidad de reorte de buro de credito
* --------------------------------------------------------------------------
*/
public class ExpedientesFalabella {

    /**
    * Obtiene los documentos e imagenes configurados en el Custom Metadata Expediente_Falabella__mdt, para la consulta del Expediente
    * @return regresa un mapa con una variable booleana de exito y la lista de documentos e imagenes 
    **/
    @AuraEnabled
    public static Map<String,Object> getDocumentsList() {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        List<Expediente_Falabella__mdt> lstExpedientes = [SELECT MasterLabel,
                                                                Micro_Servicio__c, 
                                                                Nombre_del_Documento__c, 
                                                                Parametro_Micro_Servicio__c, 
                                                                WD_Adicionales__c 
                                                        FROM Expediente_Falabella__mdt 
                                                        ORDER BY MasterLabel];

        if( lstExpedientes.size() > 0 ) {

            success = true;
        }

        mapResult.put('success', success);
        mapResult.put('lstExpedientes', lstExpedientes);

        return mapResult;
    }


    /**
    * Llamado al MicroServicio ApiGee para obtener el documento en Base64
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param documentSubTypeId: nombre del archivo con el que se identifica el documento en el MicroServicio
    * @param idRequest: id Solicitud para la consulta del Expediente
    **/
    @AuraEnabled
    public static Map<String, Object> getDocumentApiGee(String documentSubTypeId, String idRequest) {
        
        System.debug('ExpedientesFalabella.cls - getDocumentApiGee: consulta disponibilidad doc ' + idRequest);
        
        Boolean msv2 = false;

        try {
            Case sucuCase = [SELECT Sucursal__c FROM Case WHERE ID_Solicitud__c = :idRequest]; // obtiene el nombre de la sucursal en el caso
        
            if(sucuCase.Sucursal__c != null){
                List<String> splitSucuCase = sucuCase.Sucursal__c.split('- ');
                String sucu = splitSucuCase.size() == 1? splitSucuCase[0] : splitSucuCase[1];
                List<Sucursal_Gestor__mdt> sucuStatus = [SELECT glosa__c, msV2__c FROM Sucursal_Gestor__mdt WHERE glosa__c = :sucu]; // obtiene si la sucursal está activa en el meta para la v2

                if(sucuStatus.size() > 0 && sucuStatus[0].msV2__c){
                    msv2 = true;
                    System.debug('Estatus sucursal: ' + sucuStatus[0].glosa__c + ': ' + sucuStatus[0].msV2__c);
                }  
            }
        } catch (Exception e) {
            msV2 = true;
            System.debug('No se encontró un caso, se consultará la msV2: ' + msv2);
            System.debug('Catch CURP: ' + idRequest + ' Error: ' + e);
        }
        

        return MicroServicioApiGee.getDocumentApiGee(documentSubTypeId, idRequest, msv2);
    }


    /**
    * Llamado al MicroServicio BlobStorage para obtener la imagen en Base64
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param idSolicitud: id Solicitud para la Consulta del Expediente
    * @param link: nombre del archivo con el que se identifica la imagen en el MicroServicio
    * @param microServicio: parametro para indentificar a que servicio se esta llamando (WistonData o BlobStorage)
    **/
    @AuraEnabled
    public static Map<String, Object> getDocumentBlobStorage(String idSolicitud, String link, String microServicio) {

        return MicroServicioModalImagenesBO.descargarImagen(idSolicitud, link, microServicio);
    }


    /**
    * Llamado al MicroServicio GestorIdSolicitud para obtener el Id Solicitud relacionado con el CURP del cliente
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param numeroIdentificacion: curp del cliente
    * @param tipoIdentificacion: parametro para identificar el tipo de documento
    **/
    @AuraEnabled
    public static Map<String, Object> getIdRequest(String numeroIdentificacion, String tipoIdentificacion) {

        return MicroServicioGestorIdSolicitud.getIdRequest(numeroIdentificacion, tipoIdentificacion);
    }


    /**
    * Llamado al MicroServicio Productos para obtener el Numero de Contrato del Cliente
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param curp: curp del cliente
    **/
    @AuraEnabled
    public static Map<String,Object> getContractNumber(String curp) {

        return MicroServicioProductos.obtenerProductosCliente(curp);
    }

    /**
    * Llamado al MicroServicio Buro de Credito para verificar disponibilidad del reporte 
    * @return respuesta del MicroServicio de tipo BuroDeCreditoXMLJSON
    *
    * @param params: parametros para la consulta del reporte de buro
    **/
    @AuraEnabled
    public static BuroDeCreditoXMLJSON getPdfCreditReport(Map<String, String> params) {

        MicroServicioBuroCreditoBO msXMLBuro = new MicroServicioBuroCreditoBO();

        return msXMLBuro.xmlBuroCredito(params);
    }
}