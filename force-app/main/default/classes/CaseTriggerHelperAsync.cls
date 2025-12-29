/**
* Nombre: CaseTriggerHelperAsync
* Autor: ---
* Descripcion: Clase Asincrona de la Clase CaseTriggerHelper
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ----                    Creación
* 2.0           09/09/2021      Mauricio Rosales        Validacion dinamica Motivos de Retencion
* --------------------------------------------------------------------------
*/
public class CaseTriggerHelperAsync {

    // Metodo Asincrono para crear Casos con status Cerrado
    @future(callout=true)
    public static void cierraCasosAsync(List<Id> listIdCasosUpdate) {  
        
        try {

            if( !listIdCasosUpdate.isEmpty() ) {

                List<Case> listCaseToUpdate = [SELECT Status, RecordTypeId, Solicitud_de_cancelaci_n__c FROM Case WHERE Id IN : listIdCasosUpdate];

                for(Case casoUpdate: listCaseToUpdate) {

                    if ( casoUpdate.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId()) ) {

                        if( casoUpdate.Solicitud_de_cancelaci_n__c ) {
            
                            casoUpdate.Solicitud_de_cancelaci_n__c = false;
                            casoUpdate.Status = 'Cerrado';

                            ///
                            if( CaseTriggerHelper.lstCasesMoveStatus == null ) {

                                CaseTriggerHelper.lstCasesMoveStatus = new Set<String>();
                            }
                            
                            CaseTriggerHelper.lstCasesMoveStatus.add(casoUpdate.Id);
                        }
                    }
                }

                if( listCaseToUpdate.size() > 0 ) {

                    update listCaseToUpdate;
                }
            }            
        } catch(Exception ex) {

            System.debug('ERROR en la actualizacion de Casos Asincrona:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }        
    }
}