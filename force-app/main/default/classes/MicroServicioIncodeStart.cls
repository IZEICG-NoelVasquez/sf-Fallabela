public class MicroServicioIncodeStart {    

    private ClienteMicroServicios client;
    private static final String POST = 'POST';
    private static final String INCODESTART = 'client/incode/start';

    public MicroServicioIncodeStart() {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        client = new ClienteMicroServicios();
        client.setMethod(POST);
        client.setEndpoint(INCODESTART);
        client.setMicroServicio(currentClassName);
        client.generarToken();
    }

    public IncodeStartJSON msIncodeStart(Map<String, String> params) {

        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));

        HttpResponse res;
        HttpRequest req = client.crearRequestFigital(params, null);
        Boolean success = false;
        IncodeStartJSON result;

        try {

            for(Integer i = 0; i < 3; i ++) {

                res = client.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    success = true;
                    break;
                }
            }

            System.debug('res.getBody() ' + res.getBody());
            
            if (success) {

				result = IncodeStartJSON.parse(res.getBody());
				
            } else {

                client.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }

            ///result = IncodeStartJSON.parse('{"code":"ok","message":{"interviewId":"626c16592923960013f26c94","token":"eyJhbGciOiJIUzI1NiJ9.eyJleHRl82cm5hbFVzZXJJZCI6IjYyNzA5ZTM2YWFjZDI2MDAxOWEzZGYwMiIsInJvbGUiOiJBQ0NFU1MiLCJrZXlSZWYiOiI2MWU4NzUzZTdhNDY4ZDAwMTQzMWExNDEiLCJleHAiOjE2NjI2NTMzMDAsImlhdCI6MTY1NDcwNDUwMH0.3_VtlSXnQyazhXfdFw7YcvFRURqH8v-Y5B2VinISUTA29","interviewCode":"WMGIFZ","idCaptureTimeout":25,"selfieCaptureTimeout":25,"idCaptureRetries":3,"selfieCaptureRetries":3,"curpValidationRetries":1,"clientId":"falabella858","env":"demo","existingSession":true}}');

        } catch(Exception ex) {

            System.debug('ERROR: ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
            client.logError(currentClassName, ex.getMessage());
        }

        return result;
    }

    
    public static Map<String,Object> getInterviewId(String countryCode, String externalId) {

        Map<String,Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('countryCode', countryCode);
		params.put('externalId', externalId);

        //
        MicroServicioIncodeStart incodeStart = new MicroServicioIncodeStart();
        IncodeStartJSON responseIncodeStart = incodeStart.msIncodeStart(params);

        if( responseIncodeStart != null && responseIncodeStart.code == 'ok' ) {

            success = true;
        }

        mapResult.put('success', success);
        mapResult.put('responseIncodeStart', responseIncodeStart);
        
        return mapResult;
    }
}