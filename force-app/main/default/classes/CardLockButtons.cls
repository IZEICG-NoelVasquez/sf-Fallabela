/**
* Nombre: CardLockButtons
* Autor: Mauricio Rosales
* Descripcion: Clase Apex del componente CardLockButtons
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           27/07/2021      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class CardLockButtons {

    /**
    * Metodo para obtener el registro del Caso, validar si existe el metada para el tipo de registro y 
    * y validar si la tarjeta ya fue bloqueada
    * Regresa un mapa con una variable de exito, el registro del caso, el custom metadata de Bloqueo de tarjeta y 
    * una variable booleana del bloqueo de la tarjeta
    *
    * @param recordId: Id del registro del Caso
    **/
    @AuraEnabled
    public static Map<String,Object> getCaseInfo(String recordId) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        List<Case> lstCases = [SELECT CURPcontacto__c, 
                                    TarjetaCaso__c, 
                                    Subcategor_a_Texto__c 
                                FROM Case WHERE Id =: recordId];

        if( lstCases.size() > 0 ) {

            Bloqueo_de_Tarjeta__mdt cmCardLock = loadCardLockSubCategories(lstCases[0].Subcategor_a_Texto__c);

            if( cmCardLock != null ) {

                ///
                String fieldLockedCard = '';

                if( (cmCardLock.Bloqueo_de_Tarjeta_Campos_Requeridos__r != null) && (cmCardLock.Bloqueo_de_Tarjeta_Campos_Requeridos__r.size() > 0) ) {

                    for(Bloqueo_de_Tarjeta_Campo_Requerido__mdt requiredField: cmCardLock.Bloqueo_de_Tarjeta_Campos_Requeridos__r ) {

                        if( requiredField.Tarjeta_bloqueada__c ) {

                            fieldLockedCard = requiredField.Nombre_de_API__c;

                            break;
                        }
                    }

                    ///
                    if( String.isNotBlank(fieldLockedCard) ) {

                        mapResult.put('cardLocked', cardLocked(fieldLockedCard, recordId) );
                    }                    
                }

                success = true;

                mapResult.put('cmCardLock', cmCardLock);

                mapResult.put('caseRecord', lstCases[0]);
            }
        }

        mapResult.put('success', success);

        return mapResult;
    }

    /**
    * Consulta al custom metadata Bloqueo_de_Tarjeta__mdt
    * Regresa un registro del custom metadata Bloqueo_de_Tarjeta__mdt
    *
    * @param subCategory: Sub categoria del Caso
    **/
    public static Bloqueo_de_Tarjeta__mdt loadCardLockSubCategories(String subCategory) {

        Bloqueo_de_Tarjeta__mdt cmCardLock = null;

        List<Bloqueo_de_Tarjeta__mdt> lstCMCardLock = [SELECT MasterLabel, 
                                                            Descripcion__c, 
                                                            Etiqueta_en_SF__c, 
                                                            SubCategoria__c, 
                                                            Categoria__c,
                                                            (SELECT Nombre_de_API__c, Valor_del_Campo__c, Tarjeta_bloqueada__c FROM Bloqueo_de_Tarjeta_Campos_Requeridos__r)
                                                    FROM Bloqueo_de_Tarjeta__mdt 
                                                    WHERE Pantalla_principal__c = false 
                                                        AND SubCategoria__c =: subCategory ];

        if( lstCMCardLock.size() > 0 ) {

            cmCardLock = lstCMCardLock[0];
        }

        return cmCardLock;
    }

    /**
    * Consulta al objeto de Casos paravalidar si la tarjeta ya fue bloqueada
    * Regresa una variable boolena de exito si la consulta es exitosa
    *
    * @param caseField: Campo para la consulta al objeto de Casos
    * @param recordId: Ide del registro de casos
    **/
    public static Boolean cardLocked(String caseField, String recordId) {

        Boolean result = false;

        try {

            String strQuery = 'SELECT Id FROM Case WHERE Id = \'' + recordId + '\' AND ' + caseField +  ' = true LIMIT 1';

            List<Case> lstCases = Database.query(strQuery);

            if( lstCases.size() > 0 ) {

                result = true;
            }

        } catch (Exception ex) {

            System.debug('Error: ' + ex.getMessage() + '  LINEA: ' + ex.getLineNumber() );
        }

        return result;
    }    

    /**
    * Llamado al MicroServicio Productos para obtener el Identificador de la Tarjeta
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param curp: curp del cliente
    **/
    @AuraEnabled
    public static Map<String,Object> getProducts(String curp) {

        return MicroServicioProductos.obtenerProductosCliente(curp);
    }

}