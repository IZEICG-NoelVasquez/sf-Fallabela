/**
* Nombre: CreateCase
* Autor
* Descripcion: Clase helper para la creacion y actualizacion de casos desde los componentes del Autenticador
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           01/06/2021      Mauricio Rosales            Metodos para crear casos abiertos y cerrar casos.
* 3.0           22/07/2021      Mauricio Rosales            Validacion de saltos de etapa en el trigger
* 4.0           04/08/2021      Mauricio Rosales            Bloqueo de tarjetas desde un registro de Casos
* 5.0           01/11/2021      Mauricio Rosales            Se regresa el error en el metodo updateCaseByRT
* 6.0           07/12/2021      Mauricio Rosales            Try Catch para regresar las DmlException al componente
* --------------------------------------------------------------------------
*/
public class CreateCase {
    
    /**
    * Metodo para crear casos, actualizar el Status y cerrar el caso
    * Regresa un mapa con una variable de exito, el Folio del caso, el Id del caso y el Id de la Cuenta
    *
    * @param recordTypeId: Id del RecordType
    * @param customerId: Id de la Cuenta
    * @param personId: Id del Contacto
    * @param category: Categoria del Caso
    * @param altoRiesgo: variable boleana del Alto Riesgo del Caso
    * @param metodoContactoValue: Metodo de Contacto del Caso
    * @param numeroDeTarjetaValue: Numero de Tarjeta del Caso
    * @param camposRequeridos: Campos requeridos para cerrar el Caso
    **/
    public Map<String, Object> createCaseClosedByRT (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Case newCase = new Case();
        
        try {
            
            newCase.RecordTypeId = recordTypeId;
            newCase.AccountId = customerId;
            newCase.ContactId = personId;
            newCase.Categor_a__c = category;
            newCase.Riesgo__c = altoRiesgo ? 'Alto' : 'Bajo';
            newCase.Origin = String.isNotBlank(metodoContactoValue) ? metodoContactoValue : 'Contact Center';
            newCase.TarjetaCaso__c = String.isNotBlank(numeroDeTarjetaValue) ? numeroDeTarjetaValue : '';
            
            insert newCase;    
            
            String strSOQL = 'SELECT CaseNumber, Status, AccountId';
            List<String> listCamposReq = camposRequeridos.split(',');
            List<String> listTemp; 
            
            for(String str: listCamposReq) {
                
                listTemp = new List<String>();
                listTemp = str.split(':');
                strSOQL += ', ' + listTemp[0];
            }
            strSOQL += ' FROM Case ';
            strSOQL += 'WHERE Id = \'' + newCase.Id + '\' LIMIT 1';
            
            Case updateCase = Database.query(strSOQL);
            
            for(String str: listCamposReq) {      
                
                listTemp = new List<String>();
                listTemp = str.split(':');
                
                if( listTemp[1] == 'true' ) {
                    
                    updateCase.put(listTemp[0], true);
                    
                } else if( listTemp[1] == 'false' ) {
                    
                    updateCase.put(listTemp[0], false);
                    
                } else {
                    
                    updateCase.put(listTemp[0], listTemp[1]);
                }
            }
            
            update updateCase;
            
            /// Se agrega el Id del Caso para permitir los saltos de etapa en el trigger
            CaseTriggerHelper.lstCasesMoveStatus.add(updateCase.Id);
            
            updateCase.Status = 'Informar folio y despedida';
            
            update updateCase;
            if(camposRequeridos.contains('Type:CURP Duplicado')){
                
                /// Se completan Milestones de etapas anteriores para Casos creados en etapa Normalizacón
                List<CaseMilestone> lstMilestones = [SELECT CompletionDate, MilestoneType.Name FROM CaseMilestone WHERE CaseId =: newCase.Id AND CompletionDate = null ];
                
                for(CaseMilestone cmMile: lstMilestones) {
                    
                    if(cmMile.MilestoneType.Name != 'Normalización') {
                        
                        cmMile.CompletionDate = Datetime.now();
                    }
                }
                update lstMilestones;
                Group aclaracionesCorto = [select Id from Group where  Type = 'Queue' AND DeveloperNAME = 'Aclaraciones_Corto' LIMIT 1];
                updateCase.Status = 'Normalización';
                updateCase.OwnerId = aclaracionesCorto.Id;
                
            } else {
                
                updateCase.Status = 'Cerrado';
                
            }
            
            update updateCase;
            
            success = true;
            
            result.put('folioCaso', updateCase.CaseNumber);
            result.put('account', updateCase.AccountId);
            result.put('caseId', newCase.Id);
            
        } catch (Exception ex) {
            
            System.debug('ERROR: ' + ex.getMessage() + '  Linea: ' + ex.getLineNumber() );
            
            result.put('folioCaso', '');
            result.put('account', '');
            result.put('caseId', '');
        }
        
        result.put('success', success);
        
        return result;
    }
    
