/**
* Nombre: CaseTriggerHandlerTest
* Autor:
* Descripcion: Test Method de las clases CaseTriggerHandler, CaseTriggerHelper. Y del trigger CaseTrigger
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           22/02/2021      Mauricio Rosales            Nuevos metodos para obtener la cobertura de codigo
* 3.0           15/07/2021      Mauricio Rosales            Validacion al saltar etapas por RecordType
* 4.0           10/09/2021      Mauricio Rosales            Validacion dinamica Motivos de Retencion
* 5.0           23/11/2021      Mauricio Rosales            Validacion historial de casos Emboce Centralizado
* --------------------------------------------------------------------------
*/
@isTest
private class CaseTriggerHandlerTest {  

    @testSetup
    static void setupData () {
        
        TriggerConfig__c tggrConfigSetting = new TriggerConfig__c();
        tggrConfigSetting.Name = 'CaseTrigger';
        tggrConfigSetting.IsEnabled__c = true;        
        insert tggrConfigSetting;

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

        Account newPersonAccount = new Account();
        newPersonAccount.RecordTypeID = recordTypeId;
        newPersonAccount.FirstName = 'Test FName';
        newPersonAccount.LastName = 'Test LName';
        newPersonAccount.PersonMailingStreet = 'test@yahoo.com';
        newPersonAccount.PersonMailingPostalCode = '12345';
        newPersonAccount.PersonMailingCity = 'SFO';
        newPersonAccount.PersonEmail = 'test@yahoo.com';
        newPersonAccount.PersonHomePhone = '1234567';
        newPersonAccount.PersonMobilePhone = '12345678';
        newPersonAccount.CURP__c = 'TEST123TEST123TEST';
        newPersonAccount.Cliente_Soriban__c = true;
        insert newPersonAccount;

        List<Case> listCasos = new List<Case>();

        Case newCase1 = new Case();
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase1.Status = 'Autorización';
        newCase1.ID_Solicitud__c = '11223344';
        newCase1.Evaluar__c = 'Pendiente';
        newCase1.Motivo_de_Pendiente__c = '1.3.- INE Frontal Esta Ilegible';
        listCasos.add(newCase1);

        Case newCase2 = new Case();
        newCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        newCase2.Status = 'Detalle del caso';
        newCase2.AccountId = newPersonAccount.Id;
        newCase2.Categor_a__c = 'Cargo no reconocido';
        newCase2.Tiene_la_tarjeta_en_su_poder__c = 'SI';
        newCase2.Tuvo_contacto_con_el_establecimiento__c = 'SI';
        newCase2.Clasificaci_n_cargo__c = 'NO';
        newCase2.Se_presto_la_tarjeta_a_un_familiar__c = 'NO';
        listCasos.add(newCase2);

        Case newCase3 = new Case();
        newCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        newCase3.Status = 'Detalle del caso';
        newCase3.AccountId = newPersonAccount.Id;
        newCase3.Categor_a__c = 'Cargo no reconocido';
        newCase3.Tiene_la_tarjeta_en_su_poder__c = 'SI';
        newCase3.Tuvo_contacto_con_el_establecimiento__c = 'NO';
        newCase3.Medio_de_entrega_tarjeta__c = 'Domicilio';
        newCase3.La_cuenta_presenta_incidencia__c = 'Sí';
        newCase3.Clasificaci_n_cargo__c = 'NO';
        newCase3.Se_presto_la_tarjeta_a_un_familiar__c = 'NO';
        listCasos.add(newCase3);

        Case newCase4 = new Case();
        newCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        newCase4.Status = 'Informar folio y despedida';
        newCase4.AccountId = newPersonAccount.Id;
        newCase4.Categor_a__c = 'Promociones';
        listCasos.add(newCase4);

        insert listCasos;

        CaseComment comentarioCaso = new CaseComment(); 
        comentarioCaso.ParentId = newCase1.Id;
        comentarioCaso.CommentBody = '1.1.- Solicitud - Esta ilegible';        
        insert comentarioCaso;

        ///
        Task tarea = new Task();
        tarea.TaskSubtype = 'Task';
        tarea.WhatId = newCase1.Id;
        insert tarea;

        Tipo_de_Registro_de_Caso__c tipoRegistro = new Tipo_de_Registro_de_Caso__c();
        tipoRegistro.Name = 'Plan_de_Pagos';
        tipoRegistro.Estados_del_Caso__c = 'Detalle del caso;Informar folio y despedida;Análisis de la Cuenta;Análisis de la aclaración;Cancelado;Cerrado';
        tipoRegistro.Estados_del_caso_Texto__c = 'Detalle del caso;Informar folio y despedida;Análisis de la Cuenta;Análisis de la aclaración;Cancelado;Cerrado';
        insert tipoRegistro;
    }

