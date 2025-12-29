/**
* Nombre: PickListCaseOriginControllerTest
* Autor: Mauricio Rosales
* Descripcion: Clase controladora del Componente Lightning PickListCaseOrigin
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           30/03/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class PickListCaseOriginController {

    /*
    * Obtiene el nombre del perfil del usuario actual
    * Regresa un Mapa con una variable booleana de exito, y la informacion del Perfil
    */
    @AuraEnabled
    public static Map<String, Object> getUserInfo() {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        List<User> lstUsers = [SELECT Profile.Name FROM User WHERE Id =: userinfo.getUserId()];

        if( lstUsers.size() > 0 ) {

            mapResult.put('userProfile', lstUsers[0].Profile.Name);

            success = true;
        }

        mapResult.put('success', success);
        
        return mapResult;
    }


    /*
    * Obtiene la lista de valores del campo Origin del objeto Case
    * Regresa un Mapa con los valores activos del campo Origin
    */
    @AuraEnabled
    public static Map<String, String> getContactMethod() {

        Map<String, String> mapResult = new Map<String, String>();

        ///
        Schema.DescribeFieldResult contactMethod = Case.Origin.getDescribe();

        for(Schema.PicklistEntry ple : contactMethod.getPicklistValues() ) {

            if( ple.isActive() ) {

                mapResult.put( ple.getLabel(), ple.getValue());
            }
        }

        return mapResult;
    }
}