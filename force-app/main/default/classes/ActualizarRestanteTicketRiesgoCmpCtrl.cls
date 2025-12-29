public class ActualizarRestanteTicketRiesgoCmpCtrl {
    private ClienteAdmisiones cliente;

    public ActualizarRestanteTicketRiesgoCmpCtrl() {

        cliente = new ClienteAdmisiones();
        cliente.setMethod('GET');
    }

    public RecuperarInfoSolicitudJSON recuperarInfoSolicitudMicroS(String idSolicutud) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse response;
        Boolean isSuccess = false;
        RecuperarInfoSolicitudJSON result;

        cliente.setEndpoint('getInfoCardPreEvaluation?cardApplicationId='+idSolicutud);
		
        try {   
			
            for (Integer i = 0; i < 3; i++) {

                response = cliente.doRequest_v1(null);

                if (response.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('response ' + response.getBody());
            
            if (isSuccess) {

                result = RecuperarInfoSolicitudJSON.parse(response.getBody());                
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
    public static Map<String, Object> recuperarInformacionSolicitud(String idSolicutud, Boolean blnComponente) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        Map<String,Object> resultRestantes;

        ActualizarRestanteTicketRiesgoCmpCtrl msRecuperarInfo = new ActualizarRestanteTicketRiesgoCmpCtrl();
        RecuperarInfoSolicitudJSON recuperarInfo = msRecuperarInfo.recuperarInfoSolicitudMicroS(idSolicutud);
        
        if (recuperarInfo != null) {

            List<Case> casoReenviado = [SELECT Solicitud_Repetida__c, Cliente_Repetido__c FROM Case WHERE ID_Solicitud__c =: idSolicutud LIMIT 1];
            
            if( casoReenviado.size() > 0 && (casoReenviado[0].Solicitud_Repetida__c || casoReenviado[0].Cliente_Repetido__c) ) {
                resultRestantes = CrearCasosBackOffice.casoUpsertRestantes( recuperarInfo, idSolicutud, true);
            } else {
                resultRestantes = CrearCasosBackOffice.casoUpsertRestantes( recuperarInfo, idSolicutud, false);
            }
            
            if( Boolean.valueOf( resultRestantes.get('success') ) ) {
                success = true;
            }
        }

        System.debug('Recuperar Informacion Solicitud Success: ' + success);
        result.put('success', success);
        result.put('recuperarInfo', recuperarInfo);
        
        return result;
    }
}