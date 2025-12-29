/**
* Nombre: AuthenticateCampaniasController
* Autor
* Descripcion: Clase controladora del Componente Lightning AuthenticateCampanias 
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           10/02/2021      Mauricio Rosales            Validaciones OTP Dinamicas
* --------------------------------------------------------------------------
*/
public class AuthenticateCampaniasController {

    /**
    * Obtiene la lista de Campanias Activas para el id del Cliente
    * Regresa la lista de Campanias
    *
    * @param personId: id de PersonAccount que se Ingreso en el Autenticador de Call Center
    **/
    @AuraEnabled
    public static List<CampaignMember> obtenerCampaignsCliente (String personId) {

        Limites__mdt maxCampaign = [SELECT Limite__c FROM Limites__mdt 
                                   Where DeveloperName =: 'Maximo_Numero_de_Campanias'
                                   LIMIT 1];
        Integer limitCampaign = maxCampaign.Limite__c.intValue();
        List<CampaignMember> result = [SELECT Campaign.Name, Campaign.Id, Campaign.StartDate, Campaign.EndDate, Campaign.Description, Status, Campaign.Tipo_Campa_a__c
                                        FROM CampaignMember 
                                        WHERE LeadOrContactId =: personId
                                        AND Campaign.IsActive = true
                                        AND Campaign.StartDate <=: Date.today()
                                        AND Campaign.EndDate >=: Date.today()
                                       	ORDER BY Campaign.Prioridad__c ASC
                                        LIMIT :limitCampaign];
        
        return result;
    }

    /**
    * Obtiene los nombres de las Campanias Activas para email y sms, que se tienen configurados en el Custom Metadata Configuracion Aumento de Linea
    * Regresa los nombres de las campanias en un Mapa
    *
    **/
    @AuraEnabled
    public static Map<String, String> configuracionAumentoDeLinea() {

        Map<String, String> result = new Map<String, String>();

        Configuracion_Aumento_de_Linea__mdt aumentoDeLinea = [SELECT Campania_Email__c, Campania_SMS__c FROM Configuracion_Aumento_de_Linea__mdt WHERE DeveloperName =: 'Aumento_de_Linea' LIMIT 1 ];

        String email = aumentoDeLinea.Campania_Email__c;
        String sms = aumentoDeLinea.Campania_SMS__c;

        System.debug('Campaña Email:  ' + email);
        System.debug('Campaña SMS:  ' + sms);

        result.put('email', email);
        result.put('sms', sms); 

        return result;
    }
}