public class FigitalGetScores {

    @AuraEnabled
    public static Map<String,Object> msIncodeStart(String countryCode, String externalId, String recordId) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;
        Boolean recordAlreadyCreated = false;

        System.debug('recordId:  ' + recordId);
        System.debug('externalId:  ' + externalId);

        List<Case> lstCases = [SELECT (SELECT Id FROM Validaciones_Figital__r LIMIT 1) FROM Case WHERE Id =: recordId LIMIT 1];

        if( (lstCases.size() > 0) && (lstCases[0].Validaciones_Figital__r.size() > 0) ) {

            recordAlreadyCreated = true;
            mapResult.put('success', success);
            mapResult.put('recordAlreadyCreated', recordAlreadyCreated);

        } else {

            mapResult = MicroServicioIncodeStart.getInterviewId(countryCode, externalId);
            mapResult.put('recordAlreadyCreated', recordAlreadyCreated);
        }

        return mapResult;
    }
    
    @AuraEnabled
    public static Map<String,Object> msIncodeScore(String interviewId, String recordId, String token) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        Map<String,Object> mapMSIncode = MicroServicioIncodeScore.getScores(interviewId, token);

        if( Boolean.valueOf(mapMSIncode.get('success')) ) {

            IncodeScoreJSON responseIncodeScore = (IncodeScoreJSON)mapMSIncode.get('responseIncodeScore');

            Validacion_Figital__c figital = new Validacion_Figital__c();
            figital.Name = 'Score';
            figital.Caso__c = recordId;
            figital.Id_de_Sesion__c = interviewId;
            figital.URL_dashboard__c = Constants.MS_INCODE_DASHBOARD_URL + interviewId;

            try {

                if( validateObjectNullValue(responseIncodeScore.message.parseResponse) ) {

                    figital.Sub_score_de_Validacion_Id__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.idValidation) && validateObjectNullValue(responseIncodeScore.message.parseResponse.idValidation.overall) && validateObjectNullValue(responseIncodeScore.message.parseResponse.idValidation.overall.value) ? Decimal.valueOf(responseIncodeScore.message.parseResponse.idValidation.overall.value) : null;
                    figital.Sub_score_de_Deteccion_de_vida__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.liveness) && validateObjectNullValue(responseIncodeScore.message.parseResponse.liveness.overall) && validateObjectNullValue(responseIncodeScore.message.parseResponse.liveness.overall.value) ? Decimal.valueOf(responseIncodeScore.message.parseResponse.liveness.overall.value) : null;                    
                    figital.Sub_score_de_Reconocimiento_facial__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.faceRecognition) && validateObjectNullValue(responseIncodeScore.message.parseResponse.faceRecognition.overall) && validateObjectNullValue(responseIncodeScore.message.parseResponse.faceRecognition.overall.value) ? Decimal.valueOf(responseIncodeScore.message.parseResponse.faceRecognition.overall.value) : null;
                    figital.Score_total__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.overall) && validateObjectNullValue(responseIncodeScore.message.parseResponse.overall.value) ? Decimal.valueOf(responseIncodeScore.message.parseResponse.overall.value) : null;
                    figital.Resultado_de_la_lista_nominal__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.ineScrapingValidation) && validateObjectNullValue(responseIncodeScore.message.parseResponse.ineScrapingValidation.result) ? responseIncodeScore.message.parseResponse.ineScrapingValidation.result : null;
                    figital.Sub_socre_de_OCR__c = validateObjectNullValue(responseIncodeScore.message.parseResponse.governmentValidation) && validateObjectNullValue(responseIncodeScore.message.parseResponse.governmentValidation.ocrValidationOverall) && validateObjectNullValue(responseIncodeScore.message.parseResponse.governmentValidation.ocrValidationOverall.value) ? Decimal.valueOf(responseIncodeScore.message.parseResponse.governmentValidation.ocrValidationOverall.value) : null;
                    ///figital.Fecha_del_tramite__c = '';
                    ///figital.Estado_de_la_sesion__c = '';
                }            

                insert figital;
                success = true;

            } catch(Exception ex) { System.debug('ERROR:  ' + ex.getMessage() + '  LINEA  :  ' + ex.getLineNumber() ); }
        }

        mapResult.put('success', success);

        return mapResult;
    }

    public static Boolean validateObjectNullValue(Object field) {

        return field != null ? true : false;
    }
}