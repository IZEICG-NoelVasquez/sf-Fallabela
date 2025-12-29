public class CrearCasosBackOffice {

    private static final String RT_RIESGOS = 'Riesgos/Originación';
    private static final String RT_VT_GLOBAL = 'Verificacion Telefonica Global';
    private static final String RT_VT_VILLAGARCIA = 'Monto igual o mayores a $20,000 o Villa de Garcia';
    private static final String RT_VT_RIESGOS ='Riesgos/Originación';

    public static Map<String, Object> casoUpsertCreacion(WSCreateDataBO createData, String idSolicitud) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        // Variable para identificar casos reenviados
        Boolean blnCasoReenviado = false;
        Case caso = new Case();

        try {

            caso.ID_Solicitud__c = idSolicitud;
            String gsRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get(RT_VT_RIESGOS).getRecordTypeId();
            Id idQueueRiesgos = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Riesgos_Falabella'].Id;

            caso.RecordTypeId = gsRecordTypeID;
            caso.OwnerId = idQueueRiesgos;
            caso.CURP__c = createData.curp;
            caso.Nombre_s__c = createData.name;
            caso.Primer_Apellido__c = createData.surname;
            caso.Segundo_Apellido__c = createData.secondsurname;
            /// Ajuste para crear el caso con estatus de Nuevo
            caso.Status = 'New';
            caso.Caso_Actualizado_por_WebService__c = true;
            /// Se actualiza campo para validacion de actualizacion en MS Admision
            caso.Actualizaci_n_Alta_en_SAT__c = false;
            caso.Actualizaci_n_de_domicilio_en_SAT__c = false;

            caso.Estatus__c = createData.evaluationResult;
            
            /// Se elimina campo tipo_cola__c
            ///if(createData.tipo_cola != null){
                ///caso.tipo_cola__c = createData.tipo_cola;
            ///}        
            System.debug('--------------Caso inicial------------\n' + System.JSON.serializePretty(caso));

            Database.UpsertResult upsertCaso = Database.upsert(caso, Case.ID_Solicitud__c);            

            if( upsertCaso.isSuccess() ) {
                if( !upsertCaso.isCreated() ) {
                    caso.Solicitud_Repetida__c = true;
                    caso.Cliente_Repetido__c = true;

                    blnCasoReenviado = true;

                    Database.upsert(caso, Case.ID_Solicitud__c);
                }
                success = true;
            }
        } catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }

        result.put('success', success);
        result.put('blnCasoReenviado', blnCasoReenviado);
        result.put('idCaso', caso.Id);

        return result;
    }
    
    public static Map<String, Object> casoUpsertRestantes(RecuperarInfoSolicitudJSON rec, String idSolicitud, Boolean blnCasoReenviado) {
        
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;        
        Case caso = new Case();        

        try {

            caso.ID_Solicitud__c = idSolicitud;

            /// Campo para guardar el exito de la consulta de WS Recuperar Informacion de la Solicitud
            caso.Actualizaci_n_de_domicilio_en_SAT__c = true;

            ///
            String userLocal = UserInfo.getLocale();
            System.debug('userLocal:  ' + userLocal);

            //En esta sección se da formato a la fecha recibida del campo [modifiedDate]
            String modifiedDateAux = String.isNotBlank(rec.modifiedDate) ? rec.modifiedDate.substringBefore('T').replace('-','/') : '';
            String day = String.isNotBlank(modifiedDateAux) ? modifiedDateAux.substringAfterLast('/') : '';
            String month = String.isNotBlank(modifiedDateAux) ? modifiedDateAux.substringBetween('/') : '';
            String year = String.isNotBlank(modifiedDateAux) ? modifiedDateAux.substringBefore('/') : '';                
            modifiedDateAux = String.isNotBlank(modifiedDateAux) ? ( userLocal == 'en_US' ? (month +'/' + day + '/' + year) : (day + '/' + month + '/' + year) ) : '';

            String birthDateAux = String.isNotBlank(rec.birthDate) ? rec.birthDate : '';
            String dayBirthD = String.isNotBlank(birthDateAux) ? birthDateAux.substringBefore('/') : '';
            String monthBirthD = String.isNotBlank(birthDateAux) ? birthDateAux.substringBetween('/') : '';
            String yearBirthD = String.isNotBlank(birthDateAux) ? modifiedDateAux.substringAfterLast('/') : '';
            birthDateAux = String.isNotBlank(birthDateAux) ? (userLocal == 'en_US' ? (monthBirthD +'/' + dayBirthD + '/' + yearBirthD) : (dayBirthD + '/' + monthBirthD + '/' + yearBirthD) ) : '';
            
            //Se agregarán los campos obtenidos por el servicio al caso existente [Salesforce-JSON]
            ///caso.Luz_Negra__c = rec.blackLigthValidation;
            caso.Resultado_INE__c    = rec.ineResult;
            caso.Direcci_n_Diferente_al_INE__c = rec.ifeAddressEqualsDeclaredAddress;
            ///caso.Captura_Foto__c = rec.pictureCaptured;
            caso.Producto_solicitado__c = rec.productName;
            ///caso.Descripci_n_Producto_solicitado__c = rec.productCode;
            caso.Fecha_de_actualizaci_n__c = String.isNotBlank(modifiedDateAux) ? date.parse(modifiedDateAux) : null;
            caso.Cupo__c = Decimal.valueOf(rec.quota);
            ///caso.Ciudad_laboral__c = rec.companyMunicipality;
            ///caso.Extensi_n_tel_fono_trabajo__c = rec.jobExtension;
            caso.Sucursal__c = rec.sucursal;
            caso.ID_Usuario__c = rec.webAgent;
            caso.ID_Promotor__c = rec.promotorId;
            ///caso.ID_Referido_cajero_soriana__c = rec.referredId;
            caso.N_mero_de_Tel_fono_M_vil__c = rec.cellPhoneNumber;
            caso.N_mero_de_Tel_fono_Casa__c = rec.homePhoneNumber;
            caso.Email__c = rec.email;
            caso.Fecha_de_Pago_Riesgos__c = rec.paymentDay;
            caso.N_Tarjeta_recompensas__c = rec.rewardsCardNumber;
            caso.Calle__c = rec.street;
            caso.Exterior__c = rec.exteriorNumber;
            caso.Interior__c = rec.interiorNumber;
            caso.Colonia_Texto__c = rec.colony;
            caso.C_digo_Postal_Texto__c = rec.zipCode;
            caso.Ciudad__c = rec.city;
            caso.Poblaci_n_Delegaci_n_o_Municipio__c = rec.municipality;
            caso.Estado__c = rec.state;
            ///caso.Entidad_Federativa_de_Nacimiento_Riesgos__c = rec.birthFederalEntity;
            caso.Fecha_de_nacimiento_riesgos__c = String.isNotBlank(birthDateAux) ? date.parse(birthDateAux) : null;
            caso.G_nero__c = rec.genre;
            caso.Nacionalidad__c = rec.nationality;
            caso.Pa_s_de_Nacionalidad__c = rec.nationalityCountry;
            ///caso.C_digo_postal_laboral__c = rec.companyZipCode;
            caso.Calle_Laboral__c = rec.companyStreet;
            caso.N_mero_exterior_laboral__c = rec.companyInteriorNumber;
            ///caso.N_mero_interior_laboral__c = rec.companyExteriorNumber;
            ///caso.Colonia_Fraccionamiento_laboral__c = rec.companyColony;
            ///caso.Poblaci_n_Estado_laboral__c = rec.companyState;
            ///caso.Delegaci_n_Municipio_laboral__c = rec.companyMunicipality;
            ///caso.Tipo_de_empleo__c = rec.jobType;
            caso.RFC_Caso__c = rec.rfc;
            caso.Homoclave__c = rec.homoclave;
            caso.Persona_f_sica_con_actividad_empresarial__c = rec.ppob;
            caso.Empleo_Actual_A_os__c = String.valueOf(rec.jobYear);
            caso.Empleo_Actual_Meses__c = String.valueOf(rec.jobMonth);
            ///caso.Empleo_Actual_Tipo_de_contrato__c = rec.contractJobType;
            caso.Ingresos_mensuales__c = rec.monthlyIncome;
            caso.N_mero_tel_fono_trabajo__c = rec.jobPhone;
            caso.Nombre_de_Empresa__c = rec.companyName;
            caso.Actividad_o_giro_del_negocio__c = rec.activityType;
            caso.Ocupaci_n_o_profesi_n__c = rec.occupationType;
            caso.Empleo_Anterior_Fecha_de_Ingreso__c = rec.previousJobStartDate;
            caso.Empleo_Anterior_Fecha_de_Egreso__c = rec.previousJobEndDate;
            caso.Empleo_Anterior_Nombre_de_la_Empresa__c = rec.previousJobCompanyName;
            ///caso.Empleo_Anterior_Ingresos__c = rec.previousJobMonthlyIncome;
            caso.Nombre_completo_1__c = rec.firstReferenceFullName;
            ///caso.Parentesco_1__c = rec.firstReferenceRelationship;
            caso.N_mero_de_contacto_1__c = rec.firstReferencePhoneNumber;
            caso.Nombre_completo_2__c = rec.secondReferenceFullName;
            ///caso.Parentesco_2__c = rec.secondReferenceRelationship;
            caso.N_mero_de_contacto_2__c = rec.secondReferencePhoneNumber;
            caso.Estado_Civil__c = rec.maritalStatus;
            caso.Dependientes_econ_micos_Cuantos__c = rec.dependentsNumber;
            ///caso.Grado_m_ximo_de_estudios__c = rec.education;
            ///caso.Tiempo_de_residencia_A_os__c = String.valueOf(rec.residenceTime);
            ///caso.Tipo_de_Residencia__c = rec.residenceType;
            caso.Nombre_s__c = rec.name;
            caso.Primer_Apellido__c = rec.surname;
            caso.Segundo_Apellido__c = rec.secondSurname;
            caso.Tarjeta_de_cr_dito__c = rec.creditCard;
            caso.ltimos_cuatro_d_gitos__c = rec.lastFourDigits;
            caso.Cr_dito_Automotriz__c = rec.creditAutomotriz;
            caso.Autorizaci_n_Bur_de_Cr_dito__c = rec.checkBuroAuthorization;
            caso.Cr_dito_Hipotecario__c = rec.creditMortgage;
            caso.Acept_t_rminos__c = rec.acceptTerms;
            caso.Aviso_de_privacidad__c = rec.privacityAdvertisement;
            caso.Otra_Colonia__c = rec.otherColony;
            caso.Dependientes_econ_micos_Si_No__c = rec.dependents;
            caso.Fiel__c = rec.fiel;
            caso.Origen_de_los_Recursos__c = rec.originResources;
            caso.Destino_de_los_Recursos__c = rec.destinationResources;
            caso.Monto_promedio_de_disposici_n__c = rec.amountDisposal;
            caso.Num_promedio_de_disposiciones_mensuales__c = rec.averageMonthlyProvisionsNumber;
            caso.Env_o_de_estado_de_cuenta__c = rec.sendStatusAccount;
            caso.Estatus__c = rec.codigoStatusEvaluacion;
            ///caso.Canal_origen__c = rec.canalOrigen;
            ///caso.Canal_actual__c = rec.currentChannel;
            
            System.debug('--------------Caso completo------------\n' + System.JSON.serializePretty(caso));    

            Database.UpsertResult upsertCaso = Database.upsert(caso, Case.ID_Solicitud__c);

            /// Se crea Registro de la Lista relacionada Notas a Canales
            if( rec.noteCanal != null && rec.noteCanal != '' ) {
                Notas_a_Canales__c nota = new Notas_a_Canales__c();
                nota.Caso__c = caso.Id;
                nota.Comentarios__c = rec.noteCanal;
                insert nota;
            }
            
            /// Se guarda en un Set los codigos existentes para evitar duplicados
            List<Codigo_de_dudas__c> listCodigosDudasExistentes;
            Set<String> setCodigoName = new Set<String>();
            if( blnCasoReenviado ) {
                listCodigosDudasExistentes = [SELECT Name FROM Codigo_de_dudas__c WHERE Caso__c =: caso.Id ];
                for(Codigo_de_dudas__c codigo: listCodigosDudasExistentes) {
                    setCodigoName.add(codigo.Name);
                }
            }

            //Crear objetos relacionados [Codigo_de_dudas__c]
            List<Codigo_de_dudas__c> listCodigos = new List<Codigo_de_dudas__c>();
            set<String> codigosV = new set<String>();
            
            for(RecuperarInfoSolicitudJSON.CodesDoubt item : rec.codesDoubt){

                /// Se valida si es un caso reenviado y si el codigo ya existe
                if( (blnCasoReenviado && !setCodigoName.contains(item.code)) || (!blnCasoReenviado) ) {

                    Codigo_de_dudas__c aux = new Codigo_de_dudas__c();
                    aux.Caso__c = caso.Id;
                    aux.Name = item.code;
                    aux.Descripci_n__c = item.description;
                    listCodigos.add(aux);
                    codigosV.add(item.code);
                    ///
                    System.debug('item:  ' + item );
                }         
            }
            
            if(listCodigos.size()>0){
                insert listCodigos;
            }

            /// Se guarda en un Set las Validaciones del Caso existentes para evitar duplicados
            List<Validaciones_del_Caso__c> listValidacionCasoExistentes;
            Set<String> setValidacionCasoName = new Set<String>();
            if( blnCasoReenviado ) {
                listValidacionCasoExistentes = [SELECT Name FROM Validaciones_del_Caso__c WHERE Case__c =: caso.Id ];
                for(Validaciones_del_Caso__c validacionCaso: listValidacionCasoExistentes) {
                    setValidacionCasoName.add(validacionCaso.Name);
                }
            }
            
            //generar validaciones y verificación
            List<Validaciones_de_Codigo_CM__mdt> validaciones = checkValidaciones(codigosV);
            List<Validaciones_del_Caso__c> validacionesToInsert = new List<Validaciones_del_Caso__c>();
            List<Verificaci_n_Telef_nica__c> verificacionesTel = new List<Verificaci_n_Telef_nica__c>();
            boolean verificacion = false;
            
            for(Validaciones_de_Codigo_CM__mdt iter : validaciones){
                
                if(iter.Catalogo_Codigos_CM__r.Verificacion_Telefonica__c && verificacion == false){
                    
                    verificacion = true;
                    Id recordTypeId = Schema.SObjectType.Verificaci_n_Telef_nica__c.getRecordTypeInfosByName().get(RT_VT_VILLAGARCIA).getRecordTypeId();
                    Id recordTypeId2 = Schema.SObjectType.Verificaci_n_Telef_nica__c.getRecordTypeInfosByName().get(RT_VT_GLOBAL).getRecordTypeId();  
                    
                    Verificaci_n_Telef_nica__c veriAux = new Verificaci_n_Telef_nica__c();
                    veriAux.Caso__c = caso.Id;
                    
                    if(caso.Cupo__c > 20000 || caso.Sucursal__c == 'Villa de García'){
                        veriAux.RecordTypeId  = recordTypeId;
                    }else{
                        veriAux.RecordTypeId  = recordTypeId2;
                    }
                    
                    verificacionesTel.Add(veriAux);
                    
                }
                
                /// Se valida si es un caso reenviado y los registro de Validaciones del Caso para evitar duplicados
                if(  !setValidacionCasoName.contains(iter.Catalogo_Validaciones_CM__r.Label) ) {

                    Validaciones_del_Caso__c validAux = new Validaciones_del_Caso__c();
                    validAux.Case__c = caso.Id;
                    validAux.Name = iter.Catalogo_Validaciones_CM__r.Label;
                    validacionesToInsert.Add(validAux);

                    setValidacionCasoName.add(iter.Catalogo_Validaciones_CM__r.Label);
                }                    
            }
            
            if(validacionesToInsert.size() > 0){
                insert validacionesToInsert;
            }
            if(verificacionesTel.size() > 0){
                insert verificacionesTel;
            }    

            if( upsertCaso.isSuccess() ) {

                success = true;
            }
        } catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
        }
        ///
               
        result.put('success', success);
        result.put('idCaso', caso.Id);

        return result;
    }

    public static List<Validaciones_de_Codigo_CM__mdt> searchInfoValidacion(String code) {
        
        List<Validaciones_de_Codigo_CM__mdt> validacion = [
            Select 	
            Catalogo_Codigos_CM__r.Label,       
            Catalogo_Codigos_CM__r.Descripci_n__c,
            Catalogo_Codigos_CM__r.Verificacion_Telefonica__c,
            Catalogo_Validaciones_CM__r.Label 
            FROM Validaciones_de_Codigo_CM__mdt 
            WHERE Catalogo_Codigos_CM__r.Label =: code
        ];
        ///
        System.debug('validacion --------->  ' + validacion);
        
        return validacion;
    }
    
    public static List<Validaciones_de_Codigo_CM__mdt> checkValidaciones(set<String> codes) {
        
        List<Validaciones_de_Codigo_CM__mdt> listValidaciones = new List<Validaciones_de_Codigo_CM__mdt>();
        
        for (String it : codes){
            ///
            System.debug('it ------------->  ' + it);
            
            for(Validaciones_de_Codigo_CM__mdt item : searchInfoValidacion(it)){
                
                if(!listValidaciones.contains(item)){
                    
                    System.debug('----------------------------------------------');
                    System.debug('Código :'+item.Catalogo_Codigos_CM__r.Label);
                    System.debug('Descripción :'+item.Catalogo_Codigos_CM__r.Descripci_n__c);
                    System.debug('Verificación telefónica :'+item.Catalogo_Codigos_CM__r.Verificacion_Telefonica__c);
                    System.debug('Validación :'+item.Catalogo_Validaciones_CM__r.Label );
                    System.debug('----------------------------------------------');
                    listValidaciones.add(item);
                }    
            }            
        }
        
        return listValidaciones;        
    }
}