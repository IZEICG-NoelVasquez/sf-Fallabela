/**
* Class used to interact with twilio's authy api
*/
public class TwilioVerifyClient {
	
    private static final Integer MX_CODE = 52;
    private static final Integer CODE_LENGTH = 6;
    private static final String VIA = 'sms';
    private static final String FORMAT = 'json';
    private static final String LOCALE = 'es';
    private static final String ENDPOINT = 'https://api.authy.com/protected/';
    
    //	POST https://api.authy.com/protected/{FORMAT}/phones/verification/start
	//	API KEY n8OEDYzWBPKfMiNJFLc3DRxuZ7zi5Kiq

	/*	
		curl -XPOST 'https://api.authy.com/protected/json/phones/verification/start' \
        -H "X-Authy-API-Key: n8OEDYzWBPKfMiNJFLc3DRxuZ7zi5Kiq" \
        -d via='sms' \
        -d phone_number='442-400-0109' \
        -d country_code=521 \
        -d code_length=6 \
        -d locale='es'
	*/
    
    public HttpResponse sendCode (String phoneNumber) {
                
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT + FORMAT + '/phones/verification/start?via=sms&phone_number=' + 
                            						EncodingUtil.urlEncode(phoneNumber, 'UTF-8') + '&country_code=' + MX_CODE +
                           						'&locale='+ LOCALE + '&code_length='+ CODE_LENGTH);
        request.setMethod('POST');
        request.setHeader('X-Authy-API-Key', 'n8OEDYzWBPKfMiNJFLc3DRxuZ7zi5Kiq');
        
        Http http = new Http();

        HttpResponse response = http.send(request);
        System.debug(request);
        System.debug(response);
        
        return response;
        
    }

    // GET https://api.authy.com/protected/{FORMAT}/phones/verification/check

    /* curl 'https://api.authy.com/protected/json/phones/verification/check?phone_number=987-654-3210&country_code=1&verification_code=123456' \
		-H "X-Authy-API-Key: d57d919d11e6b221c9bf6f7c882028f9"
	*/
    public HttpResponse validateCode (String phoneNumber, String code) {
                
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT + FORMAT + '/phones/verification/check?phone_number=' + 
                            						EncodingUtil.urlEncode(phoneNumber, 'UTF-8') + '&country_code=' + MX_CODE +
                           						'&verification_code='+ code);
        request.setMethod('GET');
        request.setHeader('X-Authy-API-Key', 'n8OEDYzWBPKfMiNJFLc3DRxuZ7zi5Kiq');
        
        Http http = new Http();

        HttpResponse response = http.send(request);
        
        return response;
        
    }

}