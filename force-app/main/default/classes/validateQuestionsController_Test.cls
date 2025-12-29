/************************************************************************************************
Apex Class Name	:	validateQuestionsController_Test 
Version			:	1.0
Created Date    :	02/08/2019 13:21
Function 		: 	Cubrir a la clase controladora del componente ValidateQuestions
Cover Class		:	validateQuestionsController
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     06/08/2019 	   Original Version
* Mauricio Rosales   18/Dic/2020       Ajustes rango de dias en Metadata
*************************************************************************************************/
@isTest
public class validateQuestionsController_Test {

    @testSetup
    static void setupData() {

        //Creamos una cuenta del cliente
        Account acc1 = new Account();
        acc1.LastName = 'Test112233';
        acc1.CURP__c = 'ABCD112233HDFABC00';
        insert acc1;
        //Creamos una tarjeta asocianda al ciente
        Tarjeta__c tar = new Tarjeta__c();
        tar.Account__c = acc1.Id;
        tar.BIN__c = '612054';
        tar.ltimos_4_d_gitos_tarjeta__c = '4563';
        tar.D_a_Fecha_de_corte__c = '10';
        tar.Donde_pag_su_tarjeta__c = 'Otro Medio';
        tar.Cuando_realiz_el_pago_de_tarjeta__c = '20';
        tar.Compra_diferida__c = 'Si';
        insert tar;
        
        Case c2 = new Case();
        c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de Celular').getRecordTypeId();
        c2.Categor_a__c = 'Actualizar Datos';
        c2.AccountId = acc1.Id;
        insert c2;
        
    }
    //Método para validar el buscar una tarjeta a partir del Id del cliente y el número
    //de tarjeta, y validar la creación del registro de Validación de Preguntas
    //seteando las respuestas del cliente
    @isTest static void test_validateQuestions() {
        
        Account acc1 = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];
        Contact ctc = [SELECT Id FROM Contact WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];
        Case caso = [SELECT Id FROM Case WHERE AccountId =: acc1.Id ];
        //Hacemos un query a la tarjeta recien insertada para obtener el valor del campo
        //formula N_mero_de_tarjeta__c
        Tarjeta__c tar = [SELECT Id, N_mero_de_tarjeta__c, D_a_Fecha_de_Corte__c, Donde_pag_su_tarjeta__c, Cuando_realiz_el_pago_de_tarjeta__c, Compra_diferida__c 
                                FROM Tarjeta__c 
                                Where Account__c =: acc1.Id AND BIN__c = '612054' LIMIT 1];
        
        String tipoDeIntento = 'validateQuestions';
        String rangoDiasVencimiento = 'rangoDiasVencimiento';
        String rangoDiasUltimoPago = 'rangoDiasUltimoPago';
    
        ///
        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de Celular').getRecordTypeId();
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';
        String camposRequeridos = 'Autenticaci_n_exitosa__c:No';

        Test.startTest();

        //probamos el número de intentos permitidos        
        Map<String, Integer> intentospermitidos = validateQuestionsController.getValidateQuestionsTry(tipoDeIntento, rangoDiasVencimiento, rangoDiasUltimoPago);

        //probamos el número de Intentos realizados hoy
        Integer intentosHoy = validateQuestionsController.getValidationToday(acc1.Id);

        //probamos el número total de casos del cliente
        Integer casosDelCliente = validateQuestionsController.casosDelCliente(acc1.Id);

        //probamos el número de casos abiertos relaciondos al cliente
        Integer casosAbiertosDelCliente = validateQuestionsController.casosAbiertosDelCliente(acc1.Id);

        //probamos el obtener la tarjeta con Id cliente y número de tarjeta
        Tarjeta__c tarjeta = validateQuestionsController.getCardData(tar.N_mero_de_tarjeta__c, acc1.Id);

        //probamos creacion de registro validación de preguntas
        Validacion_Incorrecta__c vi = validateQuestionsController.createValidacionIncorrecta(tar.N_mero_de_tarjeta__c, acc1.Id, tar.D_a_Fecha_de_Corte__c, tar.Donde_pag_su_tarjeta__c, tar.Cuando_realiz_el_pago_de_tarjeta__c, tar.Compra_diferida__c,true,4,'Si','Si', caso.Id);
        
        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>(); //se agregó para que salga del método de createCase
        Map<String, Object> crearCasoValidacionPreguntas = validateQuestionsController.createCaseClosedCurp(recordTypeId, acc1.Id, ctc.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );

        Test.stopTest();

        Intentos_de_Validacion__mdt intentosConsulta =  [SELECT Intentos__c FROM Intentos_de_Validacion__mdt WHERE MasterLabel = 'validateQuestions' LIMIT 1];
        System.assertEquals(intentospermitidos.get('validateQuestions'), intentosConsulta.Intentos__c);

        System.assertEquals(intentosHoy, 0);

        System.assertEquals(casosDelCliente, 1);

        System.assertEquals(casosAbiertosDelCliente, 1);

        System.assertEquals(tarjeta.Id, tar.Id);

        Validacion_Incorrecta__c validacionConsulta = [SELECT Id FROM Validacion_Incorrecta__c WHERE Tarjeta__c =: tar.Id AND Account__c =: acc1.Id LIMIT 1];
        System.assertEquals(vi.Id, validacionConsulta.Id);

        System.assertEquals(crearCasoValidacionPreguntas.get('success'), true);
    }

    @isTest static void test_casoCURP() {

        Account acc1 = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];
        Contact ctc = [SELECT Id FROM Contact WHERE CURP__c = 'ABCD112233HDFABC00' LIMIT 1 ];

        String recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de CURP').getRecordTypeId();
        String category = 'Actualización de Datos';
        Boolean altoRiesgo = true;
        String metodoContactoValue = 'Contact Center';
        String numeroDeTarjetaValue = '';

        String camposRequeridos = 'Actualizaci_n_Alta__c:Actualización,';
        camposRequeridos += 'CURP_texto__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Curp_Anterior__c:ABCD112233HDFABC00,';
        camposRequeridos += 'Nombre_s__c:TEST,';
        camposRequeridos += 'Segundo_Apellido__c:TEST,';
        camposRequeridos += 'Primer_Apellido__c:TEST,';
        camposRequeridos += 'Actualizaci_n_de_CURP__c:CURP Duplicado,';
        camposRequeridos += 'Type:CURP Duplicado,';
        camposRequeridos += 'Actualizaci_n_de_nombre__c:No,';
        camposRequeridos += 'Actualizar_domicilio__c:No';

        Test.startTest();
        
        CaseTriggerHelper.lstCasesMoveStatus = new Set<String>(); //se agregó para que salga del método de createCase
        Map<String, Object> crearCasoCURP = validateQuestionsController.createCaseClosedCurp(recordTypeId, acc1.Id, ctc.Id, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos );
        
        Test.stopTest();

        System.assertEquals( crearCasoCURP.get('success'), true);
    }

    @isTest 
    static void getUserProfile(){
        String userProfile = validateQuestionsController.getUserProfile();
        System.assertEquals('System Administrator', userProfile);
    }

}