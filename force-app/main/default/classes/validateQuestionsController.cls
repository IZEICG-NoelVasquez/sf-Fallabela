/************************************************************************************************
Apex Class Name	:	validateQuestionsController 
Version			:	1.0
Created Date    :	02/08/2019 13:21
Function 		: 	Controller del compoente validateQuestions
Test Class		:	validateQuestionsController_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     02/08/2019 	   Original Version
* Mauricio Rosales   18/Dic/2020       Ajustes rango de dias en Metadata
*************************************************************************************************/
public class validateQuestionsController {

    /**
    *Método para obtener el número de validaciones Incorrectas Permitidas por día
    *
    * @param tipoDeIntento: Nombre del Custom Metadata Numero de Intentos
    * @param rangoDiasVencimiento: Nombre del Custom Metadata Rango de dias para fecha de vencimiento
    * @param rangoDiasUltimoPago: Nombre del Custom Metadata Rango de dias para fecha ultimo dia de pago
    */
    @AuraEnabled
    public static Map<String, Integer> getValidateQuestionsTry(String tipoDeIntento, String rangoDiasVencimiento, String rangoDiasUltimoPago) {

        ///
        Map<String, Integer> mapResult = new Map<String, Integer>();

        List<String> listRegistros = new List<String>{ tipoDeIntento, rangoDiasVencimiento, rangoDiasUltimoPago};

        List<Intentos_de_Validacion__mdt> intentos =  [SELECT Intentos__c, MasterLabel
                                                        FROM Intentos_de_Validacion__mdt 
                                                        WHERE MasterLabel IN : listRegistros ];

        ///
        for(Intentos_de_Validacion__mdt intVal: intentos) {

            if( intVal.MasterLabel == tipoDeIntento ) {

                mapResult.put(tipoDeIntento, intVal.Intentos__c.intValue());

            } else if( intVal.MasterLabel == rangoDiasVencimiento ) {

                mapResult.put(rangoDiasVencimiento, intVal.Intentos__c.intValue());

            } else if( intVal.MasterLabel == rangoDiasUltimoPago ) {

                mapResult.put(rangoDiasUltimoPago, intVal.Intentos__c.intValue());

            }
        }

        return mapResult;
    }
    //Método para obtener el número de validaciones Incorrectas del día del cliente
    @AuraEnabled
    public static integer getValidationToday(String customerId){
        List<Validacion_Incorrecta__c> VIList = new List<Validacion_Incorrecta__c>();
        try {
            VIList = [Select Id
                      From Validacion_Incorrecta__c
                      Where Account__c=:customerId AND
                      Validacion_Exitosa__c = false AND
                      Creado_Hoy__c = true];
        } catch (Exception e){
        }
        Integer numeroDeValidacionesIncorrectas = VIList.size();
        return numeroDeValidacionesIncorrectas;     
    }
    //Método para obtener el número de casos del cliente
    @AuraEnabled
    public static integer casosDelCliente(String customerId){
        List<Case> casos = new List<Case>();
        try {
            casos = [Select Id
                      From Case
                      Where AccountId=:customerId];
        } catch (Exception e){
        }
        Integer numeroDeCasos = casos.size();
        return numeroDeCasos;     
    }
    //Método para obtener el número de casos abiertos del cliente
    @AuraEnabled
    public static integer casosAbiertosDelCliente(String customerId){
        List<Case> casosAbiertos = new List<Case>();
        try {
            casosAbiertos = [Select Id
                      From Case
                      Where AccountId=:customerId AND
                      Status != 'Cancelado' AND
                      Status != 'Cerrado'];
        } catch (Exception e){
        }
        Integer numeroDeCasosAbiertos = casosAbiertos.size();
        return numeroDeCasosAbiertos;     
    }
    //Método para obtener la tarjeta del cliente, a partir deL Id de la cuenta y el número de tarjeta
    @AuraEnabled
    public static Tarjeta__c getCardData (String numeroDeTarjeta,String customerId) {
        System.debug('numeroDeTarjeta '+numeroDeTarjeta);
        System.debug('customerId '+customerId);
        Tarjeta__c Tarjeta = [Select Id, D_a_Fecha_de_corte__c, Donde_pag_su_tarjeta__c, Cuando_realiz_el_pago_de_tarjeta__c, Compra_diferida__c 
                                         From Tarjeta__c
                                         Where N_mero_de_tarjeta__c =: numeroDeTarjeta AND 
                                               Account__c =: customerId LIMIT 1];
        System.debug('numeroDeTarjeta '+numeroDeTarjeta);
   
        return Tarjeta;    
    }
    //Método que crea un registro de Validación de Pregunta, 
    //seteando los campos de las respuestas del usuario
    @AuraEnabled
    public static Validacion_Incorrecta__c createValidacionIncorrecta(String numeroDeTarjeta, 
    String customerId, String DiaDeCorte, String UltimoPago, String DiaUltimoPago, 
    String CompraDiferida, Boolean exitosa, Integer coincidencias,
    String tieneCasosAbiertos, String tieneCasosAbiertosAns, String idCaso){
        //obtenemos primero los datos de la tarjeta a partir del número de tarjeta y del Id de la cuenta
        Tarjeta__c Tarjeta = [Select Id, D_a_Fecha_de_corte__c, Donde_pag_su_tarjeta__c, Cuando_realiz_el_pago_de_tarjeta__c, Compra_diferida__c 
                                         From Tarjeta__c
                                         Where N_mero_de_tarjeta__c =: numeroDeTarjeta AND 
                                               Account__c =: customerId LIMIT 1];
        Account cuenta = [Select Id From Account Where Id =:  customerId LIMIT 1];
        //Creamos el registro de Validación de Preguntas con los campos de las respuestas
        //Y la consulta a los datos de la tarjeta del cliente
        Validacion_Incorrecta__c VI = new Validacion_Incorrecta__c();
        VI.Tarjeta__c = Tarjeta.Id;
        VI.Account__c = cuenta.Id;
        VI.Fecha_de_Corte_Real__c = Tarjeta.D_a_Fecha_de_corte__c;
        VI.Donde_pago_su_Tarjeta_Real__c = Tarjeta.Donde_pag_su_tarjeta__c;
        VI.Dia_de_Ultimo_Pago_Real__c = Tarjeta.Cuando_realiz_el_pago_de_tarjeta__c;
        VI.Compra_Diferida_Real__c = Tarjeta.Compra_diferida__c;
        VI.Fecha_de_Corte_Respuesta__c = DiaDeCorte;
        VI.Donde_pago_su_Tarjeta_Respuesta__c = UltimoPago;
        VI.Dia_de_Ultimo_Pago_Respuesta__c = DiaUltimoPago;
        VI.Compra_Diferida_Respuesta__c = CompraDiferida;
        VI.Validacion_Exitosa__c = exitosa;
        VI.Coincidencias__c = coincidencias;
        VI.Casos_Abiertos_Real__c = tieneCasosAbiertosAns;
        VI.Casos_Abiertos_Respuesta__c = tieneCasosAbiertos;
        VI.Caso__c = exitosa ? null : (idCaso != '' ? idcaso : null);
        insert VI;
        return VI;
    }
    @AuraEnabled
    public static Map<String, Object> createCaseClosedCurp (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {
        Map<String, Object> result = new Map<String, Object>();
        CreateCase casoCurp = new CreateCase();
        result = casoCurp.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
        return result;
    }

    @AuraEnabled
    public static string getUserProfile(){
        Profile UserProfile;
        try {
            Id profileId = UserInfo.getProfileId();
            UserProfile = [SELECT Name FROM Profile WHERE Id = :profileId LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error al obtener el perfil del usuario: ' + e.getMessage());
        }
        return UserProfile.Name;
    }
}