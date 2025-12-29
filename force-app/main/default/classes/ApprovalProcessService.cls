/**
* Nombre: ApprovalProcessService
* Autor: Mauricio Rosales
* Descripcion: Clase de Servicio para los Procesos de Aprobacion
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                     Descripción
* --------------------------------------------------------------------------
* 1.0           21/04/2022      Mauricio Rosales           Creación
* --------------------------------------------------------------------------
*/
public class ApprovalProcessService {
    
    public static void submitForApproval(String objectId, String processDefinitionNameOrId, Boolean skipEntryCriteria, String submitterId, String comments) {

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(objectId);
        req1.setProcessDefinitionNameOrId(processDefinitionNameOrId);
        req1.setSkipEntryCriteria(skipEntryCriteria);
        req1.setSubmitterId(submitterId);
        req1.setComments(comments);

        try {

            Approval.ProcessResult result = Approval.process(req1);

        } catch(Exception ex) {

            System.debug('Error ApprovalProcessService:  ' + ex.getMessage() );
        }
    }
}