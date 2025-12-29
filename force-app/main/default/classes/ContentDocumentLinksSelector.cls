/**
* Nombre: ContentDocumentLinksSelector
* Autor: Mauricio Rosales
* Descripcion: Clase Selector del Objeto ContentDocumentLink
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           26/01/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class ContentDocumentLinksSelector {    

    /**
    * SOQL para obtener la lista de registros de ContentDocumentLink relacionados por el campo LinkedEntityId
    * @return Regresa una lista de ContentDocumentLink
    *
    * @param recordIds: Lista de registros relacionados al ContentDocumentLink
    **/
    public static List<ContentDocumentLink> selectByListLinkedEntityId(List<String> recordIds) {

        List<ContentDocumentLink> lstContentDocLink = [SELECT LinkedEntityId, ContentDocument.FileExtension, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN : recordIds];

        return lstContentDocLink;
    }
}