/**
* Nombre: MicroServicioBloqueoDeTarjeta
* Autor: Mauricio Rosales
* Descripcion: Clase Apex del componente MicroServicioBloqueoDeTarjeta
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           01/06/2021      Mauricio Rosales            Creación
* 2.0           08/06/2021      Mauricio Rosales            Validacion de Error devuelto por el MicroServicio
* 3.0           03/08/2021      Mauricio Rosales            Bloqueo de tarjetas desde un registro de Casos
* 4.0           01/07/2022      Mauricio Rosales            Mapa con fechas de vencimiento de las tarjetas relacionadas a la cuenta
* --------------------------------------------------------------------------
*/
public class MicroServicioBloqueoDeTarjeta {

    private ClienteMicroServicios cliente;
    private static String POST = 'POST';
    private static String BLOQUEOTARJETA = 'block/tdc';

    public MicroServicioBloqueoDeTarjeta() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(BLOQUEOTARJETA);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }

    /**
    * Metodo para consumir el Cliente y consumir el MicroServicio
    * Regresa la respuesta del MicroServicio de tipo BloqueoDeTarjetaJSON
    *
    * @param params: mapa con los parametros para el consumo del MicroServicio
    **/
    public String msCardLock(Map<String, Map<String, String> > params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest_v2(params);
        ///
        Map<String, String> mapDateHour = formatDateHour();
        req = cliente.addDateHour(req, mapDateHour.get('strDate'), mapDateHour.get('strHour'));
        Boolean isSuccess = false;
        String result;

        try {   

            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());

            for (String s : res.getBody().split(':')) {

                System.debug('s ' + s);
            }            
            
            if (isSuccess) {

                result = res.getBody();

            } else {

                /// Se envia el error al componente
                result = res.getBody();
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

            //String jsonBloqueoDeTarjeta = '{ \"code\": \"ok\", \"message\": { \"estadoOperacion\": { \"codigoOperacion\": \"00\", \"glosaOperacion\": \"[AZ7] OPERACIÓN REALIZADA CON ÉXITO\" } } }';
            //result = BloqueoDeTarjetaJSON.parse(jsonBloqueoDeTarjeta);

            ///result = '{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"[AZ7] OPERACIÓN REALIZADA CON ÉXITO"}}}';
            ///isSuccess = true;
            ///result = '{ \"code\": \"ok\", \"message\": \"[AZ7][COD:02]ERROR: LA OPERACIÓN NO SE PUDO REALIZAR\" }';

            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
        }

        return result;
    }

    /**
    * Metodo para Setear los parametros y llamar al MicroServicio
    * Regresa un mapa con una variable de exito y la respuesta del MicroServicio
    *
    * @param mapRequestFields: mapa con los parametros para el consumo del MicroServicio
    **/
    @AuraEnabled
    public static Map<String, Object> cardLock(Map<String, String> mapRequestFields) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, Map<String, String> > params = new Map<String, Map<String, String> >();

        params.put('plastico', new Map<String, String>() );        
        params.get('plastico').put('tipoPlastico', mapRequestFields.get('tipoPlastico'));
        params.get('plastico').put('identificador', mapRequestFields.get('identificadorProducto'));

        params.put('cuentaTarjetaCredito', new Map<String, String>() );
        params.get('cuentaTarjetaCredito').put('identificador', mapRequestFields.get('identificador'));

        params.put('informacionContactoRequirente', new Map<String, String>() );        
        params.get('informacionContactoRequirente').put('numeroDocumento', mapRequestFields.get('numeroDocumento'));
        params.get('informacionContactoRequirente').put('tipoDocumento', mapRequestFields.get('tipoDocumento'));

        params.put('motivoRequerimiento', new Map<String, String>() );        
        params.get('motivoRequerimiento').put('descripcion', mapRequestFields.get('descripcionMotivoReq'));
        params.get('motivoRequerimiento').put('codigo', mapRequestFields.get('codigoMotivoReq'));

        params.put('tipoRequerimiento', new Map<String, String>() );        
        params.get('tipoRequerimiento').put('descripcion', mapRequestFields.get('descripcionTipoReq'));
        params.get('tipoRequerimiento').put('codigo', mapRequestFields.get('codigoTipoReq'));

        MicroServicioBloqueoDeTarjeta microServiceCardLock = new MicroServicioBloqueoDeTarjeta();
        String cardLockJSON = microServiceCardLock.msCardLock(params);

        ///
        BloqueoDeTarjetaJSON cardLockJSONSuccess = null;
        MicroServicioJSONError cardLockJSONError = null;

        try {

            cardLockJSONSuccess = BloqueoDeTarjetaJSON.parse(cardLockJSON); 

        } catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );

            try {

                cardLockJSONError = MicroServicioJSONError.parse(cardLockJSON); 

            } catch (Exception ex2) {

                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        if( cardLockJSONSuccess != null ) {

            result.put('success', true);
            result.put('cardLockJSON', cardLockJSONSuccess );

        } else if( cardLockJSONError != null ) {

            result.put('success', false);
            result.put('cardLockJSON', cardLockJSONError );

        } else {

            result.put('success', false);
            result.put('cardLockJSON', cardLockJSON );
        }

        return result;
    }

    /**
    * Metodo para obtener la fecha y la hora actual
    * Regresa un mapa con la fecha y la hora en formato String
    **/
    public static Map<String,String> formatDateHour() {

        Map<String, String> result = new Map<String, String>();

        DateTime dtNow = DateTime.now();

        String strDate = dtNow.format('yyyy-MM-dd');
        String strHour = dtNow.format('HH:mm:ss');

        result.put('strDate', strDate);
        result.put('strHour', strHour);

        return result;
    }

    /**
    * Metodo para obtener los Tipos de Bloqueo y los campos Requeridos
    * Regresa un mapa con la consulta de los Custom Metadata Bloqueo_de_Tarjeta__mdt y Bloqueo_de_Tarjeta_Campos_Requeridos__mdt
    * Y un mapa con las fechas de vencimiento de las tarjetas relacionadas a la cuenta
    *
    * @param accountId Id de la cuenta
    **/
    @AuraEnabled
    public static Map<String, Object> getCardLockValues(String accountId) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        Boolean successCardsInfo = false;

        List<Bloqueo_de_Tarjeta__mdt> lstCMCardLock = [SELECT MasterLabel, 
                                                            Descripcion__c, 
                                                            Etiqueta_en_SF__c, 
                                                            SubCategoria__c, 
                                                            Categoria__c, 
                                                            X_meses_antes_de_vencimiento__c, 
                                                            (SELECT Nombre_de_API__c, Valor_del_Campo__c FROM Bloqueo_de_Tarjeta_Campos_Requeridos__r)
                                                    FROM Bloqueo_de_Tarjeta__mdt 
                                                    WHERE Pantalla_principal__c = true];

        if( lstCMCardLock.size() > 0 ) {

            result.put('lstCMCardLock', lstCMCardLock);

            success = true;
        }

        Map<String,Object> mapCardInfo = getCardInfo(accountId);
        if( Boolean.valueOf(mapCardInfo.get('success')) ) {

            result.put('mapCards', mapCardInfo.get('mapCards'));
            successCardsInfo = true;
        }

        result.put('successCardsInfo', successCardsInfo);
        result.put('success', success);

        return result;
    }

    /**
    * Obtiene las fechas de vencimiento de las tarjetas relacionadas a la Cuenta
    * Regresa un mapa con el identificador de la tarjeta y la fecha de vencimiento
    *
    * @param accountId: Id de la cuenta
    **/
    public static Map<String,Object> getCardInfo(String accountId) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        List<Tarjeta__c> lstCards = [SELECT N_mero_de_tarjeta__c, feccadtar__c FROM Tarjeta__c WHERE Account__c =: accountId];

        if( lstCards.size() > 0 ) {            

            Map<String,String> mapCards = new Map<String,String>();
            for(Tarjeta__c card: lstCards ) {

                mapCards.put( card.N_mero_de_tarjeta__c, card.feccadtar__c);
            }

            mapResult.put('mapCards', mapCards);
            success = true;
        }

        mapResult.put('success', success);

        return mapResult;
    }

    /**
    * Metodo para crear casos abiertos, se llama a la clase helper CreateCase
    * Regresa un mapa con una variable de exito, el Folio del caso y el Id
    *
    * @param recordTypeId: Id del RecordType
    * @param customerId: Id de la Cuenta
    * @param personId: Id del Contacto
    * @param category: Categoria del Caso
    * @param altoRiesgo: variable boleana del Alto Riesgo del Caso
    * @param metodoContactoValue: Metodo de Contacto del Caso
    * @param numeroDeTarjetaValue: Numero de Tarjeta del Caso
    **/
    @AuraEnabled
    public static Map<String, Object> createCaseOpenByRT(String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue ) {

        return CreateCase.createCaseOpenByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue);
    }

    /**
    * Metodo para cerrar casos, se llama a la clase helper CreateCase
    * Regresa un mapa con una variable de exito
    *
    * @param newCaseId: Id del Registro del Caso
    * @param mapRequiredFields: Mapa con los campos Requeridos (Nombre de API, Valor del campo)
    **/
    @AuraEnabled
    public static Map<String, Object> closeCaseByRT(String newCaseId, Map<String, Object> mapRequiredFields) {

        return CreateCase.closeCaseByRT(newCaseId, mapRequiredFields);
    }


    /**
    * Metodo para actualizar el caso
    * Regresa un mapa con una variable de exito
    *
    * @param caseId: Id del Registro del Caso
    * @param mapRequiredFields: Mapa con los campos del Caso (Nombre de API, Valor del campo)
    **/
    @AuraEnabled
    public static Map<String, Object> updateCaseByRT(String caseId, Map<String, Object> mapFields) {

        return CreateCase.updateCaseByRT(caseId, mapFields);
    }
 
}