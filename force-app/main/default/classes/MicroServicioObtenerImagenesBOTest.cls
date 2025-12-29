/**
* Nombre: MicroServicioObtenerImagenesBOTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase MicroServicioObtenerImagenesBO
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           25/11/2020      Mauricio Rosales            Ajustes para consumir los MicroServicios de Falabella.
* 3.0           18/01/2021      Mauricio Rosales            Al agregar nuevos archivos en Custom Metadata, los Motivos de Pendiente y Solicitud Repetida se configuran en Metadata
* --------------------------------------------------------------------------
*/
@isTest
public class MicroServicioObtenerImagenesBOTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Id rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        Case caso_1 = new Case();
        caso_1.AccountId = acc.Id;
        caso_1.ID_Solicitud__c = '1521133';
        caso_1.Cupo__c = 100;
        caso_1.RecordTypeId = rtCredito;
        caso_1.Status = 'Cerrado';
        insert caso_1;
    }

    @isTest static void obtenerListaImgWS() {

        Case caso_1 = [SELECT Id FROM Case WHERE ID_Solicitud__c = '1521133' LIMIT 1];

        Test.startTest();

        Map<String, Object> result = MicroServicioObtenerImagenesBO.obtenerListaImagenesWS(caso_1.Id);

        Test.stopTest();

        List<Map<String, Object>> listResult = (List<Map<String, Object>>)result.get('listMapDocumentos');

        System.assertEquals(result.get('success'), true);
        System.assertEquals(listResult.size() > 0, true);
    }
}