public with sharing class icg_Utils {
	

	@InvocableMethod(label='Clone Record' description='Clones and insert record.')
	public static void cloneRecord (List<Case> records) {

		List<Case> newCases = new List<Case>();
		List<Case> modifiedCases = new List<Case>();
		List<MyEvent__e> events = new List<MyEvent__e>();
        
        Map<Id, Case> caseMaps = new Map<Id, Case>(records);
        
        for (Case c : [SELECT Account.PersonContactId FROM Case WHERE Id IN: caseMaps.keySet()]) {
            
            caseMaps.put(c.Id, c);
            
        }

		for (Case c : records) {

			Case modifiedCase = new Case(Id=c.Id);

			Case clonedcase;

			if (c.Status != null && c.Cliente_desconoce_transacciones__c != null && c.Status.equals('Validación de Movimientos') && 
					c.Cliente_desconoce_transacciones__c.equals('SI')) {


				clonedcase = c.clone(false, true, false, false);
				clonedcase.ContactId = caseMaps.containsKey(c.Id) && caseMaps.get(c.Id).Account != null ? caseMaps.get(c.Id).Account.PersonContactId : null;
                clonedCase.Status = 'Detalle de movimientos';
				clonedcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cargo no reconocido').getRecordTypeId();	
                    
				//modifiedCase.Status = 'Cerrado';
				//modifiedCases.add(modifiedCase);
                    

			} else if ( c.Status != null && c.Status.equals('Detalle del Medio de Envío Actual') && c.Datos_del_cliente_son_correctos__c != null && 
							c.Medio_de_env_o_de_estado_de_cuenta_selec__c != null) {
				
				if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Cambio de Medio Envío').getRecordTypeId())) {

					//Si la respuesta es NO (son correctos) y Medio de envío de EDC actual= correo, pasa a la etapa (actualización de datos)
					if (c.Datos_del_cliente_son_correctos__c.equals('NO') && c.Medio_de_env_o_de_estado_de_cuenta_selec__c.equals('Email')) {

						//modifiedCase.Status = 'Actualización de Datos';
						//modifiedCases.add(modifiedCase);

						clonedcase = c.clone(false, true, false, false);
                        clonedcase.ContactId = caseMaps.containsKey(c.Id) && caseMaps.get(c.Id).Account != null ? caseMaps.get(c.Id).Account.PersonContactId : null;
						clonedcase.Status = 'Actualización de Correo';

						clonedcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de Correo').getRecordTypeId();

					} 
				
                    
				} else if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reenvío de Estado de Cuenta').getRecordTypeId())) {

					//Si la respuesta es NO, pasa a la siguiente etapa. En la siguiente etapa (Actualización de Datos) crear nuevo caso de Actualización de correo. 
					if (c.Datos_del_cliente_son_correctos__c.equals('NO')) {

                        //modifiedCase.Status = 'Actualización de Datos';

						//modifiedCases.add(modifiedCase);

						clonedcase = c.clone(false, true, false, false);
                        clonedcase.ContactId = caseMaps.containsKey(c.Id) && caseMaps.get(c.Id).Account != null ? caseMaps.get(c.Id).Account.PersonContactId : null;
						clonedcase.Status = 'Actualización de Correo';

						clonedcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Actualización de Correo').getRecordTypeId();

					} else if (c.Datos_del_cliente_son_correctos__c.equals('SI')) {

						//Respuesta SI, se salta a informar folio y se cierra el caso
						//modifiedCase.Status = 'Informar folio y despedida';
						//modifiedCases.add(modifiedCase);

					}

				}

			}
			
			if (clonedcase != null) {

				newCases.add(clonedcase);

			}

		}
		
       
            
        try {
            if (!modifiedCases.isEmpty()) {
                System.debug('Update ' + modifiedCases);
                List<Database.SaveResult> modifiedResults = Database.update(modifiedCases);
    
            }
    
            if (!newCases.isEmpty()) {
                
                List<Database.SaveResult> caseResults = Database.insert(newCases);
    
                for (Database.SaveResult sr : caseResults) {
    
                    if (sr.isSuccess()) {
                        events.add(new MyEvent__e(Message__c='navigateToSObject', value__c=sr.getId()));	
                    }
                    
                }
    
            }

		
			List<Database.SaveResult> results = EventBus.publish(events);
        } catch (Exception e) {
            
        }

	}



}