public class MicroServicioAumentoDeLinea {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String CONSULTACUPO = 'client/get/cupo';
    private static final String AUMENTOCUPO = 'producto/update/cupo';
    private static final String STRCONSULTA = 'MicroServicioConsultaDeLinea';
    private static final String STRAUMENTO = 'MicroServicioAumentoDeLinea';

    public void ConsultaDeLinea() {

        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(CONSULTACUPO);
        cliente.setMicroServicio(STRCONSULTA);
        cliente.generarToken(); 
    }

    public void AumentoDeLinea() {
        
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(AUMENTOCUPO);
        cliente.setMicroServicio(STRAUMENTO);
        cliente.generarToken(); 
    }

    public String consultaCupo(Map<String, String> params) {    

        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        String result;

        System.debug('req ' + req);

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

                // Se envia el error al Componente
                result = res.getBody();
                cliente.logError(STRCONSULTA, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(STRCONSULTA, e.getMessage());        
        }
        
        return result;
    }

    
    public String aumentoCupo(Map<String, String> params) {

        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        String result;

        System.debug('req ' + req);

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

                // Se envia el error al Componente
                result = res.getBody();
                cliente.logError(STRAUMENTO, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
            cliente.logError(STRAUMENTO, e.getMessage());
        }
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> consultaLineaDeCredito(String tipoCupo, String identificador, String numeroDocumento) {
        
        Map<String, Object> result = new Map<String, Object>();
        ///Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('tipoCupo', tipoCupo);
        params.put('identificador', identificador);
        params.put('numeroDocumento', numeroDocumento);
        
        System.debug('tipoCupo: ' + tipoCupo);
        System.debug('identificador: ' + identificador);
        System.debug('numeroDocumento: ' + numeroDocumento);
        
        ///MicroServicioAumentoDeLinea msConsultaCupo = new MicroServicioAumentoDeLinea();
        ///msConsultaCupo.ConsultaDeLinea();
        ///String resultConsultaDeCupo = msConsultaCupo.consultaCupo(params);
        String resultConsultaDeCupo = '{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"OK AUMENTO CONSULTADO"},"cupo":{"cupoTotal":22000},"cupoPreAprobado":27000}}';

        System.debug('resultConsultaDeCupo:  ' + resultConsultaDeCupo);
        
        ConsultaCupoJSON consultaJSONExito;
        ConsultaCupoErrorJSON consultaJSONError;

        try {
            // Se valida si se tiene un Aumento Disponible
            consultaJSONExito = ConsultaCupoJSON.parse(resultConsultaDeCupo); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            // Se procesa el error
            try {
                consultaJSONError = ConsultaCupoErrorJSON.parse(resultConsultaDeCupo); 
            } catch (Exception ex2) {
                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        System.debug('consultaJSONExito:  ' + consultaJSONExito);
        System.debug('consultaJSONError:  ' + consultaJSONError);

        if( consultaJSONExito != null ) {
            //  Aumento de Credito Disponible
            result.put('success', true);
            result.put('resultConsultaDeCupo', consultaJSONExito );
        } else if( consultaJSONError != null ) {
            // Aumento de Credito NO Disponible
            result.put('success', false);
            result.put('resultConsultaDeCupo', consultaJSONError );
        } else {
            // Error
            result.put('success', false);
            result.put('resultConsultaDeCupo', consultaJSONError );
        }
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> aumentoLineaDeCredito(String tipoCupo,String identificador, String numeroDocumento, String codigoProducto, String codigoSubProducto, String identificadorProducto, String codigoMoneda, String cupoTotal, String nuevoCupo) {

        Map<String, Object> result = new Map<String, Object>();
        //Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('tipoCupo', tipoCupo);
        params.put('identificador', identificador);
        params.put('numeroDocumento', numeroDocumento);
        params.put('codigoProducto', codigoProducto);
        params.put('codigoSubProducto', codigoSubProducto);
        params.put('identificadorProducto', identificadorProducto);
        params.put('codigoMoneda', codigoMoneda);
        params.put('cupoTotal', cupoTotal);
        params.put('nuevoCupo', nuevoCupo);
        
        System.debug('tipoCupo: ' + tipoCupo);
        System.debug('identificador: ' + identificador);
        System.debug('numeroDocumento: ' + numeroDocumento);
        System.debug('codigoProducto: ' + codigoProducto);
        System.debug('codigoSubProducto: ' + codigoSubProducto);
        System.debug('identificadorProducto: ' + identificadorProducto);
        System.debug('codigoMoneda: ' + codigoMoneda);
        System.debug('cupoTotal: ' + cupoTotal);
        System.debug('nuevoCupo: ' + nuevoCupo);

        ///MicroServicioAumentoDeLinea msAumentoCupo = new MicroServicioAumentoDeLinea();
        ///msAumentoCupo.AumentoDeLinea();
        ///String resultAumentoDeCupo = msAumentoCupo.aumentoCupo(params);
        String resultAumentoDeCupo = '{"code":"ok","message":{"estadoOperacion":{"codigoOperacion":"00","glosaOperacion":"OK"}}}';

        System.debug('resultAumentoDeCupo:  ' + resultAumentoDeCupo);

        AumentoCupoJSON aumentoJSONExito;
        AumentoCupoErrorJSON aumentoJSONError;

        try {
            ///
            aumentoJSONExito = AumentoCupoJSON.parse(resultAumentoDeCupo); 
        } catch(Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            ///
            try {
                aumentoJSONError = AumentoCupoErrorJSON.parse(resultAumentoDeCupo); 
            } catch (Exception ex2) {
                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        System.debug('aumentoJSONExito:  ' + aumentoJSONExito);
        System.debug('aumentoJSONError:  ' + aumentoJSONError);
        
        if( aumentoJSONExito != null ) {
            //  Aumento de Credito Exito
            result.put('success', true);
            result.put('resultAumentoDeCupo', aumentoJSONExito );
        } else if( aumentoJSONError != null ) {
            // Aumento de Credito Mensaje de Error
            result.put('success', false);
            result.put('resultAumentoDeCupo', aumentoJSONError );
        } else {
            // Error
            result.put('success', false);
            result.put('resultAumentoDeCupo', aumentoJSONError );
        }
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedAumentoCupo (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoAumento = new CreateCase();
        result = casoAumento.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }
    
}