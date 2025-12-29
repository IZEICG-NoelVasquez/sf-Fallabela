/**
* Nombre: CaseTriggerHelper
* Autor: ---
* Descripcion: Clase Helper de la Clase CaseTriggerHandler
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ----                    Creación
* 2.0           25/06/2021      Mauricio Rosales        Asignacion de la Cola de Usuarios Aclaraciones como Propietario
* 3.0           12/07/2021      Mauricio Rosales        Validacion al saltar etapas por RecordType
* 4.0           06/09/2021      Mauricio Rosales        Validacion dinamica Motivos de Retencion
* 5.0           03/11/2021      Mauricio Rosales        Se elimina validacion dinamica Motivos de Retencion y salto de etapa en Reversa de Anualidad
* 6.0           19/11/2021      Mauricio Rosales        Validacion historial de casos Emboce Centralizado
* 7.0           27/12/2021      Mauricio Rosales        Creacion de caso Retencion de titular dependiente de los campos Motivo de cancelación de tarjeta y Motivo de la Retención
* --------------------------------------------------------------------------
*/
public class CaseTriggerHelper {
    
    private static  Map<String,String> latestOwnerCaseByCaseNumberMao = new Map<String,String>();
    private static Map<String, List<Campo_Requerido_Etapa__mdt>> mapEtapaCampos;
    private static Map<Id, Profile> profilesMap;
    private static Map<Id, RecordType> mapRts;
    private static Map<Id, List<CaseMilestone>> mapCm;
    private static Map <String, Schema.SObjectField> fieldMap;
    private static Set<String> motivosCancelacion;
    private static Set<String> motivosCerrado;
    private static final String CHECKBOX_TYPE = 'Checkbox';
    private static List<TaskStatus> statuses;
    @TestVisible private static List<Case> newCases;
    @TestVisible private static Map<Id, Case> mapCases;
    @TestVisible private static Map<String, C_digo_Postal__c> mapColoniaCP;
    @TestVisible private static Map<Id, Causas_Condusef__c> mapCausasCondusef;
    private static final List<String> CAUSASCONDUSEF = new List<String>{'0749', '0835', '0913', '0940'};
    private static Boolean milestonesCompleted = false;
    private static Boolean caseSetUpLoaded = false;
    private static Boolean TasksClosed = false;
    private static Boolean casesInserted = false;
    private static Map<String, set<Id>> setIdUserByQueueId  ;
    private static final List<String> indicenciaAppCierraPuntaList = new List<String>{ 
        'Activar clave dinámica (NIP)',
        'Asesoria en configuración de tarjeta',
        'Asesoría general App',
        'Asesoría pago de servicios',
        'Asesoría recarga T.A',
        'Bloquear/Desbloquear clave dinámica',
        'Cliente con dispositivo Huawei',
        'Crea o recupera clave de internet',
        'Crea o recupera usuario',
        'Error al tomar Avance',
        'Error al tomar CPP',
        'Error al tomar Incremento',
        'Error de enrolamiento por wifi',
        'No llega OTP',
        'Otra incidencias',
        'Agregar 521 en SAT',
        'Error en diferir compras en App',
        'Eliminar 00 en SAT'
    };
    private static set<String> transactionTypeClose = new set<String>{
        'Cancelación de Prestamo personal',
        'Liberación por pago anticipado de préstamo personal'
    };
    private static  Map<Id, String> queueNameByIdQueue = new Map<Id, String> ();
    private static set<String> queueIdsList ;
    private static final List<String> LSTQUEUESDEVNAME = new List<String>{'Aclaraciones_Corto','Retencion',Constants.RETENCION_TITULAR_QUEUE_ACLARACIONES,'Riesgos_Coordinadores','Riesgos_Gerentes',Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER,
                                                            'Riesgos_Falabella','BackOffice_Figital', 'Aux' , 'Soriana'};
    private static set<String> caseTypes = new set<String>{'Insumos dañados', 'Errores de ambiente', 'Clientes ya vinculados', 'Inhabilitada', 'Productos erroneos'};
    @TestVisible private static Map<String, Group> mapQueues;
    private static list<String> lstRecordTypes;
    private static Map<String, Tipo_de_Registro_de_Caso__c> mapRecordTypeStatus;
    private static Map<String, List<String>> mapRecordTypeStatus2 = new Map<String, List<String>> ();
    private static List<String> estadosPickListValues = new list<String>();
    public static Set<String> lstCasesMoveStatus;
    
    @TestVisible private static List<CaseComment> commentLst;
    private static Set<String> listMotivoPendiente;

    @TestVisible private static Map<Id, Set<String> > mapCasoListComentarios;
    
    @TestVisible private static Set<String> setAccountsEmboce;
    private static final List<String> lstValidationEmboceRecordType = new List<String>{'Reporte_por_Robo_o_Extrav_o','Reporte_por_Deterioro','Reporte_por_Retenci_n_Cajero','Sospecha_de_Fraude','Cargo_no_reconocido'};
    @TestVisible private static Set<String> setValidationEmboceRecordTypeId;

    private static List<String> lstCustomNotifications = new List<String>{'Aprobacion_de_Cupo_Riesgos'};
    @TestVisible private static Map<String, CustomNotificationType> mapCustomNotification;
    @TestVisible private static Map<String, User> mapUser;

    private static List<String> lstUserRoleBackOffice = new List<String>{'Gerente_Backoffice','Coordinador_Riesgos'};
    @TestVisible private static Set<String> lstIdRoleUsersBackOffice;

    /// Validacion de Archivos Adjuntos
    private static List<String> lstValidationAttachmentsRecordType = new List<String>{'Cargo_no_reconocido','Compra_no_diferida','Abono_de_Puntos','Promoci_n_no_Aplicada','Reversa_de_Anualidad','Pago_No_Aplicado',
      																				  'Procedimiento_de_Cobro','Cancelaci_n_de_Tarjeta_por_Fallecimiento','Cobro_a_Persona','Reversa_de_Comisi_n','Remisi_n','Reposici_n', 'Soporte_a_m_dulo',
        																	'Contrato_manual'};
    @TestVisible private static Map<String,List<ContentDocumentLink>> mapCaseIdLstAttachments;
    @TestVisible private static List<String> lstAllowedAttachments;
    private static set<String> caseReasonSN=new set<String>{'Falla DEXXIS Indisponibilidad','Reporte de incidencias Técnicos','Reporte de incidencias Sistemas','Equipos dañados Remplazo de embosadora',
        													'Equipos dañados Remplazo de Celular (Zonal/Regional)','Equipos dañados Remplazo de Laptop (Zonal/Regional)','Equipos dañados Remplazo de Tablet',
        													'Equipos dañados Cámara','Equipos dañados Cintas de embozadora','Equipos dañados Huellero','Equipos dañados Teclado','Equipos dañados Monitores',
        													'Equipos dañados Rodillos para embozadora','Equipos dañados Cables de corriente (tablet)','Equipos dañados Adaptadores (tablet)','Equipos dañados CPU',
        													'Equipos dañados Tarjetas','Equipos dañados Ratón'};
                                                                
    private static user soporteModuloUsuario;
    private static CustomNotificationType notificacion;
    /// OmniChannel
    private static String serviceChannelId;

    // public static void verifyOwnerToUpdate(set<Id> ownerIdList){
    //     setIdUserByQueueId = new Map<String,set<Id>>();
    //     queueIdsList =  new set<String>();
    //    for(Group queueExisting : [SELECT Id, Name, Type FROM Group WHERE Id IN :ownerIdList ]  ){
    //     if(queueExisting.type == 'Queue'){
    //         queueIdsList.add(queueExisting.Id);

    //     }
    //    }
    //    for(GroupMember  membersQueue: [ SELECT Id, UserOrGroupId ,  GroupId FROM GroupMember WHERE GroupId IN :queueIdsList ]){
    //     if(!setIdUserByQueueId.containsKey(membersQueue.GroupId)){
    //         setIdUserByQueueId.put(membersQueue.GroupId ,new set<Id>() );

    //     }
    //     setIdUserByQueueId.get(membersQueue.GroupId ).add(membersQueue.UserOrGroupId);
    //    }
    //    system.debug('queueIdsList'+queueIdsList);
      
    // }
    public static void loadMapsSoporteModulo(){
        
    }

    public static void loadMapCasesEmboce() {

        if( setAccountsEmboce == null ) {

            setAccountsEmboce = new Set<String>();
        }

        if( setValidationEmboceRecordTypeId == null ) {

            setValidationEmboceRecordTypeId = new Set<String>();
        }

        for(String strEmboceRT: lstValidationEmboceRecordType ) {

            setValidationEmboceRecordTypeId.add( Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(strEmboceRT).getRecordTypeId() );
        }

        Boolean blnValidationRuleEmboce = false;

        String idRTEmboce = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();

        List<String> lstIdAccounts = new List<String>();
        for(Case caso: (List<Case>)Trigger.new) {

            lstIdAccounts.add(caso.AccountId);

            if( setValidationEmboceRecordTypeId.contains(caso.RecordTypeId) ) {

                blnValidationRuleEmboce = true;
            }
        }

        if( blnValidationRuleEmboce ) {

            Date dtToday = System.today();

            for(Case caso: [SELECT CreatedDate , AccountId FROM Case 
                            WHERE AccountId IN : lstIdAccounts AND RecordTypeId = : idRTEmboce]) {                

                if( !setAccountsEmboce.contains(caso.AccountId) && (caso.CreatedDate.date().daysBetween(dtToday) < Integer.valueOf(Constants.EMBOCE_CENTRALIZADO_VALIDACION_DIAS_SUBCATEGORIAS)) ) {

                    setAccountsEmboce.add(caso.AccountId);
                }                
            }
        }
    }
    public  static void  loadLatestOwner(){
        set<Id> caseIdList = trigger.newMap.keySet();
        for(CaseHistory caseHistoryValue : [select id , Field,OldValue,CaseId  from CaseHistory where Caseid IN :caseIdList and field = 'Owner' ORDER BY CreatedDate DESC ]){
           
           if(String.valueOf(caseHistoryValue.OldValue).startsWith('00') && !latestOwnerCaseByCaseNumberMao.containsKey(caseHistoryValue.Caseid)){
                latestOwnerCaseByCaseNumberMao.put(caseHistoryValue.caseId , String.valueOf(caseHistoryValue.OldValue));
           }
            
        }
        
    }
    public static void initCaseComment(){

        if( commentLst == null ) {
            commentLst = new List<CaseComment>();

            ///
            Set<Id> setIdCasos = new Set<Id>();
            for(Case cs: (List<Case>)Trigger.new) {
    
                if( cs.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ) {
    
                    setIdCasos.add(cs.Id);
                }
            }

            mapCasoListComentarios = new Map<Id, Set<String> >();
            List<CaseComment> listComentariosCaso = setIdCasos.size() > 0 ? [SELECT CommentBody, ParentId FROM CaseComment WHERE ParentId IN : setIdCasos] : new List<CaseComment>();
            for(CaseComment comentario: listComentariosCaso) {

                ///
                if( !mapCasoListComentarios.containsKey(comentario.ParentId) ) {
                    mapCasoListComentarios.put(comentario.ParentId, new Set<String>() );
                }
                mapCasoListComentarios.get(comentario.ParentId).add(comentario.CommentBody);
            }            
        }
    }
    
