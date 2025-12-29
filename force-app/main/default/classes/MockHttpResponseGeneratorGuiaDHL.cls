@isTest
global class MockHttpResponseGeneratorGuiaDHL implements HttpCalloutMock {
    private final String BASE_URL = 'https://cmr-mx-business';
    private final String URI = '.fif.tech/api/business/';
    private String BACKEND = 'backend';
    private String VERSION = 'v1';
    private final String OAUTH = 'oauth2/token';
    private String endpoint = 'products';
    private String method = 'POST';
    private Configuracion_Microservicio__mdt cm;
    private String microServicio = 'default';
    
    public void setEndpoint (String endpoint) { 
        this.endpoint = endpoint;
    }

    public void setMethod (String method) {  
        this.method = method;
    }

    public void setVersion (String version) {
        
        this.VERSION = version;
    }

    public void generarToken () {

        String url = obtenerURLENDPOINT() + '/' + OAUTH;
    }

    public void setMicroServicio (String microServicio) {
        
        this.microServicio = microServicio;
        cm = [SELECT Ambiente__c, Channel__c, Commerce__c, Country__c, Client_ID__c, 
                        Client_Secret__c, Provision_Key__c, Authenticated_UserID__c
                FROM Configuracion_Microservicio__mdt WHERE Label =: microServicio LIMIT 1];
    }

    private String obtenerURLENDPOINT () {

        setMicroServicio(microServicio);
        
        String url = '';
        if (cm.Ambiente__c!=null) {
            url = BASE_URL  + '-' + cm.Ambiente__c + URI + VERSION + '/' + BACKEND + '/' + endpoint;
        } else {
            url = BASE_URL + URI  + VERSION + '/' + BACKEND + '/' + endpoint;
        }

        return url;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        String url = obtenerURLENDPOINT();

        // Optionally, only send a mock response for a specific endpoint
        // and method.
      //  System.assertEquals(url, req.getEndpoint());
       // System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        System.debug('endpoint:  ' + endpoint);
        if( endpoint == 'client/create/otp' ) {
            res.setBody('{"code":"ok","message":{"codigoEstado":"201","glosaEstado":"Operación realizada exitosamente"}}');
        } else if( endpoint == 'client/validate/otp' ) {
            res.setBody('{"code":"ok","message":{"respuesta":{"codigoRespuesta":"201","glosaRespuesta":"Validación del OTP exitosa"}}}');
        } 
        else {
            res.setBody('<?xml version="1.0" encoding="UTF-8"?><req:TrackingResponse xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com TrackingResponse.xsd"><Response><ServiceHeader><MessageTime>2019-10-30T01:14:38.707+01:00</MessageTime><MessageReference>1234567890123456789012345678</MessageReference><SiteID>v62_d4J76B8uJh</SiteID></ServiceHeader></Response><AWBInfo><AWBNumber>5675479924</AWBNumber> <Status><ActionStatus>success</ActionStatus></Status> <ShipmentInfo><OriginServiceArea> <ServiceAreaCode>NLU</ServiceAreaCode><Description>ECATEPEC-MEX</Description></OriginServiceArea><DestinationServiceArea><ServiceAreaCode>OAX</ServiceAreaCode><Description>OAXACA-MEX</Description></DestinationServiceArea><ShipperName>CENTRO DE OPERACIONES MTY</ShipperName><ShipperAccountNumber>980193820</ShipperAccountNumber><ConsigneeName>RAFAEL MORALES MIGUEL</ConsigneeName> <ShipmentDate>2019-09-19T14:20:01</ShipmentDate><Pieces>1</Pieces> <Weight>1.0</Weight><WeightUnit>K</WeightUnit><GlobalProductCode>N</GlobalProductCode><ShipmentDesc>000000530350</ShipmentDesc> <DlvyNotificationFlag>Y</DlvyNotificationFlag>  <Shipper> <City>ESTACION IN HOUSE NLU</City>  <PostalCode>00001</PostalCode><CountryCode>MX</CountryCode> </Shipper>  <Consignee><City>TLACOLULA DE MATAMOR OAXACA OAXACA</City><PostalCode>70400</PostalCode> <CountryCode>MX</CountryCode>  </Consignee>  <ShipperReference><ReferenceID>000000530350</ReferenceID> </ShipperReference><ShipmentEvent>  <Date>2019-09-19</Date>  <Time>14:19:48</Time>  <ServiceEvent> <EventCode>PU</EventCode><Description>Envío retirado/recolectado.</Description>  </ServiceEvent>    <Signatory/>  <ServiceArea><ServiceAreaCode>NLU</ServiceAreaCode> <Description>ECATEPEC-MEX</Description>  </ServiceArea> </ShipmentEvent> <ShipmentEvent> <Date>2019-09-19</Date> <Time>19:07:07</Time><ServiceEvent><EventCode>PL</EventCode> <Description>Procesado en ECATEPEC-MEX</Description>  </ServiceEvent> <Signatory/>  <ServiceArea> <ServiceAreaCode>NLU</ServiceAreaCode>   <Description>ECATEPEC-MEX</Description>   </ServiceArea>   </ShipmentEvent>  <ShipmentEvent><Date>2019-09-19</Date> <Time>19:07:58</Time> <ServiceEvent> <EventCode>DF</EventCode>  <Description>Salida de un centro de tránsito de DHL en ECATEPEC-MEX</Description>    </ServiceEvent> <Signatory/> <ServiceArea> <ServiceAreaCode>NLU</ServiceAreaCode>  <Description>ECATEPEC-MEX</Description></ServiceArea> </ShipmentEvent>  <ShipmentEvent><Date>2019-09-19</Date> <Time>19:09:46</Time>  <ServiceEvent>  <EventCode>AF</EventCode> <Description>Llegada a un centro de tránsito de DHL en HANGARES-MEX</Description> </ServiceEvent> <Signatory/><ServiceArea>  <ServiceAreaCode>HMX</ServiceAreaCode><Description>HANGARES-MEX</Description>  </ServiceArea> </ShipmentEvent> <ShipmentEvent>  <Date>2019-09-19</Date><Time>22:24:29</Time> <ServiceEvent> <EventCode>PL</EventCode> <Description>Procesado en HANGARES-MEX</Description> </ServiceEvent>  <Signatory/>  <ServiceArea> <ServiceAreaCode>HMX</ServiceAreaCode><Description>HANGARES-MEX</Description></ServiceArea></ShipmentEvent><ShipmentEvent><Date>2019-09-20</Date><Time>00:52:58</Time><ServiceEvent><EventCode>DF</EventCode><Description>Salida de un centro de tránsito de DHL en HANGARES-MEX</Description></ServiceEvent><Signatory/><ServiceArea><ServiceAreaCode>HMX</ServiceAreaCode><Description>HANGARES-MEX</Description></ServiceArea></ShipmentEvent><ShipmentEvent><Date>2019-09-20</Date><Time>14:50:58</Time><ServiceEvent><EventCode>OH</EventCode><Description>Envío en espera de mayor información.Por favor contacte a DHL.</Description></ServiceEvent><Signatory/><ServiceArea><ServiceAreaCode>OAX</ServiceAreaCode><Description>OAXACA-MEX</Description></ServiceArea></ShipmentEvent></ShipmentInfo></AWBInfo><LanguageCode>es</LanguageCode></req:TrackingResponse><!-- ServiceInvocationId:20191030011438_97ed_591336fd-f2a5-45ae-95cd-1d8b736df938 -->');
        }
        
        res.setStatusCode(200);
        return res;
    }
}