    /**
    * Metodo para crear casos abiertos
    * Regresa un mapa con una variable de exito, el Folio del caso y el Id
    *
    * @param recordTypeId: Id del RecordType
    * @param customerId: Id de la Cuenta
    * @param personId: Id del Contacto
    * @param category: Categoria del Caso
    * @param altoRiesgo: variable boleana del Alto Riesgo del Caso
    * @param metodoContactoValue: Metodo de Contacto del Caso
    * @param numeroDeTarjetaValue: Numero de Tarjeta del Caso
    **/
    public static Map<String, Object> createCaseOpenByRT(String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Case newCase = new Case();
        
        try {            
            
            newCase.RecordTypeId = recordTypeId;
            newCase.AccountId = customerId;
            newCase.ContactId = personId;
            newCase.Categor_a__c = category;
            newCase.Riesgo__c = altoRiesgo ? 'Alto' : 'Bajo';
            newCase.Origin = String.isNotBlank(metodoContactoValue) ? metodoContactoValue : 'Contact Center';
            newCase.TarjetaCaso__c = String.isNotBlank(numeroDeTarjetaValue) ? numeroDeTarjetaValue : '';
            
            insert newCase;
            
            List<Case> lstCases = [SELECT CaseNumber FROM Case WHERE Id =: newCase.Id LIMIT 1];
            
            if( lstCases.size() > 0 ) {
                
                success = true;
                
                result.put('caseNumber', lstCases[0].CaseNumber);
                result.put('caseId', newCase.Id);
            }           
            
        } catch(Exception ex) {
            
            System.debug('ERROR: ' + ex.getMessage() + '  Linea: ' + ex.getLineNumber() );
            
            result.put('caseNumber', null);
            result.put('caseId', null);
        }       
        
        result.put('success', success);
        
        return result;
    }
    
    /**
    * Metodo para cerrar casos 
    * Regresa un mapa con una variable de exito
    *
    * @param newCaseId: Id del Registro del Caso
    * @param mapRequiredFields: Mapa con los campos Requeridos (Nombre de API, Valor del campo)
    **/
    public static Map<String, Object> closeCaseByRT(String newCaseId, Map<String, Object> mapRequiredFields){
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        try {
            
            Case caseUpdate = updateCase(newCaseId, mapRequiredFields);
            
            /// Se agrega el Id del Caso para permitir los saltos de etapa en el trigger
            CaseTriggerHelper.lstCasesMoveStatus.add(caseUpdate.Id);
            
            caseUpdate.Status = 'Informar folio y despedida';
            
            update caseUpdate;
            
            caseUpdate.Status = 'Cerrado';
            
            update caseUpdate;
            
            success = true;
            
            
        } catch(Exception ex) {
            
            System.debug('ERROR: ' + ex.getMessage() + '  Linea: ' + ex.getLineNumber() );
        }
        
        result.put('success', success);
        
        return result;
    }
    
    /**
    * Metodo para actualizar el caso
    * Regresa un mapa con una variable de exito
    *
    * @param caseId: Id del Registro del Caso
    * @param mapRequiredFields: Mapa con los campos del Caso (Nombre de API, Valor del campo)
    **/
    public static Map<String, Object> updateCaseByRT(String caseId, Map<String, Object> mapFields) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        String error = '';
        
        try {
            
            Case caseUpdate = updateCase(caseId, mapFields);
            
            success = true;
            
        } catch(DmlException exDml) {
            
            String msg = '';
            
            for (Integer i = 0; i < exDml.getNumDml(); i++) {
                
                msg =+ exDml.getDmlMessage(i) +  '\n';
            }
            
            throw new AuraHandledException(msg);
            
        } catch(Exception ex) {
            
            System.debug('ERROR: ' + ex.getMessage() + '  Linea: ' + ex.getLineNumber() );
            
            error = ex.getMessage();            
            
            throw new AuraHandledException(ex.getMessage());
        }
        
        result.put('success', success);
        result.put('error', error);
        
        return result;
    }
    
    /**
    * Metodo para obtener los campos requeridos y actualizar el Caso
    * Regresa el registro del Caso
    *
    * @param caseId: Id del Registro del Caso
    * @param mapFields: Mapa con los campos del Caso (Nombre de API, Valor del campo)
    **/
    public static Case updateCase(String caseId, Map<String, Object> mapFields) {
        
        String strQuery = 'SELECT Status ';
        
        if( !mapFields.isEmpty() ) {
            
            for(String strField: mapFields.keySet() ) {
                
                strQuery += ', ' + strField;
            }
        }
        
        strQuery += ' FROM Case WHERE Id = \'' + caseId + '\' LIMIT 1';
        
        Case caseUpdate = Database.query(strQuery);
        
        ///
        if( !mapFields.isEmpty() ) {
            
            for(String strField: mapFields.keySet() ) {
                
                caseUpdate.put(strField, mapFields.get(strField));
            }
        }
        
        update caseUpdate;
        
        return caseUpdate;
    } 
}