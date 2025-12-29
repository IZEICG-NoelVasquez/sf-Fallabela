@isTest
global class MockHttpResponseGeneratorAdmisiones implements HttpCalloutMock {
    private String body = '{"example":"test"}';
    private Integer statusCode = 200;

    public void setBody(String body) {
        this.body = body;
    }

    public void setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and meth

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        res.setBody(body);

        res.setStatusCode(statusCode);
        return res;
    }
}