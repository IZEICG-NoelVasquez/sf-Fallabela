/**
* Nombre: SendEmailTemplateControllerTest
* Autor: ----
* Descripcion: Test Method de la Clase SendEmailTemplateController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ----             ----                       Creación
* 2.0           28/01/2021       Mauricio Rosales           Componente para visualizar el PDF
* 3.0           05/02/2021       Mauricio Rosales           Validacion de al menos un movimiento seleccionado
* --------------------------------------------------------------------------
*/
@isTest
public class SendEmailTemplateControllerTest {
    
    /**
	 * setup
	 */
	@testSetup
    static void setupData () {
        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'CaseTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;
        
        APIKey__c APIKey = new APIKey__c();
        APIKey.Name = 'PDFKey';
        APIKEy.cryptoKey__c = EncodingUtil.base64Encode(Crypto.generateAesKey(256));
        insert APIKey;
        
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
        
        List<Case> caseLst = new List<Case>();
        
        Case caso = new Case();
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        caso.Categor_a__c = 'Cargo no reconocido';
        caso.AccountId=newPersonAccount.Id;
        caso.Status = 'Documentación requerida';
        caseLst.add(caso);
        
        insert caseLst;

        Movimientos__c movimiento = new Movimientos__c();
        movimiento.Caso_Movimiento__c = caso.Id;
        movimiento.Formato_Aclaraciones__c = true;
        movimiento.Fecha_del_movimiento__c = System.today();
        movimiento.Monto__c = 1;
        movimiento.Referencia_Factura__c = '12345678901234567890123';
        movimiento.Establecimiento__c = 'Test';
        movimiento.Creado_en_Autenticador__c = true;

        insert movimiento;
        
    }
    
   	/**
	 * TO DO
	 * sendEmail
	 * This is a mock test
	 */
    @isTest
    public static void sendTest() {
        
        Case c = [SELECT Id, ContactId, Correo_Formato_Aclaraciones_Enviado__c FROM Case LIMIT 1];
        
        Test.startTest();
        Boolean sent = SendEmailTemplateController.send(c.ContactId, c.Id, '1111222233334444');
		Test.stopTest();

		System.assertEquals(true, sent, 'An email should be sent');
    }

    @isTest
    static void getUserInfoTest() {

        Test.startTest();

        Map<String, Object> mapResult = SendEmailTemplateController.getUserInfo();

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest
    static void getMovimientosTest() {

        Case caso = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();

        Map<String, Object> mapResult = SendEmailTemplateController.getMovimientos(caso.Id);

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }
}