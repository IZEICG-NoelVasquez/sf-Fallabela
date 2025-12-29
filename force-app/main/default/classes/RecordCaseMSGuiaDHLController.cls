/**
* Nombre: RecordCaseMSGuiaDHLController
* Autor: Mauricio Rosales
* Descripcion: Controlador del Componente Lightning RecordCaseMSGuiaDHL
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           24/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class RecordCaseMSGuiaDHLController {
    
    /**
    * Obtiene la informacion del Caso
    * @return regresa una variable de exito y el registro del caso
    *
    * @param recordId: id del registro de Casos
    **/
    @AuraEnabled
    public static Map<String,Object> getCaseRecordInfo(String recordId) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        List<Case> lstCaseRecord = [SELECT AccountId, Account.CURP__c, Estatus__c FROM Case WHERE Id = : recordId];

        if( lstCaseRecord.size() > 0 ) {

            mapResult.put('caseRecord', lstCaseRecord[0]);

            success = true;
        }

        mapResult.put('success', success);
        
        return mapResult;
    }
}