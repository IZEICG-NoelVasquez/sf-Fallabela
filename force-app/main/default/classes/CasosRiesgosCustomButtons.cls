/**
* Nombre: CasosRiesgosCustomButtons
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning CasosRiesgosCustomButtons
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           15/03/2022      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public  class CasosRiesgosCustomButtons {
    
    /*
    * Obtiene el registro del Caso
    * Regresa un Mapa con la informacion del caso y una variable booleana de exito
    *
    * @param recordId: id del registro de Casos
    */
    @AuraEnabled
    public static Map<String,Object> getCaseInfo(String recordId) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        List<Case> lstCase = [SELECT Solicitud_de_cancelaci_n__c, 
                                    Comentarios__c, 
                                    C_digo_Postal_Direcci_n_Otros__c  
                                FROM Case WHERE Id =: recordId AND Solicitud_de_cancelaci_n__c = true ];

        if( lstCase.size() > 0 ) {

            mapResult.put('caseInfo', lstCase[0]);

            success = true;
        }

        mapResult.put('success', success);

        return mapResult;
    }
}