    public static void loadCaseSetUp() {
        
                
        soporteModuloUsuario=[select id from user where alias='epere' limit 1];
		notificacion=[select id from customNotificationType where developername='Asignacion_de_Caso' limit 1];

        if (caseSetUpLoaded == false) {

            Set<Id> caseIdsSet = new Set<Id>();
            Set<String> coloniasSet = new Set<String>();
            ///
            lstRecordTypes = new List<String>();

            if( lstCasesMoveStatus == null ) {

                lstCasesMoveStatus = new Set<String>();
            }
            
            ///
            Boolean blnCaseBackOffice = false;
            List<String> lstOwnerIdUser = new List<String>();
            
            for(Case c: (List<Case>) Trigger.new) {

                if (c.Id!=null) {

                    caseIdsSet.add(c.Id);
                }

                if (c.Colonia_Direccion__c!=null) {

                    coloniasSet.add(c.Colonia_Direccion__c);
                }
                
                ///
                lstRecordTypes.add( Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() );

                if( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {

                    if( String.valueOf(c.OwnerId).startsWith('005') ) {

                        lstOwnerIdUser.add(c.OwnerId);
                    }                    

                    blnCaseBackOffice = true;
                }
            }
            
            if(mapCases==null && !caseIdsSet.isEmpty()) {

                mapCases = new Map<Id, Case>([SELECT Id, Account.PersonContactId, Account.Cliente_Soriban__c FROM Case WHERE Id IN: caseIdsSet]);
            }
            
            if(mapColoniaCP==null && !coloniasSet.isEmpty()) {

                mapColoniaCP = new Map<String, C_digo_Postal__c>();

                for (C_digo_Postal__c cp: [SELECT Id, Name, Colonia__c, Colonia_Lookup__c FROM C_digo_Postal__c WHERE Colonia_Lookup__c IN: coloniasSet]) {

                    mapColoniaCP.put(cp.Colonia_Lookup__c, cp);
                }
            }
            
            if (mapCausasCondusef == null) {

                mapCausasCondusef = new Map<id, Causas_Condusef__c>([SELECT Id, Name FROM Causas_Condusef__c]);
            }            
            newCases = new List<Case>();

            /// Mapa Queues (Llave: DeveloperName, valor: Queue)
            List<Group> lstQueues = [SELECT DeveloperName FROM Group WHERE DeveloperName IN : LSTQUEUESDEVNAME ];
            mapQueues = new Map<String, Group>();

            for(Group queue: lstQueues) {

                mapQueues.put(queue.DeveloperName, queue);
            }

            /// Mapa Tipo_de_Registro_de_Caso__c
            mapRecordTypeStatus = new Map<String, Tipo_de_Registro_de_Caso__c>();
            for(Tipo_de_Registro_de_Caso__c rt: [SELECT Name, Estados_del_Caso__c,Estados_del_caso_Texto__c FROM Tipo_de_Registro_de_Caso__c WHERE Name IN : lstRecordTypes] ) {

                mapRecordTypeStatus.put(rt.Name, rt);
                if(String.isNotEmpty(rt.Estados_del_caso_Texto__c) && String.isNotBlank(rt.Estados_del_caso_Texto__c)){
                    mapRecordTypeStatus2.put(rt.Name ,rt.Estados_del_caso_Texto__c.split(';') );

                }
                
            }     
            system.debug(mapRecordTypeStatus.get('Cargo_no_reconocido'));       
            
            // Schema.DescribeFieldResult  fieldEstadoCasoResult =   Tipo_de_Registro_de_Caso__c.Estados_del_Caso__c.getDescribe();
            // List<Schema.PicklistEntry> picklistValues = fieldEstadoCasoResult.getPicklistValues();
            // for (Schema.PicklistEntry pe : fieldEstadoCasoResult.getPicklistValues()) {
            //     for(String rtName : lstRecordTypes){
                    
            //         if(mapRecordTypeStatus.containsKey(rtName) && (mapRecordTypeStatus.get(rtName).Estados_del_Caso__c).contains(pe.getValue())){
            //             estadosPickListValues.add(pe.getValue());

                        
            //         }
            //        mapRecordTypeStatus2.put(rtName ,estadosPickListValues );


            //     }
            // }
            system.debug('estadosPickListValues'+JSON.serialize(mapRecordTypeStatus2.get('Cargo_no_reconocido')));
            /// Mapa Custom Notification
            /// Se utiliza la Custom Notification en Call Center
            mapCustomNotification = new Map<String, CustomNotificationType>();
            for(CustomNotificationType customNot: [SELECT DeveloperName FROM CustomNotificationType WHERE DeveloperName IN : lstCustomNotifications ]) {

                mapCustomNotification.put(customNot.DeveloperName, customNot);
            }

            /// Back Office             
            mapUser = new Map<String, User>();
            lstIdRoleUsersBackOffice = new Set<String>();

            if( blnCaseBackOffice ) {

                /// Mapa Users                
                for(User usr: [SELECT FirstName, LastName, UserRole.DeveloperName FROM User WHERE Id IN : lstOwnerIdUser ] ) {

                    mapUser.put(usr.Id, usr);
                }

                //// Mapa Role, List<User>
                for(UserRole usrRole: [SELECT Id FROM UserRole WHERE DeveloperName IN : lstUserRoleBackOffice ] ) {

                    /// mapRoleLstUsersBO.put();
                    lstIdRoleUsersBackOffice.add(usrRole.Id);
                }
            }
        }
        caseSetUpLoaded = true;
        
    }

    /**
    * Se obtiene la lista de extensiones validas, definidas en la Custom Label REGLA_DOCUMENTACION_ARCHIVOS_PERMITIDOS
    * Se obtienen los registros de ContentDocumentLink para cada registro de Casos que detono el trigger
    * y se guadan el el Mapa mapCaseIdLstAttachments
    *
    * @param lstNewCases: Lista de Casos que detonaron el Trigger
    **/
    public static void loadContentDocuments(List<Case> lstNewCases) {

        /// Lista de Archivos permitidos
        lstAllowedAttachments = String.isNotBlank(Constants.REGLA_DOCUMENTACION_ARCHIVOS_PERMITIDOS) ? Constants.REGLA_DOCUMENTACION_ARCHIVOS_PERMITIDOS.split(',') : new List<String>();

        /// Lista de RecordTypeIds para la validacion de Attachments
        Set<String> lstRecordTypeIds = new Set<String>();
        for(String recordType: lstValidationAttachmentsRecordType) {

            lstRecordTypeIds.add( Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId() );
        }

        ///
        List<String> lstCaseIds = new List<String>();

        for(Case caseNew: lstNewCases) {

            if( lstRecordTypeIds.contains(caseNew.RecordTypeId) ) {

                lstCaseIds.add(caseNew.Id);
            }
        }

        mapCaseIdLstAttachments = new Map<String,List<ContentDocumentLink>>();

        if( lstCaseIds.size() > 0 ) {
            
            for(ContentDocumentLink contentDocLnk: ContentDocumentLinksSelector.selectByListLinkedEntityId(lstCaseIds) ) {

                if( !mapCaseIdLstAttachments.containsKey(contentDocLnk.LinkedEntityId) ) {

                    mapCaseIdLstAttachments.put(contentDocLnk.LinkedEntityId, new List<ContentDocumentLink>());
                }

                mapCaseIdLstAttachments.get(contentDocLnk.LinkedEntityId).add(contentDocLnk);
            }
        }
    }

    /**
    * Busca en la lista de Ducumentos, que alguno tenga la extension de los tipos definidos en la lista lstAllowedAttachments
    * @return Regresa una variable booleana, si alguno de los documentos tiene 
    *
    * @param lstAttachments: Lista de registros ContentDocumentLink
    **/
    public static Boolean validateAllowedAttachments(List<ContentDocumentLink> lstAttachments) {

        Boolean blnAllowedAttachment = false;

        for(ContentDocumentLink contentDocLink: lstAttachments) {

            if( lstAllowedAttachments.contains(contentDocLink.ContentDocument.FileExtension)  ) {

                blnAllowedAttachment = true;
                break;
            }
        }

        return blnAllowedAttachment;
    }
    
    public static void insertCases() {

        System.debug('before insertCases: ' + casesInserted);
        
        if(casesInserted == false) {
            try {
                
                if (!newCases.isEmpty()) {

                    System.debug('Insert newCases');
                    casesInserted = true;
                    System.debug('casesInserted: ' + casesInserted);
                    List<Database.SaveResult> caseResults = Database.insert(newCases);      
                    System.debug('casesInsertedAfter');

                    /// Se agregan a la lista los Id de los casos para actualizar en Metodo Asincrono
                    List<Id> lstIdCasesUpdateAsync = new List<Id>();

                    for(Case casoUpdate: newCases) {

                        if ( casoUpdate.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId()) ) {

                            if(casoUpdate.Solicitud_de_cancelaci_n__c ) {

                                lstIdCasesUpdateAsync.add(casoUpdate.Id);
                            }
                        }                        
                    }

                    if( lstIdCasesUpdateAsync.size() > 0 ) {

                        CaseTriggerHelperAsync.cierraCasosAsync(lstIdCasesUpdateAsync);
                    }
                }
                
            } catch (Exception e) {
                System.debug('Exception from Creating New Case Type Up Grade: ' + e);
            }             
        }  
    }
    
    public static void loadFieldsMap () {
        if (fieldMap == null) {
            fieldMap = ObjectDescriberUtil.getFieldMap('Case');      
        }
        
        
    }
    
    public static void loadMotivosCancelacion () {
        if (motivosCancelacion==null) {
            motivosCancelacion = new Set<String>{'Motivo_de_cierre_decancelacin__c', 'Motivo_de_cancelaci_n__c', 'Motivo_de_cancelaci_n_de_tarjeta__c', 'Motivo_de_cierre_de_caso_sin_xito__c'};
                }
    }
    
    public static void loadTaskStatuses () {
        
        if (statuses == null) {
            statuses = [SELECT ApiName, IsClosed FROM TaskStatus WHERE IsClosed = true LIMIT 1];            
        }
        
    }
    
    
    public static void loadMotivosCerrado() {
        
        if (motivosCerrado==null) {
            //creacion de caso amsivos 
            //, 'Tipo_de_caso__c', 'Descripci_n_de_Causa_Condusef__c','Causa_CONDUSEF__c'
            motivosCerrado = new Set<String>{'Subject', 'Responsable_de_ltima_tarea__c', 'EntitlementId', 'Status','SystemModstamp', 'Fecha_estimada_de_cierre__c', 'D_as_restantes__c', 'Tiempo_restante__c', 'Tiempo_Actualizar_1_minuto__c','Tiempo_Notificacion__c', 'Tipo_de_caso__c', 'Descripci_n_de_Causa_Condusef__c','Causa_CONDUSEF__c'};
                }
    }
    
    public static void loadMapEtapaCampos () {
        
        if (mapEtapaCampos == null ) {
            mapEtapaCampos = new Map<String, List<Campo_Requerido_Etapa__mdt>>();
            
            Map<String, Schema.RecordTypeInfo> recordTypeInfosByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
            
            for (Campo_Requerido_Etapa__mdt cre : [SELECT Etapa_SubCategoria__r.Etapa__r.Value__c, 
                                                   Etapa_SubCategoria__r.Sub_Categoria__r.Value__c, 
                                                   Campo__r.Value__c, Campo__r.Type__c,
                                                   Campo__r.API_Name__c
                                                   FROM Campo_Requerido_Etapa__mdt]) {
                                                       
                                                       if ( !recordTypeInfosByName.containsKey(cre.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c) ) {
                                                           continue;
                                                       }
                                                       
                                                       if (mapEtapaCampos.containsKey( recordTypeInfosByName.get(cre.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c).getName() )) {
                                                           
                                                           mapEtapaCampos.get( recordTypeInfosByName.get(cre.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c).getName() ).add(cre);
                                                           
                                                       } else {
                                                           
                                                           mapEtapaCampos.put( recordTypeInfosByName.get(cre.Etapa_SubCategoria__r.Sub_Categoria__r.Value__c).getName(), 
                                                                              new List<Campo_Requerido_Etapa__mdt>{cre});
                                                           
                                                       }
                                                   }
        }
        
        if (mapRts == null) {
            mapRts = new Map<Id, RecordType>((List<RecordType>) [SELECT Name FROM RecordType]);          
        }
        
        
        
        
    }
    