    @isTest static void moveStatus_1() {

        Id rtRiesgos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        Id rtCargoNoR = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        Id rtPlanPagos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();

        List<Id> listIdRT = new List<Id>();
        listIdRT.add(rtRiesgos);
        listIdRT.add(rtCargoNoR);
        listIdRT.add(rtPlanPagos);

        List<Case> listCasos = [SELECT Status, RecordTypeId, Motivo_de_Pendiente__c, Tiene_la_tarjeta_en_su_poder__c FROM Case WHERE RecordTypeId IN : listIdRT];

        for(Case caso: listCasos) {

            if( caso.RecordTypeId.equals(rtRiesgos) ) {

                caso.Motivo_de_Pendiente__c = '1.0.- Solicitud - No se anexo;1.1.- Solicitud - Esta ilegible;1.2.- Solicitud - Esta incompleta';

            } else if ( caso.RecordTypeId.equals(rtCargoNoR) ) {

                if( caso.Tiene_la_tarjeta_en_su_poder__c == 'NO' ) {

                    caso.Status = 'Dictamen';

                } else if( caso.Tiene_la_tarjeta_en_su_poder__c == 'SI' ) {

                    caso.Status = 'Informar folio y despedida';
                    
                } 

            } else if ( caso.RecordTypeId.equals(rtPlanPagos) ) {

                caso.Status = 'Detalle del caso';

            }
        }

        Test.startTest();

        Database.update(listCasos, false);

        Test.stopTest();
    }

    @isTest static void moveStatus_2() {

        Id rtCargoNoR = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        Id rtRiesgos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        Id rtPlanPagos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();

        List<Id> listIdRT = new List<Id>();
        listIdRT.add(rtCargoNoR);
        listIdRT.add(rtRiesgos);
        listIdRT.add(rtPlanPagos);
        List<Case> listCasosToUpdate = new list<Case>();
        List<Case> listCasos = [SELECT Status, RecordTypeId, Actualizaci_n_Alta_en_SAT__c FROM Case WHERE RecordTypeId IN : listIdRT];

        for(Case caso: listCasos) {

            if ( caso.RecordTypeId.equals(rtCargoNoR) ) {

                caso.Status = 'Bloqueo y reposición';

            } else if ( caso.RecordTypeId.equals(rtRiesgos) ) {

                caso.Actualizaci_n_Alta_en_SAT__c = true;
                caso.Status = 'Cerrado';

            } else if ( caso.RecordTypeId.equals(rtPlanPagos) ) {

                caso.Status = 'Análisis de la aclaración';
            }
            listCasosToUpdate.add(caso);
        }

        Test.startTest();

        Database.update(listCasosToUpdate, false);

        Test.stopTest();
    }

    @isTest static void validateCreatingCasesTest() {

        /// Validacion historial de casos Emboce Centralizado
        List<Account> listAccounts = [SELECT Id FROM Account WHERE CURP__c = 'TEST123TEST123TEST' LIMIT 1];        

        Case caseEmboce = new Case();
        caseEmboce.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        caseEmboce.Categor_a__c = 'Información de Producto';
        caseEmboce.AccountId = listAccounts[0].Id;
        caseEmboce.Tiene_la_tarjeta_en_su_poder__c = 'SI';
        caseEmboce.Tuvo_contacto_con_el_establecimiento__c = 'SI';
        insert caseEmboce;

        List<Case> lstInsertCases = new List<Case>();

        Case newCase1 = new Case();
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        newCase1.Status = 'Detalle de movimientos';
        newCase1.AccountId = listAccounts[0].Id;
        newCase1.Categor_a__c = 'Cargo no reconocido';
        lstInsertCases.add(newCase1);


        Test.startTest();

        /// Validacion historial de casos Emboce Centralizado
        Database.insert(lstInsertCases, false);

        Test.stopTest();
    }
    @isTest
    static void auxTest(){
        caseTriggerHelper.aux();
    }
}