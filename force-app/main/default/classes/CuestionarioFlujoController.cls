public class CuestionarioFlujoController {
    @AuraEnabled
    public static String getRecordType(String cuestionarioId){
        Cuestionario__C cuest = [Select Id,RecordType.Name From Cuestionario__c Where Id=:cuestionarioId LIMIT 1];
        return cuest.RecordType.Name; 
    }
    @AuraEnabled
    public static String getSucursalRecord(String cuestionarioId){
       Cuestionario__C cuest = [Select Id,Sucursal__c From Cuestionario__c Where Id=:cuestionarioId LIMIT 1];
        return cuest.Sucursal__c; 
    }
    @AuraEnabled
    public static String getStatus(String cuestionarioId){
       Cuestionario__C cuest = [Select Id,Status__c From Cuestionario__c Where Id=:cuestionarioId LIMIT 1];
        return cuest.Status__c; 
    }
    @AuraEnabled
    public static String getArrayImage(String CuestionarioId){
        Cuestionario__C cuest = [Select Id,MapUploadImage__c From Cuestionario__c Where Id=:CuestionarioId LIMIT 1];
        return cuest.MapUploadImage__c;
    }
    @AuraEnabled
    public static Boolean getValidadoOTP(String CuestionarioId){
        Cuestionario__C cuest = [Select Id,OTP_Validado__c From Cuestionario__c Where Id=:CuestionarioId LIMIT 1];
        return cuest.OTP_Validado__c;
    }
    @AuraEnabled
    public static String getPhoneSucursal(String sucursal){
        System.debug('sucursal '+sucursal);
        Sucursal__mdt suc = [Select MasterLabel, DeveloperName,Telefono__c
                                       From Sucursal__mdt
                                       Where MasterLabel =: sucursal LIMIT 1];
         System.debug('suc '+suc);
        return suc.Telefono__c;   
    }
    @AuraEnabled
    public static void send_notification(string tipo,string inicio,string mensaje,string numeroTelefono,string codigoArea) {
        Cadena__mdt cad = [SELECT Cadena__c
                           FROM Cadena__mdt 
                           WHERE MasterLabel =: 'CodigoArea' 
                           LIMIT 1];
        if(codigoarea.length() >3){ codigoarea = codigoarea.right(3);}
        if(codigoarea == '152'){codigoarea = '521';}
        if(cad.Cadena__c != null){codigoarea = cad.Cadena__c + codigoarea;}
        //Mapa que almacena el resultado de la consulta al microservicio
        Map<String, Object> result = new Map<String, Object>();
        //colocamos por default success en false
        Boolean success = false;
        //Mapa que almacena los paramentros de la invocación al microservicio
        Map<String, String> params = new Map<String, String>();
        params.put('tipo', tipo); 
        params.put('inicio', inicio);   
        params.put('mensaje', mensaje); 
        params.put('numeroTelefono', numeroTelefono); 
        params.put('codigoArea', codigoArea);      
        System.debug('Consulta tipo: ' + tipo);
        System.debug('Consulta inicio: ' + inicio);
        System.debug('Consulta mensaje: ' + mensaje);
        System.debug('Consulta numeroTelefono: ' + numeroTelefono);
        System.debug('Consulta codigoArea: ' + codigoArea);
        //Invocamos al microservicio
        MicroServicioSendNotification SendNotification = new MicroServicioSendNotification();
        System.debug('SendNotification: ' + SendNotification);
        //Llamamos a la clase JSON para enviarle los parametros
        SendNotificationJSON resultSendNotification = SendNotification.getSendNotification(params);
        System.debug('resultSendNotification: ' + resultSendNotification);
        //Si la respuesta no es nula colocamos success en true
        if(resultSendNotification != null) { success = true;}
        //Llemamos el mapa de la respuesta con el valor de success y la resputa en formato JSON
        System.debug('Consultar Send Notification Success: ' + success);
        result.put('success', success);
        result.put('resultSendNotification', resultSendNotification);
        //Retornamos el mapa result
        //return resultado; 
    }
}