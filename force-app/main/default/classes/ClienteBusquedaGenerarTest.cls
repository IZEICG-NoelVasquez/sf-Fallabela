@isTest
public class ClienteBusquedaGenerarTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.FirstName = 'Cliente';
        acc.LastName = 'Prueba 123';
        acc.Fecha_de_nacimiento1__c = date.newinstance( 1990, 12, 01);
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;
    }

    @isTest 
    static void Busqueda_Exito() {


        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/api/clienteBusquedaGenerar';
        request.httpMethod = 'GET';
        request.params.put('fechaDeNacimiento', '01/12/1990');
        request.params.put('nombreCliente', 'CLIENTE PRUEBA');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ClienteBusquedaGenerar.showAccounts();

        Test.stopTest();

        ClienteBusquedaGenerar.Clientes exitoResponse = (ClienteBusquedaGenerar.Clientes)JSON.deserialize(response.responseBody.toString(), ClienteBusquedaGenerar.Clientes.class);
        System.assertEquals( exitoResponse.clientes[0].curp, 'ABCD112233HDFABC00');
    }

    @isTest 
    static void Busqueda_ErrorFecha() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/api/clienteBusquedaGenerar';
        request.httpMethod = 'GET';
        request.params.put('fechaDeNacimiento', '01/12');
        request.params.put('nombreCliente', 'CLIENTE PRUEBA');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ClienteBusquedaGenerar.showAccounts();

        Test.stopTest();

        List<ClienteBusquedaGenerar.Error> errorResponse = (List<ClienteBusquedaGenerar.Error>)JSON.deserialize(response.responseBody.toString(), List<ClienteBusquedaGenerar.Error>.class);
        System.assertEquals( errorResponse[0].message, 'Revise los parametros de entrada');
    }

    @isTest 
    static void Busqueda_ErrorCliente() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/api/clienteBusquedaGenerar';
        request.httpMethod = 'GET';
        request.params.put('fechaDeNacimiento', '01/01/2000');
        request.params.put('nombreCliente', 'ERROR');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ClienteBusquedaGenerar.showAccounts();

        Test.stopTest();
        
        List<ClienteBusquedaGenerar.Error> errorResponse = (List<ClienteBusquedaGenerar.Error>)JSON.deserialize(response.responseBody.toString(), List<ClienteBusquedaGenerar.Error>.class);
        System.assertEquals( errorResponse[0].message, 'No se encontraron coincidencias');
    }

    @isTest 
    static void Busqueda_ErrorURI() {

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri ='/api/errorTest';
        request.httpMethod = 'GET';
        request.params.put('fechaDeNacimiento', '01/12/1990');
        request.params.put('nombreCliente', 'CLIENTE PRUEBA');
        
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();

        ClienteBusquedaGenerar.showAccounts();

        Test.stopTest();

        System.assertEquals( response.statusCode, 404);
    }
}