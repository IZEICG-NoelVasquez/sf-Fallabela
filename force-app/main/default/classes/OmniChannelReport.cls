public class OmniChannelReport {

    @AuraEnabled
    public static Map<String,Object> getUsers(List<String> lstProfiles) {

        Map<String,Object> mapResult = new Map<String,Object>();
        Boolean success = false;

        /// PRUEBAS usr Emiliano Trevinio
        List<User> lstUsers = [SELECT Name FROM User WHERE Profile.Name IN : lstProfiles OR Name = 'Emiliano Treviño' ];

        success = lstUsers.size() > 0 ? true : false;

        mapResult.put('success', success);
        mapResult.put('lstUsers', lstUsers);

        return mapResult;
    }
    
    @AuraEnabled
    public static List<OmniReport> getOmniReport(Map<String,String> mapUsers, Date startDate, Date endDate) {

        List<OmniReport> lstOmniReport = new List<OmniReport>();
        
        endDate = endDate != null ? endDate.addDays(1) : endDate;

        Id idRecordTypeRiesgos = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        Id idRecordTypeFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();
        List<Id> lstRTCases = new List<Id>{idRecordTypeRiesgos,idRecordTypeFigital};

        /// PRIMER PASO
        Set<String> setIdUser = new Set<String>();
        Map<String, List<UserServicePresence>> mapUserLstUserPresence = new Map<String, List<UserServicePresence>>();

        /// Se Obtienen los Inicios de Sesion en OmniChannel
        for(UserServicePresence userPresence: [SELECT StatusStartDate, StatusEndDate, StatusDuration, UserId FROM UserServicePresence 
                                                WHERE StatusEndDate != null 
                                                AND StatusStartDate >=: startDate 
                                                AND StatusEndDate <=: endDate]) {

            setIdUser.add(userPresence.UserId);            

            if( !mapUserLstUserPresence.containsKey(userPresence.UserId) ) {

                mapUserLstUserPresence.put(userPresence.UserId, new List<UserServicePresence>() );

            }

            mapUserLstUserPresence.get(userPresence.UserId).add(userPresence);
        }

        /// SEGUNDO PASO
        Set<String> setWorkItemIds = new Set<String>();

        for(AgentWork agentW: [SELECT AcceptDateTime, WorkItemId, UserId FROM AgentWork 
                                WHERE UserId IN : setIdUser 
                                AND AcceptDateTime != null 
                                AND AcceptDateTime >=: startDate 
                                AND AcceptDateTime <=: endDate ]) {

            setWorkItemIds.add(agentW.WorkItemId);
        }

        /// TERCER PASO
        Map<String, List<Case>> mapUserCases = new Map<String, List<Case>>();
        Map<String, Map<String, Integer>> mapUserCaseDetails = new Map<String, Map<String, Integer>>();

        /// Se Obtienen los casos atendidos en el Periodo de Tiempo 
        for(Case casePerUser: [SELECT OwnerId, Evaluar__c, Fecha_y_hora_de_solicitud_en_an_lisis__c, ClosedDate FROM Case 
                                WHERE RecordTypeId IN : lstRTCases 
                                AND Status = 'Cerrado'
                                AND Id IN : setWorkItemIds ]) {

            if( !mapUserCases.containsKey(casePerUser.OwnerId) ) {

                mapUserCases.put(casePerUser.OwnerId, new List<Case>());
            }

            mapUserCases.get(casePerUser.OwnerId).add(casePerUser);
        }

        /// CALCULOS 

        /// Mapa Principal de lista de Usuarios  (Id Usuario, Nombre)
        for(String idUsr: mapUsers.keySet() ) {

            OmniReport newOmniReport = new OmniReport(null, null, null, '0', '0', '0', null);

            ///
            if( mapUserLstUserPresence.containsKey(idUsr) ) {

                /// Numero de logins en Omni Channel
                newOmniReport.userName = mapUsers.get(idUsr);
                newOmniReport.numberOfLogins = String.valueOf( mapUserLstUserPresence.get(idUsr).size() );

                Long lgResolutionTime = 0;

                /// Tiempo activo en Omni Channel
                for(UserServicePresence userPresence: mapUserLstUserPresence.get(idUsr)) {                    

                    /// Tiempo en Segundos (* 1000 en Milisegundos)
                    lgResolutionTime += userPresence.StatusDuration;
                }

                newOmniReport.connectedTime = Utilities.tiempoDeResolucion(lgResolutionTime * 1000);

                /// Mapa de Casos por Usuario
                if( mapUserCases.containsKey(idUsr) ) {

                    Integer approvedCases = 0;
                    Integer rejectedCases = 0;
                    Integer pendingCases = 0;

                    List<Long> lstAverage = new List<Long>();

                    ///
                    for(Case userCase: mapUserCases.get(idUsr)) {                        

                        approvedCases = userCase.Evaluar__c == 'Aprobar' ? approvedCases + 1 : approvedCases;
                        rejectedCases = userCase.Evaluar__c == 'Rechazar' ? rejectedCases + 1 : rejectedCases;
                        pendingCases = userCase.Evaluar__c == 'Pendiente' ? pendingCases + 1 : pendingCases;

                        lstAverage.add(userCase.ClosedDate.getTime() - userCase.Fecha_y_hora_de_solicitud_en_an_lisis__c.getTime());
                    }

                    newOmniReport.approvedCases = String.valueOf(approvedCases);
                    newOmniReport.rejectedCases = String.valueOf(rejectedCases);
                    newOmniReport.pendingCases = String.valueOf(pendingCases);

                    Long averageEvaluationTime = lstAverage.size() > 0 ? Utilities.getAverageLong(lstAverage) : 0;
                    newOmniReport.averageEvaluationTime = lstAverage.size() > 0 ? Utilities.tiempoDeResolucion(averageEvaluationTime) : '';
                }

                lstOmniReport.add(newOmniReport);
            }            
        }

        return lstOmniReport;
    }


    public class OmniReport {

        @AuraEnabled public String userName;
        @AuraEnabled public String numberOfLogins;
        @AuraEnabled public String connectedTime;
        @AuraEnabled public String approvedCases;
        @AuraEnabled public String rejectedCases;
        @AuraEnabled public String pendingCases;
        @AuraEnabled public String averageEvaluationTime;

        public OmniReport(String userName, String numberOfLogins, String connectedTime, String approvedCases, String rejectedCases, String pendingCases, String averageEvaluationTime) {

            this.userName = userName;
            this.numberOfLogins = numberOfLogins;
            this.connectedTime = connectedTime;
            this.approvedCases = approvedCases;
            this.rejectedCases = rejectedCases;
            this.pendingCases = pendingCases;
            this.averageEvaluationTime = averageEvaluationTime;
        }
    }
}