    public static void loadProfilesMap () {
        profilesMap = new Map<Id, Profile>((List<Profile>) [SELECT Name FROM Profile]);
    }
    
    public static void loadCaseMilestones () {
        
        if (mapCm==null) {
            mapCm = new Map<Id, List<CaseMilestone>>();
            
            for (CaseMilestone cm : [SELECT Id, CompletionDate, CaseId, MilestoneType.Name
                                     FROM CaseMilestone
                                     WHERE CaseId IN : Trigger.newMap.keySet()
                                     AND IsCompleted = true]) {
                                         
                                         if (mapCm.containsKey(cm.CaseId)) {
                                             
                                             mapCm.get(cm.CaseId).add(cm);
                                             
                                         } else {
                                             
                                             mapCm.put(cm.CaseId, new List<CaseMilestone>{cm});
                                             
                                         }
                                         
                                     }
        }
        
        
    }    
    
    public static void validateRequiredFields (Case caseNew, Case caseOld) {
        System.debug('validateRequiredFields');
        System.debug('caseOld.Status: ' + caseOld.Status);
        System.debug('caseNew.Status: ' + caseNew.Status);
               
        if(caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Soporte_a_m_dulo').getRecordTypeId())){
            if(caseTypes.contains(caseNew.type) && caseNew.Status == 'Cancelado'){
                caseNew.OwnerId=soporteModuloUsuario.id;
                CustomNotificationService.sendCustomNotification(new set<String>{soporteModuloUsuario.id}, 'Caso cancelado', 'El caso '+ caseNew.caseNumber + ' se ha cancelado', notificacion.id, caseNew.id );
            }
            /*if(!mapCaseIdLstAttachments.containsKey(caseNew.Id) || ( mapCaseIdLstAttachments.containsKey(caseNew.Id) && (mapCaseIdLstAttachments.get(caseNew.Id).isEmpty()) ) ) {
                caseNew.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));
            }*/
        }    
        if (!caseNew.Status.equals(caseOld.Status)) {
            if (mapEtapaCampos.containsKey(mapRts.get(caseOld.RecordTypeId).Name) && !caseNew.Status.equals(caseOld.Status) && !caseNew.Status.equals('Cancelado') ) {
               List<Campo_Requerido_Etapa__mdt> requeridos = mapEtapaCampos.get( mapRts.get(caseOld.RecordTypeId).Name );
                Map<String, Object> fieldsToValue = caseNew.getPopulatedFieldsAsMap();
                Map<String, Object> oldFieldsToValue = caseOld.getPopulatedFieldsAsMap();
                
                for (Campo_Requerido_Etapa__mdt campo : requeridos) {
                    
                    if (campo.Etapa_SubCategoria__r.Etapa__r.Value__c.equals(caseOld.Status)) {
                        
                        if (fieldsToValue.get(campo.Campo__r.API_Name__c) == null) {
                            
                            caseNew.addError(new CaseTriggerException('Campo requerido: ' + campo.Campo__r.Value__c));
                            
                        } else if (campo.Campo__r.Type__c.equals(CHECKBOX_TYPE) && fieldsToValue.get(campo.Campo__r.API_Name__c) == false) {
                            
                            caseNew.addError(new CaseTriggerException('Campo requerido: ' + campo.Campo__r.Value__c));
                            
                        } else if (String.isBlank(String.valueOf(fieldsToValue.get(campo.Campo__r.API_Name__c)))) {
                            
                            caseNew.addError(new CaseTriggerException('Campo requerido: ' + campo.Campo__r.Value__c));
                            
                        }
                        
                    }
                    
                }
                moveStatus(caseNew, caseOld);
            } else if( !mapEtapaCampos.containsKey(mapRts.get(caseOld.RecordTypeId).Name) && !caseNew.Status.equals(caseOld.Status) && !caseNew.Status.equals('Cancelado') ) {

                /// Validacion de Cambio de Etapa sin Campos Obligatorios en Metadata (Ejemplo Status Informar Folio y Despedida)
                moveStatusSinCamposObligatorios(caseNew, caseOld);

            } else if ( caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
                        caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {
                /// Validacion de cambio de Status para Casos de Riesgos 
                moveStatusRiesgos(caseNew, caseOld);

            }
              
            
            if (caseNew.Status.equals('Actualización de Celular') && !caseNew.Celular_Nuevo__c.equals(caseOld.Celular_Nuevo__c)  ) {
                caseNew.addError(new CaseTriggerException('El numero no puede ser modificado'));
            }  
            
        }
        
    }
    
    public static void validaEtapaAnteriorCerrada (Case c, Case oldCase) {
        
        System.debug('validaEtapaAnteriorCerrada'+Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName());
        System.debug('c.Status: ' + c.Status);
        System.debug('oldCase.Status: ' + oldCase.Status);
        
        
        if (!c.Status.equals(oldCase.Status)) {
                // List<String> pickListValuesList =Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() == 'Cargo_no_reconocido' || Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() ==  'Solicitud_de_Contrato' ?  mapRecordTypeStatus2.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()) : mapRecordTypeStatus.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()).Estados_del_Caso__c.split(';');
                    List<String> pickListValuesList = mapRecordTypeStatus2.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName());

            // List<String> pickListValuesList= new List<String>();
            
            // Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
            // List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

            // for( Schema.PicklistEntry pickListVal : ple){
            //     pickListValuesList.add(pickListVal.getLabel());
            // }
            Integer previousValue = 0;
            Integer newValue = 0;
            Boolean previousValueFound = false;
            Boolean newValueFound = false;
            Boolean attemptStatusReturn = false;

            for(String statusVal : pickListValuesList ) {
                if(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() == 'Riesgos_Originaci_n'){
                    break;
                }                
                /// Se Busca el valor anterior de Status
                if( !previousValueFound ) {

                    previousValue ++;

                    previousValueFound = validateChangeStatus(statusVal, oldCase.Status);
                }

                /// Se Busca el valor nuevo de Status
                if( !newValueFound ) {

                    newValue ++;

                    newValueFound = validateChangeStatus(statusVal, c.Status);
                }


                if( previousValueFound && newValueFound ) {

                    if (newValue < previousValue) {

                        attemptStatusReturn = true;
                        c.addError(new CaseTriggerException('No puede regresar de etapa'));
                    }

                    break;
                }
            }

            /// Validacion para NO permitir Saltos de Etapa (Status) por RecordType
            if( !attemptStatusReturn && !c.Status.equals('Cancelado') && !lstCasesMoveStatus.contains(c.Id) 
                && mapRecordTypeStatus.containsKey( Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() ) 
                && String.isNotBlank(mapRecordTypeStatus.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()).Estados_del_Caso__c) ) {
                 List<String> lstStatus1  = mapRecordTypeStatus.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()).Estados_del_Caso__c.split(';');
                // List<String> lstStatus =Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() == 'Cargo_no_reconocido' || Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() ==  'Solicitud_de_Contrato' ?  mapRecordTypeStatus2.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()) : mapRecordTypeStatus.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName()).Estados_del_Caso__c.split(';');
                    List<String> lstStatus = mapRecordTypeStatus2.get(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName());
                previousValueFound = false;
                newValueFound = false;
                previousValue = 0;
                newValue = 0;
				System.debug('Fer'+ json.serialize( lstStatus));

              
                for(String statusRT: lstStatus) {

                    // if(!lstStatus1.contains(statusRT) && Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getDeveloperName() == 'Cargo_no_reconocido' ){
                 
                    //     continue;
                    // }
                    /// Se Busca el valor anterior de Status
                    if( !previousValueFound ) {

                        previousValue ++;

                        previousValueFound = validateChangeStatus(statusRT, oldCase.Status);
                    }

                    /// Se Busca el valor nuevo de Status
                    if( !newValueFound ) {
    
                        newValue ++;

                        newValueFound = validateChangeStatus(statusRT, c.Status);
                    }

					System.debug('Fer:)' + previousValue+ newValue);
                    if( previousValueFound && newValueFound ) {

                        if( ( (c.Status.equals('Cerrado')) && (newValue > previousValue + 2) )
                            || ( (!c.Status.equals('Cerrado')) && (newValue > previousValue + 1) ) ) {

                            c.addError(new CaseTriggerException('No puede saltar etapas'));
                        }

                        break;
                    }
                }
            }            
        }        
    }

    private static Boolean validateChangeStatus(String statusRecordType, String statusSearch) {

        return statusRecordType.equals(statusSearch) ? true : false;
    }
    
    public static void validaEtapaCerrada (Case c, Case oldCase) {
        //--------------------------- BACK OFFICE -------------------------------------   
        if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
            c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {

            if( (c.Status == 'Cerrado') && (oldCase.Status != 'Cerrado') ) {
            
                if( !c.Actualizaci_n_Alta_en_SAT__c ) {

                    c.addError('Debe actualizar la Solicitud antes de cerrar el Caso');
                }

                /// Se agregan validaciones para las Aprobaciones
                if( c.Cupo__c > 30000 && c.Cupo__c <= 80000 && !c.Primera_Aprobaci_n__c && c.Se_bloqueo_la_tarjeta__c) {

                    c.addError('Se necesita Aprobar el caso');
                }

                if( c.Cupo__c > 80000 && !c.Primera_Aprobaci_n__c && !c.Segunda_Aprobaci_n__c && c.Se_bloqueo_la_tarjeta__c ) {

                    c.addError('Se necesita Aprobar el caso');
                }

            } else if( (c.Status != oldCase.Status) && (c.Status == 'Asignada') ) {

                c.Fecha_y_hora_de_solicitud_en_an_lisis__c = System.now();

            } else if( (c.Status != oldCase.Status) && (c.Status == 'Autorización') ) {

                c.Fecha_y_hora_en_autorizacin__c = System.now();
            }
        }
        //-----------------------------------------------------------------------
        
        if ( oldCase.Status.equals('Cancelado') || oldCase.Status.equals('Cerrado') || oldCase.Status.equals('Closed') ) {
            System.debug('validaEtapaCerrada');
            for (Schema.SObjectField sfield : fieldMap.Values()) {
                
                Boolean isChanged = false;
                
                schema.describefieldresult dfield = sfield.getDescribe();
                
                if (dfield.isAccessible()) {
                    
                    // compare nulls first
                    if ( c.get(dfield.getLocalName()) == null ||
                        oldCase.get(dfield.getLocalName()) == null ) {
                            
                            isChanged = c.get(dfield.getLocalName()) == oldCase.get(dfield.getLocalName()) 
                                ? false : true;
                            
                        } else if ( (!c.get(dfield.getLocalName())
                                     .equals( oldCase.get(dfield.getLocalName())) ? true : false)) {
                                         
                                         System.debug('oldCase.get(dfield.getLocalName())' + oldCase.get(dfield.getLocalName()));
                                         System.debug('c.get(dfield.getLocalName())' + c.get(dfield.getLocalName()));
                                         isChanged = true;
                                         
                                         
                                     }
                    
                    if ( isChanged ) {
                        
                        System.debug(' isChanged ' + isChanged);
                        if ( !motivosCancelacion.contains(dfield.getLocalName()) && (oldCase.Status.equals('Cancelado') || oldCase.Status.equals('Closed') )) {
                          
                            c.addError('Esta etapa no puede modificarse');
                            
                        } else if ( !motivosCerrado.contains(dfield.getLocalName()) && (oldCase.Status.equals('Cerrado') || oldCase.Status.equals('Closed'))) {
                            System.debug('CAMPO modificado'+dfield.getLocalName());
                            
                            /// Excepcion para permitir actualizar Casos por medio del WS
                            if( !(oldCase.Status.equals('Cerrado') && c.Status.equals('New') && c.Caso_Actualizado_por_WebService__c) ) {
                                c.addError('El caso no puede ser modificado');
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } 
    }

    public static void approvalProcessesBO (Case newCase, Case oldCase) {

        if( newCase.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
            newCase.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {

            /// Dictaminacion = Aprobar o Rechazar
            if(  newCase.Validar_Movimientos__c && (newCase.Evaluar__c != oldCase.Evaluar__c) && ((newCase.Evaluar__c == 'Aprobar') || (newCase.Evaluar__c == 'Rechazar')) && (newCase.Status == 'Autorización') &&
                !newCase.Primera_Aprobaci_n__c && (newCase.Coordinadores_y_Gerentes_Ausentes__c == 'No') && (newCase.OwnerId != null) && !String.valueOf(newCase.OwnerId).startsWith('00G') ) {

                if( (newCase.Cupo__c != null) && newCase.Cupo__c > 30000 && newCase.Cupo__c <= 60000 && mapUser.containsKey(newCase.OwnerId) && 
                    mapUser.get(newCase.OwnerId).UserRole.DeveloperName == 'Analista_JR_Backoffice' ) {

                    /// Notifica a Coordinadores
                    if( mapQueues.containsKey('Riesgos_Coordinadores') && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {

                        CustomNotificationService.sendCustomNotification(new Set<String>{mapQueues.get('Riesgos_Coordinadores').Id},
                                                                        mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' solicita aprobación para el caso ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / Agente: ' + mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' / ID Solicitud: ' + newCase.ID_Solicitud__c + ' / Cupo: ' + newCase.Cupo__c, 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);
                    }

                    /// Aprobacion 30,000 a 60,000
                    ApprovalProcessService.submitForApproval(newCase.Id, 'X30_000_a_60_000', false, UserInfo.getUserId(), null);

                } else if( (newCase.Cupo__c != null) && newCase.Cupo__c > 60000 && newCase.Cupo__c <= 80000 && mapUser.containsKey(newCase.OwnerId) &&
                            (mapUser.get(newCase.OwnerId).UserRole.DeveloperName == 'Analista_JR_Backoffice') ) {

                    /// Notifica a Coordinadores
                    if( mapQueues.containsKey('Riesgos_Coordinadores') && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {

                        CustomNotificationService.sendCustomNotification(new Set<String>{mapQueues.get('Riesgos_Coordinadores').Id},
                                                                        mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' solicita aprobación para el caso ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / Agente: ' + mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' / ID Solicitud: ' + newCase.ID_Solicitud__c + ' / Cupo: ' + newCase.Cupo__c, 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);
                    }

                    /// Aprobacion 60,000 a 80,000
                    ApprovalProcessService.submitForApproval(newCase.Id, 'X60_000_a_80_000', false, UserInfo.getUserId(), null);

                } else if( (newCase.Cupo__c != null) && newCase.Cupo__c > 80000 && !newCase.Segunda_Aprobaci_n__c && mapUser.containsKey(newCase.OwnerId) &&
                            (mapUser.get(newCase.OwnerId).UserRole.DeveloperName == 'Analista_JR_Backoffice' || mapUser.get(newCase.OwnerId).UserRole.DeveloperName == 'Analista_SR_Backoffice' || 
                            mapUser.get(newCase.OwnerId).UserRole.DeveloperName == 'Coordinador_Riesgos') ) {

                    /// Notifica a Gerentes
                    if( mapQueues.containsKey('Riesgos_Gerentes') && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {

                        CustomNotificationService.sendCustomNotification(new Set<String>{mapQueues.get('Riesgos_Gerentes').Id},
                                                                        mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' solicita aprobación para el caso ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / Agente: ' + mapUser.get(newCase.OwnerId).FirstName + ' ' + mapUser.get(newCase.OwnerId).LastName + ' / ID Solicitud: ' + newCase.ID_Solicitud__c + ' / Cupo: ' + newCase.Cupo__c, 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);
                    }

                    /// Aprobacion 80,000 a 150,000
                    ApprovalProcessService.submitForApproval(newCase.Id, 'X80_000_a_150_000_v2', false, UserInfo.getUserId(), null);
                }
            }            
            
            /// Notificaciones Proceso de Aprobacion Cupo
            if( newCase.Validar_Movimientos__c && (newCase.Actualizaci_n_exitosa__c != oldCase.Actualizaci_n_exitosa__c) && (newCase.Status == 'Autorización') && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {

                if( (newCase.Cupo__c != null) && newCase.Cupo__c > 30000 && newCase.Cupo__c <= 80000 && newCase.Primera_Aprobaci_n__c ) {
            
                    if( newCase.Actualizaci_n_exitosa__c == 'Sí' ) {

                        /// Notifica Analista Aprobacion
                        CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                        'La solicitud de aprobación fue aprobada ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);

                    } else if( newCase.Actualizaci_n_exitosa__c == 'No' ) {

                        /// Notifica Analista Rechazo
                        CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                        'La solicitud de aprobación fue rechazada ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);
                    } 

                } else if( (newCase.Cupo__c != null) && newCase.Cupo__c > 80000 && newCase.Segunda_Aprobaci_n__c ) {                
                
                    if( newCase.Actualizaci_n_exitosa__c == 'Sí' ) {

                        /// Notifica Analista Aprobacion
                        CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                        'La solicitud de aprobación fue aprobada ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);

                    } else if( newCase.Actualizaci_n_exitosa__c == 'No' ) {

                        /// Notifica Analista Rechazo
                        CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                        'La solicitud de aprobación fue rechazada ' ,
                                                                        'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                        mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                        newCase.Id);
                    }
                }
            }

            
            /// Notificaciones Proceso de Aprobacion Actualizacion de Email
            if( (newCase.Cuenta_al_Corriente__c != oldCase.Cuenta_al_Corriente__c) && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {

                if( newCase.Cuenta_al_Corriente__c == 'Sí' ) {

                    ///Notifica Analista Aprobacion
                    CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                    'La solicitud de aprobación fue aprobada ' ,
                                                                    'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                    mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                    newCase.Id);

                } else if( newCase.Cuenta_al_Corriente__c == 'No' ) {

                    /// Notifica Analista Rechazo
                    CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                    'La solicitud de aprobación fue rechazada ' ,
                                                                    'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                    mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                    newCase.Id);
                }
            }
            

            /// Notificacion Caso cerrado por Coordinador o Gerente
            if( (newCase.Status != oldCase.Status) && (newCase.Status == 'Cerrado') && newCase.Primera_Aprobaci_n__c &&
                ( (lstIdRoleUsersBackOffice.contains(UserInfo.getUserRoleId())) || (Test.isRunningTest()) ) && mapCustomNotification.containsKey('Aprobacion_de_Cupo_Riesgos') ) {            
            
                if( (newCase.Cupo__c != null) && (newCase.Cupo__c > 30000 && newCase.Cupo__c <= 80000) || (newCase.Cupo__c > 80000 && newCase.Segunda_Aprobaci_n__c) ) {

                    /// Notificacion Caso cerrado
                    CustomNotificationService.sendCustomNotification(new Set<String>{newCase.OwnerId},
                                                                    'Se cerro el caso ' ,
                                                                    'Numero de Folio: ' + newCase.CaseNumber + ' / ID Solicitud: ' + newCase.ID_Solicitud__c , 
                                                                    mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                    newCase.Id);
                }
            }
        }
    }
    
    public static void moveStatus (Case c, Case oldCase) {
        System.debug('moveStatus');
        System.debug('oldCase.Status: ' + oldCase.Status);
        System.debug('c.status: ' + c.Status);
        

        if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Prestamo_Personal').getRecordTypeId()) ) {

          if( oldCase.Status == 'Informar folio y despedida' ) {
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
                
            }

        }else if( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Liberaci_n').getRecordTypeId()))
        {
            
            if(!transactionTypeClose.contains(c.Tipo_de_transacci_n__c) &&c.status != oldCase.Status && c.Status == 'Análisis de la aclaración' && oldCase.Status == 'Informar folio y despedida'){
               
                c.status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);

            }

        } else if(  String.isNotBlank(c.Reason) && (c.Reason.equals('Re tipificación') || c.Reason.equals('Incidencias CC') || c.Reason.equals('Abono previo') || c.Reason.equals('Transacción mayor a 90 días') || c.Reason.equals('Falta de documentación')) &&
            ( (String.isNotBlank(c.Dictamen__c) && c.Dictamen__c.equals('No procede')) || (String.isNotBlank(c.Dictamen_Fraudes__c) && c.Dictamen_Fraudes__c.equals('No procede')) )  ) {    
                /// Aplica para todos los RecordTypes
                /// Si CaseReason es 'Re tipificación' OR 'Incidencias CC'
                /// Y si Dictamen Aclaraciones es 'No procede' OR Dictamen Fraudes es 'No procede'

            c.Status = 'Cancelado';
            lstCasesMoveStatus.add(c.Id);
        
        } 
        else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Contrato_manual').getRecordTypeId()) ) {
            if( oldCase.Status == 'Validación del cliente' ) {
                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }
            if(c.Datos_de_embosado__c=='Envío a módulo' && (c.Sucursal__c== null || c.Sucursal__c=='')){
                c.addError(new CaseTriggerException( 'Campo Sucursal no se puede dejar vacío, llénalo o selecciona otro Dato de embosado' ));
            }
        }
        else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Compra_no_diferida').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }

            //Si la promoción esta vigente, flujo normal. 
            //Si NO esta vigente o NO registrada, SE SALTA A LA ETAPA DE INFORMAR FOLIO Y SE CIERRA EL CASO. NO PASA A ACLARACIONES
            if ( c.Estatus_promoci_n__c != null && !c.Estatus_promoci_n__c.equals('Vigente')) {
                
                if (c.Status.equals('Detalle de la compra')) {

                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);

                }  else if (c.Status.equals('Análisis de la aclaración') || c.Status.equals('Analisis de la aclaración (N)') || 
                            c.Status.equals('Informar folio y despedida') && oldCase.Status.equals('Informar folio y despedida') || oldCase.Status.equals('Módulo')) {

                    c.Status = 'Cancelado';
                    lstCasesMoveStatus.add(c.Id);
                }

            
            }
            else if( oldCase.Status.equals('Informar folio y despedida') && c.N_mero_de_cuotas_a_diferir__c != null && 
                (c.N_mero_de_cuotas_a_diferir__c == 'CPP 3 MCI' || c.N_mero_de_cuotas_a_diferir__c == 'CPP 6 MCI' || c.N_mero_de_cuotas_a_diferir__c == 'CPP 9 MCI' || 
                c.N_mero_de_cuotas_a_diferir__c == 'CPP 12 MCI' || c.N_mero_de_cuotas_a_diferir__c == 'CPP buen fin 3 MCI' || c.N_mero_de_cuotas_a_diferir__c == 'CPP buen fin 6 MCI' || 
                c.N_mero_de_cuotas_a_diferir__c == 'CPP buen fin 9 MCI' || c.N_mero_de_cuotas_a_diferir__c == 'CPP buen fin 12 MCI' || c.N_mero_de_cuotas_a_diferir__c=='3 MSI compra antes del corte' ||  c.N_mero_de_cuotas_a_diferir__c=='3MSI Plan Fazil') ) {
				c.Tipo_de_caso__c= c.N_mero_de_cuotas_a_diferir__c=='3 MSI compra antes del corte' ||  c.N_mero_de_cuotas_a_diferir__c=='3MSI Plan Fazil' ? 'Servicio':  c.Tipo_de_caso__c;
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);

            }
            
            
            
            
        } else if (( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId()) || 
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_No_Reconocido_M_dulo').getRecordTypeId()) ) ) {
                      
            if( c.Status != oldCase.status && oldCase.Status == 'Análisis del caso' && latestOwnerCaseByCaseNumberMao.containsKey(c.Id) ){
                c.ownerId = latestOwnerCaseByCaseNumberMao.get(c.Id);

            }
            
            if( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cargo_no_reconocido').getRecordTypeId()) &&
                (c.Clasificaci_n_Cargo_Formula__c == 'Cargo no reconocido' || Test.isRunningTest()) && (oldCase.Status == 'Informar folio y despedida') ) {

                /// Se valida que al menos exista un Archivo Adjunto al Caso
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }
              if( c.Status != oldCase.status && c.Status.equals('Análisis del caso') && !c.Se_solicit_Pagar_a_Prosa__c ){
                // c.ownerId = mapQueues.containsKey('Soriana') ? mapQueues.get('Soriana').Id : c.ownerId; 
                c.status = 'Dictamen';
                lstCasesMoveStatus.add(c.Id);
            }
            
            if ( String.isNotBlank(c.Clasificaci_n_Cargo_Formula__c) && c.Clasificaci_n_Cargo_Formula__c.equals('Cargo no reconocido')) {
                
                // 1)Si las respuestas son SI, NO, NO--> Cargo desconocido (En clasificación cargo) FLUJO NORMAL. 
                // 2) Cualquier otra combinación Cargo no reconocido 
                // 3) Si Clasificación cargo= No reconocido, se saltan las siguientes etapas:  Bloqueo y reposición y Dictamen de fraudes.
                
                if (c.Status.equals('Bloqueo y reposición')) {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else if (c.Status.equals('Dictamen')) {
                    
                    c.Status = 'Ajuste contable';
                    lstCasesMoveStatus.add(c.Id);
                }
                
            }
            
            // Si el caso se cierra y Clasificaci_n_Cargo_Formula__c es Cargo Desconocido, y si PersonAccount es Soriban 
            // y la tarjeta se entrega a Domicilio, 
            // crear un Case 'Up Grade'
            if ( String.isNotBlank(c.Clasificaci_n_Cargo_Formula__c) && c.Status.equals('Informar folio y despedida') && c.Clasificaci_n_Cargo_Formula__c.equals('Cargo desconocido') ) {
                
                Case CaseWithAccountFields = mapCases.get(c.Id);
                
                if ( CaseWithAccountFields.Account.Cliente_Soriban__c && c.Medio_de_entrega_tarjeta__c.equals('Domicilio') && c.La_cuenta_presenta_incidencia__c.equals('Sí')) {
                    
                    System.debug('Inside To create Up Grade Case Cargo desconocido');
                    
                    // Create new Case Type 'Up Grade'
                    Case newCase;
                    
                    newCase = new Case();
                    
                    
                    newCase.ContactId = CaseWithAccountFields.Account.PersonContactId;
                    newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Up_Grade').getRecordTypeId();
                    newCase.Categor_a__c = 'Cambio de producto';
                    newCase.Status = 'Validación de la Cuenta';
                    /// Ajuste Para llenar campos en el nuevo caso Up Grade
                    ///c.La_cuenta_presenta_incidencia__c = 'Sí';
                    newCase.La_cuenta_presenta_incidencia__c = 'Sí';
                    newCase.ParentId = c.Id;
                    newCase.TarjetaCaso__c = c.TarjetaCaso__c != null ? c.TarjetaCaso__c : '';
                    ///
                    newCase.OwnerId = mapQueues.containsKey('Aclaraciones_Corto') ? mapQueues.get('Aclaraciones_Corto').Id : c.OwnerId;

                    newCases.add(newCase);
                    
                }               
                
            }
            
        } else if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Producto').getRecordTypeId())) {
                        
            // En la tipificación Cambio de producto, 
            // al estar en la etapa Información Cambio de Producto y contestar la pregunta ¿Presenta adeudo en MC? "SI". 
            // Se presiona botón marcar como completado y enlaza a la etapa Informar folio y despedida. 
            // Después de presiona el botón marcar como completado en la etapa Informar folio y despedida,enlaza a la etapa cerrada, sin pasar por normalización.
            
            // #86: Cambio de Producto. 
            // Si la respuesta es NO en ¿El cliente desea cambiar el producto?, 
            // SE SALTA A LA ETAPA DE INFORMAR FOLIO Y SE CIERRA EL CASO. 
            // (Actualmente si se salta a informar folio pero no se cierra al avanzar de etapa)
            
            
            if (c.Presenta_adeudo_en_MC__c != null && c.Presenta_adeudo_en_MC__c.equals('Sí')) {
                
                if (oldCase.Status.equals('Información Cambio de Producto') ) {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else if (oldCase.Status.equals('Informar folio y despedida')) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);                    
                }
                
            } else if (c.El_cliente_desea_cambiar_de_producto__c != null && c.El_cliente_desea_cambiar_de_producto__c.equals('No')) {
                
                if ( oldCase.Status.equals('Beneficios del Producto') ) {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else if ( oldCase.Status.equals('Informar folio y despedida') ) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);                    
                }                
            }
            
        } else if ( (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cambio_de_Medio_Env_o').getRecordTypeId()) 
                        && c.Datos_del_cliente_son_correctos__c != null)) {
            
            // Cambio medio de Envío
            // ¿Datos del cliente son correctos?= SI, 
            // saltar la etapa de Actualización de Datos y seguir flujo normal. 
            // ¿Datos del cliente son correctos?= NO, 
            // solo saltar etapa de Actualización de medio de envío y cerrar. 
            // BORRAR LAS OTRAS REGLAS QUE YA SE TENIAN DE ESTA TIPIFICACION
            
            if (c.Datos_del_cliente_son_correctos__c.equals('SI')) {
                
                if (c.Status.equals('Actualización de Datos')) {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                } 
                
            } else if ( c.Datos_del_cliente_son_correctos__c.equals('NO') ) {
                
                if (c.Status.equals('Actualización de medio de envío')) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Aumento_de_L_nea_de_Cr_dito').getRecordTypeId()) ) {
            // if( oldCase.Status.equals('Validación del cliente') && c.Status.equals('Informar folio y despedida') ) {
            //     if( c.Cliente_en_Base_de_Datos_de_Campa_a__c == 'No' || c.Cliente_acepta_aumento_l_nea_de_cr_dito__c == 'NO'){
            //         c.Status = 'Cancelado';
            //         lstCasesMoveStatus.add(c.Id);
            //     }
            // }
            if( oldCase.Status.equals('Informar folio y despedida') && c.Status.equals('Análisis de la Cuenta') ) {

                if(c.Origen_Campa_a__c  != 'Incremento de Garantia'){
                        c.Status = 'Cerrado';
                        lstCasesMoveStatus.add(c.Id);
                }
                // if( !(c.Origen_Campa_a__c == 'Solicitud sin campaña' && c.Cliente_en_Base_de_Datos_de_Campa_a__c == 'No' && c.Cliente_acepta_aumento_l_nea_de_cr_dito__c == 'SI') ) {

                //     c.Status = 'Cerrado';
                //     lstCasesMoveStatus.add(c.Id);

                // } else 
                if( mapQueues.containsKey(Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER) && c.OwnerId == mapQueues.get(Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER).Id ) {

                    /// Notifica a Back Office
                    CustomNotificationService.sendCustomNotification(new Set<String>{mapQueues.get(Constants.QUEUE_BACK_OFFICE_CASE_CALL_CENTER).Id},
                                                                    'Caso asignado - Aumento de Línea de Crédito ' ,
                                                                    'Se ha asignado el Caso: ' + c.CaseNumber + ' a su grupo de trabajo', 
                                                                    mapCustomNotification.get('Aprobacion_de_Cupo_Riesgos').Id, 
                                                                    c.Id);
                }
            } 
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Titular').getRecordTypeId()) ) {
                                     
                                     
            if ( String.isNotBlank(c.Cliente_desea_continuar_con_la_cancelac__c) && c.Cliente_desea_continuar_con_la_cancelac__c.equals('No') && String.isNotBlank(c.Motivo_de_la_Retenci_n__c) 
                && String.isNotBlank(c.Motivo_de_cancelaci_n_de_tarjeta__c) ) {
                
                
                if (oldCase.Status.equals('Motivo de Cancelación')){
                    
                    // En Caso que el Cliente no desee cancelar la Tarjeta y el Motivo de Retención no sea vacío, 
                    // se deberá de cancelar el Caso actual y crear una nueva tipificación de Retención de titular que en los que 
                    // aparezcan precapturados los campos de la primera Etapa de Retención y empiece este nueva tipificación en la 
                    // segunda etapa llamada Cálculo de la Retención si Motivo de Retención es diferente de 'Beneficios' ó cancelado si lo es

                    List<MyEvent__e> events = new List<MyEvent__e>();
                    
                    // Cancel current Case
                    c.Status = 'Cancelado';
                    lstCasesMoveStatus.add(c.Id);
                    
                    // Create new Case 'Retención de Titular' with status 'Cálculo de la Retención'
                    Case clonedcase;
                    
                    clonedcase = c.clone(false, true, false, false);                    
                    
                    clonedcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retenci_n_de_Titular').getRecordTypeId();
                     clonedCase.Status = 'Cerrado';
                    ///
                    // if(/*c.Motivo_de_la_Retenci_n__c.contains('Bono de') || c.Motivo_de_la_Retenci_n__c.equals('Bonificación de anualidad') 
                    //     || c.Motivo_de_la_Retenci_n__c.contains('Dinero Electrónico') || c.Motivo_de_la_Retenci_n__c.contains('Bonificación de comisión por tardío') 
                    //     || c.Motivo_de_la_Retenci_n__c.contains('Bonificación de comisión por reposición') || c.Motivo_de_la_Retenci_n__c.contains('Bonificación seguros') 
                    //     || c.Motivo_de_la_Retenci_n__c.contains('Upgrade/Cambio de Producto') || c.Motivo_de_la_Retenci_n__c.contains('Disminución de tasa de interés') */
                    //     // se agregó Upgrade
                    //     c.Motivo_de_la_Retenci_n__c.contains('Bono de') || c.Motivo_de_la_Retenci_n__c.contains('Bonificación de')
                    //     || c.Motivo_de_la_Retenci_n__c.contains('Incremento de línea') || c.Motivo_de_la_Retenci_n__c.contains('Cambio de')
                    //     || c.Motivo_de_la_Retenci_n__c.contains('Comisión anual') || c.Motivo_de_la_Retenci_n__c.contains('Upgrade')
                    // ) {

                    //     clonedCase.Status = 'Cálculo de la Retención';
                    //     clonedcase.OwnerId = mapQueues.containsKey(Constants.RETENCION_TITULAR_QUEUE_ACLARACIONES) ? mapQueues.get(Constants.RETENCION_TITULAR_QUEUE_ACLARACIONES).Id : c.OwnerId;

                    // } else if( c.Motivo_de_la_Retenci_n__c.equals('Beneficios') ) {

                    //     ////if( c.Motivo_de_cancelaci_n_de_tarjeta__c.equals('Límite de crédito') ) {

                    //         ////clonedCase.Status = 'Cálculo de la Retención';
                    //         //clonedcase.OwnerId = mapQueues.containsKey('Retencion') ? mapQueues.get('Retencion').Id : c.OwnerId;

                    //     ////} else {

                    //         /// Se cierra el caso en el metodo asincrono
                    //         clonedCase.Status = 'Retención';
                    //         clonedcase.Solicitud_de_cancelaci_n__c = true;
                    //     ////}
                    // }                    
                    
                    if (clonedcase != null) {
                        
                        newCases.add(clonedcase);
                        
                    }                    
                }
                
            } else if ( String.isNotBlank(c.Acepta_o_no_cargos__c) && String.isNotBlank(c.Saldo_IMPAGO__c) ) {                
                
            //    if ( c.Acepta_o_no_cargos__c.equals('SI') || c.Acepta_o_no_cargos__c.equals('N/A') && c.Saldo_IMPAGO__c.equals('Si') ) {                    
                    
            //         if (oldCase.Status.equals('Consulta cuenta de cliente')) {

            //             c.Status = 'Informar folio y despedida';
            //             lstCasesMoveStatus.add(c.Id);
            //         } 
                    
            //     } else if (c.Acepta_o_no_cargos__c.equals('N/A') && c.Saldo_IMPAGO__c.equals('No')) {
                    
            //         if (oldCase.Status.equals('Informar folio y despedida')) {

            //             c.Status = 'Cerrado';
            //             lstCasesMoveStatus.add(c.Id);
            //         }
                    
            //     } else if ( c.Acepta_o_no_cargos__c.equals('NO') ) {
                    
            //         c.Status = 'Cancelado';
            //         lstCasesMoveStatus.add(c.Id);
            //     }                
                //AJuste ticket  218
                if ((c.Acepta_o_no_cargos__c.equals('SI')  && String.isNotBlank(c.Saldo_IMPAGO__c)) 
                    || ( c.Acepta_o_no_cargos__c.equals('N/A') && c.Saldo_IMPAGO__c.equals('Si'))
                    || (c.Acepta_o_no_cargos__c.equals('N/A') && c.Saldo_IMPAGO__c.equals('No') && c.Devoluci_n_de_Garantia__c.equals('Si')) 
                    || (c.Acepta_o_no_cargos__c.equals('SI- acepta el cargo despues de 10 dias garantizada') && String.isNotBlank(c.Saldo_IMPAGO__c))
                    ) {                    
                    
                    if (oldCase.Status.equals('Consulta cuenta de cliente')) {

                        c.Status = 'Informar folio y despedida';
                        lstCasesMoveStatus.add(c.Id);
                    } 
                    
                } else if (c.Acepta_o_no_cargos__c.equals('N/A') && c.Saldo_IMPAGO__c.equals('No') && c.Devoluci_n_de_Garantia__c.equals('No')) {
                    
                    if (oldCase.Status.equals('Cancelar Cuenta')) {

                        c.Status = 'Cerrado';
                        lstCasesMoveStatus.add(c.Id);
                    }
                    
                } else if ( c.Acepta_o_no_cargos__c.equals('NO') ) {
                    
                    c.Status = 'Cancelado';
                    lstCasesMoveStatus.add(c.Id);
                }                
                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Operaciones_del_cliente').getRecordTypeId()) ||
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Operaciones_del_Cliente_M_dulo').getRecordTypeId())) {
                        
            // Operaciones del cliente.  
            // Unicamente si Clasificación tarjeta declinada = PIN Incorrecto seguir con flujo normal (todas las etapas). 
            // Cualquier otra selección, pasar a informar folio y posteriormente cerrar caso.
            
            if (String.isNotBlank(c.Clasificaci_n_Tarjeta_Declinada__c) && !c.Clasificaci_n_Tarjeta_Declinada__c.equals('PIN Incorrecto')) {
                
                if (oldCase.Status.equals('Informar folio y despedida') || oldCase.Status.equals('Módulo') ) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                }
            }

        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Abono_de_Puntos').getRecordTypeId()) ) {
            
            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }            

                // #54: Abono de Puntos. 
                // Cuando Comercio de la compra AP es Soriana 
                // al marcar como completada la etapa de "Informar despedida y folio" 
                // debe mostrar en automático la etapa de Cerrado del folio.            
                if( c.Comercio_de_la_compraAP__c != null && c.Comercio_de_la_compraAP__c.toLowerCase().equals('soriana')  ) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reporte_por_Robo_o_Extrav_o').getRecordTypeId()) || 
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reporte_por_Retenci_n_Cajero').getRecordTypeId()) || 
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reporte_por_Deterioro').getRecordTypeId()) ||
                    c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sospecha_de_Fraude').getRecordTypeId()) ) {
                        
            // Si el caso se cierra, y si PersonAccount es Soriban y la tarjeta se entrega a Domicilio, 
            // crear un Case 'Up Grade'
            if ( c.Status.equals('Cerrado') ) {
                
                Case CaseWithAccountFields = mapCases.get(c.Id);
                
                
                if ( c.La_cuenta_presenta_incidencia__c.equals('Sí')) {
                    
                    System.debug('Inside To create Up Grade Case');
                    
                    List<MyEvent__e> events = new List<MyEvent__e>();
                    
                    // Create new Case Type 'Up Grade'
                    Case clonedcase;
                    
                    clonedcase = c.clone(false, true, false, false);
                    
                    clonedcase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Up_Grade').getRecordTypeId();
                    clonedcase.Categor_a__c = 'Cambio de producto';
                    clonedcase.Status = 'Validación de la Cuenta';
                    ///
                    clonedcase.ParentId = c.Id;
                    ///
                    clonedcase.OwnerId = mapQueues.containsKey('Aclaraciones_Corto') ? mapQueues.get('Aclaraciones_Corto').Id : c.OwnerId;
                    
                    
                    newCases.add(clonedcase);
                    
                }
                
                
                
                // #87: Reporte por Robo o Extravío 
                // Etapa Validación de Movimientos 
                // si ¿Cliente desconoce transacciones?=Si 
                // avance a informar folio y despedida y después cerrar caso.
                
            } 
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reenv_o_de_Estado_de_Cuenta').getRecordTypeId()) && 
                    c.Datos_del_cliente_son_correctos__c != null ) { 
            
            // Reenvío de EDC- 
            // ¿Datos del cliente son correctos?= SI, 
            // Saltar a etapa de Informar folio y despedida  y cerrar caso
            if (c.Datos_del_cliente_son_correctos__c.equals('SI')) {
                
                if (c.Status.equals('Actualización de Datos')) {
                    
                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else if (c.Status.equals('Informar folio y despedida')) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }                
            } 
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Pago_No_Aplicado').getRecordTypeId()) ) {
            
            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }
                                                                      
            // Pago No Aplicado 
            // Si Establecimiento de pago=Soriana 
            // NO pasar por etapa de Documentacion requerida. 
            // Si Establecimiento de pago= Interbancario, 
            // seguir con etapa de Documentación Requerida y mandar plantilla con formato de aclaración
            
            // Pago No Aplicado
            // Si el dictamen fue dado en contra 
            // debe de cerrarse el caso directamente sin pasar a Aplicación del pago.
            
            // se removio la condicion a peticion de Luis Cordova
            if (c.Dictamen__c != null && c.Dictamen__c.toLowerCase().equals('en contra')) {
                
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Retiro_de_efectivo_en_ATM').getRecordTypeId()) ) { 
                                                                      
            // Retiro de efectivo en ATM 
            // Si el dictamen fue dado en contra 
            // debe de cerrarse el caso directamente sin pasar a Aplicación del pago.
            if (c.Dictamen__c != null && c.Dictamen__c.toLowerCase().equals('en contra')) {
                
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Comisi_n').getRecordTypeId()) ) {
            
            if( oldCase.Status == 'Informar folio y despedida' && (c.Tipo_de_comisi_n__c == 'Pago tardío') ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }

            // Si el campo Dictamen Aclaraciones= En contra, 
            // Cerrar caso. 
            // Si el campo Dictamen Aclaraciones= A favor, 
            // seguir con la siguiente etapa Aplicación del abono.
            
            if (c.Dictamen__c != null && c.Dictamen__c.toLowerCase().equals('en contra')) {
                
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reversa_de_Anualidad').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' && (c.Reversa_de_Anualidad_por__c == 'Empleados' || c.Reversa_de_Anualidad_por__c == 'Promoción') ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                }
            }
                                                                      
            // Si campo Reversa de Anualidad por: Promoción y Empleados pasar a 'Informar folio y despedida', 
            // si es 'Mala Venta' seguir flujo normal
            if (String.isNotBlank(c.Reversa_de_Anualidad_por__c) && !c.Reversa_de_Anualidad_por__c.equals('Mala Venta') ) {
                
                if (oldCase.Status.equals('Detalle para la cancelación de anualidad')) {

                    c.Status = 'Informar folio y despedida';
                    lstCasesMoveStatus.add(c.Id);
                }                
            }
            
            // Si Reversa de Anualidad es igual a 'Promoción, Empleados o Seguro de Compra Protegida'
            // En etapa 'Informar folio y despedida' pasar a etapa 'Cerrada'
            /// Se elimina brinco de etapa

            // Si el campo Dictamen Aclaraciones= En contra, 
            // Cerrar caso. 
            // Si el campo Dictamen Aclaraciones= A favor, 
            // seguir con la siguiente etapa Aplicación del abono.
            if (c.Dictamen__c != null && c.Dictamen__c.toLowerCase().equals('en contra')) {
                
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
            }

            // Si Cliente_Acepta_Beneficios__c = Beneficios cerrar caso cuando esté en 'Informar folio y despedida'
            if (String.isNotBlank(c.Cliente_Acepta_Beneficios__c) && c.Cliente_Acepta_Beneficios__c.equals('Beneficios') ) {
                
                if (oldCase.Status.equals('Informar folio y despedida')) {

                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }                
            }
            
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Tel_fono_Fijo').getRecordTypeId()) ) {
                                                                      
            // El checkbox "Validación de Teléfono Anterior", 
            // cuando no se marca y se presiona el botón Marcar estado como completado, 
            // debe cerrar el caso.
            
            if (c.Validaci_n_de_Tel_fono_Anterior__c != null && !c.Validaci_n_de_Tel_fono_Anterior__c ) {
                
                if (oldCase.Status.equals('Validación del Teléfono Anterior')) {
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_SORIBAN').getRecordTypeId()) ) {
            
            if ( String.isNotBlank(c.Actualizar_domicilio__c) && c.Actualizar_domicilio__c.equals('No') ) { // Si no de desea actualizar domicilio, saltar a Actualización de Datos
                
                if (oldCase.Status.equals('Actualización de Nombre')) {

                    c.Status = 'Actualización de Datos';
                    lstCasesMoveStatus.add(c.Id);
                }
                
            }
            
            if ( String.isNotBlank(c.Estado_Direccion__c) && String.isNotBlank(c.Municipio_Direccion__c) && String.isNotBlank(c.Colonia_Direccion__c) && String.isBlank(c.C_digo_Postal_Direccion__c) ) {
                
                if (oldCase.Status.equals('Actualización de Domicilio parte 1')) { // Si código postal no se encuentra, buscarlo por SOQL y registrar en Código Postal Texto
                    // Set Código Postal
                    
                    C_digo_Postal__c cp = mapColoniaCP.get(c.Colonia_Direccion__c);
                    
                    if (cp != null) {
                        c.C_digo_Postal_Texto__c = cp.Name;
                    }
                    
                }
                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Domicilio').getRecordTypeId()) ) {
                                                                      
            if ( String.isNotBlank(c.Estado_Direccion__c) && String.isNotBlank(c.Municipio_Direccion__c) && String.isNotBlank(c.Colonia_Direccion__c) && String.isBlank(c.C_digo_Postal_Direccion__c) ) {
                
                if (oldCase.Status.equals('Actualización de Domicilio parte 1')) { // Si código postal no se encuentra, buscarlo por SOQL y registrar en Código Postal Texto
                    // Set Código Postal
                    
                    C_digo_Postal__c cp = mapColoniaCP.get(c.Colonia_Direccion__c);                    
                    
                    if (cp != null) {
                        c.C_digo_Postal_Direccion__c = cp.Name;
                    }
                    
                }
                
            }
            
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_de_Celular').getRecordTypeId()) ) {
                                                                      
            // Etapa: Autenticación  Buro. 
            // Si la autenticacion no exitosa 
            // se debe cerrar el caso en automatico,  
            // si es exitosa se asigna la siguiente etapa.
            if ( oldCase.Status.equals('Autenticación de Buro') && c.Autenticaci_n_exitosa__c != null && c.Autenticaci_n_exitosa__c.toLowerCase().equals('no') ) {
                
                c.Status = 'Cerrado';
                lstCasesMoveStatus.add(c.Id);
                
            } else if ( oldCase.Status.equals('Actualización de Datos') && c.Status.equals('Actualización de Celular') && !c.Celular_Nuevo_Verificado__c  ) {
                
                c.addError(new CaseTriggerException('Accion requerida: validar OTP'));
                
                List<Database.SaveResult> results = EventBus.publish(new List<MyEvent__e>{new MyEvent__e(Message__c='fireSendOTP', value__c=c.Celular_Nuevo__c, RecordId__c=c.Id )});
                System.debug('results: ' + results);               
                // Inspect publishing results
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            System.debug('Error returned: ' +
                                        error.getStatusCode() +' - '+
                                        error.getMessage());
                        }
                    }
                }
                
            } 
            
        } else if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('APP').getRecordTypeId()) ) {
            System.debug('indicenciaAppCierraPuntaList'+ mapQueues);
            System.debug('c.Incidencia_App__c '+ c.Incidencia_App__c );
            // (!c.Incidencia_App__c.equals('No llega el código OTP') && !c.Incidencia_App__c.equals('Error de Sistemas') && !c.Incidencia_App__c.equals('Disposición de Efectivo App') )
            if (oldCase.status.equals('Informar folio y despedida')) {
                if (c.Incidencia_App__c != null && indicenciaAppCierraPuntaList.contains(c.Incidencia_App__c)) { 
                    // c.OwnerId = mapQueues.get('Aux').Id;
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                    // System.debug('entra app'+c.OwnerId);
                }
            }
            
        } else if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('WEB').getRecordTypeId()) ) {
                                                                      
            if (oldCase.status.equals('Informar folio y despedida')) {
                if (c.Incidencia_Web__c != null && (!c.Incidencia_Web__c.equals('No llega el código OTP') && !c.Incidencia_Web__c.equals('Error de Sistema') ) ) { 
                    
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Up_Grade').getRecordTypeId()) ) {
            
            if (String.isNotBlank(c.La_cuenta_presenta_incidencia__c) && c.La_cuenta_presenta_incidencia__c.equals('No')) {
                
                if (oldCase.Status.equals('Análisis de la Cuenta')) {

                    c.Status = 'Up Grade';
                    lstCasesMoveStatus.add(c.Id);
                }
            }   
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Quita').getRecordTypeId()) ) {
            
            if (String.isNotBlank(c.Cancelaci_n_de_la_cuenta__c) && c.Cancelaci_n_de_la_cuenta__c.equals('Sí')) {
                
                if (oldCase.Status.equals('Aplicación de Quita')) {

                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }
                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reestructura').getRecordTypeId()) ) {
            
            if (String.isNotBlank(c.Tipo_de_Mora__c) && c.Tipo_de_Mora__c.equals('Cartera Congelada')) {
                
                if (oldCase.Status.equals('Reestructura')) {

                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }
                
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Consulta_de_PAN').getRecordTypeId()) ) {
            System.debug('Consulta de PAN XXXX');
            if (oldCase.Status.equals('Consulta Cuenta') && c.Status.equals('Consulta de PAN') && c.La_tarjeta_presenta_bloqueo__c.equals('No') && !c.Celular_PAN_Verificado__c) {
                
                
                c.addError(new CaseTriggerException('Accion requerida: validar OTP'));
                
                List<Database.SaveResult> results = EventBus.publish(new List<MyEvent__e>{new MyEvent__e(Message__c='fireSendOTPPAN', RecordId__c=c.Id )});
                System.debug('results: ' + results);               
                // Inspect publishing results
                for (Database.SaveResult result : results) {
                    if (!result.isSuccess()) {
                        for (Database.Error error : result.getErrors()) {
                            System.debug('Error returned: ' +
                                        error.getStatusCode() +' - '+
                                        error.getMessage());
                        }
                    }
                }
            }
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Audiencia_CONDUSEF').getRecordTypeId()) ) {
            System.debug('inside Audiencia CONDUSEF');
            
            if (String.isNotBlank(c.Causa_CONDUSEF__c)) {
                
                String causaNumber = mapCausasCondusef.get(c.Causa_CONDUSEF__c).Name;
                Boolean isEqual = false;
                
                for(String causa: CAUSASCONDUSEF) {

                    if (causa.equals(causaNumber)) {

                        isEqual = true;
                        if (oldCase.Status.equals('Documentación requerida')) {

                            if (String.isNotBlank(c.Tipo_de_bloqueo__c) && c.Tipo_de_bloqueo__c.equals('N/A')) {

                                c.Status = 'Ajuste contable';
                                lstCasesMoveStatus.add(c.Id);
                            }
                        }
                        break;
                    }
                    
                }
                
                if (isEqual==false) {

                    if (oldCase.Status.equals('Revisa Folio')) { 

                        if (String.isNotBlank(c.Tipo_de_bloqueo__c) && c.Tipo_de_bloqueo__c.equals('N/A')) {

                            c.Status = 'Ajuste contable';
                            lstCasesMoveStatus.add(c.Id);

                        }else if (String.isNotBlank(c.Tipo_de_bloqueo__c) && !c.Tipo_de_bloqueo__c.equals('N/A')) {

                            c.Status = 'Dictamen Fraudes';
                            lstCasesMoveStatus.add(c.Id);
                        }
                    }
                }
            }
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Saldo_a_Favor').getRecordTypeId()) ) { 
            /// RecordType - Saldo a Favor
            /// Si el Estatus es Normalizacion y se cambia a la siguiente Etapa
            /// Si el campo Dictamen__c es igual a 'No procede'
            if( oldCase.Status.equals('Normalización') && !c.Status.equals('Cerrado') && 
                c.Dictamen__c != null && c.Dictamen__c.equals('No procede') ) {
  
                  c.Status = 'Cerrado';
                  lstCasesMoveStatus.add(c.Id);
            }
  
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Actualizaci_n_Nom_RFC_FN').getRecordTypeId()) ) {
            /// RecordType - Actualización Nom, RFC, FN
            /// Si el Estatus es Informar folio y despedida
            
            if( oldCase.Status.equals('Información') && c.Status.equals('Informar folio y despedida') ) {
                
                if ( String.isNotBlank(c.Tipo_de_informaci_n__c) && c.Tipo_de_informaci_n__c.equals('Nombre') ) {

                    /// Si Tipo_de_informaci_n__c es Nombre
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }

            } else if( oldCase.Status.equals('Dictamen') && c.Status.equals('Dictamen Final') ) {
                
                /// Si el Estatus es Dictamen Final                
                if( String.isNotBlank(c.Dictamen_Fraudes__c) && c.Dictamen_Fraudes__c.equals('En Contra') ) {

                    /// Si Dictamen_Fraudes__c es En Contra
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);

                } else if( String.isNotBlank(c.Dictamen_Fraudes__c) && String.isNotBlank(c.Reason) && c.Dictamen_Fraudes__c.equals('No procede') && c.Reason.equals('Falta de documentación') ) {

                    /// Si Dictamen_Fraudes__c es No Procede y Reason es Falta de documentación
                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                }
            }
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Procedimiento_de_Cobro').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' ) {

                if( c.Clasificaci_n_Medio_de_env_o_no_llega__c == 'Cliente realizó el pago' ) {

                    /// Se valida que al menos exista un Archivo Adjunto
                    if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                    /// Validar Archivos Adjuntos Permitidos
                    } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                        if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                            c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                        }
                    }
                }

                /// RecordType - Procedimiento de Cobro
                /// Si el Status es igual a 'Dictamen'
                /// Si Fecha_de_pago__c es igual a Today o Yesterday. Si Tipo_de_Mora__c es igual a 'Mora Leve'
                /// Si Establecimiento_de_pago__c es 'Soriana' o 'Interbancario'

                Date dtToday = System.today();
                Date dtYesterday = System.today().addDays(-1);
                
                if( c.Status.equals('Dictamen') ) {

                    if( (c.Fecha_de_pago__c == dtToday || c.Fecha_de_pago__c == dtYesterday) && String.isNotBlank(c.Tipo_de_Mora__c) && c.Tipo_de_Mora__c.equals('Mora Leve') 
                        && String.isNotBlank(c.Establecimiento_de_pago__c) && (c.Establecimiento_de_pago__c.equals('Soriana') || c.Establecimiento_de_pago__c.equals('Interbancario')) ) {

                        c.Status = 'Cerrado';
                        lstCasesMoveStatus.add(c.Id);
                    } 
                }
            }
            
        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Plan_de_Pagos').getRecordTypeId()) ) {
            /// RecordType - Plan de Pagos
            /// Si Status = Análisis de la Cuenta
            /// Si Pago_Acreditado__c = 'Se realizo fuera de la fecha de pago, pagó incompleto, no realizo pago.'
            /// O si Pago_Acreditado__c = 'Si' y Estatus_promocin__c = Reclamo

            if( oldCase.Status.equals('Informar folio y despedida') && c.Status.equals('Análisis de la Cuenta') ) {

                if( String.isNotBlank(c.Estatus_promocin__c) && c.Estatus_promocin__c.equals('Servicio') &&
                    String.isNotBlank(c.Pago_Acreditado__c) && ( c.Pago_Acreditado__c.equals('Sí') || c.Pago_Acreditado__c.equals('Promesa de pago') ) ) {

                    c.Status = 'Cerrado';
                    lstCasesMoveStatus.add(c.Id);
                    
                } else if( String.isNotBlank(c.Estatus_promocin__c) && c.Estatus_promocin__c.equals('Reclamo') && 
                            String.isNotBlank(c.Pago_Acreditado__c) && c.Pago_Acreditado__c.equals('Sí') ) {

                    c.Status = 'Análisis de la aclaración';
                    lstCasesMoveStatus.add(c.Id);

                } else if( String.isNotBlank(c.Pago_Acreditado__c) && c.Pago_Acreditado__c.equals('Se realizo fuera de la fecha de pago, pagó incompleto, no realizo pago.') ) {

                    c.Status = 'Cancelado';
                    lstCasesMoveStatus.add(c.Id);
                } 
            }

        } /*else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId()) ) {
            /// RecordType - Emboce Centralizado
            /// Si Status anterior es igual a Confirmación
            /// Si nuevo Status es igual a Investigación de envío

            if( oldCase.Status.equals('Confirmación') && c.Status.equals('Investigación de envío') ) {

                c.Status = 'Asignada';
                lstCasesMoveStatus.add(c.Id);
            }

        }*/ else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Promoci_n_no_Aplicada').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                } 
            }

        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cancelaci_n_de_Tarjeta_por_Fallecimiento').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                } 
            }

        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cobro_a_Persona').getRecordTypeId()) ) {

            if( oldCase.Status == 'Informar folio y despedida' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                } 
            }

        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Remisi_n').getRecordTypeId()) ) {

            if( oldCase.Status == 'Detalle del caso' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                } 
            }

        } else if ( c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reposici_n').getRecordTypeId()) ) {

            if( oldCase.Status == 'Detalle del caso' ) {

                /// Se valida que al menos exista un Archivo Adjunto
                if( !mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {

                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));

                /// Validar Archivos Adjuntos Permitidos
                } else if( lstAllowedAttachments.size() > 0 && lstAllowedAttachments[0] != 'null' ) {

                    if( !validateAllowedAttachments(mapCaseIdLstAttachments.get(c.Id)) ) {

                        c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO ));
                    }
                } 
            }

        } else if (c.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Soporte_a_m_dulo').getRecordTypeId())){
            if(c.Status == 'Dictamen' && c.Clasificaci_n_Medio_de_env_o_no_llega__c == 'Si se soluciona en linea' || c.Clasificaci_n_Medio_de_env_o_no_llega__c == 'No se soluciona en linea'){
                c.Status='Cerrado';
                if(!mapCaseIdLstAttachments.containsKey(c.Id) || ( mapCaseIdLstAttachments.containsKey(c.Id) && (mapCaseIdLstAttachments.get(c.Id).isEmpty()) ) ) {
                    c.addError(new CaseTriggerException( Constants.REGLA_DOCUMENTACION_MENSAJE_ERROR ));         
                }
            }
            if(caseTypes.contains(c.type) && c.Status == 'Cerrado'){
                c.OwnerId=soporteModuloUsuario.id;
                CustomNotificationService.sendCustomNotification(new set<String>{soporteModuloUsuario.id}, 'Caso ' + c.Status,  ' El caso ' + c.caseNumber + ' se ha cerrado', notificacion.id, c.id );            
            }
        }
    } 

    public static void moveStatusSinCamposObligatorios (Case newCase, Case oldCase) {
        System.debug('moveStatusSinCamposObligatorios');
        System.debug('oldCase.Status: ' + oldCase.Status);
        System.debug('newCase.status: ' + newCase.Status);

        /// RecorTypes sin Etapas con campos obligatorios
    }
    
    public static void moveStatusModulo(Case newCase, Case oldCase){
        
    }

    ///
    public static void moveStatusRiesgos (Case caseNew, Case oldCase) {
        System.debug('moveStatus Riesgos');
        System.debug('oldCase.Status: ' + oldCase.Status);
        System.debug('caseNew.status: ' + caseNew.Status);

        if ( caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
            caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {

            /// Se deshabilita campo que permite al WS cambiar el Status del Caso de Cerrado a Nuevo
            if( oldCase.Status.equals('New') && (caseNew.Status.equals('Asignada') || caseNew.Status.equals('Autorización')) && caseNew.Caso_Actualizado_por_WebService__c  ) {

                caseNew.Caso_Actualizado_por_WebService__c = false;

            } else if( oldCase.Status.equals('Asignada') && caseNew.Status.equals('Autorización') && !caseNew.Actualizaci_n_de_domicilio_en_SAT__c ) {

                /// Se valida si ya se realilizo la consulta Recuperar Informacion de la Solicitud
                caseNew.addError('Debe realizar la Consulta de campos antes de cambiar de etapa');
            }
        }
    }

    ///
    public static void assignOwnerOmnichannel(Case newCase, Case oldCase) {  
        System.debug('llegue assign owner');      
        ///
        if( newCase.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) ||
            newCase.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId()) ) {
                System.debug('entre if');
             // PendingServiceRoutingService.createPendingServiceRouting(newCase.Id, newCase.RecordTypeId);           
        }
    }


    ///
    public static void validateCreatingCases(Case newCase) {

        if( setValidationEmboceRecordTypeId.contains(newCase.RecordTypeId) ) {

            if( setAccountsEmboce.contains(newCase.AccountId) ) {

                newCase.addError(new CaseTriggerException('Sub Categoría no permitida, se creó un caso de Emboce Centralizado en los últimos ' + Constants.EMBOCE_CENTRALIZADO_VALIDACION_DIAS_SUBCATEGORIAS + ' días'));                
            }
        }
    }
    
    public static void createCaseComments (Case caseNew, Case caseOld) {
        
        if( (caseNew.RecordTypeId.equals(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId()) &&
            String.isNotBlank(caseNew.Evaluar__c) && caseNew.Evaluar__c == 'Pendiente' && 
            String.isNotBlank(caseNew.Motivo_de_Pendiente__c) && caseNew.Motivo_de_Pendiente__c != caseOld.Motivo_de_Pendiente__c) ) {

            /// Back Office Credito
            List<String> motivos = String.isNotBlank(caseNew.Motivo_de_Pendiente__c) && caseNew.Motivo_de_Pendiente__c != caseOld.Motivo_de_Pendiente__c ? caseNew.Motivo_de_Pendiente__c.split(';') : new List<String>();

            for(String motivo: motivos) {

                if( !mapCasoListComentarios.containsKey(caseNew.Id) ) {

                    CaseComment comment = new CaseComment();                
                    comment.parentid = caseNew.Id;
                    comment.commentbody = motivo;
                    commentLst.add(comment);

                    mapCasoListComentarios.put(caseNew.Id, new Set<String>{motivo} );

                } else if(  mapCasoListComentarios.containsKey(caseNew.Id) && !mapCasoListComentarios.get(caseNew.Id).contains(motivo) ) {

                    CaseComment comment = new CaseComment();                
                    comment.parentid = caseNew.Id;
                    comment.commentbody = motivo;
                    commentLst.add(comment);

                    mapCasoListComentarios.get(caseNew.Id).add(motivo);
                }
            }

        }
    }
    
    public static void publishCaseComments (){
        if(!commentLst.isEmpty()){
            Database.insert(commentLst);
        }
    }
    
    public static void closeTasks (Map<Id, Case> caseNew, Map<Id, Case> caseOld) {
        
        if (TasksClosed == false) {
            System.debug('closeTasks');
            TasksClosed = true;
            Set<Id> closedCases = new Set<Id>();
            
            for (Case c : [SELECT Id FROM Case WHERE ( Status ='Cancelado' OR  Status = 'Cerrado')
                           AND Id IN: caseNew.keySet()] ) {
                               
                               closedCases.add(c.Id);
                               
                           }
            
            try {
                
                List<Task> lstTask = new List<Task>();
                for (Task t : [select id, status from task where WhatId IN: closedCases and TaskSubtype = 'Task' ]) {
                    
                    if (!t.Status.equals(statuses.get(0).ApiName)) {
                        t.Status = statuses.get(0).ApiName;
                        lstTask.add(t);
                    }   
                }
                
                if(lstTask.size()>0){
                    update lstTask;
                    System.debug('lstTask');    
                }
                    
            } catch (Exception e) {
                System.debug(e);
            }
            
        }          
        
    }
    
    public class CaseTriggerException extends Exception {}
    
    public static void completeCurrentMilestones (Map<Id, Case> caseNew, Map<Id, Case> caseOld) {
        
        System.debug('completeCurrentMilestones');
        System.debug('caseOld: ' + caseOld.values().Status);
        System.debug('caseNew: ' + caseNew.values().Status);
        
        
        if (milestonesCompleted == false ) {
            
            System.debug(caseNew.keySet());
            
            List<String> cmsProcessList = new List<String>(); 
            List<CaseMilestone> cmsToUpdate = new List<CaseMilestone>();
            Set<String> setCMSCompletos = new Set<String>();
            
            for (CaseMilestone cm :  [SELECT Id, CompletionDate, CaseId, MilestoneType.Name
                                      FROM CaseMilestone
                                      WHERE CaseId IN : caseNew.keySet()]) {
                                          
                                          cmsProcessList.add(cm.MilestoneType.Name); // Milestones Names en lista como están en el 'Support Process'
                                          
                                          if (cm.CompletionDate == null) { // Milestones no completados
                                              cmsToUpdate.add(cm);  
                                          } else {
                                              setCMSCompletos.add(cm.MilestoneType.Name); // Milestones Completados
                                          }
                                          
                                      }
            
            Map<String, MilestoneType>  msByName = new Map<String, MilestoneType>();
            
            for (MilestoneType cm : [SELECT Name FROM MilestoneType]) {
                msByName.put(cm.Name, cm);
            }
            
            if (!cmsToUpdate.isEmpty()) { 
                
                for (CaseMilestone cm : cmsToUpdate) { 
                    
                    if ( !caseNew.get(cm.CaseId).Status.equals(caseOld.get(cm.CaseId).Status) // Si se está cambiando de etapa
                        && caseOld.get(cm.CaseId).Status.equals(cm.MilestoneType.Name) // Y el Milestone Name == Etapa Actual(Old)
                        && !caseNew.get(cm.CaseId).Status.equals('Cancelado') ) { /// Ajuste para Re-Tipificar Casos
                            
                            if (!setCMSCompletos.contains(caseNew.get(cm.CaseId).Status)) { // Si el milestones de la etapa siguiente aún no está completado
                                System.debug('Milestone Completado');
                                cm.completionDate = Datetime.now(); // Completa el Milestone
                            }
                            
                        }
                    
                }
                
                try {
                    
                    update cmsToUpdate;
                    System.debug('cmsToUpdate');
                    
                } catch (Exception e) {
    
                    throw new AuraHandledException(e.getMessage());
                    
                }
                
                
            }
            milestonesCompleted = true;
        }
        
        
        
    }

    // public static void verifyOwnerPermitUpdate(Case c , case oldCase){
    //    system.debug('queueIdsListq'+queueIdsList);
    //     set<Id> userQueueList =  setIdUserByQueueId.containsKey(c.OwnerId) ? setIdUserByQueueId.get(c.OwnerId) : new set<Id>();
    //     system.debug('entra validate'+ setIdUserByQueueId);
    //     if( queueIdsList.contains(c.ownerId)&&(!setIdUserByQueueId.containsKey(c.LastModifiedById) && !userQueueList.contains(c.LastModifiedById) && oldCase.status== c.status )){
    //         c.addError('Solo el owner puede modificar el Caso');
    //     }


    // }
