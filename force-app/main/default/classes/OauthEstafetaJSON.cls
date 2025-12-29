/**
* Nombre: OauthEstafetaJSON
* Autor: Mauricio Rosales
* Descripcion: Clase Apex para el parseo de la respuesta del Web Service Oauth de Estafeta
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           13/01/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class OauthEstafetaJSON {

    @AuraEnabled public String access_token;
    @AuraEnabled public String token_type;
    @AuraEnabled public Integer expires_in;
    @AuraEnabled public String scope;

    public static OauthEstafetaJSON parse(String json) {

        return (OauthEstafetaJSON) System.JSON.deserialize(json, OauthEstafetaJSON.class);
    }
}