/**
* Nombre: CasosControllerExtensionTest
* Autor
* Descripcion: Test Method de la Clase CasosControllerExtension
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           24/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           11/11/2021      Mauricio Rosales            Se agrega campo en la funcion obtenerCasos() y se regresa el nombre del perfil
* 4.0           10/12/2021      Mauricio Rosales            Condicion para excluir casos de la bandeja Credito-Fraudes
* --------------------------------------------------------------------------
*/
@isTest
public class CasosControllerExtensionTest {

    @testSetup
    static void setupData() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Id rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        List<Case> listCasos = new List<Case>();

        Case caso_1 = new Case();
        caso_1.AccountId = acc.Id;
        caso_1.ID_Solicitud__c = '1521133';
        caso_1.RecordTypeId = rtCredito;
        caso_1.Status = 'New';
        caso_1.OwnerId = UserInfo.getUserId();
        listCasos.add(caso_1);

        Case caso_2 = new Case();
        caso_2.AccountId = acc.Id;
        caso_2.ID_Solicitud__c = '1521144';
        caso_2.RecordTypeId = rtCredito;
        caso_2.Status = 'Asignada';
        caso_2.OwnerId = UserInfo.getUserId();
        listCasos.add(caso_2);

        Case caso_3 = new Case();
        caso_3.AccountId = acc.Id;
        caso_3.ID_Solicitud__c = '1521155';
        caso_3.RecordTypeId = rtCredito;
        caso_3.Status = 'Cerrado';
        caso_3.OwnerId = UserInfo.getUserId();
        listCasos.add(caso_3);

        insert listCasos;
    }

    @isTest static void test_method_1() {

        Map<String,Object> mapResult;
        Integer intCasosDeHoy;
        List<Case> listCasosCerrados;

        Test.startTest();

        mapResult = CasosControllerExtension.obtenerCasos();
        intCasosDeHoy = CasosControllerExtension.obtenerCasosToday();
        listCasosCerrados = CasosControllerExtension.obtenerCasosCerrados();

        Test.stopTest();

        List<Profile> lstProfile = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        System.assertEquals( lstProfile[0].Name, String.valueOf(mapResult.get('profileName')));
        System.assertEquals( intCasosDeHoy, 3);
        System.assertEquals( listCasosCerrados.size(), 1);
    }
}