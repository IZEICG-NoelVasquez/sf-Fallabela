/**
* Nombre: PickListCaseOriginControllerTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de las clase PickListCaseOriginController
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           16/04/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
@isTest
public class PickListCaseOriginControllerTest {

    @isTest static void getUserInfoTest() {

        Test.startTest();

        Map<String, Object> mapResult = PickListCaseOriginController.getUserInfo();

        Test.stopTest();

        System.assertEquals( mapResult.get('success'), true);
    }

    @isTest static void getContactMethodTest() {

        Test.startTest();

        Map<String, String> mapResult = PickListCaseOriginController.getContactMethod();

        Test.stopTest();

        System.assertEquals( !mapResult.isEmpty(), true);
    }
}