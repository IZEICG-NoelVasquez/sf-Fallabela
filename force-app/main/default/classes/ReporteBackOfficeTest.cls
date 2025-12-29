/**
* Nombre: ReporteBackOfficeTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase ReporteBackOffice
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           24/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           22/02/2022      Mauricio Rosales            Historial de cambios, tiempo de resolucion por bandeja
* --------------------------------------------------------------------------
*/
@isTest
public class ReporteBackOfficeTest {

    @testSetup
    static void setupData () {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;

        Id rtCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        Id rtFraudes = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Fraudes').getRecordTypeId();

        List<Case> listCasos = new List<Case>();

        Case caso_1 = new Case();
        caso_1.AccountId = acc.Id;
        caso_1.ID_Solicitud__c = '1521133';
        caso_1.Cupo__c = 100;
        caso_1.RecordTypeId = rtCredito;
        caso_1.Status = 'Cerrado';
        caso_1.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now().addDays(-2).addHours(-2).addMinutes(-15);
        listCasos.add(caso_1);

        Case caso_2 = new Case();
        caso_2.AccountId = acc.Id;
        caso_2.ID_Solicitud__c = '1521144';
        caso_2.Cupo__c = 100;
        caso_2.RecordTypeId = rtCredito;
        caso_2.Status = 'Cerrado';
        caso_2.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now().addDays(-2).addMinutes(-15);
        listCasos.add(caso_2);

        Case caso_3 = new Case();
        caso_3.AccountId = acc.Id;
        caso_3.ID_Solicitud__c = '1521155';
        caso_3.Cupo__c = 100;
        caso_3.RecordTypeId = rtCredito;
        caso_3.Status = 'Cerrado';

        caso_3.Publicidad__c = true;
        caso_3.Fecha_estimada_de_cierre__c = System.now();
        caso_3.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now().addHours(-2).addMinutes(-15);
        listCasos.add(caso_3);

        Case caso_4 = new Case();
        caso_4.AccountId = acc.Id;
        caso_4.ID_Solicitud__c = '1521166';
        caso_4.Cupo__c = 100;
        caso_4.RecordTypeId = rtCredito;
        caso_4.Status = 'Cerrado';

        caso_4.Publicidad__c = true;
        caso_4.Fecha_estimada_de_cierre__c = System.now();
        caso_4.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now();
        listCasos.add(caso_4);

        ///
        Case caso_5 = new Case();
        caso_5.AccountId = acc.Id;
        caso_5.ID_Solicitud__c = '1521151';
        caso_5.Cupo__c = 100;
        caso_5.RecordTypeId = rtFraudes;
        caso_5.Status = 'Cerrado';
        caso_5.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now();
        listCasos.add(caso_5);

        Case caso_6 = new Case();
        caso_6.AccountId = acc.Id;
        caso_6.ID_Solicitud__c = '1521152';
        caso_6.Cupo__c = 100;
        caso_6.RecordTypeId = rtFraudes;
        caso_6.Status = 'Cerrado';
        caso_6.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now();
        listCasos.add(caso_6);

        Case caso_7 = new Case();
        caso_7.AccountId = acc.Id;
        caso_7.ID_Solicitud__c = '1521153';
        caso_7.Cupo__c = 100;
        caso_7.RecordTypeId = rtFraudes;
        caso_7.Status = 'Cerrado';
        caso_7.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now();
        listCasos.add(caso_7);


        insert listCasos;

        Notas_a_Canales__c notaCanal = new Notas_a_Canales__c();
        notaCanal.Caso__c = caso_1.Id;
        notaCanal.Comentarios__c = 'Nota de Prueba';
        insert notaCanal;

        List<Codigo_de_dudas__c> listCodigoDuda = new List<Codigo_de_dudas__c>();

        Codigo_de_dudas__c codigoDuda_1 = new Codigo_de_dudas__c();
        codigoDuda_1.Caso__c = caso_1.Id;
        codigoDuda_1.Descripci_n__c = '5006';
        listCodigoDuda.add(codigoDuda_1);

        Codigo_de_dudas__c codigoDuda_2 = new Codigo_de_dudas__c();
        codigoDuda_2.Caso__c = caso_2.Id;
        codigoDuda_2.Descripci_n__c = '6009';
        listCodigoDuda.add(codigoDuda_2);

        Codigo_de_dudas__c codigoDuda_3 = new Codigo_de_dudas__c();
        codigoDuda_3.Caso__c = caso_3.Id;
        codigoDuda_3.Descripci_n__c = '6045';
        listCodigoDuda.add(codigoDuda_3);

        Codigo_de_dudas__c codigoDuda_4 = new Codigo_de_dudas__c();
        codigoDuda_4.Caso__c = caso_4.Id;
        codigoDuda_4.Descripci_n__c = '6047';
        listCodigoDuda.add(codigoDuda_4);

        insert listCodigoDuda;

        List<Historial_de_Cambios__c> lstHistorialCambios = new List<Historial_de_Cambios__c>();

        Historial_de_Cambios__c historial_1 = new Historial_de_Cambios__c();
        historial_1.Caso__c = caso_1.Id;
        historial_1.Name = 'Número de Teléfono Móvil';
        historial_1.API_Name__c = ReporteBackOffice.strAPINameTelefonoMovil;
        historial_1.Numero_de_intento__c = 1;
        lstHistorialCambios.add(historial_1);

        Historial_de_Cambios__c historial_2 = new Historial_de_Cambios__c();
        historial_2.Caso__c = caso_1.Id;
        historial_2.Name = 'Cupo';
        historial_2.API_Name__c = ReporteBackOffice.strAPINameCupo;
        historial_2.Numero_de_intento__c = 1;
        lstHistorialCambios.add(historial_2);

        Historial_de_Cambios__c historial_3 = new Historial_de_Cambios__c();
        historial_3.Caso__c = caso_1.Id;
        historial_3.Name = 'Estatus';
        historial_3.API_Name__c = ReporteBackOffice.strAPINameEstatus;
        lstHistorialCambios.add(historial_3);

        insert lstHistorialCambios;
    }

    @isTest static void caso_BackOffice() {

        ///
        Date fechaInicio = System.today().addDays(-3);
        Date fechaFin = System.today().addDays(1);

        Map<String,Object> mapResult;

        Test.startTest();

        mapResult = ReporteBackOffice.getCasosBOCredito(fechaInicio, fechaFin, false, '', 'Riesgos_Originaci_n', 0, true);

        Test.stopTest();

        List<ReporteBackOffice.CasoBackOffice> listCasosReporte = (List<ReporteBackOffice.CasoBackOffice>)mapResult.get('listCasosBackOffice');

        System.assertEquals(7, listCasosReporte.size());
    }
}