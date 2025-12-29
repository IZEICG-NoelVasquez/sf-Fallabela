@RestResource(urlMapping='/portal/*/*')
global with sharing class ServicePortalCase  {

    private class Attach {
        String Body;
        String ContentType;
        String Name;
    }

    private class Caso {
        
        String Etapa;
        String Curp;
        String SubCategoria;

    }

    private class PortalCase {
        Caso caso;
        List<Attach> archivos;
    }

    //add service to return all Categorias and Subcategorias

    @HttpGet
    global static void show () {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String uri = req.requestURI;
        String folio = req.params.containsKey('folio') ? req.params.get('folio') : null;
        String subCategoria = req.params.containsKey('subCategoria') ? req.params.get('subCategoria') : null;        
        String fecha_inicio = req.params.containsKey('fecha_inicio') ? req.params.get('fecha_inicio') : null;
        String fecha_fin = req.params.containsKey('fecha_fin') ? req.params.get('fecha_fin') : null;
        String curpConsulta = req.params.containsKey('curp') ? req.params.get('curp') : null;
        String tipoConsulta = req.params.containsKey('tipo_consulta') ? req.params.get('tipo_consulta') : null;

        
        try {
            
            if ( uri.equals('/portal/case/') ) {
                
                // if closed, add reason closed
                
                if (String.isNotBlank(folio)) {
                    
                    List<Case> c = [SELECT Id, Subcategor_a_Texto__c, Categor_a__c, CaseNumber, Status, Account.Name, Fecha_estimada_de_cierre__c FROM Case WHERE CaseNumber =: folio LIMIT 1];
                    
                    if (!c.isEmpty()) {
                        res.responseBody = Blob.valueOf(JSON.serialize(c.get(0)));    
                    }    
                    
                } else if (String.isNotBlank(curpConsulta)) {
                    
                     Account acc = ServicePortalHelper.getAccountIdByCurp(curpConsulta);
                    
                    if (acc == null) {
                        
                        res.statusCode = 204;
                        return;
                    }
                    
                    Date dInicio = String.isBlank(fecha_inicio) ? Date.today().addYears(-1) : Date.valueOf(fecha_inicio);
                    Date dFin = String.isBlank(fecha_fin) ? Date.today() : Date.valueOf(fecha_fin);  
                    
                    if (dFin < dInicio) {
                        
                        dFin = dInicio.addYears(1);
                        
                    }
                                        
                    List<Case> c = [SELECT CaseNumber, Status, CreatedDate, Fecha_estimada_de_cierre__c, ClosedDate
                                    FROM Case WHERE CreatedDate >=: dInicio AND CreatedDate <=: dFin
                                   	AND ContactId =: acc.PersonContactId];
                    
                    if (!c.isEmpty()) {
                        
                        res.responseBody = Blob.valueOf(JSON.serialize(c));
                        
                    } 
                    
                } else {
                    res.statusCode = 204;
					return;
                }
                
            } else if (uri.equals('/portal/case/fields/') && String.isNotBlank(subCategoria)) {
                
                // change to mdt to have more info from the fields
                
                //Etapa_SubCategoria__r.Sub_Categoria__c
                List<Campo_Requerido_Etapa__mdt> camposRequeridos = ServicePortalHelper.getCamposRequeridosPorSubCategoria(subCategoria);
                
                
                res.responseBody = Blob.valueOf( JSON.serialize(camposRequeridos)  );
                
            } else if (uri.equals('/portal/case/categories/')) {
                List<Categoria__mdt> config;
                
                if ( String.isNotBlank(tipoConsulta) && tipoConsulta.equals('cliente') ) {
					
                    config = [SELECT MasterLabel, (select Value__c from Sub_Categorias__r where IsActive__c = true and Portal_Cliente__c = true)
                                               FROM Categoria__mdt
                                               WHERE Id IN  
                                               (SELECT Categoria__c 
                                                FROM Sub_Categoria__mdt 
                                                WHERE IsActive__c = true 
                                                AND Portal_Cliente__c = true) 
                                               ORDER BY MasterLabel];
                    
                } else if (String.isNotBlank(tipoConsulta) && tipoConsulta.equals('modulo') || String.isBlank(tipoConsulta)) {
                    
                    config = [SELECT MasterLabel, (select Value__c from Sub_Categorias__r where IsActive__c = true and Modulo__c = true)
                                               FROM Categoria__mdt
                                               WHERE Id IN  
                                               (SELECT Categoria__c 
                                                FROM Sub_Categoria__mdt 
                                                WHERE IsActive__c = true 
                                                AND Modulo__c = true) 
                                               ORDER BY MasterLabel];
                    
                }
                
                
                
                
                res.responseBody = Blob.valueOf( JSON.serialize(config) );
                
            } else {
                
                res.statusCode = 404;
                
            }
        } catch (Exception e) {
            
        }

    }

    @HttpPost
    global static void create () {
		System.debug('Create');
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        SavePoint sp = Database.setSavepoint();
        
        Boolean missingData = false;
        
        try {
			
            System.debug('RestContext.request.requestBody '  + RestContext.request.requestBody.toString());
            PortalCase container = (PortalCase)System.JSON.deserialize(
                                        RestContext.request.requestBody.tostring(), 
                                        PortalCase.class);
            
            Caso params = container.caso;
            List<Sub_Categoria__mdt> lstSubs = [SELECT Value__c, Categoria__r.Label FROM Sub_Categoria__mdt WHERE DeveloperName =:  params.SubCategoria];


            

            if (params == null) {return;}
            
            //Case c = new Case();
            SObject c = new Case();
            CaseComment commentObj;

            // campos
            Map<String, Object> mapRequest = ( Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.tostring());
            Map<String, Object> mapCampos = (Map<String, Object>) mapRequest.get('caso');
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
 

            for (String key : mapCampos.keySet()) {
				
				Schema.DescribeFieldResult dfr;                
                
                if (fieldMap.containsKey(key)) {
                	dfr = fieldMap.get(key).getDescribe();    
                }
                
                
                if (key.equals('Comentarios__c')) {

                    //c.put('Description', params.Comentarios);
                    commentObj = new CaseComment();
                    commentObj.CommentBody = (String) mapCampos.get(key);
                    commentObj.IsPublished =  false;



                } else if (key.equals('Etapa')) {

                    //c.put('Status', params.Etapa);

                } else if (key.equals('Curp')) {
					
                    Account acc = ServicePortalHelper.getAccountIdByCurp(params.Curp);
                    
                    if (acc == null) {
                        
						throw new ServicePortalCaseException('El cliente no existe');
                        
                    } else {
                        
                        c.put('ContactId', acc.PersonContactId);
                        c.put('AccountId', acc.Id);
                        
                    }
                    

                } else if (key.equals('SubCategoria')) {
                    					
                    
                    
                    if ( !lstSubs.isEmpty() ) {
                        
                        System.debug('lstSubs.get(0).Value__c ' + lstSubs.get(0).Value__c);
                        
                        c.put('RecordtypeId', (lstSubs.get(0).Value__c != null && ServicePortalHelper.getCaseRecordTypesByName().containsKey(lstSubs.get(0).Value__c ) ?  
                                ServicePortalHelper.getCaseRecordTypesByName().get(lstSubs.get(0).Value__c ) : null));
                        
                        c.put('Categor_a__c', lstSubs.get(0).Categoria__r.Label);
                        
                    }
                                      
                } else {
					
                    if (dfr != null && dfr.getType() == Schema.DisplayType.DATE) {
                    	c.put(key, Date.valueOf(String.valueOf( mapCampos.get(key)) ));    
                    } else {
                        c.put(key, mapCampos.get(key));    
                    }

                }

            }
            
            c.put('Status', 'Módulo');
			/*
            Case newCase = new Case();
            newCase.RecordTypeId = (String)c.get('RecordTypeId');
	        newCase.AccountId = (String)c.get('AccountId');
        	System.debug('newCase: ' + newCase);*/
            //insert newCase;
            //c = ServicePortalHelper.moveStatus((Case)c, lstSubs.get(0).Value__c);
            insert c;
            
            if (commentObj!=null) {
                //commentObj.ParentId = newCase.Id;
                commentObj.ParentId = c.Id;
                insert commentObj;
            }
            
            //c.Id = newCase.Id;
            //update c;

            List<Attachment> attachmentToInsert = new List<Attachment>();

            if (container.archivos != null) {
                for (Attach att : container.archivos) {
                    attachmentToInsert.add(
                        new Attachment(parentId = c.Id, name = att.name, 
                                       ContentType = att.ContentType, 
                                       Body = EncodingUtil.base64Decode(att.body)));
                }
                insert attachmentToInsert;
            }

            res.responseBody = Blob.valueOf(JSON.serialize([SELECT Id, Categor_a__c, Subcategor_a_Texto__c, Comentarios__c,  CaseNumber, Status, AccountId, RecordtypeId, Origin, Fecha_estimada_de_cierre__c,
                    (select Id, ContentType  from attachments) 
                    FROM Case WHERE Id =: c.Id]));

            /// Se ejecuta metodo Asincrono para detonar Entitlement Processes
            ServicePortalHelper.moveStatus( c.Id, lstSubs.get(0).Value__c);

        } catch (ServicePortalCaseException svcExc) {
            
            System.debug('svcExc ' + svcExc);
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(svcExc.getMessage());
            Database.rollback(sp);
            
        } catch (DmlException dmlExc) {
            
            System.debug('dmlExc ' + dmlExc);
            res.statusCode = 400;
            String errorMsg = '';
            Integer numErrors = dmlExc.getNumDml();
            for(Integer i=0; i<numErrors; i++) {
                
                errorMsg += dmlExc.getDmlMessage(i);
             
            }
            
            res.responseBody = Blob.valueOf(errorMsg);
            Database.rollback(sp);
            
            
        } catch (Exception e) {
			
            System.debug('e ' + e);
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(e.getMessage());
            Database.rollback(sp);

        }
		
        
        //return null;
        
    }
    
    
    public class ServicePortalCaseException Extends Exception {}


}