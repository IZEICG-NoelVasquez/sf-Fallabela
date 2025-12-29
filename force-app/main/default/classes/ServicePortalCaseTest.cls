@isTest
public class ServicePortalCaseTest {
    
    /**
* setup
*/
    @testSetup
    static void setupData () {
        
        String recordTypeId =  [SELECT Id FROM RecordType where ispersontype=true and sobjectType='account' limit 1].Id;
        Account newPersonAccount = new Account(
            RecordTypeID=recordTypeId ,
            FirstName='Test FName',
            LastName='Test LName',
            PersonMailingStreet='test@yahoo.com',
            PersonMailingPostalCode='12345',
            PersonMailingCity='SFO',
            PersonEmail='test@yahoo.com',
            PersonHomePhone='1234567',
            PersonMobilePhone='12345678',
            CURP__c='TEST123TEST123TEST'
        );
        
        insert newPersonAccount;
        
        Account acc = [SELECT Id, PersonContactId FROM Account where Id =: newPersonAccount.Id];
        
        List<Case> caseLst = new List<Case>();
        
        Case c = new Case();
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cargo no reconocido').getRecordTypeId();
        c.Categor_a__c = 'Cargo no reconocido';
        c.AccountId=newPersonAccount.Id;
        c.Status = 'Detalle de movimientos';
        c.ContactId = acc.PersonContactId;
        caseLst.add(c);
        
        insert caseLst;
        
    }
    
    @isTest static void testShowFolio() {
        Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/portal/case/';
        request.httpMethod = 'GET';
        request.params.put('folio', c.CaseNumber);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.show();
    }
    
    @isTest static void testShowCurp() {
        String fecha_fin = String.valueOf(Date.today().addYears(1));
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/portal/case/';
        request.httpMethod = 'GET';
        request.params.put('curp', 'TEST123TEST123TEST'); 
        request.params.put('fecha_fin', fecha_fin);   
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.show();
    }
    
    @isTest static void testShowSubCategoria() {
        Sub_Categoria__mdt subCategoria = [SELECT Id, Value__c from Sub_Categoria__mdt WHERE Modulo__c=:true LIMIT 1];
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/portal/case/fields/';
        request.httpMethod = 'GET';
        request.params.put('subCategoria', subCategoria.Value__c); 
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.show();
    }
    
    @isTest static void testShowTipoConsultaCliente() {
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/portal/case/categories/';
        request.httpMethod = 'GET';
        request.params.put('tipo_consulta', 'cliente'); 
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.show();
    }
    
    @isTest static void testShowTipoConsultaModulo() {
        
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/portal/case/categories/';
        request.httpMethod = 'GET';
        request.params.put('tipo_consulta', 'modulo'); 
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.show();
    }
    
    @isTest static void testCreate() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');

        String body = '{ \"caso\" : { \"Etapa\" : \"Módulo\", \"SubCategoria\" : \"sub63\", \"origin\" : \"Módulo\", \"Usuario_Reclamos__c\" : \"USUARIO EJECUTIVO 2\", \"Comentarios__c\" : \"Reversa de Comisión (Módulo)\", \"Fecha_de_cago__c\" : \"2019-01-01\", \"Monto_cargo__c\" : 1000, \"Tipo_de_comisi_n__c\": \"Pago tardío\", \"Curp\" : \"TEST123TEST123TEST\", \"Otros__c\": \"Prueba Otros\" } }';
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
    }
    
    @isTest static void testCreateWithArchive() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
                
        String body = '{ \"caso\" : { \"Etapa\" : \"Módulo\", \"SubCategoria\" : \"sub63\", \"origin\" : \"Módulo\", \"Usuario_Reclamos__c\" : \"USUARIO EJECUTIVO 2\", \"Comentarios__c\" : \"Reversa de Comisión (Módulo)\", \"Fecha_de_cago__c\" : \"2019-01-01\", \"Monto_cargo__c\" : 1000, \"Tipo_de_comisi_n__c\": \"Pago tardío\", \"Curp\" : \"TEST123TEST123TEST\", \"Otros__c\": \"Prueba Otros\" }, \"archivos\" : [{ \"Name\" : \"Unit Test Attachment\", \"Body\" : \"VW5pdCBUZXN0IEF0dGFjaG1lbnQgQm9keQ==\", \"ContentType\" : \"text/plain\" }]  }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
    }
    
    @isTest static void testCreateWithCurpError() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        
        String body = '{ \"caso\" : { \"Etapa\" : \"Módulo\", \"SubCategoria\" : \"sub63\", \"origin\" : \"Módulo\", \"Usuario_Reclamos__c\" : \"USUARIO EJECUTIVO 2\", \"Comentarios__c\" : \"Reversa de Comisión (Módulo)\", \"Fecha_de_cago__c\" : \"2019-01-01\", \"Monto_cargo__c\" : 1000, \"Tipo_de_comisi_n__c\": \"Pago tardío\", \"Curp\" : \"TEST123TESEST\", \"Otros__c\": \"Prueba Otros\" } }';
        
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithExceptionError() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"xxxx\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
	@isTest static void testCreateWithStatusCerrado() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub39\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithStatusDocumentacionRequerida() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub42\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithStatusCancelacionDeLaCuenta() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub41\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithStatusAnalisisProsa() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub43\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithStatusInvestigacionDelCaso() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub45\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    @isTest static void testCreateWithStatusDesbloqueDePIN() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub46\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
        @isTest static void testCreateWithStatusAnalisisDeLaAclaracion() {
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        
        request.requestUri ='/services/apexrest/portal/*';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
		        
        String body = '{ \"caso\" : { \"Etapa\": \"Módulo\", \"SubCategoria\" : \"sub67\", \"Curp\": \"TEST123TEST123TEST\" }   }';
        
        request.requestBody = Blob.valueOf(body);
        
        RestContext.request = request;
        RestContext.response = res;
        
        ServicePortalCase.create();
        
    }
    
    
}