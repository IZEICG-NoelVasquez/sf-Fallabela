/************************************************************************************************
Apex Class Name	:	AuthenticateHelper 
Version			:	2.0
Created Date    :	--
Function 		: 	Helper Controller del compoente AuthenticateSuccess
Test Class		:	AuthenticateCustomerControllerTest
Code Coverage   :
Modification Log
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* --                  --        	   Original Version
* Luis Sandoval     03/08/19       Se agregó la consideración de SubCategoría Riesgo  'Medio Alto'
* Mauricio Rosales  15/01/21       Filtrar SubCategorias para Casos sin Movimientos creados desde el MS Movimientos
*************************************************************************************************/
public class AuthenticateHelper {

    static final String BE = 'BE';

    public class SelectOptions {
        
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
        
        public SelectOptions (String label, String value) {
            this.label = label;
            this.value = value;
        }
        
    }
    
    /**
    * Obtiene la lista de SubCategorias de acuerdo a la Categoria Seleccionada 
    * Regresa la lista de SubCategorias
    *
    * @param category: categoria Seleccionada
    * @param isCommunity: variable booleana para casos de tipo Modulo
    * @param esClienteAnonimo: variable booleana para identificar clientes anonimos
    * @param esSoriban: campo Campa_a_Actualizaci_n_SORIBAN__c de Cuentas
    * @param authSinCel: campo Autenticar_Sin_Celular__c de Cuentas
    * @param parentezco: campo PT__pc de Cuentas
    * @param isMovimiento: casos con movimientos seleccionados
    * @param casoSinSeleccionarMovimientos: casos sin movimientos seleccionados desde el componente MS Movimientos
    **/
    public static Map<String,List<Object>> getCategoriesSubCategories(String category, Boolean isCommunity, Boolean esClienteAnonimo, Boolean esSoriban, Boolean authSinCel, String parentezco, Boolean isMovimiento, Boolean casoSinSeleccionarMovimientos) {
        
        Map<String,List<Object>> resultmap = new Map<String,List<Object>>();
        
        Boolean isContactCenter = true;
        
        if (isCommunity == null) {
            
            isCommunity = false;            
        }
        
        if (esClienteAnonimo == null) {
            
            esClienteAnonimo = false;            
        }
        
        if (isCommunity) {
            
            isContactCenter = false;            
        }
        
        List<SelectOptions> options = new List<SelectOptions>();
        List<String> altoRiesgo = new List<String>();
        List<String> medioAltoRiesgo = new List<String>();
        
        options.add(new SelectOptions('-- None --', ''));
        /// Ajuste para Filtrar Sub Categorias con Movimientos Seleccionados
        if( isMovimiento == true ) {
            for (Sub_Categoria__mdt cat : [SELECT Value__c, Riesgo__c, Anonimo__c, Soriban__c, Caso_sin_seleccionar_Movimientos__c
                                                    FROM Sub_Categoria__mdt 
                                                    WHERE Categoria__r.MasterLabel =: category 
                                                    AND IsActive__c = true
                                                    AND Movimientos__c = true
                                                    ORDER BY Value__c]) {
                if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey(cat.Value__c) ) {
                                               
                    if ( cat.Riesgo__c.equals('Alto') ) {
                                                   
                        altoRiesgo.add(cat.Value__c);                                                   
                    }                                               
                    if ( cat.Riesgo__c.equals('Medio Alto') ) {
                        medioAltoRiesgo.add(cat.Value__c);                                                  
                    }
                    if( Schema.SObjectType.Case.getRecordTypeInfosByName().get(cat.Value__c).isAvailable() ) {

                        /// Creacion de casos sin seleccionar Movimientos desde el componente MS Movimientos
                        if( casoSinSeleccionarMovimientos && cat.Caso_sin_seleccionar_Movimientos__c ) {

                            options.add(new SelectOptions(cat.Value__c, cat.Value__c));

                        } else if( !casoSinSeleccionarMovimientos && !cat.Caso_sin_seleccionar_Movimientos__c ) {

                            options.add(new SelectOptions(cat.Value__c, cat.Value__c));

                        }                        
                    }                    
                }
            }

        }
        ///
        else if (String.isNotBlank(parentezco) && parentezco.equals(BE)) {

            for (Sub_Categoria__mdt cat : [SELECT Value__c, Riesgo__c, Anonimo__c, Soriban__c
                                                    FROM Sub_Categoria__mdt 
                                                    WHERE Categoria__r.MasterLabel =: category 
                                                    AND IsActive__c = true
                                                    AND Beneficiario__c = true
                                                    ORDER BY Value__c]) {
                                               
                if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey(cat.Value__c) ) {
                                               
                    if ( cat.Riesgo__c.equals('Alto') ) {
                                                   
                        altoRiesgo.add(cat.Value__c);                                                   
                    }                                               
                    if ( cat.Riesgo__c.equals('Medio Alto') ) {
                        medioAltoRiesgo.add(cat.Value__c);                                                  
                    }
                    if( Schema.SObjectType.Case.getRecordTypeInfosByName().get(cat.Value__c).isAvailable() ) {
                        options.add(new SelectOptions(cat.Value__c, cat.Value__c));
                    }                    
                }
            }
              
        } else if ( (esSoriban != null && authSinCel != null) && (esSoriban &&  authSinCel) ) {
            
            for (Sub_Categoria__mdt cat : [SELECT Value__c, Riesgo__c, Anonimo__c, Soriban__c
                                                    FROM Sub_Categoria__mdt 
                                                    WHERE Categoria__r.MasterLabel =: category 
                                                    AND IsActive__c = true
                                                    AND Soriban__c = true
                                                    ORDER BY Value__c]) {
                                            
                if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey(cat.Value__c) ) {
                                            
                    if ( cat.Riesgo__c.equals('Alto') ) {
                                                
                        altoRiesgo.add(cat.Value__c);                                                   
                    }                                               
                    if ( cat.Riesgo__c.equals('Medio Alto') ) {
                        medioAltoRiesgo.add(cat.Value__c);                                                  
                    }
                    if( Schema.SObjectType.Case.getRecordTypeInfosByName().get(cat.Value__c).isAvailable() ) {
                        options.add(new SelectOptions(cat.Value__c, cat.Value__c));
                    }                    
                }
            }           
            
        } else {            
            
            for (Sub_Categoria__mdt cat : [SELECT Value__c, Riesgo__c, Anonimo__c, Soriban__c
                                                    FROM Sub_Categoria__mdt 
                                                    WHERE Categoria__r.MasterLabel =: category 
                                                    AND IsActive__c = true
                                                    AND ContactCenter__c =: isContactCenter
                                                    AND Modulo__c =: isCommunity
                                                    ORDER BY Value__c]) {
                System.debug('Fer entre al else'+ cat.Value__c);
                                               
                if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey(cat.Value__c) ) {
                
                    if( Schema.SObjectType.Case.getRecordTypeInfosByName().get(cat.Value__c).isAvailable() ) {
                        if ( esClienteAnonimo ) {
                            
                            if (cat.Anonimo__c) {
                                options.add(new SelectOptions(cat.Value__c, cat.Value__c));    
                            }
                            
                        } else {
                            
                            options.add(new SelectOptions(cat.Value__c, cat.Value__c));                        
                        }
                    }
                    
                    if ( cat.Riesgo__c.equals('Alto') ) {
                        altoRiesgo.add(cat.Value__c);
                    }
                    if ( cat.Riesgo__c.equals('Medio Alto') ) {
                        medioAltoRiesgo.add(cat.Value__c);                                                  
                    }
                }
                
            }             
            
        }

        resultMap.put('options', options);
        resultMap.put('altoRiesgo', altoRiesgo);
        resultMap.put('medioAltoRiesgo', medioAltoRiesgo);

        return resultMap;
    }

    public static Map<String,List<Object>> getInfoAltoRiesgo() {

        Map<String,List<Object>> resultMap = new Map<String,List<Object>>();

        List<String> altoRiesgo = new List<String>();

        for(Sub_Categoria__mdt subCategoria : [SELECT Value__c, Riesgo__c FROM Sub_Categoria__mdt WHERE IsActive__c = true ORDER BY Value__c ] ) {

            if( subCategoria.Riesgo__c == 'Alto' ) {

                altoRiesgo.add(subCategoria.Value__c);
            }
        }

        System.debug('altoRiesgo.size:  ' + altoRiesgo.size() );

        resultMap.put('altoRiesgo', altoRiesgo);

        return resultMap;
    }

    public static Account updateSelectedAccount (String idAcc) {
        System.debug('AuthenticateHelper - updateSelectedAccount');

        if (idAcc == null) {
            return null;
        }

        List<Account> accts = [SELECT ID_PersonAccount__c, Tipo_Direcci_n__c, Poblaci_n__c, Tipo_de_v_a__c, 
                                        Regi_n__c, Resto_Direcci_n__c, Delegaci_n__c, Nombre_v_a__c, Colonia__c, 
                                        N_mero_de_v_a__c, C_digo_Postal__c, ltimos_4_d_gitos_de_Celular__pc, PT__pc, 
                                        Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Autenticar_Sin_Celular__c, 
                                        Name, Oficina__c, N_m_contrato__c, CURP__c, ID_Cliente__c, PersonMailingAddress, 
                                        PersonEmail, PersonContactId, PersonMobilePhone, Ultimos_4_d_gitos_de_Mobile__c, 
                                        (select Subject, Status from cases limit 10), (select N_mero_de_tarjeta__c from Tarjetas__r), 
                                        VIP__c, Empleado__c, Subgrupo__pc, Flex__c
                                FROM Account WHERE Id =: idAcc LIMIT 1];
        Account acc;
        if ( accts != null && !accts.isEmpty() ) {
            acc = accts[0];
        }
        return acc;
    }
}