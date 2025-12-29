/**
* Nombre: CaseTriggerHandlerMocksTest
* Autor: Mauricio Rosales
* Descripcion: Test Method de la Clase CaseTriggerHelper
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/02/2021      Mauricio Rosales            Creación
* 2.0           25/06/2021      Mauricio Rosales            Asignacion de la Cola de Usuarios Aclaraciones como Propietario
* 3.0           19/07/2021      Mauricio Rosales            Validacion al saltar etapas por RecordType
* 4.0           10/09/2021      Mauricio Rosales            Validacion dinamica Motivos de Retencion
* 5.0           29/12/2021      Mauricio Rosales        Creacion de caso Retencion de titular dependiente de los campos Motivo de cancelación de tarjeta y Motivo de la Retención
* --------------------------------------------------------------------------
*/
@isTest
private class CaseTriggerHandlerMocksTest {

    @testSetup
    static void setupData () {

        Account newPersonAccount = new Account();
        newPersonAccount.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
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
    }

    /**
     * Test Method para la cubrir el Metodo validateRequiredFields
     */
    @isTest static void validateRequiredFieldsTest() {

        Id rtCargoNoReconocido = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();

        List<Account> listAccounts = [SELECT Id FROM Account WHERE CURP__c = 'TEST123TEST123TEST' LIMIT 1];

        Case newCase1 = new Case();
        newCase1.RecordTypeId = rtCargoNoReconocido;
        newCase1.Status = 'Bloqueo y reposición';
        newCase1.AccountId = listAccounts[0].Id;

        Case oldCase1 = new Case();
        oldCase1.RecordTypeId = rtCargoNoReconocido;
        oldCase1.Status = 'Detalle del caso';
        oldCase1.AccountId = listAccounts[0].Id;        

        Id rtBackOfficeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        Case newCase2 = new Case();
        newCase2.RecordTypeId = rtBackOfficeCredito;
        newCase2.Status = 'Autorización';
        newCase2.ID_Solicitud__c = '11223344';

        Case oldCase2 = new Case();
        oldCase2.RecordTypeId = rtBackOfficeCredito;
        oldCase2.Status = 'Asignada';
        oldCase2.ID_Solicitud__c = '11223344';        

        ///
        CaseTriggerHelper.loadMapEtapaCampos();
        CaseTriggerHelper.loadProfilesMap();

        Test.startTest();

        CaseTriggerHelper.validateRequiredFields(newCase1, oldCase1);
        CaseTriggerHelper.validateRequiredFields(newCase2, oldCase2);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo validaEtapaCerrada de Back Office
     */
    @isTest static void validaEtapaCerradaBOTest() {

        Id rtBackOfficeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        /// Validaciones BackOffice
        Case newCase1 = new Case();
        newCase1.RecordTypeId = rtBackOfficeCredito;
        newCase1.Status = 'Cerrado';
        newCase1.ID_Solicitud__c = '11223344';
        newCase1.Actualizaci_n_Alta_en_SAT__c = false;

        Case oldCase1 = new Case();
        oldCase1.RecordTypeId = rtBackOfficeCredito;
        oldCase1.Status = 'Autorización';
        oldCase1.ID_Solicitud__c = '11223344';
        oldCase1.Actualizaci_n_Alta_en_SAT__c = false;        

        Case newCase2 = new Case();
        newCase2.RecordTypeId = rtBackOfficeCredito;
        newCase2.Status = 'Cerrado';
        newCase2.ID_Solicitud__c = '11223344';
        newCase2.Actualizaci_n_Alta_en_SAT__c = true;
        newCase2.Cupo__c = 35000;
        newCase2.Primera_Aprobaci_n__c = false;
        newCase2.Se_bloqueo_la_tarjeta__c = true;

        Case newCase3 = new Case();
        newCase3.RecordTypeId = rtBackOfficeCredito;
        newCase3.Status = 'Cerrado';
        newCase3.ID_Solicitud__c = '11223344';
        newCase3.Actualizaci_n_Alta_en_SAT__c = true;
        newCase3.Cupo__c = 85000;
        newCase3.Primera_Aprobaci_n__c = false;
        newCase3.Segunda_Aprobaci_n__c = false;
        newCase3.Se_bloqueo_la_tarjeta__c = true;

        ///
        Case newCase4 = new Case();
        newCase4.RecordTypeId = rtBackOfficeCredito;
        newCase4.Status = 'Asignada';
        newCase4.ID_Solicitud__c = '11223344';

        Case oldCase4 = new Case();
        oldCase4.RecordTypeId = rtBackOfficeCredito;
        oldCase4.Status = 'New';
        oldCase4.ID_Solicitud__c = '11223344';

        Case newCase5 = new Case();
        newCase5.RecordTypeId = rtBackOfficeCredito;
        newCase5.Status = 'Autorización';
        newCase5.ID_Solicitud__c = '11223344';

        Case oldCase5 = new Case();
        oldCase5.RecordTypeId = rtBackOfficeCredito;
        oldCase5.Status = 'Asignada';
        oldCase5.ID_Solicitud__c = '11223344';

        Test.startTest();

            /// Validaciones BackOffice
            CaseTriggerHelper.validaEtapaCerrada(newCase1, oldCase1);
            CaseTriggerHelper.validaEtapaCerrada(newCase2, oldCase1);            
            CaseTriggerHelper.validaEtapaCerrada(newCase3, oldCase1);

            CaseTriggerHelper.validaEtapaCerrada(newCase4, oldCase4);
            CaseTriggerHelper.validaEtapaCerrada(newCase5, oldCase5);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo validaEtapaCerrada de Call Center
     */
    @isTest static void validaEtapaCerradaTest() {

        Id rtBackOfficeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        /// Modificacion Etapa Cerrada
        Case newCase5 = new Case();
        newCase5.RecordTypeId = rtBackOfficeCredito;
        newCase5.Status = 'Cerrado';
        newCase5.ID_Solicitud__c = '11223355';
        newCase5.Actualizaci_n_Alta_en_SAT__c = true;

        Case oldCase5 = new Case();
        oldCase5.RecordTypeId = rtBackOfficeCredito;
        oldCase5.Status = 'Cerrado';
        oldCase5.ID_Solicitud__c = '11223355';
        oldCase5.Actualizaci_n_Alta_en_SAT__c = false;        
        
        /// Modificacion Etapa Cancelado
        Case newCase6 = new Case();
        newCase6.RecordTypeId = rtBackOfficeCredito;
        newCase6.Status = 'Cancelado';
        newCase6.ID_Solicitud__c = '112233166';
        newCase6.Actualizaci_n_Alta_en_SAT__c = true;

        Case oldCase6 = new Case();
        oldCase6.RecordTypeId = rtBackOfficeCredito;
        oldCase6.Status = 'Cancelado';
        oldCase6.ID_Solicitud__c = '11223366';
        oldCase6.Actualizaci_n_Alta_en_SAT__c = false;

        /// 
        CaseTriggerHelper.loadFieldsMap();
        CaseTriggerHelper.loadMotivosCancelacion();
        CaseTriggerHelper.loadMotivosCerrado();

        Test.startTest();

            /// Modificacion Etapa Cerrada
            CaseTriggerHelper.validaEtapaCerrada(newCase5, oldCase5);

            /// Modificacion Etapa Cancelado
            CaseTriggerHelper.validaEtapaCerrada(newCase6, oldCase6);
        
        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatusRiesgos
     */
    @isTest static void moveStatusRiesgosTest() {

        Case newCase1 = new Case();
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase1.Caso_Actualizado_por_WebService__c = true;
        newCase1.Status = 'Asignada';

        Case oldCase1 = new Case();
        oldCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase1.Caso_Actualizado_por_WebService__c = true;
        oldCase1.Status = 'New';

        Case newCase2 = new Case();
        newCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase2.Actualizaci_n_de_domicilio_en_SAT__c = false;
        newCase2.Status = 'Autorización';

        Case oldCase2 = new Case();
        oldCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase2.Actualizaci_n_de_domicilio_en_SAT__c = false;
        oldCase2.Status = 'Asignada';


        Test.startTest();

        CaseTriggerHelper.moveStatusRiesgos(newCase1, oldCase1);
        CaseTriggerHelper.moveStatusRiesgos(newCase2, oldCase2);

        Test.stopTest();

        System.assertEquals( newCase1.Caso_Actualizado_por_WebService__c, false);
        System.assertEquals( newCase2.Caso_Actualizado_por_WebService__c, false);
    }

    /**
     * Test Method para la cubrir el Metodo approvalProcessesBO
     */
    @isTest static void approvalProcessesBOTest() {

        ///  Approval Processes Back Office
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='Analista Backoffice' LIMIT 1];
        List<UserRole> usrRole = [SELECT DeveloperName FROM UserRole WHERE DeveloperName =: 'Analista_JR_Backoffice' LIMIT 1 ];

        User usr = new User();
        usr.Alias = 'tstabc';
        usr.Email = 'testfalabella@testfalabella.test'; 
        usr.FirstName = 'testfalabella'; 
        usr.LastName = 'testfalabella';
        usr.ProfileId = profile[0].Id; 
        usr.UserRoleId = usrRole[0].Id;        
        usr.UserName = 'testfalabella123123@testfalabella.test'; 
        usr.TimeZoneSidKey = 'America/New_York';
        usr.LocaleSidKey = 'en_US';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        insert usr;

        List<User> lstUsr = [SELECT FirstName, LastName, UserRole.DeveloperName FROM User WHERE UserName = 'testfalabella123123@testfalabella.test' ];

        CaseTriggerHelper.mapUser = new Map<String, User>();
        CaseTriggerHelper.mapUser.put( lstUsr[0].Id, lstUsr[0]);

        List<String> lstNamesQueues = new List<String>{'Riesgos_Coordinadores','Riesgos_Gerentes'};
        List<Group> lstQueues = [SELECT DeveloperName FROM Group WHERE DeveloperName IN : lstNamesQueues ];
        CaseTriggerHelper.mapQueues = new Map<String, Group>();
        for(Group queueUsr: lstQueues) {

            CaseTriggerHelper.mapQueues.put(queueUsr.DeveloperName, queueUsr);
        }

        CaseTriggerHelper.mapCustomNotification = new Map<String, CustomNotificationType>();
        List<CustomNotificationType> lstCustomNotification = [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName =: 'Aprobacion_de_Cupo_Riesgos' LIMIT 1];
        CaseTriggerHelper.mapCustomNotification.put(lstCustomNotification[0].DeveloperName,lstCustomNotification[0]);

        CaseTriggerHelper.lstIdRoleUsersBackOffice = new Set<String>();

        /// Aprobacion 30,000 a 60,000
        Case newCase1 = new Case();
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase1.Evaluar__c = 'Aprobar';
        newCase1.Status = 'Autorización';
        newCase1.Primera_Aprobaci_n__c = false;
        newCase1.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        newCase1.OwnerId = usr.Id;
        newCase1.Cupo__c = 35000;
        newCase1.ID_Solicitud__c = '123123111';
        newCase1.Validar_Movimientos__c = true;

        Case oldCase1 = new Case();
        oldCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase1.Evaluar__c = null;
        oldCase1.Status = 'Autorización';
        oldCase1.Primera_Aprobaci_n__c = false;
        oldCase1.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        oldCase1.OwnerId = usr.Id;
        oldCase1.Cupo__c = 35000;
        oldCase1.ID_Solicitud__c = '123123111';
        oldCase1.Validar_Movimientos__c = true;

        /// Aprobacion 60,000 a 80,000
        Case newCase2 = new Case();
        newCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase2.Evaluar__c = 'Aprobar';
        newCase2.Status = 'Autorización';
        newCase2.Primera_Aprobaci_n__c = false;
        newCase2.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        newCase2.OwnerId = usr.Id;
        newCase2.Cupo__c = 65000;
        newCase2.ID_Solicitud__c = '123123222';
        newCase2.Validar_Movimientos__c = true;

        Case oldCase2 = new Case();
        oldCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase2.Evaluar__c = null;
        oldCase2.Status = 'Autorización';
        oldCase2.Primera_Aprobaci_n__c = false;
        oldCase2.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        oldCase2.OwnerId = usr.Id;
        oldCase2.Cupo__c = 65000;
        oldCase2.ID_Solicitud__c = '123123222';
        oldCase2.Validar_Movimientos__c = true;

        /// Aprobacion 80,000 a 150,000
        Case newCase3 = new Case();
        newCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase3.Evaluar__c = 'Aprobar';
        newCase3.Status = 'Autorización';
        newCase3.Primera_Aprobaci_n__c = false;
        newCase3.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        newCase3.OwnerId = usr.Id;
        newCase3.Cupo__c = 85000;
        newCase3.ID_Solicitud__c = '123123333';
        newCase3.Segunda_Aprobaci_n__c = false;
        newCase3.Validar_Movimientos__c = true;

        Case oldCase3 = new Case();
        oldCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase3.Evaluar__c = null;
        oldCase3.Status = 'Autorización';
        oldCase3.Primera_Aprobaci_n__c = false;
        oldCase3.Coordinadores_y_Gerentes_Ausentes__c = 'No';
        oldCase3.OwnerId = usr.Id;
        oldCase3.Cupo__c = 85000;
        oldCase3.ID_Solicitud__c = '123123333';
        oldCase3.Segunda_Aprobaci_n__c = false;
        oldCase3.Validar_Movimientos__c = true;

        /// Notifica Analista Aprobacion (mayor a 30,000, menor a 80,000)
        Case newCase4 = new Case();
        newCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase4.Actualizaci_n_exitosa__c = 'Sí';
        newCase4.Status = 'Autorización';
        newCase4.Primera_Aprobaci_n__c = true;
        newCase4.OwnerId = usr.Id;
        newCase4.Cupo__c = 35000;
        newCase4.ID_Solicitud__c = '123123444';
        newCase4.Validar_Movimientos__c = true;

        Case oldCase4 = new Case();
        oldCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase4.Actualizaci_n_exitosa__c = null;
        oldCase4.Status = 'Autorización';
        oldCase4.Primera_Aprobaci_n__c = true;
        oldCase4.OwnerId = usr.Id;
        oldCase4.Cupo__c = 35000;
        oldCase4.ID_Solicitud__c = '123123444';
        oldCase4.Validar_Movimientos__c = true;

        /// Notifica Analista Rechazo (mayor a 30,000, menor a 80,000)
        Case newCase5 = new Case();
        newCase5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase5.Actualizaci_n_exitosa__c = 'No';
        newCase5.Status = 'Autorización';
        newCase5.Primera_Aprobaci_n__c = true;
        newCase5.OwnerId = usr.Id;
        newCase5.Cupo__c = 35000;
        newCase5.ID_Solicitud__c = '123123555';
        newCase5.Validar_Movimientos__c = true;

        Case oldCase5 = new Case();
        oldCase5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase5.Actualizaci_n_exitosa__c = null;
        oldCase5.Status = 'Autorización';
        oldCase5.Primera_Aprobaci_n__c = true;
        oldCase5.OwnerId = usr.Id;
        oldCase5.Cupo__c = 35000;
        oldCase5.ID_Solicitud__c = '123123555';
        oldCase5.Validar_Movimientos__c = true;

        /// Notifica Analista Aprobacion (mayor a 80,000)
        Case newCase6 = new Case();
        newCase6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase6.Actualizaci_n_exitosa__c = 'Sí';
        newCase6.Status = 'Autorización';
        newCase6.Segunda_Aprobaci_n__c = true;
        newCase6.OwnerId = usr.Id;
        newCase6.Cupo__c = 85000;
        newCase6.ID_Solicitud__c = '123123666';
        newCase6.Validar_Movimientos__c = true;

        Case oldCase6 = new Case();
        oldCase6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase6.Actualizaci_n_exitosa__c = null;
        oldCase6.Status = 'Autorización';
        oldCase6.Segunda_Aprobaci_n__c = true;
        oldCase6.OwnerId = usr.Id;
        oldCase6.Cupo__c = 85000;
        oldCase6.ID_Solicitud__c = '123123666';
        oldCase6.Validar_Movimientos__c = true;

        /// Notifica Analista Rechazo (mayor a 80,000)
        Case newCase7 = new Case();
        newCase7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase7.Actualizaci_n_exitosa__c = 'No';
        newCase7.Status = 'Autorización';
        newCase7.Segunda_Aprobaci_n__c = true;
        newCase7.OwnerId = usr.Id;
        newCase7.Cupo__c = 85000;
        newCase7.ID_Solicitud__c = '123123777';
        newCase7.Validar_Movimientos__c = true;

        Case oldCase7 = new Case();
        oldCase7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase7.Actualizaci_n_exitosa__c = null;
        oldCase7.Status = 'Autorización';
        oldCase7.Segunda_Aprobaci_n__c = true;
        oldCase7.OwnerId = usr.Id;
        oldCase7.Cupo__c = 85000;
        oldCase7.ID_Solicitud__c = '123123777';
        oldCase7.Validar_Movimientos__c = true;

        /// Notifica Analista Aprobacion Actualizacion de Email
        Case newCase8 = new Case();
        newCase8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase8.Cuenta_al_Corriente__c = 'Sí';
        newCase8.OwnerId = usr.Id;
        newCase8.ID_Solicitud__c = '123123888';

        Case oldCase8 = new Case();
        oldCase8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase8.Cuenta_al_Corriente__c = null;
        oldCase8.OwnerId = usr.Id;
        oldCase8.ID_Solicitud__c = '123123888';

        /// Notifica Analista Rechazo Actualizacion de Email
        Case newCase9 = new Case();
        newCase9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase9.Cuenta_al_Corriente__c = 'No';
        newCase9.OwnerId = usr.Id;
        newCase9.ID_Solicitud__c = '123123999';

        Case oldCase9 = new Case();
        oldCase9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase9.Cuenta_al_Corriente__c = null;
        oldCase9.OwnerId = usr.Id;
        oldCase9.ID_Solicitud__c = '123123999';

        /// Notificacion Caso cerrado por Coordinador o Gerente
        Case newCase10 = new Case();
        newCase10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase10.Status = 'Cerrado';
        newCase10.Primera_Aprobaci_n__c = true;
        newCase10.Segunda_Aprobaci_n__c = true;
        newCase10.OwnerId = usr.Id;
        newCase10.Cupo__c = 85000;
        newCase10.ID_Solicitud__c = '123123010';

        Case oldCase10 = new Case();
        oldCase10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase10.Status = 'Autorización';
        oldCase10.Primera_Aprobaci_n__c = true;
        oldCase10.Segunda_Aprobaci_n__c = true;
        oldCase10.OwnerId = usr.Id;
        oldCase10.Cupo__c = 85000;
        oldCase10.ID_Solicitud__c = '123123010';

        Test.startTest();

        CaseTriggerHelper.approvalProcessesBO(newCase1, oldCase1);
        CaseTriggerHelper.approvalProcessesBO(newCase2, oldCase2);
        CaseTriggerHelper.approvalProcessesBO(newCase3, oldCase3);

        CaseTriggerHelper.approvalProcessesBO(newCase4, oldCase4);
        CaseTriggerHelper.approvalProcessesBO(newCase5, oldCase5);
        CaseTriggerHelper.approvalProcessesBO(newCase6, oldCase6);
        CaseTriggerHelper.approvalProcessesBO(newCase7, oldCase7);

        CaseTriggerHelper.approvalProcessesBO(newCase8, oldCase8);
        CaseTriggerHelper.approvalProcessesBO(newCase9, oldCase9);

        CaseTriggerHelper.approvalProcessesBO(newCase10, oldCase10);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo createCaseComments
     */
    @isTest static void createCaseCommentsTest() {

        Case newCase1 = new Case();
        newCase1.Id = '5003F000007kfV4QAI';
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        newCase1.Evaluar__c = 'Pendiente';
        newCase1.Motivo_de_Pendiente__c = '1.0.- Solicitud - No se anexo;1.1.- Solicitud - Esta ilegible';

        Case oldCase1 = new Case();
        oldCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        oldCase1.Evaluar__c = 'Pendiente';
        oldCase1.Motivo_de_Pendiente__c = '1.0.- Solicitud - No se anexo';

        ///
        CaseTriggerHelper.commentLst = new List<CaseComment>();
        CaseTriggerHelper.mapCasoListComentarios = new Map<Id, Set<String> >();

        Test.startTest();

        CaseTriggerHelper.createCaseComments(newCase1, oldCase1);

        Test.stopTest();

        System.assertEquals( CaseTriggerHelper.commentLst.size(), 2);
        System.assertEquals( CaseTriggerHelper.mapCasoListComentarios.get('5003F000007kfV4QAI'), new Set<String>{'1.0.- Solicitud - No se anexo','1.1.- Solicitud - Esta ilegible'});
    }
    
    /**
     * Test Method para la cubrir el Metodo moveStatus (Primer if)
     */
    @isTest static void moveStatusPrimerIfTest() {

        /// Primer if
        Case newCase1 = new Case();
        newCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Pago_No_Aplicado').getRecordTypeId();
        newCase1.Reason = 'Incidencias CC';
        newCase1.Dictamen__c = 'No procede';                                

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Primer if
        CaseTriggerHelper.moveStatus(newCase1, newCase1);

        Test.stopTest();

        System.assertEquals( newCase1.Status, 'Cancelado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Compra_no_diferida)
     */
    @isTest static void moveStatusCompraNoDiferidaTest() {

        /// Compra no diferida
        Case newCase2 = new Case();
        newCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        newCase2.Estatus_promoci_n__c = 'No Vigente';
        newCase2.Status = 'Detalle de la compra';

        Case newCase3 = new Case();
        newCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        newCase3.Estatus_promoci_n__c = 'No Vigente';
        newCase3.Status = 'Informar folio y despedida';

        Case oldCase3 = new Case();
        oldCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        oldCase3.Estatus_promoci_n__c = 'No Vigente';
        oldCase3.Status = 'Módulo';

        /// Compra no diferida (segunda regla)
        Case oldCase2a = new Case();
        oldCase2a.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        oldCase2a.Estatus_promoci_n__c = 'Vigente';
        oldCase2a.N_mero_de_cuotas_a_diferir__c = 'CPP buen fin 12 MCI';
        oldCase2a.Status = 'Informar folio y despedida';

        Case newCase2a = new Case();
        newCase2a.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        newCase2a.Estatus_promoci_n__c = 'Vigente';
        newCase2a.N_mero_de_cuotas_a_diferir__c = 'CPP buen fin 12 MCI';
        newCase2a.Status = 'Análisis de la aclaración';

        /// Validacion de Archivos Adjuntos
        Case newCase4 = new Case();
        newCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        newCase4.Status = 'Análisis de la aclaración';

        Case oldCase4 = new Case();
        oldCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId();
        oldCase4.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        ///
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase2.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase3.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase2a.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'null'};

        Test.startTest();

        /// Compra no diferida
        CaseTriggerHelper.moveStatus(newCase2, newCase2);
        CaseTriggerHelper.moveStatus(newCase3, oldCase3);
        /// Compra no diferida (segunda regla)
        CaseTriggerHelper.moveStatus(newCase2a, oldCase2a);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.moveStatus(newCase4, oldCase4);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase4.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};
        CaseTriggerHelper.moveStatus(newCase4, oldCase4);

        Test.stopTest();

        System.assertEquals( newCase2.Status, 'Informar folio y despedida');
        System.assertEquals( newCase3.Status, 'Cancelado');
        /// Compra no diferida (segunda regla)
        System.assertEquals( newCase2a.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cargo_no_reconocido)
     * Algunos Metodos se cubren en la clase CaseTriggerHandlerTest
     */
    @isTest static void moveStatusCargoNoReconocidoTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase4 = new Case();
        newCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        newCase4.Tiene_la_tarjeta_en_su_poder__c = 'NO - Tiene un reporte de Robo/Extravío dentro de 90 días';
        newCase4.Status = 'Documentación requerida';

        Case oldCase4 = new Case();
        oldCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId();
        oldCase4.Tiene_la_tarjeta_en_su_poder__c = 'NO - Tiene un reporte de Robo/Extravío dentro de 90 días';
        oldCase4.Status = 'Informar folio y despedida';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase4, oldCase4);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase4.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase4, oldCase4);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cambio_de_Producto)
     */
    @isTest static void moveStatusCambioDeMCTest() {

        /// Cambio de MC a Privada
        Case newCase4 = new Case();
        newCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        newCase4.Presenta_adeudo_en_MC__c = 'Sí';
        newCase4.Status = 'Información Cambio de Producto';

        Case oldCase4 = new Case();
        oldCase4.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        oldCase4.Presenta_adeudo_en_MC__c = 'Sí';
        oldCase4.Status = 'Información Cambio de Producto';

        Case newCase5 = new Case();
        newCase5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        newCase5.Presenta_adeudo_en_MC__c = 'Sí';
        newCase5.Status = 'Informar folio y despedida';

        Case oldCase5 = new Case();
        oldCase5.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        oldCase5.Presenta_adeudo_en_MC__c = 'Sí';
        oldCase5.Status = 'Informar folio y despedida';

        Case newCase6 = new Case();
        newCase6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        newCase6.El_cliente_desea_cambiar_de_producto__c = 'No';
        newCase6.Status = 'Beneficios del Producto';

        Case oldCase6 = new Case();
        oldCase6.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        oldCase6.El_cliente_desea_cambiar_de_producto__c = 'No';
        oldCase6.Status = 'Beneficios del Producto';

        Case newCase7 = new Case();
        newCase7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        newCase7.El_cliente_desea_cambiar_de_producto__c = 'No';
        newCase7.Status = 'Informar folio y despedida';

        Case oldCase7 = new Case();
        oldCase7.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId();
        oldCase7.El_cliente_desea_cambiar_de_producto__c = 'No';
        oldCase7.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Cambio de MC a Privada
        CaseTriggerHelper.moveStatus(newCase4, oldCase4);
        CaseTriggerHelper.moveStatus(newCase5, oldCase5);
        CaseTriggerHelper.moveStatus(newCase6, oldCase6);
        CaseTriggerHelper.moveStatus(newCase7, oldCase7);

        Test.stopTest();

        System.assertEquals( newCase4.Status, 'Informar folio y despedida');
        System.assertEquals( newCase5.Status, 'Cerrado');
        System.assertEquals( newCase6.Status, 'Informar folio y despedida');
        System.assertEquals( newCase7.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cambio_de_Medio_Env_o)
     */
    @isTest static void moveStatusCambioMedioEnvioTest() {

        /// Cambio de Medio Envío
        Case newCase8 = new Case();
        newCase8.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Medio_Env_o').getRecordTypeId();
        newCase8.Datos_del_cliente_son_correctos__c = 'SI';
        newCase8.Status = 'Actualización de Datos';

        Case newCase9 = new Case();
        newCase9.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Medio_Env_o').getRecordTypeId();
        newCase9.Datos_del_cliente_son_correctos__c = 'NO';
        newCase9.Status = 'Actualización de medio de envío';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Cambio de Medio Envío
        CaseTriggerHelper.moveStatus(newCase8, newCase8);
        CaseTriggerHelper.moveStatus(newCase9, newCase9);

        Test.stopTest();

        System.assertEquals( newCase8.Status, 'Informar folio y despedida');
        System.assertEquals( newCase9.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Aumento_de_L_nea_de_Cr_dito)
     */
    @isTest static void moveStatusAumentoLineaCreditoTest() {

        /// Aumento de Línea de Crédito
        Case newCase10 = new Case();
        newCase10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId();        
        newCase10.Origen_Campa_a__c = 'Correo';
        newCase10.Cliente_en_Base_de_Datos_de_Campa_a__c = 'No';
        newCase10.Cliente_acepta_aumento_l_nea_de_cr_dito__c = 'SI';
        newCase10.Status = 'Análisis de la Cuenta';

        Case oldCase10 = new Case();
        oldCase10.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId();
        oldCase10.Origen_Campa_a__c = 'Correo';
        oldCase10.Cliente_en_Base_de_Datos_de_Campa_a__c = 'No';
        oldCase10.Cliente_acepta_aumento_l_nea_de_cr_dito__c = 'SI';
        oldCase10.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        /// Notificacion a Back Office
        List<Group> lstQueues = [SELECT DeveloperName FROM Group WHERE DeveloperName =: Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER ];
        CaseTriggerHelper.mapQueues = new Map<String, Group>();
        for(Group queueUsr: lstQueues) {

            CaseTriggerHelper.mapQueues.put(queueUsr.DeveloperName, queueUsr);
        }

        Case newCase11 = new Case();
        newCase11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId();        
        newCase11.Origen_Campa_a__c = 'Solicitud sin campaña';
        newCase11.Cliente_en_Base_de_Datos_de_Campa_a__c = 'No';
        newCase11.Cliente_acepta_aumento_l_nea_de_cr_dito__c = 'SI';
        newCase11.OwnerId = CaseTriggerHelper.mapQueues.containsKey(Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER) ? CaseTriggerHelper.mapQueues.get(Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER).Id : UserInfo.getUserId();
        newCase11.Status = 'Análisis de la Cuenta';

        Case oldCase11 = new Case();
        oldCase11.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId();
        oldCase11.Origen_Campa_a__c = 'Solicitud sin campaña';
        oldCase11.Cliente_en_Base_de_Datos_de_Campa_a__c = 'No';
        oldCase11.Cliente_acepta_aumento_l_nea_de_cr_dito__c = 'SI';
        oldCase11.Status = 'Informar folio y despedida';

        CaseTriggerHelper.mapCustomNotification = new Map<String, CustomNotificationType>();
        List<CustomNotificationType> lstCustomNotification = [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName =: 'Aprobacion_de_Cupo_Riesgos' LIMIT 1];
        CaseTriggerHelper.mapCustomNotification.put(lstCustomNotification[0].DeveloperName,lstCustomNotification[0]);
        
        Test.startTest();

        /// Aumento de Línea de Crédito
        CaseTriggerHelper.moveStatus(newCase10, oldCase10);
        CaseTriggerHelper.moveStatus(newCase11, oldCase11);

        Test.stopTest();

        System.assertEquals( newCase10.Status, 'Cerrado');
        System.assertEquals( newCase11.Status, 'Análisis de la Cuenta');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cancelaci_n_de_Titular)
     */
    @isTest static void moveStatusCancelacionTitularTest() {

        /// Cancelación de Titular
        Case newCase13 = new Case();
        newCase13.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase13.Status = 'Motivo de Cancelación';
        newCase13.Motivo_de_cancelaci_n_de_tarjeta__c = 'Límite de crédito';
        newCase13.Cliente_desea_continuar_con_la_cancelac__c = 'No';
        newCase13.Subgrupo__c = 'Nuevos con uso';
        newCase13.Motivo_de_la_Retenci_n__c = 'Beneficios';

        Case newCase13a = new Case();
        newCase13a.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase13a.Status = 'Motivo de Cancelación';
        newCase13a.Motivo_de_cancelaci_n_de_tarjeta__c = 'Deseaba otro producto';
        newCase13a.Cliente_desea_continuar_con_la_cancelac__c = 'No';
        newCase13a.Subgrupo__c = 'Nuevos con uso';
        newCase13a.Motivo_de_la_Retenci_n__c = 'Beneficios';

        Case newCase13b = new Case();
        newCase13b.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase13b.Status = 'Motivo de Cancelación';
        newCase13b.Motivo_de_cancelaci_n_de_tarjeta__c = 'Deseaba otro producto';
        newCase13b.Cliente_desea_continuar_con_la_cancelac__c = 'No';
        newCase13b.Subgrupo__c = 'Nuevos con uso';
        newCase13b.Motivo_de_la_Retenci_n__c = 'Bono de Puntos 1,000 pts';

        Case newCase14 = new Case();
        newCase14.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase14.Acepta_o_no_cargos__c = 'N/A';
        newCase14.Saldo_IMPAGO__c = 'Si';
        newCase14.Status = 'Consulta cuenta de cliente';

        Case oldCase14 = new Case();
        oldCase14.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        oldCase14.Acepta_o_no_cargos__c = 'N/A';
        oldCase14.Saldo_IMPAGO__c = 'Si';
        oldCase14.Status = 'Consulta cuenta de cliente';

        Case newCase15 = new Case();
        newCase15.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase15.Acepta_o_no_cargos__c = 'N/A';
        newCase15.Saldo_IMPAGO__c = 'No';
        newCase15.Status = 'Informar folio y despedida';

        Case oldCase15 = new Case();
        oldCase15.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        oldCase15.Acepta_o_no_cargos__c = 'N/A';
        oldCase15.Saldo_IMPAGO__c = 'No';
        oldCase15.Status = 'Informar folio y despedida';

        Case newCase16 = new Case();
        newCase16.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId();
        newCase16.Acepta_o_no_cargos__c = 'NO';
        newCase16.Saldo_IMPAGO__c = 'No';
        newCase16.Status = 'Informar folio y despedida';

        ///
        CaseTriggerHelper.newCases = new List<Case>();
        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        CaseTriggerHelper.mapQueues = new Map<String, Group>();

        Test.startTest();

        /// Cancelación de Titular
        CaseTriggerHelper.moveStatus(newCase13, newCase13);
        CaseTriggerHelper.moveStatus(newCase13a, newCase13a);
        CaseTriggerHelper.moveStatus(newCase13b, newCase13b);
        CaseTriggerHelper.moveStatus(newCase14, oldCase14);
        CaseTriggerHelper.moveStatus(newCase15, oldCase15);
        CaseTriggerHelper.moveStatus(newCase16, newCase16);

        Test.stopTest();

        System.assertEquals( CaseTriggerHelper.newCases.size(), 3);
        System.assertEquals( newCase14.Status, 'Informar folio y despedida');
        System.assertEquals( newCase15.Status, 'Cerrado');
        System.assertEquals( newCase16.Status, 'Cancelado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Operaciones_del_cliente)
     */
    @isTest static void moveStatusTarjetaNoPasaTest() {

        /// Tarjeta no pasa
        Case newCase17 = new Case();
        newCase17.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Operaciones_del_cliente').getRecordTypeId();
        newCase17.Clasificaci_n_Tarjeta_Declinada__c = 'Tarjeta no operativa';
        newCase17.Status = 'Informar folio y despedida';

        Case oldCase17 = new Case();
        oldCase17.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Operaciones_del_cliente').getRecordTypeId();
        oldCase17.Clasificaci_n_Tarjeta_Declinada__c = 'Tarjeta no operativa';
        oldCase17.Status = 'Informar folio y despedida';

        Case newCase18 = new Case();
        newCase18.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Operaciones_del_cliente').getRecordTypeId();
        newCase18.Clasificaci_n_Tarjeta_Declinada__c = 'Tarjeta no operativa';
        newCase18.Status = 'Detalle de la Tarjeta Declinada';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Tarjeta no pasa
        CaseTriggerHelper.moveStatus(newCase17, oldCase17);
        CaseTriggerHelper.moveStatus(newCase18, newCase18);

        Test.stopTest();

        System.assertEquals( newCase17.Status, 'Cerrado');
        System.assertEquals( newCase18.Status, 'Informar folio y despedida');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Abono_de_Puntos)
     */
    @isTest static void moveStatusAbonoDePuntosTest() {

        /// Abono de Puntos
        Case newCase19 = new Case();
        newCase19.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId();
        newCase19.Comercio_de_la_compraAP__c = 'Soriana';
        newCase19.Status = 'Informar folio y despedida';

        Case oldCase19 = new Case();
        oldCase19.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId();
        oldCase19.Comercio_de_la_compraAP__c = 'Soriana';
        oldCase19.Status = 'Informar folio y despedida';

        /// Validacion de Archivos Adjuntos
        Case newCase20 = new Case();
        newCase20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId();
        newCase20.Status = 'Documentación requerida';

        Case oldCase20 = new Case();
        oldCase20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId();
        oldCase20.Status = 'Informar folio y despedida';

        ///
        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase19.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'null'};

        Test.startTest();

        /// Abono de Puntos
        CaseTriggerHelper.moveStatus(newCase19, oldCase19);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.moveStatus(newCase20, oldCase20);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase20.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};
        CaseTriggerHelper.moveStatus(newCase20, oldCase20);

        Test.stopTest();

        System.assertEquals( newCase19.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Sospecha_de_Fraude)
     */
    @isTest static void moveStatusSospechaFraudeTest() {

        List<Account> listAccounts = [SELECT Id FROM Account WHERE CURP__c = 'TEST123TEST123TEST' LIMIT 1];

        /// Sospecha de Fraude
        Case newCase20 = new Case();
        newCase20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sospecha_de_Fraude').getRecordTypeId();
        newCase20.Status = 'Cerrado';
        newCase20.AccountId = listAccounts[0].Id;
        newCase20.Categor_a__c = 'Tarjeta Declinada';
        newCase20.La_cuenta_presenta_incidencia__c = 'Sí';
        newCase20.OwnerId = UserInfo.getUserId();

        Case oldCase20 = new Case();
        oldCase20.Id = '5003F000007kfV4QAI';
        oldCase20.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sospecha_de_Fraude').getRecordTypeId();
        oldCase20.Status = 'Informar folio y despedida';
        oldCase20.AccountId = listAccounts[0].Id;
        oldCase20.Categor_a__c = 'Tarjeta Declinada';
        oldCase20.La_cuenta_presenta_incidencia__c = 'Sí';
        oldCase20.OwnerId = UserInfo.getUserId();

        ///
        CaseTriggerHelper.newCases = new List<Case>();
        CaseTriggerHelper.mapCases = new Map<Id, Case>{'5003F000007kfV4QAI' => oldCase20};
        CaseTriggerHelper.mapQueues = new Map<String, Group>();

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Sospecha de Fraude
        CaseTriggerHelper.moveStatus(newCase20, oldCase20);

        Test.stopTest();

        System.assertEquals( CaseTriggerHelper.newCases.size(), 1);
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Reenv_o_de_Estado_de_Cuenta)
     */
    @isTest static void moveStatusReenvioEdoCtaTest() {

        /// Reenvío de Estado de Cuenta
        Case newCase21 = new Case();
        newCase21.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reenv_o_de_Estado_de_Cuenta').getRecordTypeId();
        newCase21.Datos_del_cliente_son_correctos__c = 'SI';
        newCase21.Status = 'Actualización de Datos';

        Case newCase22 = new Case();
        newCase22.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reenv_o_de_Estado_de_Cuenta').getRecordTypeId();
        newCase22.Datos_del_cliente_son_correctos__c = 'SI';
        newCase22.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Reenvío de Estado de Cuenta
        CaseTriggerHelper.moveStatus(newCase21, newCase21);
        CaseTriggerHelper.moveStatus(newCase22, newCase22);

        Test.stopTest();

        System.assertEquals( newCase21.Status, 'Informar folio y despedida');
        System.assertEquals( newCase22.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Pago_No_Aplicado)
     */
    @isTest static void moveStatusPagoNoAplicadoTest() {

        /// Pago No Aplicado
        Case newCase23 = new Case();
        newCase23.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Pago_No_Aplicado').getRecordTypeId();
        newCase23.Dictamen__c = 'En contra';

        /// Validacion de Archivos Adjuntos
        Case newCase24 = new Case();
        newCase24.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Pago_No_Aplicado').getRecordTypeId();
        newCase24.Status = 'Documentación requerida';

        Case oldCase24 = new Case();
        oldCase24.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Pago_No_Aplicado').getRecordTypeId();
        oldCase24.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        ///
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Pago No Aplicado
        CaseTriggerHelper.moveStatus(newCase23, newCase23);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase24, oldCase24);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase24.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase24, oldCase24);

        Test.stopTest();

        System.assertEquals( newCase23.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Retiro_de_efectivo_en_ATM)
     */
    @isTest static void moveStatusRetiroEfectivoATMTest() {

        /// Retiro de efectivo en ATM
        Case newCase24 = new Case();
        newCase24.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retiro_de_efectivo_en_ATM').getRecordTypeId();
        newCase24.Dictamen__c = 'En contra';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Retiro de efectivo en ATM
        CaseTriggerHelper.moveStatus(newCase24, newCase24);

        Test.stopTest();

        System.assertEquals( newCase24.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Reversa_de_Comisi_n)
     */
    @isTest static void moveStatusReversaComisionTest() {

        /// Reversa de Comisión
        Case newCase25 = new Case();
        newCase25.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Comisi_n').getRecordTypeId();
        newCase25.Dictamen__c = 'En contra';

        /// Validacion de Archivos Adjuntos
        Case newCase26 = new Case();
        newCase26.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Comisi_n').getRecordTypeId();
        newCase26.Tipo_de_comisi_n__c = 'Pago tardío';
        newCase26.Status = 'Validación de la anualidad';

        Case oldCase26 = new Case();
        oldCase26.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Comisi_n').getRecordTypeId();
        oldCase26.Tipo_de_comisi_n__c = 'Pago tardío';
        oldCase26.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        ///
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Reversa de Comisión
        CaseTriggerHelper.moveStatus(newCase25, newCase25);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase26, oldCase26);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase26.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase26, oldCase26);

        Test.stopTest();

        System.assertEquals( newCase25.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Reversa_de_Anualidad)
     */
    @isTest static void moveStatusReversaAnualidadTest() {

        /// Reversa de Anualidad
        Case newCase26 = new Case();
        newCase26.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        newCase26.Reversa_de_Anualidad_por__c = 'Empleados';
        newCase26.Status = 'Detalle para la cancelación de anualidad';

        Case oldCase26 = new Case();
        oldCase26.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        oldCase26.Reversa_de_Anualidad_por__c = 'Empleados';
        oldCase26.Status = 'Detalle para la cancelación de anualidad';

        Case newCase27 = new Case();
        newCase27.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        newCase27.Reversa_de_Anualidad_por__c = 'Promoción';
        newCase27.Status = 'Informar folio y despedida';
        newCase27.Dictamen__c = 'En contra';
        newCase27.Cliente_Acepta_Beneficios__c = 'Beneficios';

        Case oldCase27 = new Case();
        oldCase27.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        oldCase27.Reversa_de_Anualidad_por__c = 'Promoción';
        oldCase27.Status = 'Informar folio y despedida';
        oldCase27.Dictamen__c = 'En contra';
        oldCase27.Cliente_Acepta_Beneficios__c = 'Beneficios';

        /// Validacion de Archivos Adjuntos
        Case newCase28 = new Case();
        newCase28.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        newCase28.Reversa_de_Anualidad_por__c = 'Empleados';
        newCase28.Status = 'Validación de la anualidad';

        Case oldCase28 = new Case();
        oldCase28.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId();
        oldCase28.Reversa_de_Anualidad_por__c = 'Empleados';
        oldCase28.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        ///
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Reversa de Anualidad
        CaseTriggerHelper.moveStatus(newCase26, oldCase26);
        CaseTriggerHelper.moveStatus(newCase27, oldCase27);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase28, oldCase28);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase28.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase28, oldCase28);

        Test.stopTest();

        System.assertEquals( newCase26.Status, 'Informar folio y despedida');
        System.assertEquals( newCase27.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Actualizaci_n_de_Tel_fono_Fijo)
     */
    @isTest static void moveStatusActualizacionTelFijoTest() {

        /// Actualización de Teléfono Fijo
        Case newCase28 = new Case();
        newCase28.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Tel_fono_Fijo').getRecordTypeId();
        newCase28.Validaci_n_de_Tel_fono_Anterior__c = false;
        newCase28.Status = 'Validación del Teléfono Anterior';

        Case oldCase28 = new Case();
        oldCase28.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Tel_fono_Fijo').getRecordTypeId();
        oldCase28.Validaci_n_de_Tel_fono_Anterior__c = false;
        oldCase28.Status = 'Validación del Teléfono Anterior';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Actualización de Teléfono Fijo
        CaseTriggerHelper.moveStatus(newCase28, oldCase28);

        Test.stopTest();

        System.assertEquals( newCase28.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Actualizaci_n_SORIBAN)
     */
    @isTest static void moveStatusActualizacionSoribanTest() {

        /// Actualización SORIBAN
        Case newCase29 = new Case();
        newCase29.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_SORIBAN').getRecordTypeId();
        newCase29.Actualizar_domicilio__c = 'No';
        newCase29.Status = 'Actualización de Nombre';

        Case oldCase29 = new Case();
        oldCase29.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_SORIBAN').getRecordTypeId();
        oldCase29.Actualizar_domicilio__c = 'No';
        oldCase29.Status = 'Actualización de Nombre';
        
        Case newCase30 = new Case();
        newCase30.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_SORIBAN').getRecordTypeId();
        newCase30.Status = 'Actualización de Domicilio parte 1';
        newCase30.Estado_Direccion__c = 'a0A1N00001Nvw5sUAB';
        newCase30.Municipio_Direccion__c = 'a0B1N00000IRmgHUAT';
        newCase30.Colonia_Direccion__c = 'a0C0v000001qpQHEAY';

        ///
        C_digo_Postal__c codigoPostal = new C_digo_Postal__c();
        codigoPostal.Name = '66273';
        CaseTriggerHelper.mapColoniaCP = new Map<String, C_digo_Postal__c>{'a0C0v000001qpQHEAY' => codigoPostal};

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Actualización SORIBAN
        CaseTriggerHelper.moveStatus(newCase29, oldCase29);
        CaseTriggerHelper.moveStatus(newCase30, newCase30);

        Test.stopTest();

        System.assertEquals( newCase29.Status, 'Actualización de Datos');
        System.assertEquals( newCase30.C_digo_Postal_Texto__c, '66273');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Actualizaci_n_de_Domicilio)
     */
    @isTest static void moveStatusActualizacionDomicilioTest() {

        /// Actualización de Domicilio
        Case newCase31 = new Case();
        newCase31.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Domicilio').getRecordTypeId();
        newCase31.Status = 'Actualización de Domicilio parte 1';
        newCase31.Estado_Direccion__c = 'a0A1N00001Nvw5sUAB';
        newCase31.Municipio_Direccion__c = 'a0B1N00000IRmgHUAT';
        newCase31.Colonia_Direccion__c = 'a0C0v000001qpQHEAY';

        ///
        C_digo_Postal__c codigoPostal = new C_digo_Postal__c();
        codigoPostal.Name = 'a0D0v000003NtRNEA0';
        CaseTriggerHelper.mapColoniaCP = new Map<String, C_digo_Postal__c>{'a0C0v000001qpQHEAY' => codigoPostal};

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Actualización de Domicilio
        CaseTriggerHelper.moveStatus(newCase31, newCase31);

        Test.stopTest();

        System.assertEquals( newCase31.C_digo_Postal_Direccion__c, 'a0D0v000003NtRNEA0');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Actualizaci_n_de_Celular)
     */
    @isTest static void moveStatusActualizacionCelularTest() {

        /// Actualización de Celular
        Case newCase32 = new Case();
        newCase32.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Celular').getRecordTypeId();
        newCase32.Autenticaci_n_exitosa__c = 'no';
        newCase32.Status = 'Autenticación de Buro';

        Case newCase33 = new Case();
        newCase33.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Celular').getRecordTypeId();
        newCase33.Celular_Nuevo_Verificado__c = false;
        newCase33.Status = 'Actualización de Celular';

        Case oldCase33 = new Case();
        oldCase33.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Celular').getRecordTypeId();
        oldCase33.Celular_Nuevo_Verificado__c = false;
        oldCase33.Status = 'Actualización de Datos';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Actualización de Celular
        CaseTriggerHelper.moveStatus(newCase32, newCase32);
        CaseTriggerHelper.moveStatus(newCase33, oldCase33);

        Test.stopTest();

        System.assertEquals( newCase32.Status, 'Cerrado');
        System.assertEquals( newCase33.Status, 'Actualización de Celular');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - APP)
     */
    @isTest static void moveStatusAppTest() {

        /// APP
        Case newCase34 = new Case();
        newCase34.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('APP').getRecordTypeId();
        newCase34.Incidencia_App__c = 'CURP no reconocido';
        newCase34.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// APP
        CaseTriggerHelper.moveStatus(newCase34, newCase34);

        Test.stopTest();

        System.assertEquals( newCase34.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - WEB)
     */
    @isTest static void moveStatusWebTest() {

        /// WEB
        Case newCase35 = new Case();
        newCase35.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB').getRecordTypeId();
        newCase35.Incidencia_Web__c = 'CURP no reconocido';
        newCase35.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// WEB
        CaseTriggerHelper.moveStatus(newCase35, newCase35);

        Test.stopTest();

        System.assertEquals( newCase35.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Up_Grade)
     */
    @isTest static void moveStatusUpGradeTest() {

        /// Up Grade
        Case newCase36 = new Case();
        newCase36.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Up_Grade').getRecordTypeId();
        newCase36.La_cuenta_presenta_incidencia__c = 'No';
        newCase36.Status = 'Análisis de la Cuenta';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Up Grade
        CaseTriggerHelper.moveStatus(newCase36, newCase36);

        Test.stopTest();

        System.assertEquals( newCase36.Status, 'Up Grade');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Quita)
     */
    @isTest static void moveStatusQuitaTest() {

        /// Quita
        Case newCase37 = new Case();
        newCase37.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quita').getRecordTypeId();
        newCase37.Cancelaci_n_de_la_cuenta__c = 'Sí';
        newCase37.Status = 'Aplicación de Quita';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Quita
        CaseTriggerHelper.moveStatus(newCase37, newCase37);

        Test.stopTest();

        System.assertEquals( newCase37.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Reestructura)
     */
    @isTest static void moveStatusReestructuraTest() {

        /// Reestructura
        Case newCase38 = new Case();
        newCase38.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reestructura').getRecordTypeId();
        newCase38.Tipo_de_Mora__c = 'Cartera Congelada';
        newCase38.Status = 'Reestructura';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Reestructura
        CaseTriggerHelper.moveStatus(newCase38, newCase38);

        Test.stopTest();

        System.assertEquals( newCase38.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Consulta_de_PAN)
     */
    @isTest static void moveStatusConsultaDePanTest() {

        /// Consulta de PAN
        Case newCase39 = new Case();
        newCase39.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Consulta_de_PAN').getRecordTypeId();
        newCase39.La_tarjeta_presenta_bloqueo__c = 'No';
        newCase39.Celular_PAN_Verificado__c = false;
        newCase39.Status = 'Consulta de PAN';

        Case oldCase39 = new Case();
        oldCase39.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Consulta_de_PAN').getRecordTypeId();
        oldCase39.La_tarjeta_presenta_bloqueo__c = 'No';
        oldCase39.Celular_PAN_Verificado__c = false;
        oldCase39.Status = 'Consulta Cuenta';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Consulta de PAN
        CaseTriggerHelper.moveStatus(newCase39, oldCase39);

        Test.stopTest();

        System.assertEquals( newCase39.Status, 'Consulta de PAN');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Audiencia_CONDUSEF)
     */
    @isTest static void moveStatusAudienciaCondusefTest() {

        /// Audiencia CONDUSEF
        Causas_Condusef__c causasCondusef = new Causas_Condusef__c();
        causasCondusef.Name = '0749';
        causasCondusef.Clave_Causa_CONDUSEF__c = '0749';
        causasCondusef.Cuasa_ID__c = '0749';

        Causas_Condusef__c causasCondusef2 = new Causas_Condusef__c();
        causasCondusef2.Name = 'Test';
        causasCondusef2.Clave_Causa_CONDUSEF__c = 'Test';
        causasCondusef2.Cuasa_ID__c = 'Test';

        Case newCase40 = new Case();
        newCase40.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Audiencia_CONDUSEF').getRecordTypeId();
        newCase40.Causa_CONDUSEF__c = 'a180v000000N5VkAAK';
        newCase40.Status = 'Documentación requerida';
        newCase40.Tipo_de_bloqueo__c = 'N/A';

        Case newCase41 = new Case();
        newCase41.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Audiencia_CONDUSEF').getRecordTypeId();
        newCase41.Causa_CONDUSEF__c = 'a180v000000N5VkAAA';
        newCase41.Status = 'Revisa Folio';
        newCase41.Tipo_de_bloqueo__c = 'N/A';

        Case newCase42 = new Case();
        newCase42.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Audiencia_CONDUSEF').getRecordTypeId();
        newCase42.Causa_CONDUSEF__c = 'a180v000000N5VkAAA';
        newCase42.Status = 'Revisa Folio';
        newCase42.Tipo_de_bloqueo__c = 'Robo';

        ///
        CaseTriggerHelper.mapCausasCondusef = new Map<Id, Causas_Condusef__c>{'a180v000000N5VkAAK' => causasCondusef, 'a180v000000N5VkAAA' => causasCondusef2 };

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Audiencia CONDUSEF
        CaseTriggerHelper.moveStatus(newCase40, newCase40);
        CaseTriggerHelper.moveStatus(newCase41, newCase41);
        CaseTriggerHelper.moveStatus(newCase42, newCase42);

        Test.stopTest();

        System.assertEquals( newCase40.Status, 'Ajuste contable');
        System.assertEquals( newCase41.Status, 'Ajuste contable');
        System.assertEquals( newCase42.Status, 'Dictamen Fraudes');
    }


    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Saldo_a_Favor)
     */
    @isTest static void moveStatusSaldoAFavorTest() {

        /// Saldo a Favor
        Case newCase43 = new Case();
        newCase43.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Saldo_a_Favor').getRecordTypeId();
        newCase43.Dictamen__c = 'No procede';
        newCase43.Status = 'Normalización';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Saldo a Favor
        CaseTriggerHelper.moveStatus(newCase43, newCase43);

        Test.stopTest();

        System.assertEquals( newCase43.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Actualizaci_n_Nom_RFC_FN)
     */
    @isTest static void moveStatusActualizacionNombreTest() {

        /// Actualización Nom, RFC, FN
        Case newCase44 = new Case();
        newCase44.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_Nom_RFC_FN').getRecordTypeId();
        newCase44.Tipo_de_informaci_n__c = 'Nombre';
        newCase44.Status = 'Informar folio y despedida';

        Case oldCase44 = new Case();
        oldCase44.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_Nom_RFC_FN').getRecordTypeId();
        oldCase44.Tipo_de_informaci_n__c = 'Nombre';
        oldCase44.Status = 'Información';

        Case newCase45 = new Case();
        newCase45.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_Nom_RFC_FN').getRecordTypeId();
        newCase45.Dictamen_Fraudes__c = 'En Contra';
        newCase45.Status = 'Dictamen Final';

        Case oldCase45 = new Case();
        oldCase45.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_Nom_RFC_FN').getRecordTypeId();
        oldCase45.Dictamen_Fraudes__c = 'En Contra';
        oldCase45.Status = 'Dictamen';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Actualización Nom, RFC, FN
        CaseTriggerHelper.moveStatus(newCase44, oldCase44);
        CaseTriggerHelper.moveStatus(newCase45, oldCase45);

        Test.stopTest();

        System.assertEquals( newCase44.Status, 'Cerrado');
        System.assertEquals( newCase45.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Procedimiento_de_Cobro)
     */
    @isTest static void moveStatusMalProcesoCobroTest() {

        /// Mal proceso de cobro
        Case newCase46 = new Case();
        newCase46.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Procedimiento_de_Cobro').getRecordTypeId();
        newCase46.Fecha_de_pago__c = System.today();
        newCase46.Tipo_de_Mora__c = 'Mora Leve';
        newCase46.Establecimiento_de_pago__c = 'Soriana';
        newCase46.Status = 'Dictamen';

        Case oldCase46 = new Case();
        oldCase46.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Procedimiento_de_Cobro').getRecordTypeId();
        oldCase46.Fecha_de_pago__c = System.today();
        oldCase46.Tipo_de_Mora__c = 'Mora Leve';
        oldCase46.Establecimiento_de_pago__c = 'Soriana';
        oldCase46.Status = 'Informar folio y despedida';

        /// Validacion de Archivos Adjuntos
        Case newCase47 = new Case();
        newCase47.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Procedimiento_de_Cobro').getRecordTypeId();
        newCase47.Clasificaci_n_Medio_de_env_o_no_llega__c = 'Cliente realizó el pago';
        newCase47.Status = 'Dictamen';

        Case oldCase47 = new Case();
        oldCase47.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Procedimiento_de_Cobro').getRecordTypeId();
        oldCase47.Clasificaci_n_Medio_de_env_o_no_llega__c = 'Cliente realizó el pago';
        oldCase47.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
        ///
        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Mal proceso de cobro
        CaseTriggerHelper.moveStatus(newCase46, oldCase46);
        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase47, oldCase47);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase47.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase47, oldCase47);

        Test.stopTest();

        System.assertEquals( newCase46.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Plan_de_Pagos)
     */
    @isTest static void moveStatusPlanDePagosTest() {

        /// Plan de Pagos
        Case newCase47 = new Case();
        newCase47.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        newCase47.Pago_Acreditado__c = 'Se realizo fuera de la fecha de pago, pagó incompleto, no realizo pago.';
        newCase47.Status = 'Análisis de la Cuenta';

        Case oldCase47 = new Case();
        oldCase47.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        oldCase47.Pago_Acreditado__c = 'Se realizo fuera de la fecha de pago, pagó incompleto, no realizo pago.';
        oldCase47.Status = 'Informar folio y despedida';

        Case newCase48 = new Case();
        newCase48.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        newCase48.Pago_Acreditado__c = 'Sí';
        newCase48.Estatus_promocin__c = 'Reclamo';
        newCase48.Status = 'Análisis de la Cuenta';

        Case oldCase48 = new Case();
        oldCase48.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        oldCase48.Pago_Acreditado__c = 'Sí';
        oldCase48.Estatus_promocin__c = 'Reclamo';
        oldCase48.Status = 'Informar folio y despedida';

        ///
        Case newCase48a = new Case();
        newCase48a.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        newCase48a.Pago_Acreditado__c = 'Promesa de pago';
        newCase48a.Estatus_promocin__c = 'Servicio';
        newCase48a.Status = 'Análisis de la Cuenta';

        Case oldCase48a = new Case();
        oldCase48a.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId();
        oldCase48a.Pago_Acreditado__c = 'Promesa de pago';
        oldCase48a.Estatus_promocin__c = 'Servicio';
        oldCase48a.Status = 'Informar folio y despedida';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        //// Plan de Pagos
        CaseTriggerHelper.moveStatus(newCase47, oldCase47);
        CaseTriggerHelper.moveStatus(newCase48, oldCase48);
        CaseTriggerHelper.moveStatus(newCase48a, oldCase48a);

        Test.stopTest();

        System.assertEquals( newCase47.Status, 'Cancelado');
        System.assertEquals( newCase48.Status, 'Análisis de la aclaración');
        System.assertEquals( newCase48a.Status, 'Cerrado');
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Emboce_Centralizado)
     */
    /*@isTest static void moveStatusEmboceCentralizadoTest() {

        /// Emboce Centralizado
        Case newCase49 = new Case();
        newCase49.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        newCase49.Status = 'Investigación de envío';

        Case oldCase49 = new Case();
        oldCase49.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        oldCase49.Status = 'Confirmación';

        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();

        Test.startTest();

        /// Emboce Centralizado
        CaseTriggerHelper.moveStatus(newCase49, oldCase49);

        Test.stopTest();

        System.assertEquals( newCase49.Status, 'Asignada');
    }*/

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Promoci_n_no_Aplicada)
     */
    @isTest static void moveStatusPromocionNoAplicadaTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase50 = new Case();
        newCase50.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Promoci_n_no_Aplicada').getRecordTypeId();
        newCase50.Status = 'Análisis de la aclaración';

        Case oldCase50 = new Case();
        oldCase50.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Promoci_n_no_Aplicada').getRecordTypeId();
        oldCase50.Status = 'Informar folio y despedida';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase50, oldCase50);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase50.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase50, oldCase50);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cancelaci_n_de_Tarjeta_por_Fallecimiento)
     */
    @isTest static void moveStatusCancelacionFallecimientoTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase51 = new Case();
        newCase51.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Tarjeta_por_Fallecimiento').getRecordTypeId();
        newCase51.Status = 'Documentación requerida';

        Case oldCase51 = new Case();
        oldCase51.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Tarjeta_por_Fallecimiento').getRecordTypeId();
        oldCase51.Status = 'Informar folio y despedida';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase51, oldCase51);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase51.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase51, oldCase51);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Cobro_a_Persona)
     */
    @isTest static void moveStatusCobroPersonaTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase51 = new Case();
        newCase51.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cobro_a_Persona').getRecordTypeId();
        newCase51.Status = 'Dictamen';

        Case oldCase51 = new Case();
        oldCase51.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cobro_a_Persona').getRecordTypeId();
        oldCase51.Status = 'Informar folio y despedida';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase51, oldCase51);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase51.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase51, oldCase51);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Remisi_n)
     */
    @isTest static void moveStatusRemisionTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase52 = new Case();
        newCase52.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Remisi_n').getRecordTypeId();
        newCase52.Status = 'Dictamen';

        Case oldCase52 = new Case();
        oldCase52.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Remisi_n').getRecordTypeId();
        oldCase52.Status = 'Detalle del caso';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase52, oldCase52);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase52.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase52, oldCase52);

        Test.stopTest();
    }

    /**
     * Test Method para la cubrir el Metodo moveStatus (RecordType - Reposici_n)
     */
    @isTest static void moveStatusReposicionTest() {

        /// Validacion de Archivos Adjuntos
        Case newCase53 = new Case();
        newCase53.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reposici_n').getRecordTypeId();
        newCase53.Status = 'Dictamen';

        Case oldCase53 = new Case();
        oldCase53.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reposici_n').getRecordTypeId();
        oldCase53.Status = 'Detalle del caso';

        CaseTriggerHelper.mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();
        CaseTriggerHelper.lstAllowedAttachments = new List<String>{'txt'};

        Test.startTest();

        /// Se valida que al menos exista un Archivo Adjunto al Caso
        CaseTriggerHelper.moveStatus(newCase53, oldCase53);
        /// Validar Archivos Adjuntos Permitidos
        CaseTriggerHelper.mapCaseIdLstAttachments.put(newCase53.Id, new List<ContentDocumentLink>{ new ContentDocumentLink() } );
        CaseTriggerHelper.moveStatus(newCase53, oldCase53);

        Test.stopTest();
    }
}