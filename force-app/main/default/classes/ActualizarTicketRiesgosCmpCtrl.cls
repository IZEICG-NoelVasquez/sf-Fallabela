public  class ActualizarTicketRiesgosCmpCtrl {
    private ClienteAdmisiones cliente;

    public ActualizarTicketRiesgosCmpCtrl() {

        cliente = new ClienteAdmisiones();
        cliente.setEndpoint('updateCardPreEvaluation');
        cliente.setMethod('GET');
    }

    public ActualizarSolicitudResponseJSON actualizarTicketAdmisionMicroS(String toUpdate) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse response;
        Boolean isSuccess = false;
        ActualizarSolicitudResponseJSON result;
		
        try {   
			
            for (Integer i = 0; i < 3; i++) {

                response = cliente.doRequest_v1(toUpdate);

                if (response.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('response ' + response.getBody());
            
            if (isSuccess) {

                result = ActualizarSolicitudResponseJSON.parse(response.getBody());                
            } else {

                cliente.logError(currentClassName, String.valueOf(response.getStatusCode()));
            }
            
        } catch (Exception e) {

            cliente.logError(currentClassName, e.getMessage());   
            System.debug('ERROR:  ' + e.getMessage() + '  LINEA:  ' + e.getLineNumber() );
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> actualizarTicketAdminsion(String recordId, String estatus, String evaluar, String motivoDePendiete, String motivoDeRechazo, String idSolicitud, String curp) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        String codStatus = estatus;
        String rejected = '------';
        String pendient = '------';
        
        if(evaluar == 'Aprobar') {    

            codStatus = '00';
        }else if(evaluar == 'Pendiente') {

            codStatus = '02';
            if(motivoDePendiete != null && motivoDePendiete != '') {
                pendient = motivoDePendiete;
            } 
        }else if(evaluar == 'Rechazar') {

            codStatus = '03';
            if(motivoDeRechazo != null && motivoDeRechazo != '') {
                String strMotivoDeRechazoTexto = obtenerMensajeMotivoDeRechazo();
                rejected = motivoDeRechazo + ' ' + strMotivoDeRechazoTexto;
            }
        }

        ActualizarSolicitudJSON toUpdate = new ActualizarSolicitudJSON();
        toUpdate.cardApplicationId = Integer.valueOf(idSolicitud);
        toUpdate.reasonRejected = rejected;
        toUpdate.reasonPending = pendient;
        toUpdate.codigoStatusEvaluacion = codStatus;
        toUpdate.curp = curp;
        toUpdate.callNumber = '3';
        
        ActualizarTicketRiesgosCmpCtrl msActualizarTicket = new ActualizarTicketRiesgosCmpCtrl();
        ActualizarSolicitudResponseJSON actualizarTicket = msActualizarTicket.actualizarTicketAdmisionMicroS(System.JSON.serializePretty(toUpdate));

        if (actualizarTicket != null) {
            //success = true;
            //if( actualizarTicket.descCodigoOperacion == 'Solicitud Actualizada' ) {
            if( actualizarTicket.codigoOperacion == '13' ) {
                List<Case> listCasos = [SELECT Actualizaci_n_Alta_en_SAT__c FROM Case WHERE Id =: recordId];
                if( listCasos.size() > 0 ) {
                    listCasos[0].Actualizaci_n_Alta_en_SAT__c = true;

                    update listCasos;
                }
                success = true;
            }
        }
        System.debug('Actualizar Ticket Admision Success: ' + success);
        result.put('success', success);
        result.put('actualizarTicket', actualizarTicket);
        
        return result;
    }

    public static String obtenerMensajeMotivoDeRechazo() {

        String strResult = '';

        List<Cadena__mdt> listCadena = [SELECT Cadena__c FROM Cadena__mdt WHERE DeveloperName = 'RiesgosMotivoDeRechazoWS' LIMIT 1];
        System.debug('listCadena:  ' + listCadena);
        if( listCadena.size() > 0 ) {

            strResult = listCadena[0].Cadena__c;
        }

        return strResult;
    }

}