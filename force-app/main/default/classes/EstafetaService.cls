/**
* Nombre: EstafetaService
* Autor: Mauricio Rosales
* Descripcion: Clase de Servicio para el consumo Web Service Estafeta
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           10/01/2023      Mauricio Rosales            Creación
* 2.0           08/03/2023      Mauricio Rosales            Metodo para obtner el Historial de una Lista de Guias del Web Service Estafeta
* --------------------------------------------------------------------------
*/
public class EstafetaService {

    /**
    * Se crean los Headers del Request para el Oauth de Estafeta
    * @return Regresa un mapa con los Headers
    **/
    @TestVisible
    private static Map<String,String> headersToken() {

        Map<String,String> mapHeaders = new Map<String,String>{ConstantsEstafetaService.HTTP_CONTENT_TYPE => ConstantsEstafetaService.HTTP_APP_URLENCODED};

        return mapHeaders;
    }

    /**
    * Se crea el Body del Request para el Oauth de Estafeta
    * @return Regresa una variable String con el Body
    *
    * @param clientId: Credenciales para la autenticacion del Web Service
    * @param clientSecret: Credenciales para la autenticacion del Web Service
    **/
    @TestVisible
    private static String bodyToken(String clientId, String clientSecret) {

        String body = ConstantsEstafetaService.HTTP_GRANT_TYPE + '=' + ConstantsEstafetaService.HTTP_CLIENT_CREDENTIALS +
                    '&' + ConstantsEstafetaService.HTTP_SCOPE + '=' + ConstantsEstafetaService.HTTP_EXECUTE +
                    '&' + ConstantsEstafetaService.HTTP_CLIENT_ID + '=' + clientId +
                    '&' + ConstantsEstafetaService.HTTP_CLIENT_SECRET + '=' + clientSecret;

        return body;
    }

    /**
    * Se crean los Headers del Request para el Web Service CustShipmentTracking de Estafeta
    * @return Regresa un mapa con los Headers
    *
    * @param clientId: Credenciales para la autenticacion del Web Service
    * @param accessToken: Token generado en el Oauth de Estafeta
    **/
    @TestVisible
    private static Map<String,String> headersCustShipmentTracking(String clientId, String accessToken) {

        Map<String,String> mapHeaders = new Map<String,String>{ConstantsEstafetaService.HTTP_ACCEPT => ConstantsEstafetaService.HTTP_APP_JSON,
                                                                ConstantsEstafetaService.HTTP_CONTENT_TYPE => ConstantsEstafetaService.HTTP_APP_JSON,
                                                                ConstantsEstafetaService.HTTP_APIKEY => clientId,
                                                                ConstantsEstafetaService.HTTP_AUTHORIZATION => ConstantsEstafetaService.HTTP_BEARER + ' ' + accessToken};

        return mapHeaders;
    }

    /**
    * Se crea el Body del Request para el Web Service CustShipmentTracking de Estafeta
    * @return Regresa una variable String con el Body
    *
    * @param suscriberId: Credenciales para la autenticacion del Web Service
    * @param login: Credenciales para la autenticacion del Web Service
    * @param password: Credenciales para la autenticacion del Web Service
    * @param lstWayBills: Lista de Numeros de Guias de Estafeta
    **/
    @TestVisible
    private static String bodyCustShipmentTrackingList(String suscriberId, String login, String password, List<String> lstWayBills) {

        String body = '{"suscriberId":"' + suscriberId + '","login":"' + login + '","password":"' + password + '","searchType":{"type":"' + ConstantsEstafetaService.ESTAFETA_SEARCHTYPE + 
                        '","waybillList":{"waybillType":"' + ConstantsEstafetaService.ESTAFETA_WAYBILLTYPE + '","waybills":{"string":[';

        for(Integer i = 0; i < lstWayBills.size(); i ++ ) {

            body += (i > 0  ? ',' : '')  +  '"' + lstWayBills[i] + '"';
        }
                        
        body +=         ']}}},"searchConfiguration":{"filterType":' + 
                        '{"filterInformation":false,"filterType":"' + ConstantsEstafetaService.ESTAFETA_FILTERTYPE + '"},"historyConfiguration":{"historyType":"' + ConstantsEstafetaService.ESTAFETA_HISTORYTYPE + 
                        '","includeHistory":true},"includeCustomerInfo":true,"includeDimensions":true,"includeInternationalData":true,"includeMultipleServiceData":true,' + 
                        '"includeReturnDocumentData":true,"includeSignature":true,"includeWaybillReplaceData":true}}';

        return body;
    }


