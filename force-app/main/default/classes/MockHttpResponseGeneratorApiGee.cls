/**
* Nombre: MockHttpResponseGeneratorApiGee
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para generar el Mock del llamado el MicroServicio ApiGee
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/06/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
global class MockHttpResponseGeneratorApiGee implements HttpCalloutMock {

    private String body = '{"example":"test"}';
    private Integer statusCode = 200;

    public void setBody(String body) {

        this.body = body;
    }

    public void setStatusCode(Integer statusCode) {

        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        if (req.getEndpoint().contains('/oauth/cc/token')) {
           
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('grant_type=client_credentials');

            GetCampainsController.AutenticateSuccessApiGee tokenResponse = new GetCampainsController.AutenticateSuccessApiGee();
            tokenResponse.access_token = 'abc123';
            res.setBody(JSON.serialize(tokenResponse));
            res.setStatusCode(200);
        }else if(req.getEndpoint().contains('/customer-relationship-management/v2/customers/')){
             GetCampainsController.status statusCampain = new GetCampainsController.status();
            statusCampain.statusId = 'OK';
            statusCampain.statusDescription = 'OK';
            GetCampainsController.campaignStatus campaignStatus = new GetCampainsController.campaignStatus();
            campaignStatus.status = statusCampain;

               
            GetCampainsController.campaignBody campaignBody = new GetCampainsController.campaignBody();
            campaignBody.campaignStatus = campaignStatus;
            campaignBody.campaignId = 'prueba campaña';

             GetCampainsController.CampainResponse campainResponse = new GetCampainsController.CampainResponse();
                campainResponse.campaign = campaignBody;

             List<GetCampainsController.CampainResponse> campainResponseList = new List<GetCampainsController.CampainResponse>{campainResponse};
           
            res.setBody(Json.serialize(campainResponseList));
            res.setStatusCode(200);
        } else{
                res.setHeader('Content-Type', 'application/json');

                res.setBody(body);

                res.setStatusCode(statusCode);
        }
       

        return res;
    }
    
}