@isTest
public class ActualizarRestanteTicketRiesgoCmpTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Case caso = new Case();
        caso.AccountId = acc.Id;
        caso.ID_Solicitud__c = '1521122';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Riesgos/Originación').getRecordTypeId();
        caso.Solicitud_Repetida__c = true;
        caso.Cliente_Repetido__c = true;
        insert caso;
    }    

    @isTest static void caso_Nuevo() {

        String body = generaJson();
        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> resultMap = ActualizarRestanteTicketRiesgoCmpCtrl.recuperarInformacionSolicitud('1521133',true);

        Test.stopTest();

        List<Case> listCase = [SELECT ID_Solicitud__c FROM Case WHERE ID_Solicitud__c = '1521133'];
        System.assertEquals( listCase[0].ID_Solicitud__c, '1521133');
    }

    @isTest static void caso_Reenviado() {

        String body = generaJson();
        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> resultMap = ActualizarRestanteTicketRiesgoCmpCtrl.recuperarInformacionSolicitud('1521122',true);

        Test.stopTest();

        System.assertEquals( resultMap.get('success') , true);
    }

    @isTest static void error() {

        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> resultMap = ActualizarRestanteTicketRiesgoCmpCtrl.recuperarInformacionSolicitud('1521122',true);

        Test.stopTest();

        System.assertEquals( resultMap.get('success') , false);
    }

    @isTest static void errorCatch() {

        MockHttpResponseGeneratorAdmisiones mockAdmisiones = new MockHttpResponseGeneratorAdmisiones();
        mockAdmisiones.setStatusCode(200);
        mockAdmisiones.setBody('');
        Test.setMock(HttpCalloutMock.class, mockAdmisiones);

        Test.startTest();

        Map<String, Object> resultMap = ActualizarRestanteTicketRiesgoCmpCtrl.recuperarInformacionSolicitud('1521122',true);

        Test.stopTest();

        System.assertEquals( resultMap.get('success') , false);
    }

    static String generaJson() {

        String json = '{'+
            '\"cardApplicationId\": 1521122,'+
            '\"rewardsCardNumber\": \"2000100000003597\",'+
            '\"curp\": \"ABCD112233HDFABC00\",'+
            '\"name\": \"NOMBRE\",'+
            '\"surname\": \"ADS\",'+
            '\"secondSurname\": \"XCZ\",'+
            '\"email\": \"l@l.cl\",'+
            '\"cellPhoneNumber\": \"9876543345\",'+
            '\"rfc\": \"BZML920311\",'+
            '\"homoclave\": \"123\",'+
            '\"street\": \"EWQ\",'+
            '\"exteriorNumber\": \"31\",'+
            '\"interiorNumber\": \"321\",'+
            '\"zipCode\": \"86758\",'+
            '\"colony\": \"3 BRAZOS\",'+
            '\"otherColony\": \"3 BRAZOS\",'+
            '\"city\": \"CENTLA\",'+
            '\"ifeAddressEqualsDeclaredAddress\": \"false\",'+
            '\"municipality\": \"CENTLA\",'+
            '\"state\": \"Tabasco\",'+
            '\"creditCard\": \"SI\",'+
            '\"lastFourDigits\": \"7890\",'+
            '\"creditAutomotriz\": \"NO\",'+
            '\"checkBuroAuthorization\": \"SI\",'+
            '\"creditMortgage\": \"SI\",'+
            '\"acceptTerms\": \"SI\",'+
            '\"privacityAdvertisement\": \"SI\",'+
            '\"genre\": \"MALE\",'+
            '\"birthDate\": \"25/11/1984\",'+
            '\"birthFederalEntity\": \"Ciudad de México\",'+
            '\"nationality\": \"Mexicana\",'+
            '\"nationalityCountry\": \"México\",'+
            '\"maritalStatus\": \"Casado Bienes Mancomunados\",'+
            '\"dependents\": \"SI\",'+
            '\"dependentsNumber\": \"1\",'+
            '\"education\": \"Carrera Técnica\",'+
            '\"residenceTime\": 1,'+
            '\"residenceType\": \"Familiares\",'+
            '\"homePhoneNumber\": \"5576017621\",'+
            '\"ppob\": \"NO\",'+
            '\"jobYear\": 2019,'+
            '\"jobMonth\": 1,'+
            '\"contractJobType\": \"Definitiva\",'+
            '\"jobType\": \"Empleado\",'+
            '\"monthlyIncome\": \"600000.0\",'+
            '\"previousJobStartDate\": \"\",'+
            '\"previousJobEndDate\": \"\",'+
            '\"previousJobCompanyName\": \"\",'+
            '\"previousJobMonthlyIncome\": \"\",'+
            '\"occupationType\": \"Administrativo\",'+
            '\"companyName\": \"\",'+
            '\"activityType\": \"ALIMENTACIÓN\",'+
            '\"jobPhone\": \"5555555555\",'+
            '\"firstReferenceFullName\": \"juan\",'+
            '\"firstReferencePhoneNumber\": \"5555555555\",'+
            '\"firstReferenceRelationship\": \"Amigos\",'+
            '\"secondReferenceFullName\": \"topo\",'+
            '\"secondReferencePhoneNumber\": \"6666666666\",'+
            '\"secondReferenceRelationship\": \"Amigos\",'+
            '\"companyZipCode\": \"21260\",'+
            '\"companyStreet\": \"23\",'+
            '\"companyInteriorNumber\": null,'+
            '\"companyExteriorNumber\": \"23\",'+
            '\"companyColony\": \"1 DE DICIEMBRE\",'+
            '\"companyState\": \"Baja California\",'+
            '\"companyMunicipality\": \"MEXICALI\",'+
            '\"fiel\": null,'+
            '\"originResources\": \"De la actividad del cliente\",'+
            '\"destinationResources\": \"Compras\",'+
            '\"paymentMethod\": \"Efectivo\",'+
            '\"amountDisposal\": \"1,000 - 5,000\",'+
            '\"averageMonthlyProvisionsNumber\": \"1- 5\",'+
            '\"paymentDay\": \"1\",'+
            '\"sendStatusAccount\": \"SI\",'+
            '\"codigoStatusEvaluacion\": \"01\",'+
            '\"reasonRejected\": null,'+
            '\"reasonPending\": null,'+
            '\"productCode\": \"9001\",'+
            '\"quota\": \"1000\",'+
            '\"canalOrigen\": \"WEB_PORTAL\",'+
            '\"currentChannel\": \"PRESENCIAL\",'+
            '\"codigoOperacion\": \"11\",'+
            '\"descCodigoOperacion\": \"Consulta Exitosa\",'+
            '\"callId\": \"1\",'+
            '\"result\": \"OK\",'+
            '\"queueType\": \"1\",'+
            '\"status\": \"Approved\",'+
            '\"blackLigthValidation\": \"NO\",'+
            '\"ineResult\": \"NO\",'+
            '\"pictureCaptured\": \"NO\",'+
            '\"productName\": \"Tarjeta Falabella MasterCard\",'+
            '\"modifiedDate\": \"2019-12-06T14:34:40.025\",'+
            '\"jobExtension\": \"5555555555\",'+
            '\"sucursal\": \"Santo Domingo\",'+
            '\"webAgent\": \"FalAdminDL\",'+
            '\"promotorId\": null,'+
            '\"referredId\": null,'+
            '\"noteCanal\": \"Test\",'+
            '\"codesDoubt\": ['+
            '  {'+
            '    \"code\": \"1000\",'+
            '    \"description\": \"Aprobada\"'+
            '  },'+
            '  {'+
            '    \"code\": \"1000.0\",'+
            '    \"description\": \"Cupo Recomendado\"'+
            '  },'+
            '  {'+
            '    \"code\": \"6051\",'+
            '    \"description\": \"???\"'+
            '  },'+
            '  {'+
            '    \"code\": \"5006\",'+
            '    \"description\": \"Test 5006\"'+
            '  }'+
            ']'+
            '}';

        return json;
    }
}