    /**
    * Llamado al Web Service Oauth de Estafeta
    * @return Regresa un mapa con una variable de exito y el Body del Response
    **/
    public static Map<String,Object> oauthToken() {

        Map<String, Object> mapResult;

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking');

        HttpRequest request = client.makeRequest(ConstantsEstafetaService.ESTAFETA_ENDPOINT_TOKEN, ConstantsEstafetaService.HTTP_METHOD_POST, headersToken(), bodyToken(client.microservicio.Client_ID__c, client.microservicio.Client_Secret__c));

        mapResult = client.callWebService(request);

        return mapResult;
    }

    /**
    * Llamado al Web Service CustShipmentTracking de Estafeta
    * @return Regresa un mapa con una variable de exito y el Body del Response
    *
    * @param accessToken: Token generado en el Oauth de Estafeta
    * @param wayBill: Numero de Guia de Estafeta
    **/
    public static Map<String,Object> custShipmentTracking(String accessToken, String wayBill) {

        Map<String, Object> mapResult;        

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking'); 

        HttpRequest request = client.makeRequest(ConstantsEstafetaService.ESTAFETA_ENDPOINT_CUSTSHIPMENTTRACKING, ConstantsEstafetaService.HTTP_METHOD_POST, headersCustShipmentTracking(client.microservicio.Client_ID__c, accessToken), 
                                            bodyCustShipmentTrackingList(client.microservicio.Section__c, client.microservicio.Provision_Key__c, client.microservicio.Authenticated_UserID__c, new List<String>{wayBill}));

        mapResult = client.callWebService(request);

        /*
        /// Responde para Pruebas
        Map<String, Object> mapResult = new Map<String, Object>();
        mapResult.put('success', true);
        mapResult.put('responseBody', '{\"ExecuteQueryResponse\":{\"ExecuteQueryResult\":{\"errorCodeDescriptionSPA\":\"\",\"errorCode\":\"0\",\"errorCodeDescriptionENG\":\"\",\"trackingData\":{\"TrackingData\":{\"deliveryData\":{\"destinationAcronym\":\"MTY\",\"zipCode\":\"64350\",\"deliveryDateTime\":\"2/6/2023 11:43:00 AM\",\"receiverName\":\"SOE: SENORA PEREZ\",\"destinationName\":\"Monterrey\"},\"multipleServiceData\":{\"nil\":true},\"additionalInformation\":\"\",\"internationalData\":{\"nil\":true},\"signature\":\"DwAAAFJvdXRlU3lzdGVtQ29yZdwANwDCAAAAAgAAAA8AKwAPACwAAgAAABAAKwAQACwAAgAAABEAKwARACwAAgAAABIAKwASACwAAgAAABMAKwATACwAAgAAABQAKwAUACwAAgAAABUAKwAVACwAAgAAABYAKwAWACwAAgAAABcAKwAXACwAAgAAABgAKwAYACwAAgAAABkAKwAZACwAAgAAABoAKwAaACwAAgAAABsAKwAbACwAAgAAABwAKwAcACwAAgAAAB0AKwAdACwAAgAAAB4AKwAeACwAAgAAAB8AKwAfACwAAgAAACAAKwAgACwAAgAAACEAKwAhACwAAgAAACIAKwAiACwAAgAAACMAKwAjACwAAgAAACQAKwAkACwAAgAAACUAKwAlACwAAgAAACYAKwAmACwAAgAAACcAKwAnACwAAgAAACgAKwAoACwAAgAAACkAKwApACwAAgAAACoAKwAqACwAAgAAACsAKwArACwAAgAAACwAKwAsACwAAgAAAC0AKwAtACwAAgAAAC4AKwAuACwAAgAAAC8AKwAvACwAAgAAADAAKwAwACwAAgAAADEAKwAxACwAAgAAADIAKwAyACwAAgAAADMAKwAzACwAAgAAADQAKwA0ACwAAgAAADUAKwA1ACwAAgAAADYAKwA2ACwAAgAAADcAKwA3ACwAAgAAADgAKwA4ACwAAgAAADkAKwA5ACwAAgAAADoAKwA6ACwAAgAAADsAKwA7ACwAAgAAADwAKwA8ACwAAgAAAD0AKwA9ACwAAgAAAD4AKwA+ACwAAgAAAD8AKwA/ACwAAgAAAEAAKwBAACwAAgAAAEEAKwBBACwAAgAAAEIAKwBCACwAAgAAAEMAKwBDACwAAgAAAEQAKwBEACwAAgAAAEUAKwBFACwAAgAAAEYAKwBGACwAAgAAAEcAKwBHACwAAgAAAEgAKwBIACwAAgAAAEkAKwBJACwAAgAAAEoAKwBKACwAAgAAAEsAKwBLACwAAgAAAEwAKwBMACwAAgAAAE0AKwBNACwAAgAAAE4AKwBOACwAAgAAAE8AKwBPACwAAgAAAFAAKwBQACwAAgAAAFEAKwBRACwAAgAAAFIAKwBSACwAAgAAAFMAKwBTACwAAgAAAFQAKwBUACwAAgAAAFUAKwBVACwAAgAAAFYAKwBWACwAAgAAAFcAKwBXACwAAgAAAFgAKwBYACwAAgAAAFkAKwBZACwAAgAAAFoAKwBaACwAAgAAAFsAKwBbACwAAgAAAFwAKwBcACwAAgAAAF0AKwBdACwAAgAAAF4AKwBeACwAAgAAAF8AKwBfACwAAgAAAGAAKwBgACwAAgAAAGEAKwBhACwAAgAAAGIAKwBiACwAAgAAAGMAKwBjACwAAgAAAGQAKwBkACwAAgAAAGUAKwBlACwAAgAAAGYAKwBmACwAAgAAAGcAKwBnACwAAgAAAGgAKwBoACwAAgAAAGkAKwBpACwAAgAAAGoAKwBqACwAAgAAAGsAKwBrACwAAgAAAGwAKwBsACwAAgAAAG0AKwBtACwAAgAAAG4AKwBuACwAAgAAAG8AKwBvACwAAgAAAHAAGQBwABsAAgAAAHAAKwBwACwAAgAAAHEAGABxABsAAgAAAHEAKwBxACwAAgAAAHIAGAByABsAAgAAAHIAKwByACwAAgAAAHMAGQBzABkAAgAAAHMAKwBzACwAAgAAAHQAKwB0ACwAAgAAAHUAKwB1ACwAAgAAAHYAKwB2ACwAAgAAAHcAKwB3ACwAAgAAAHgAKwB4ACwAAgAAAHkAKwB5ACwAAgAAAHoAKwB6ACwAAgAAAHsAKwB7ACwAAgAAAHwAKwB8ACwAAgAAAH0AKwB9ACwAAgAAAH4AKwB+ACwAAgAAAH8AKwB/ACwAAgAAAIAAKwCAACwAAgAAAIEAKwCBACwAAgAAAIIAKwCCACwAAgAAAIMAKwCDACwAAgAAAIQAKwCEACwAAgAAAIUAKwCFACwAAgAAAIYAKwCGACwAAgAAAIcAKwCHACwAAgAAAIgAKwCIACwAAgAAAIkAKwCJACwAAgAAAIoAKwCKACwAAgAAAIsAKwCLACwAAgAAAIwAKwCMACwAAgAAAI0AKwCNACwAAgAAAI4AKwCOACwAAgAAAI8AKwCPACwAAgAAAJAAKwCQACwAAgAAAJEAKwCRACwAAgAAAJIAKwCSACwAAgAAAJMAKwCTACwAAgAAAJQAKwCUACwAAgAAAJUAKwCVACwAAgAAAJYAKwCWACwAAgAAAJcAKwCXACwAAgAAAJgAKwCYACwAAgAAAJkAKwCZACwAAgAAAJoAKwCaACwAAgAAAJsAKwCbACwAAgAAAJwAKwCcACwAAgAAAJ0AKwCdACwAAgAAAJ4AKwCeACwAAgAAAJ8AKwCfACwAAgAAAKAAKwCgACwAAgAAAKEAKwChACwAAgAAAKIAKwCiACwAAgAAAKMAKwCjACwAAgAAAKQAKwCkACwAAgAAAKUAKwClACwAAgAAAKYAKwCmACwAAgAAAKcAKwCnACwAAgAAAKgAKwCoACwAAgAAAKkAKwCpACwAAgAAAKoAKwCqACwAAgAAAKsAKwCrACwAAgAAAKwAKwCsACwAAgAAAK0AKwCtACwAAgAAAK4AKwCuACwAAgAAAK8AKwCvACwAAgAAALAAKwCwACwAAgAAALEAKwCxACwAAgAAALIAKwCyACwAAgAAALMAKwCzACwAAgAAALQAKwC0ACwAAgAAALUAKwC1ACwAAgAAALYAKwC2ACwAAgAAALcAKwC3ACwAAgAAALgAKwC4ACwAAgAAALkAKwC5ACwAAgAAALoAKwC6ACwAAgAAALsAKwC7ACwAAgAAALwAKwC8ACwAAgAAAL0AKwC9ACwAAgAAAL4AKwC+ACwAAgAAAL8AKwC/ACwAAgAAAMAAKwDAACwAAgAAAMEAKwDBACwAAgAAAMIAKwDCACwAAgAAAMMAKwDDACwAAgAAAMQAKwDEACwAAgAAAMUAKwDFACwAAgAAAMYAKwDGACwAAgAAAMcAKwDHACwAAgAAAMgAKwDIACwAAgAAAMkAKwDJACwAAgAAAMoAKwDKACwAAgAAAMsAKwDLACwAAgAAAMwAKwDMACwA\",\"customerInfo\":{\"reference\":\"000002106184\",\"costsCentre\":\"\"},\"shortWaybillId\":\"0150226468\",\"statusSPA\":\"CONFIRMADO\",\"history\":{\"History\":[{\"exceptionCodeDetails\":\"\",\"eventDateTime\":\"2/4/2023 12:25:00 PM\",\"eventId\":\"EOFI\",\"eventPlaceName\":\"Monterrey\",\"eventDescriptionSPA\":\"Envio recibido en oficina   Av. Abraham Lincoln 8000 Local 40,   Barrio Chapultepec Sur,   Monterrey\",\"exceptionCodeDescriptionSPA\":\"\",\"eventDescriptionENG\":\"IN   Av. Abraham Lincoln 8000 Local 40,   Barrio Chapultepec Sur,   Monterrey\",\"eventPlaceAcronym\":\"MTY\",\"exceptionCode\":\"\",\"exceptionCodeDescriptionENG\":\"\"},{\"exceptionCodeDetails\":\"\",\"eventDateTime\":\"2/4/2023 12:58:00 PM\",\"eventId\":\"SOFI\",\"eventPlaceName\":\"Monterrey\",\"eventDescriptionSPA\":\"Recolección en oficina por ruta local\",\"exceptionCodeDescriptionSPA\":\"\",\"eventDescriptionENG\":\"OUT\",\"eventPlaceAcronym\":\"MTY\",\"exceptionCode\":\"\",\"exceptionCodeDescriptionENG\":\"\"},{\"exceptionCodeDetails\":\"\",\"eventDateTime\":\"2/4/2023 1:02:00 PM\",\"eventId\":\"SOFI\",\"eventPlaceName\":\"Monterrey\",\"eventDescriptionSPA\":\"Recolección en oficina por ruta local\",\"exceptionCodeDescriptionSPA\":\"\",\"eventDescriptionENG\":\"OUT\",\"eventPlaceAcronym\":\"MTY\",\"exceptionCode\":\"\",\"exceptionCodeDescriptionENG\":\"\"},{\"exceptionCodeDetails\":\"\",\"eventDateTime\":\"2/4/2023 1:42:00 PM\",\"eventId\":\"SCON\",\"eventPlaceName\":\"Monterrey\",\"eventDescriptionSPA\":\"Llegada a centro de distribución Monterrey\",\"exceptionCodeDescriptionSPA\":\"\",\"eventDescriptionENG\":\"Exit of Container Monterrey\",\"eventPlaceAcronym\":\"MTY\",\"exceptionCode\":\"\",\"exceptionCodeDescriptionENG\":\"\"},{\"exceptionCodeDetails\":\"\",\"eventDateTime\":\"2/6/2023 10:06:00 AM\",\"eventId\":\"ECON\",\"eventPlaceName\":\"Monterrey\",\"eventDescriptionSPA\":\"En proceso para salir a reparto Monterrey\",\"exceptionCodeDescriptionSPA\":\"\",\"eventDescriptionENG\":\"In process to delivery Monterrey\",\"eventPlaceAcronym\":\"MTY\",\"exceptionCode\":\"\",\"exceptionCodeDescriptionENG\":\"\"}]},\"customerNumber\":\"5903380\",\"packageType\":\"Sobre\",\"serviceDescriptionENG\":\"terrestre consumo facturacion mensual\",\"waybill\":\"8055903380611708627819\",\"pickupData\":{\"pickupDateTime\":\"2/4/2023 12:23:00 PM\",\"originAcronym\":\"MTY\",\"originName\":\"Monterrey\"},\"returnDocumentData\":{\"nil\":true},\"statusENG\":\"DELIVERED\",\"serviceDescriptionSPA\":\"terrestre consumo facturacion mensual\",\"serviceId\":\"70\",\"waybillReplaceData\":{\"nil\":true},\"dimensions\":{\"volumetricWeight\":\"0.00000\",\"length\":\"0\",\"width\":\"0\",\"weight\":\"1.0\",\"height\":\"0\"}}}}}}');
        */
        
        return mapResult;
    }


    /**
    * Llamado al Web Service CustShipmentTracking de Estafeta, para una lista de Guias
    * @return Regresa un mapa con una variable de exito y el Body del Response
    *
    * @param accessToken: Token generado en el Oauth de Estafeta
    * @param lstWayBills: Lista de Numeros de Guias de Estafeta
    **/
    public static Map<String,Object> custShipmentTrackingList(String accessToken, List<String> lstWayBills) {

        Map<String, Object> mapResult;        

        ClientRest client = new ClientRest('EstafetaCustShipmentTracking'); 

        HttpRequest request = client.makeRequest(ConstantsEstafetaService.ESTAFETA_ENDPOINT_CUSTSHIPMENTTRACKING, ConstantsEstafetaService.HTTP_METHOD_POST, headersCustShipmentTracking(client.microservicio.Client_ID__c, accessToken), 
                                            bodyCustShipmentTrackingList(client.microservicio.Section__c, client.microservicio.Provision_Key__c, client.microservicio.Authenticated_UserID__c, lstWayBills));

        mapResult = client.callWebService(request);
        
        return mapResult;
    }
}