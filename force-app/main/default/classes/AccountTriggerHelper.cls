/**
* Nombre: AccountTriggerHelper
* Autor: Mauricio Rosales
* Descripcion: Clase Helper de la clase AccountTriggerHandler
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           05/11/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class AccountTriggerHelper {
    
    public static Boolean validateEmboce(Account accNew) {

        Boolean blnEmboce = false;

        if( accNew.Emboce_Centralizado__c == Constants.EMBOCE_CENTRALIZADO_VALOR_CREACION_DE_CASOS && !accNew.Caso_Emboce_Creado__c ) {

            blnEmboce = true;
        }

        return blnEmboce;
    }
}