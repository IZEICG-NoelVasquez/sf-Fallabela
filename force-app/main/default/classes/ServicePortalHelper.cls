public with sharing class ServicePortalHelper {
	
	public static Account getAccountIdByCurp (String curp) {
		
		try {
			
            List<Account> lstAcct = [SELECT Id, PersonContactId FROM Account WHERE CURP__c =: curp LIMIT 1];
			return lstAcct.isEmpty() ? null : lstAcct.get(0);	
		
		} catch (Exception e) {

			System.debug('Exception ' + e);
 
		}
		
		return null;
	}

	public static Map<String, String> getCaseRecordTypesByName () {

		return AuthenticateCustomerController.getCaseRecordTypesByName();

	}


	public static List<Campo_Requerido_Etapa__mdt> getCamposRequeridosPorSubCategoria (String subCategoria) {

		List<Campo_Requerido_Etapa__mdt> camposRequeridos = new List<Campo_Requerido_Etapa__mdt>();


		for (Campo_Requerido_Etapa__mdt config : [SELECT Campo__r.API_Name__c, Campo__r.Length__c, Etapa_SubCategoria__r.Etapa__r.Value__c,
		                                                    Campo__r.Type__c, Campo__r.Value__c,
		                                                    Etapa_SubCategoria__r.Sub_Categoria__r.Value__c
		                                            FROM Campo_Requerido_Etapa__mdt 
		                                            WHERE Etapa_SubCategoria__r.Sub_Categoria__r.IsActive__c = true
		                                            AND Etapa_SubCategoria__r.Sub_Categoria__r.Modulo__c = true
                                                 	AND Etapa_SubCategoria__r.Etapa__r.Value__c = 'Módulo']) {
			
                                                        System.debug('config.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c ' + config.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c);
		    if (String.valueOf(config.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c) == subCategoria) {

		        camposRequeridos.add(config);

		    }

		}

		return camposRequeridos;
    }
    
	/// Se ejecuta metodo Asincrono para detonar Entitlement Processes
	@future(callout=true)
    public static void moveStatus ( Id idCase, String subCategoria) {

		///
		Case c = [SELECT Status FROM Case WHERE Id =: idCase ];
        
        // act de domicilio y de correo, quejas y fraude se cierran        
        if ( subCategoria.equals('Actualización Correo (Módulo)') || subCategoria.equals('Actualización Domicilio (Módulo)') || 
           	 subCategoria.equals('Quejas y/o Sugerencias (Módulo)') || subCategoria.equals('Sospecha de fraudes (Módulo)') ) {
        	
            c.Status = 'Cerrado';
            
        } else if ( subCategoria.equals('Cancelación por fallecimiento del titular (Módulo)') ) {
            
         	c.Status = 'Documentación requerida';   
            
        } else if ( subCategoria.equals('Cancelación de Adicional (Módulo)') ) {
            
            c.Status = 'Cancelación de la cuenta';   
            
        } else if (subCategoria.equals('Cargo No Reconocido (Módulo)') || subCategoria.equals('Desconoce transacción en ATM (Módulo)') ) {
            
            c.Status = 'Análisis de Prosa';   
            
        } else if ( subCategoria.equals('Liberar Saldo Retenido (Módulo)') || subCategoria.equals('Retiro de Efectivo en ATM (Módulo)') ||
                  	subCategoria.equals('Pago No Aplicado (Módulo)') ) {
            	
            c.Status = 'Investigación del caso';   
            
        } else if ( subCategoria.equals('Tarjeta no pasa (Módulo)') ) {
            
            c.Status = 'Desbloqueo de PIN';   
            
        } else if (subCategoria.equals('Promoción no Aplicada (Módulo)') || subCategoria.equals('Compra no diferida (Módulo)') || subCategoria.equals('Abono de Puntos (Módulo)') ) {
            
            c.Status = 'Análisis de la aclaración';
            
        } else if ( subCategoria.equals('Reversa de Comisión (Módulo)') ) {
            
            c.Status = 'Validación de la comisión';
            
        }
        update c;

    }
    
}