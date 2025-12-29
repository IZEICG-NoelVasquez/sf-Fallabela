public class CuestionarioController {
       
    private Cuestionario__c req {get;set;} 
    
    public CuestionarioController(ApexPages.StandardController stdController)
    {
        this.req = (Cuestionario__c)stdController.getRecord();
        
    }      
    public PageReference cancelCuestionario() 
    {
        PageReference pageRef = new PageReference('/apex/CCScommenuVF');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference guardarCuestionario() 
    {      
        
        Id cuestionarioId = ApexPages.CurrentPage (). Getparameters (). Get ('cuestionarioId');
        //req.RecordTypeId=Schema.SObjectType.Cuestionario__c.getRecordTypeInfosByName().get('Solicitud').getRecordTypeId();
        //Asignamos el valor del Id del proyecto que obtuvimos del URL al campo Proyecto__c.
        //req.Proyecto__c=proyectoId;
        insert req;     
        PageReference pageRef = new PageReference('/apex/Cuestionario_view');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('Id', req.id);
        return pageRef;
    }
    
    
    
}