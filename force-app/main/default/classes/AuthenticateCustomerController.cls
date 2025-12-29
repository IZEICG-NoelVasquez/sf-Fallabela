/**
* Nombre: AuthenticateCustomerController
* Autor
* Descripcion: Clase controladora de los Componentes Lightning AuthenticateProductos, AuthenticateCustomer, AuthenticateSuccess, AuthenticateInitial, AuthenticateCustomerPathFields, AuthenticateFail, MicroServicioSaldos, OTPCambioEtapa 
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           15/01/2021      Mauricio Rosales            Filtrar Categorias para Casos sin Movimientos creados desde el MS Movimientos
* 3.0           10/02/2021      Mauricio Rosales            Validaciones OTP Dinamicas
* 4.0           07/04/2021      Mauricio Rosales            Se mueve la consulta de Metodo de Contacto a la clase PickListCaseOriginController
* 5.0           16/06/2021      Mauricio Rosales            Se mueve el metodo obtenerProductosCliente a la clase MicroServicioProductos
* 6.0           22/11/2021      Mauricio Rosales            Se agarega try catch en el metodo createCaseByRT() para regresar los errores al componente
* 7.0           09/11/2022      Mauricio Rosales            Catalogo Tipo de Productos, Custom Metadata Tipo_de_Producto__mdt
* --------------------------------------------------------------------------
*/
public with sharing class AuthenticateCustomerController {
    
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
    * Obtiene la lista de Categorias
    * Regresa la lista de Categorias
    *
    * @param isCommunity: variable booleana para casos de tipo Modulo
    * @param esClienteAnonimo: variable booleana para identificar clientes anonimos
    * @param esSoriban: campo Campa_a_Actualizaci_n_SORIBAN__c de Cuentas
    * @param authSinCel: campo Autenticar_Sin_Celular__c de Cuentas
    * @param parentezco: campo PT__pc de Cuentas
    * @param isMovimiento: casos con movimientos seleccionados
    * @param casoSinSeleccionarMovimientos: casos sin movimientos seleccionados desde el componente MS Movimientos
    **/
    @AuraEnabled
    public static List<Object> getCategories (Boolean isCommunity, Boolean esClienteAnonimo, Boolean esSoriban, Boolean authSinCel, String parentezco, Boolean isMovimiento, Boolean casoSinSeleccionarMovimientos) {
        
        
        System.debug('esSoriban: ' + esSoriban);
        System.debug('authSinCel: ' + authSinCel);
        System.debug('isMovimiento: ' + isMovimiento);
        
        Boolean isContactCenter = true;

        List<String> idList = new List<String>();
        Set<String> availableRecordTypes = new Set<String>();
        for (RecordTypeInfo info: Case.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.isAvailable()) {
              availableRecordTypes.add(info.getName());
            }
        }
        
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
        options.add(new SelectOptions('-- None --', ''));
        
        
        /**
* TODO
* usar SOQL Dinamico 
*/
        if (isMovimiento == true) {
            
            List<Sub_Categoria__mdt> subCatParetenzco = [SELECT Categoria__c, Value__c, Caso_sin_seleccionar_Movimientos__c FROM Sub_Categoria__mdt WHERE Movimientos__c = true];

            for (Sub_Categoria__mdt subCat: subCatParetenzco) {

                if (availableRecordTypes.contains(subCat.Value__c)) {

                    /// Creacion de casos sin seleccionar Movimientos desde el componente MS Movimientos
                    if( casoSinSeleccionarMovimientos && subCat.Caso_sin_seleccionar_Movimientos__c ) {

                        idList.add(subCat.Categoria__c);

                    } else if( !casoSinSeleccionarMovimientos && !subCat.Caso_sin_seleccionar_Movimientos__c ) {

                        idList.add(subCat.Categoria__c);
                    }
                } 
            }
            
            for (Categoria__mdt cat : [SELECT Id, MasterLabel 
                                           FROM Categoria__mdt 
                                           WHERE Id IN :idList
                                           ORDER BY MasterLabel ]) {                

                options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
            }
            
            
        } else if (String.isNotBlank(parentezco) && parentezco.equals(BE)) {

          List<Sub_Categoria__mdt> subCatParetenzco = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt WHERE Beneficiario__c = true];

          for (Sub_Categoria__mdt subCat: subCatParetenzco) {
            if (availableRecordTypes.contains(subCat.Value__c)) {
              idList.add(subCat.Categoria__c);
            } 
          }
            
            for (Categoria__mdt cat : [SELECT Id, MasterLabel 
                                           FROM Categoria__mdt 
                                           WHERE Id IN :idList
                                           ORDER BY MasterLabel ]) {
                                               
                                               options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));

      }
            
        } else if ( (esSoriban != null && authSinCel != null) && (esSoriban &&  authSinCel) ) {

          List<Sub_Categoria__mdt> subCatSoriban = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt WHERE IsActive__c = true AND Soriban__c = true];
            
          for (Sub_Categoria__mdt subCat: subCatSoriban) {
            if (availableRecordTypes.contains(subCat.Value__c)) {
              idList.add(subCat.Categoria__c);
            } 
          }
            
            for (Categoria__mdt cat : [SELECT Id, MasterLabel FROM Categoria__mdt 
                                       WHERE Id IN :idList
                                      ORDER BY MasterLabel]) {
                                            
                                            options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
                                            
                                        }
            
        } else if ( esClienteAnonimo ) {
            
            if ( isContactCenter ) {

              List<Sub_Categoria__mdt> subCatAnonimo = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt WHERE IsActive__c = true AND Anonimo__c = true];

              for (Sub_Categoria__mdt subCat: subCatAnonimo) {
                if (availableRecordTypes.contains(subCat.Value__c)) {
                  idList.add(subCat.Categoria__c);
                }
              }
                
                for (Categoria__mdt cat : [SELECT Id, MasterLabel FROM Categoria__mdt 
                                           WHERE Id IN :idList
                                           ORDER BY MasterLabel ]) {
                                               
                                               options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
                                               
                                           }
                
            } else if ( isCommunity ) {

              List<Sub_Categoria__mdt> subCatAnonModule = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt WHERE IsActive__c = true AND Anonimo__c = true AND Modulo__c = true];

              for (Sub_Categoria__mdt subCat: subCatAnonModule) {
                if (availableRecordTypes.contains(subCat.Value__c)) {
                  idList.add(subCat.Categoria__c);
                }
              }
                
                for (Categoria__mdt cat : [SELECT Id, MasterLabel 
                                           FROM Categoria__mdt 
                                           WHERE Id IN :idList 
                                           ORDER BY MasterLabel ]) {
                                               
                                               options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
                                               
                                           }
                
            }
            
        } else if ( isContactCenter ) {

          List<Sub_Categoria__mdt> subCatContactCenter = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt 
                                                    WHERE IsActive__c = true 
                                                    AND ContactCenter__c = true]; 
                 
          /*                                  
          for (Sub_Categoria__mdt subCat : subCategories) {
            if (Schema.SObjectType.Case.getRecordTypeInfosByName().containsKey(subCat.Value__c) && Schema.SObjectType.Case.getRecordTypeInfosByName().get(subCat.Value__c).isAvailable()) {
              idList.add(subCat.Categoria__c);
            }

              
          }*/

          for (Sub_Categoria__mdt subCat: subCatContactCenter) {
            if (availableRecordTypes.contains(subCat.Value__c)) {
              idList.add(subCat.Categoria__c);
            }      
          }
            
            for (Categoria__mdt cat : [SELECT Id, MasterLabel 
                                      FROM Categoria__mdt 
                                      WHERE Id IN :idList
                                      ORDER BY MasterLabel ]) {
                
                options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
                
            }
            
        } else if ( isCommunity ) {

          List<Sub_Categoria__mdt> subCatModule = [SELECT Categoria__c, Value__c FROM Sub_Categoria__mdt WHERE IsActive__c = true AND Modulo__c = true];

          for (Sub_Categoria__mdt subCat: subCatModule) {
            if (availableRecordTypes.contains(subCat.Value__c)) {
              idList.add(subCat.Categoria__c);
            } 
          }
            
            for (Categoria__mdt cat : [SELECT Id, MasterLabel 
                                       FROM Categoria__mdt 
                                       WHERE Id IN :idList
                                       ORDER BY MasterLabel ]) {
                                           
                                           options.add(new SelectOptions(cat.MasterLabel, cat.MasterLabel));
                                           
                                       }
            
        } 
        
        
        return options;
        
    }
    @AuraEnabled
    public static Map<String,List<Object>> getCategoriesSubCategories (String category, Boolean isCommunity, Boolean esClienteAnonimo, Boolean esSoriban, Boolean authSinCel, String parentezco, Boolean isMovimiento, Boolean casoSinSeleccionarMovimientos) {
        
        return AuthenticateHelper.getCategoriesSubCategories( category, isCommunity, esClienteAnonimo, esSoriban, authSinCel, parentezco, isMovimiento, casoSinSeleccionarMovimientos);        
    }

    @AuraEnabled
    public static Map<String,List<Object>> getInfoAltoRiesgo() {

        return AuthenticateHelper.getInfoAltoRiesgo();
    }
    
    /**
* Retrieve record types
* @return Map of Record Types by Name
*/
    @AuraEnabled
    public static Map<String, String> getCaseRecordTypesByName () {
        
        Map<String, String> result = new Map<String, String>();
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        
        for (String key : rtMapByName.keySet()) {
            
            Schema.RecordTypeInfo info = rtMapByName.get(key);
            result.put(key, info.getRecordTypeId());
            
        }
        
        return result;
        
    }
    
    /**
* Current logged in user
* @return User
*/
    @AuraEnabled
    public static User getAgent () {
        
        return [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()];
        
    }
    
    @AuraEnabled
    public static String createCaseByRT (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, Boolean esClienteAnonimo, Map<String, Object> clienteAnonimo, Boolean esRetipificacion, String caseRecordId, String metodoContactoValue, String numeroDeTarjetaValue, String movimientosList) {
        
        System.debug('movimientosList: ' + movimientosList);
        
        System.debug('esRetipificacion ' + esRetipificacion);
        
        esRetipificacion = esRetipificacion == null ? false : esRetipificacion;
        
        Case newCase = new Case();
        
        try {
        
            newCase.RecordTypeId = recordTypeId;
            newCase.ContactId = personId;
            newCase.Categor_a__c = category;
            newCase.Riesgo__c = altoRiesgo ? 'Alto' : 'Bajo';
            newCase.Origin = String.isNotBlank(metodoContactoValue) ? metodoContactoValue : 'Contact Center';
            newCase.TarjetaCaso__c = numeroDeTarjetaValue;
            
            if ( esClienteAnonimo != null && esClienteAnonimo && clienteAnonimo != null) {
                
                newCase.Nombre_s_Anonimo__c = String.valueOf(clienteAnonimo.get('nombresAnonimo'));
                newCase.Apellido_s_Anonimo__c = String.valueOf(clienteAnonimo.get('apellidosAnonimo'));
                newCase.Celular_Anonimo__c = String.valueOf(clienteAnonimo.get('celularAnonimo'));
                newCase.Oficina_Anonimo__c = String.valueOf(clienteAnonimo.get('oficinaAnonimo'));
                newCase.Contrato_Anonimo__c  = String.valueOf(clienteAnonimo.get('contratoAnonimo'));
    
                if (!String.isEmpty(String.valueOf(clienteAnonimo.get('fdnAnonimo')))) {
                    newCase.Fecha_de_Nacimiento_Anonimo__c = Date.valueOf( String.valueOf(clienteAnonimo.get('fdnAnonimo')) );
                } 
                
            }
            
            if (esRetipificacion) {
                System.debug('caseRecordId ' + caseRecordId);
                if (String.isNotBlank(caseRecordId)) {
                    
                    newCase.ParentId = caseRecordId;
                    
                    List<Case> oldCase = [SELECT Id FROM Case WHERE Id =: caseRecordId];
                    
                    if (!oldCase.isEmpty()) {
                        oldCase.get(0).Status = 'Cancelado';
                        update oldCase;
                    }
                    
                }
                
            }
            
            insert newCase;
            
            if ( movimientosList != null ) {
                List<MovimientosWithDetallesJSON> movList = MovimientosWithDetallesJSON.parse(movimientosList);

                if( !movList.isEmpty() && movList[0].blnPlanPagosConMovs ) {
                    List<Movimientos__c> movListToInsert = new List<Movimientos__c>();
                    for(MovimientosWithDetallesJSON item: movList) {
                        Movimientos__c mov = new Movimientos__c();
                        mov.Caso_Movimiento__c = newCase.Id;
                        mov.Fecha_del_movimiento__c = Date.valueOf(item.fechaHoraTransaccion);
                        mov.Monto__c = Double.valueOf(item.montoLocal); 
                        mov.Referencia_Factura__c = item.identificador;
                        /// Ajuste para no detonar Process Builder Validar Movimientos
                        mov.Creado_en_Autenticador__c = true;
                        
                        if(recordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Desconoce transacción en ATM').getRecordTypeId()) || recordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Retiro de efectivo en ATM').getRecordTypeId()) ) {
                            mov.Nombre_de_Instituci_n_Bancaria__c = item.nombreComercio;
                        } else {
                            mov.Establecimiento__c = item.nombreComercio;
                        }
                        ///
                        if( recordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Plan de Pagos').getRecordTypeId()) ) {

                            mov.Pago_m_nimo__c = Decimal.valueOf( item.pagoMinimo );
                            mov.Limite_de_pago__c = Date.valueOf( item.fechaLimiteDePago );
                            mov.Pr_xima_Fecha_de_Corte__c = Date.valueOf( item.proximaFechaDeCorte );                        
                        }
                        
                        movListToInsert.add(mov);
                        
                        System.debug('item: ' + item.fechaHoraTransaccion);
                        System.debug('item: ' + item.montoLocal);
                        System.debug('item: ' + item.nombreComercio);
                        System.debug('item: ' + item.identificador);
                    }
                    
                    insert movListToInsert;

                    if( recordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Plan de Pagos').getRecordTypeId()) ) {

                        newCase.Estatus_final_de_tarjeta__c = movList[0].estatusFinalDeTarjeta == 'Activa' ? 'Activa' : 'Bloqueada';
                    }

                } else if( (!movList.isEmpty()) && (!movList[0].blnPlanPagosConMovs) && (recordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Plan de Pagos').getRecordTypeId())) ) {

                    newCase.Estatus_final_de_tarjeta__c = movList[0].estatusFinalDeTarjeta == 'Activa' ? 'Activa' : 'Bloqueada';
                }

                /// Ajuste para no detonar Process Builder Validar Movimientos
                newCase.Validar_Movimientos__c = true;

                update newCase;
            } 

        } catch(DmlException exDml) {

            String msg = '';

            for (Integer i = 0; i < exDml.getNumDml(); i++) {

                //Get Validation Rule & Trigger Error Messages
                msg =+ exDml.getDmlMessage(i) +  '\n';
            }

            throw new AuraHandledException(msg);

        } catch(Exception ex) {

            throw new AuraHandledException(ex.getMessage());
        }
        
        return newCase.Id;
        
    }
    
    @AuraEnabled
    public static Account getCustomer (String customerId) {
        
        return [SELECT Id, Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Name, Fecha_de_nacimiento1__c, PersonMobilePhone, Oficina__c FROM Account WHERE Id =: customerId];
        
    }
    
    @AuraEnabled
    public static Account getCustomerByCaseId (String caseId) {
        
        if (caseId == null) {
            return null;
        }
        
        Case c = [SELECT AccountId FROM Case WHERE Id =: caseId];
        
        System.debug('c ' + c);
        
        Account acc = [SELECT Id, Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Autenticar_Sin_Celular__c, Name, Fecha_de_nacimiento1__c, PersonMobilePhone, Oficina__c, PersonContactId, (select N_mero_de_tarjeta__c from Tarjetas__r) 
                       FROM Account WHERE Id =: c.AccountId];
        
        System.debug('case acc ' +acc);
        return acc == null ? new Account() : acc;
        
    }
    
    @AuraEnabled
    public static Account getCustomerByCURP (String curp) {
        System.debug('getCustomerByCURP');
        if (curp == null) {
            return null;
        }
        
        List<Account> accts = [SELECT Id, ID_PersonAccount__c, Tipo_Direcci_n__c, Poblaci_n__c, Tipo_de_v_a__c, 
							Regi_n__c, Resto_Direcci_n__c, Delegaci_n__c, Nombre_v_a__c, Colonia__c, 
							N_mero_de_v_a__c, C_digo_Postal__c, ltimos_4_d_gitos_de_Celular__pc, PT__pc, 
							Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Autenticar_Sin_Celular__c, 
							Name, Oficina__c, N_m_contrato__c, CURP__c, ID_Cliente__c, PersonMailingAddress, 
							PersonEmail, PersonContactId, PersonMobilePhone, Ultimos_4_d_gitos_de_Mobile__c, 
							(select Subject, Status from cases limit 10), (select N_mero_de_tarjeta__c from Tarjetas__r), 
							VIP__c
                       FROM Account WHERE CURP__c =: curp LIMIT 1];
        Account acc;
        if (accts!=null && !accts.isEmpty()) {
            acc = accts.get(0);
        }
        return acc;
    }
    
    @AuraEnabled
    public static Account getCustomerById (String idAcc) {
        System.debug('*** getCustomerById ***');
        if (idAcc == null) {
            return null;
        }
        
        List<Account> accts = [SELECT Id, ID_PersonAccount__c, Tipo_Direcci_n__c, Poblaci_n__c, Tipo_de_v_a__c, 
							Regi_n__c, Resto_Direcci_n__c, Delegaci_n__c, Nombre_v_a__c, Colonia__c, 
							N_mero_de_v_a__c, C_digo_Postal__c, ltimos_4_d_gitos_de_Celular__pc, PT__pc, 
							Campa_a_Actualizaci_n_SORIBAN__c, Cliente_Anonimo__c, Autenticar_Sin_Celular__c, 
							Name, Oficina__c, N_m_contrato__c, CURP__c, ID_Cliente__c, PersonMailingAddress, 
							PersonEmail, PersonContactId, PersonMobilePhone, Ultimos_4_d_gitos_de_Mobile__c, 
							(select Subject, Status from cases limit 10), (select N_mero_de_tarjeta__c from Tarjetas__r), 
							VIP__c, Condici_n_econ_mica__c, Saldo_Garantia__c
                       FROM Account WHERE Id =: idAcc LIMIT 1];
        Account acc;
        if (accts!=null && !accts.isEmpty()) {
            acc = accts.get(0);
        }
        return acc;
    }
    
    @AuraEnabled
    public static Map<String, Object> getPortalFieldsConfig (String recordId) {
        
        Map<String, Object> result = new Map<String, Object>();
        Case c = [SELECT RecordType.Name, RecordTypeId FROM Case WHERE Id =: recordId];
        
        result.put('rtID', c.RecordTypeId);
        result.put('fields', ServicePortalHelper.getCamposRequeridosPorSubCategoria(c.RecordType.Name));
        
        return result;
        
    }
    
    
    @AuraEnabled
    public static void actualizarNuevoCelular (String validatedRecordId, Boolean isValid) {
        
        List<Case> c = [SELECT Celular_Nuevo_Verificado__c FROM Case WHERE Id =: validatedRecordId];
      
        if (!c.isEmpty()) {
            
         c.get(0).Celular_Nuevo_Verificado__c = isValid;
         update c;
            
        }    
        
    }

    @AuraEnabled
    public static void actualizarPANCelular (String validatedRecordId, Boolean isValid) {
        
        List<Case> c = [SELECT Celular_PAN_Verificado__c FROM Case WHERE Id =: validatedRecordId];
      
        if (!c.isEmpty()) {
            
         c.get(0).Celular_PAN_Verificado__c = isValid;
         update c;
            
        }    
        
    }

    /**
    * Llamado al MicroServicio Productos para obtener las tarjetas relacionadas con el CURP del cliente
    * @return regresa un mapa con una variable booleana de exito y la respuesta del MicroServicio
    *
    * @param curp: curp del cliente
    **/
    @AuraEnabled
    public static Map<String, Object> obtenerProductosCliente (String curp) {

        return MicroServicioProductos.obtenerProductosCliente(curp);
    }
    
    @AuraEnabled
    public static Map<String, Object> obtenerSaldosCliente(String codigoProducto, String codigoSubProducto, String identificadorProducto, String identificador) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, String> params = new Map<String, String>();
        params.put('codigoProducto', codigoProducto);
        params.put('codigoSubProducto', codigoSubProducto);
        params.put('identificadorProducto', identificadorProducto);
        params.put('identificador', identificador);
        
        System.debug('codigoProducto: ' + codigoProducto);
        System.debug('codigoSubProducto: ' + codigoSubProducto);
        System.debug('identificadorProducto: ' + identificadorProducto);
        System.debug('identificador: ' + identificador);

        MicroServicioSaldos mss = new MicroServicioSaldos();
        SaldosJson saldos = mss.obtenerSaldos(params);
		system.debug('saldos');
        System.debug(saldos);
        if (saldos != null) {
            success = true;
        }

        result.put('success', success);
        result.put('saldos', saldos);

        return result;
        
    }

    @AuraEnabled
    public static void sendSMSmedioAltoRiesgo(Account selectedAccount){
        Account acc = [Select Id, Send_SMS__c From Account Where Id =: selectedAccount.Id LIMIT 1];
        
        System.debug('selectedAccount ' +selectedAccount);
        System.debug('Send_SMS__c ' +acc.Send_SMS__c);
        if(acc.Send_SMS__c == false){
            acc.Send_SMS__c = true;
        }
        else{
             acc.Send_SMS__c = false;
        }
        update acc;
        System.debug('Send_SMS__c2 ' +acc.Send_SMS__c);
    }

    /**
    * Obtiene la lista Validaciones OTP para cada Microservicio
    * Regresa un Mapa (llave nombre del MicroServicio, valor Mapa con (llave tipo de validacion, valor frecuencia de la validacion))
    **/
    @AuraEnabled
    public static Map<String, Object> validacionesOTPDinamicas() {

        Map<String, Object> mapResult = new Map<String, Object>();

        List<Validacion_OTP_MicroServicios__mdt> listValidacionesOTP = [SELECT MasterLabel, 
                                                                                Tipo_de_Validacion__c, 
                                                                                Frecuencia__c
                                                                        FROM Validacion_OTP_MicroServicios__mdt];

        for(Validacion_OTP_MicroServicios__mdt validacion: listValidacionesOTP ) {

            Map<String, Object> mapValidacion = new Map<String, Object>();

            if( validacion.Tipo_de_Validacion__c == 'OTP' ) {

                mapValidacion.put('otp',validacion.Frecuencia__c);

            } else if( validacion.Tipo_de_Validacion__c == 'Validacion de Preguntas' ) {

                mapValidacion.put('validacionDePreguntas',validacion.Frecuencia__c);

            }            

            mapResult.put(validacion.MasterLabel, mapValidacion);
        }

        return mapResult;
    }

    /**
     * Obtiene el Catalogo Tipo de Producto (Tipo_de_Producto__mdt)
     * Regresa un Mapa cun variable de exito y el catalogo Tipo de Producto
     */
    @AuraEnabled
    public static Map<String, Object> getMetadataProductTypeCatalog() {

        Map<String, Object> mapResult = new Map<String, Object>();

        Map<String,String> mapTypeProduct = new Map<String,String>();

        for(Tipo_de_Producto__mdt typeProd: [SELECT Producto__c, Subproducto__c, Descripcion__c FROM Tipo_de_Producto__mdt]) {

            mapTypeProduct.put(typeProd.Producto__c + typeProd.Subproducto__c, typeProd.Descripcion__c);
        }

        mapResult.put('mapTypeProduct', mapTypeProduct);
        mapResult.put('success', mapTypeProduct.size() > 0 ? true : false);

        return mapResult;
    }
}