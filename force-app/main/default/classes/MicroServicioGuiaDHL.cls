/**
* Nombre: MicroServicioGuiaDHL
* Autor: ---
* Descripcion: Controlador Apex del Componente Lightning MicroServicioGuiaDHL
* --------------------------------------------------------------------------
* Versión       Fecha             Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ----             ----                    Creación
* 2.0          30/11/2021        Mauricio Rosales        Se agrega metodo para actualizar el estatus del caso
* 3.0          12/01/2023        Mauricio Rosales        Se agrega llamado al WS de Estafeta
* --------------------------------------------------------------------------
*/
public with sharing class MicroServicioGuiaDHL {

    @AuraEnabled
    public static String getGuiaDHL(String accountId) {

        List<Guia_DHL__c> guias = [SELECT Name FROM Guia_DHL__c WHERE Cuenta__c =: accountId AND Activo__c = true];

        String retorno;

        if(guias.size()>0){

            if(guias.size()==1) {

                retorno = guias[0].Name;

            } else {

                Integer contador = 0;

                for(Guia_DHL__c guia : guias) {

                    if(contador == 0){

                        retorno = guia.Name;
                        contador = 1;

                    } else {

                        retorno+=','+guia.Name;
                    }
                }
            }
        }

        return retorno;
    }

    @AuraEnabled
    public static Map<String, Object> getDetailDHL(String guiaDHL, String CURP){
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        datetime ahora = datetime.now();
        String ahoraS = string.valueOfGmt(ahora);
        String MessageTimeS= ahoraS.left(10)+'T'+ahoraS.right(8)+'-05:00';
        System.debug('MessageTimeS2 '+MessageTimeS);
        Configuracion_Microservicio__mdt cm = [SELECT Ambiente__c, Channel__c, Commerce__c, Country__c, Client_ID__c, 
              			Client_Secret__c, Provision_Key__c, Authenticated_UserID__c
              FROM Configuracion_Microservicio__mdt WHERE Label =: 'MicroServicioGuiaDHL' LIMIT 1];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(cm.Client_ID__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        String requestxml = '';
        requestxml+='<?xml version="1.0" encoding="UTF-8"?>';
        requestxml+=' <req:KnownTrackingRequest xmlns:req="http://www.dhl.com"';
        requestxml+=' xmlns:xsi="';
        requestxml+=cm.Provision_Key__c;
        requestxml+='" xsi:schemaLocation="http://www.dhl.com TrackingRequestKnown.xsd">';
        requestxml+=' <Request><ServiceHeader><MessageTime>';
        requestxml+=MessageTimeS;
        requestxml+='</MessageTime><MessageReference>';
        requestxml+=CURP+guiaDHL;
        requestxml+='</MessageReference><SiteID>';
        requestxml+=cm.Authenticated_UserID__c;
        requestxml+='</SiteID><Password>';
        requestxml+=cm.Client_Secret__c;
        requestxml+='</Password></ServiceHeader></Request><LanguageCode>ES</LanguageCode><AWBNumber>';
        requestxml+=guiaDHL;
        requestxml+='</AWBNumber><LevelOfDetails>ALL_CHECK_POINTS</LevelOfDetails><PiecesEnabled>S</PiecesEnabled> </req:KnownTrackingRequest>';
        System.debug('requestxm44 '+requestxml);
        System.debug('guiaDHL '+guiaDHL);

        System.debug('request last 100 '+requestxml.right(100));

        request.setBody(requestxml);
        HttpResponse response = http.send(request);
        System.debug('response '+response);

        // Parse the JSON response
        if (response.getStatusCode() == 200) {
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
            System.debug(response.getBody());
            String jsonContent = XmlParser.xmlToJson(response.getBody());
            System.debug('json1 '+jsonContent);
            jsonContent = jsonContent.replace('"Date":', '"Datex":');
            jsonContent = jsonContent.replace('"Time":', '"Timex":');
            jsonContent = jsonContent.replace('"ShipmentInfo":', '');
            jsonContent = jsonContent.replace('[{"Da', '"ShipmentEvent":[{"Da');
            jsonContent = jsonContent.replace('Shipment picked up', 'Envío retirado/recolectado');
            jsonContent = jsonContent.replace('Processed at', 'Procesado en');
            jsonContent = jsonContent.replace('Departed Facility in', 'Salida de un centro de tránsito de DHL en');
            jsonContent = jsonContent.replace('Arrived at Delivery Facility in', 'Llegado a oficinas de DHL en');
            jsonContent = jsonContent.replace('Forwarded for delivery', 'Entregado a un subcontratista. Detalles de entrega pendientes');
            jsonContent = jsonContent.replace('Delivery attempted; recipient not home', 'Destinatario ausente');
            jsonContent = jsonContent.replace('Shipment on hold', 'Envío en espera en centro de DHL');
            jsonContent = jsonContent.replace('Delivered - Signed for by', 'Envío entregado - Firmado por');
            jsonContent = jsonContent.replace('Arrived at Sort Facility', 'Llegada a un centro de tránsito de DHL en');
            jsonContent = jsonContent.replace('With delivery courier', 'Envío en ruta de entrega');
            jsonContent = jsonContent.replace('Address information needed; contact DHL', 'Dirección de entrega incorrecta. Por favor contacte a DHL');
            jsonContent = jsonContent.replace('Returned to shipper', 'Devuelto al Remitente/Origen');
            jsonContent = jsonContent.replace('No Shipments Found', 'No se encontraron envíos para esta Guía');



            jsonContent= jsonContent.replaceAll('\n','').replaceAll('\r','');

            GuiaDHLJSON gDHL; 
            gDHL = GuiaDHLJSON.parse(jsonContent);
            System.debug('gDHL '+gDHL);
            result.put('success', true);
            result.put('resultGuiaDHL', gDHL);

        } else {
            System.debug(response.getBody());
            String jsonContent = XmlParser.xmlToJson(response.getBody());
               result.put('success', false);
               result.put('resultGuiaDHL', 'error');
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedGuia (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {
        
        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoCurp = new CreateCase();
        result = casoCurp.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
        return result;
    }

    /**
    * Actualiza el Estatus__c del caso
    * @return regresa una variable de exito para la actualiacion del caso
    *
    * @param recordId: Id del registro de Casos
    * @param lastEstatus: Estatus__c para actualizar el caso
    **/
    @AuraEnabled
    public static Boolean updateEstatus(String recordId, String lastEstatus) {
        
        Boolean success = false;

        List<Case> lstCase = [SELECT Estatus__c FROM Case WHERE Id = : recordId LIMIT 1];

        if( lstCase.size() > 0 ) {

            lstCase[0].Estatus__c = lastEstatus;

            update lstCase;

            success = true;
        }

        return success;
    }

    /**
    * Llamado al Oauth y al Web Service CustShipmentTracking de Estafeta
    * @return Regresa un mapa con una variable de exito y el Body del Response
    *
    * @param wayBill: Numero de Guia de Estafeta
    **/
    @AuraEnabled
    public static Map<String, Object> getWayBillEstafeta(String wayBill) {

        Map<String, Object> mapResult = new Map<String, Object>();

        Map<String, Object> mapToken = EstafetaService.oauthToken();

        if( Boolean.valueOf(mapToken.get('success')) ) {

            OauthEstafetaJSON responseOauth = OauthEstafetaJSON.parse( String.valueOf(mapToken.get('responseBody')) );

            Map<String,Object> mapWaybill = EstafetaService.custShipmentTracking(responseOauth.access_token, wayBill);

            mapResult = mapWaybill.clone();

        } else {

            mapResult = mapToken.clone();
        }

        return mapResult;
    }
}