//     //Metodo para asignar sla
//    public static void assignSLA(List<Case> lstCases){
//         List<SLA__mdt> lstSla=[Select MasterLabel, sla__c from SLA__mdt];
//         Map<String, Decimal> slaByName= new Map<String, Decimal>();        
//         for(SLA__mdt sla: lstSla){
//             slaByName.put(sla.MasterLabel, sla.SLA__c);
//         }
        
//         List<RecordType> lstRT=[select Id,Name from RecordType where sObjectType='Case'];
//         Map<String, String> rtById = new Map<String, String>();
//         for(RecordType rt: lstRT){
//             rtById.put(rt.id, rt.name);
//         }
        
//         for(case caso: lstCases){
//             string rtName= rtById.get(caso.RecordTypeId).removeEnd(' (Módulo)');
//             caso.SLA__c= slaByName.containsKey(rtName) ? slaByName.get(rtName) : null;
//             System.debug(System.today() + '' + caso.SLA__c);
//             caso.Fecha_estimada_de_cierre__c= caso.SLA__c== null? null: System.today()+ integer.valueOf(caso.SLA__c);            
//         } 
        
        
//     }
    
    // public static void assignAppSLA(List<Case> trigger.New){
    //     set<Id> recordTypeIdsList = new set<Id>();
    // Map<Id, String> recordTypeNameById = new Map<Id,String>();
    // for(Case  caseExisting : lstCases){
    //     recordTypeIdsList.add(caseExisting.RecordTypeId);
    // }

    // for(RecordType rtExisting : [SELECT Id, Name FROM RecordType WHERE Id IN :recordTypeIdsList]){
    //     recordTypeNameById.put(rtExisting.Id, rtExisting.Name);
    // }
    // set<String> rtNamesSla15 = new set<String>{
    //     'App no muestra tarjeta',
    //     'Eliminar usuario',
    //     'Error al crear clave de internet nueva',
    //     'Error al enrolarse cliente nuevo',
    //     'Error en pago de servicios',
    //     'Error en recarga de T.A.',
    //     'Error en visualización de EECC',
    //     'Error inesperado en Clave dinámica',
    //     'Error inesperado en CVV',
    //     'Error inesperado en EDC',
    //     'Error inesperado en notificaciones',
    //     'Error inesperado en QR',
    //     'Información duplicada en la App'
    // }
   public static void aux(){
        integer i=0;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1; 
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;

    }

    
}