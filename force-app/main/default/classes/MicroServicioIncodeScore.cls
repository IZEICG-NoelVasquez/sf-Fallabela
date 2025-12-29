public class MicroServicioIncodeScore {
    
    private ClienteMicroServicios client;
    private static final String POST = 'POST';
    private static final String INCODESCORE = 'client/incode/score';

    public MicroServicioIncodeScore() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        client = new ClienteMicroServicios();
        client.setMethod(POST);
        client.setEndpoint(INCODESCORE);
        client.setMicroServicio(currentClassName);
        client.generarToken();
    }

    public IncodeScoreJSON msIncodeScore(Map<String, String> params, String token) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = client.crearRequestFigital(params, token);

        Boolean success = false;
        IncodeScoreJSON result;

        try {

            for(Integer i = 0; i < 3; i ++) {

                res = client.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    success = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());
            
            if (success) {

				result = IncodeScoreJSON.parse(res.getBody());
				
            } else {

                client.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

            ///result = IncodeScoreJSON.parse('{"code":"ok","message":{"idValidation":{"overall":{"value":"100.0","status":"OK"}},"livenesscore":{"value":"99.9","status":"OK"},"faceRecognition":{"overall":{"value":"75.6","status":"OK"}},"ocrValidationOverall":{"value":"92.0","status":"OK"},"ineScrapingValidation":"success","overall":{"value":"91.8","status":"OK"}}}');

        } catch(Exception ex) {

            System.debug('ERROR: ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            client.logError(currentClassName, ex.getMessage());
        }

        return result;
    }

    public static Map<String,Object> getScores(String interviewId, String token) {

        Map<String,Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
		params.put('id', interviewId);

        MicroServicioIncodeScore incodeScore = new MicroServicioIncodeScore();
        IncodeScoreJSON responseIncodeScore = incodeScore.msIncodeScore(params, token);

        if( responseIncodeScore != null && responseIncodeScore.code == 'ok' ) {

            success = true;
        }

        mapResult.put('success', success);
        mapResult.put('responseIncodeScore', responseIncodeScore);
        
        return mapResult;
    }
}