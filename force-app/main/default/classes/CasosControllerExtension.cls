/**
* Nombre: CasosControllerExtension
* Autor
* Descripcion: Clase controladora del Componente Lightning CasosVisualizarCasosCmp
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           18/11/2020      Mauricio Rosales            Ajustes para el flujo BackOffice Fraudes
* 3.0           11/11/2021      Mauricio Rosales            Se agrega campo en la funcion obtenerCasos() y se regresa el nombre del perfil
* 4.0           10/12/2021      Mauricio Rosales            Condicion para excluir casos de la bandeja Credito-Fraudes
* --------------------------------------------------------------------------
*/public with sharing class CasosControllerExtension {
    
    public static String ST_AUTORIZADA = 'Autorización';
    public static String ST_NUEVO = 'New';
    public static String ST_ASIGNADA = 'Asignada';
    public static String ST_CERRADO = 'Cerrado';
    public static String RT_RIESGOS = 'Riesgos_Originaci_n';
    public static String RT_FIGITAL = 'BackOffice_Figital';
    public static String QUEUE_CREDITO_FRAUDES = 'BackOffice Credito/Fraudes';

    /*
    * Obtiene el nombre del perfil del usuario actual
    */
    @AuraEnabled
    public static String getProfileName(){

        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: profileId].Name;

        return profileName;
    }

    /**
    * Regresa la lista de Casos para los RecordType de BackOffice Credito o BackOffice Fraudes 
    * Dependiendo del perfil del usuario actual
    *
    **/
    @AuraEnabled
    public static Map<String,Object> obtenerCasos() {

        Map<String,Object> mapResult = new Map<String,Object>();

        String profileName = getProfileName();

        String idRecordTypeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_RIESGOS).getRecordTypeId();
        String idRecordTypeFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_FIGITAL).getRecordTypeId();

        List<Case> listaCasos = [SELECT Id, CaseNumber, ID_Solicitud__c, Nombre_s__c, Primer_Apellido__c, Segundo_Apellido__c,
                                CreatedDate,Status, Tiempo_en_Proceso__c, OwnerId, Owner.Name, Fecha_y_hora_de_solicitud_en_an_lisis__c,
                                Tiempo_en_An_lisis__c, Solicitud_Repetida__c, Solicitud_de_cancelaci_n__c, C_digo_Postal_Direcci_n_Otros__c, 
                                Validar_Movimientos__c, Publicidad__c, Bloqueo_de_Tarjeta_por_Cancelaci_n__c, Canal_origen__c, 
                                Fecha_y_hora_de_solicitud_en_Nuevo__c
                                FROM Case WHERE (Status =: ST_AUTORIZADA OR Status =: ST_NUEVO OR Status =: ST_ASIGNADA)
                                AND (RecordTypeId =: idRecordTypeCredito OR RecordTypeId =: idRecordTypeFigital) AND Owner.Name != : QUEUE_CREDITO_FRAUDES 
                                ORDER BY RecordType.DeveloperName DESC, Fecha_y_hora_de_solicitud_en_Nuevo__c DESC];

        /// Custom Metadata
        List<Semaforo_Riesgos_Inicio__mdt> lstSemaforoRiesgos = [SELECT MasterLabel, Canal_Origen__c, Segundos__c, Semaforo__c FROM Semaforo_Riesgos_Inicio__mdt];
    
        mapResult.put('listaCasos', listaCasos);
        mapResult.put('profileName', profileName);
        mapResult.put('lstSemaforoRiesgos', lstSemaforoRiesgos);

        return mapResult;
    }

    /**
    * Regresa la lista de Casos del dia actual para los RecordType de BackOffice Credito o BackOffice Fraudes 
    * Dependiendo del perfil del usuario actual
    *
    **/
    @AuraEnabled
    public static Integer obtenerCasosToday(){

        String idRecordTypeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_RIESGOS).getRecordTypeId();
        String idRecordTypeFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_FIGITAL).getRecordTypeId();

        Integer total = [SELECT COUNT() FROM Case WHERE (Status =: ST_AUTORIZADA OR Status =: ST_NUEVO OR Status =: ST_ASIGNADA OR Status =: ST_CERRADO) AND CreatedDate = TODAY AND (RecordTypeId =: idRecordTypeCredito OR RecordTypeId =: idRecordTypeFigital)];

        return total;
    }

    /**
    * Regresa la lista de Casos cerrados para los RecordType de BackOffice Credito o BackOffice Fraudes 
    * Dependiendo del perfil del usuario actual
    *
    **/
    @AuraEnabled
    public static List<Case> obtenerCasosCerrados(){

        String idRecordTypeCredito = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_RIESGOS).getRecordTypeId();
        String idRecordTypeFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(RT_FIGITAL).getRecordTypeId();

        List<Case> listaCasosCerrados = [SELECT Id, CreatedDate,ClosedDate FROM Case WHERE Status =: ST_CERRADO AND CreatedDate = TODAY AND (RecordTypeId =: idRecordTypeCredito OR RecordTypeId =: idRecordTypeFigital)];

        return listaCasosCerrados;
    }
}