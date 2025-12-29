public class PendingServiceRoutingService {
    
    private static String serviceChannelId; 
    private static Integer capacityAgentsBO;
    //(IdAgente, numeroCasos)
    private static Map<String,Integer> mapAgentNumCases;

    //(numeroCasos, lista IdAgentes con ese numero de Casos)
    private static Map<Integer, List<String>> mapAssignedCasesUsr;
    
    // Lista de casos pendientes a asignar;
    private static List<PendingServiceRouting> lstQueue;
    private static List<PendingServiceRouting> lstQueueOrdered;
    //(prioridad, lista de casos con esa prioridad);
    private static Map<Integer, List<PendingServiceRouting>> mapQueueByPriority;

    private static List<PendingServiceRouting> lstPendingServiceRoutingToInsert;
    private static List<PendingServiceRouting> lstPendingServiceRoutingToUpdate;

    public static void loadOmniChannelConfig() {

        List<ServiceChannel> serviceChannel = [SELECT Id FROM ServiceChannel WHERE DeveloperName = 'Case_Channel' LIMIT 1];
        serviceChannelId = serviceChannel.size() > 0 ? serviceChannel[0].Id : null;
        
        /// Mapa (Analista, Numero de Casos)
        mapAgentNumCases = new Map<String,Integer>();

        //// Mapa Numero de Casos Asignados, Lista de Usuarios   Ej. (0, List<User>), (1, List<User>)
        mapAssignedCasesUsr = new Map<Integer, List<String>>();
        /// Usuarios Activos en OminiChannel, con perfil de Back Office
        List<String> lstAvailableUsers = new List<String>();
        for(UserServicePresence usrPresence: [SELECT UserId FROM UserServicePresence 
                                                WHERE IsCurrentState = true 
                                                AND User.Profile.Name IN : Constants.LST_PROFILES_ADMIN_OMNICHANNEL ]) {
            lstAvailableUsers.add(usrPresence.UserId);
            mapAgentNumCases.put(usrPresence.UserId, 0);
        }
        System.debug('lstAvailableUsers ' + lstAvailableUsers);
        /// Al menos un Usuario Activos en OmniChannel
        if( lstAvailableUsers.size() > 0 ) {

            /// Lista de Status de OmniChannel
            List<String> lstAgentStatus = new List<String>{'Assigned', 'Opened'};

            /// RecordTypes BackOffice de Casos
            String idRTPresencial = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
            String idRTFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();
            List<String> lstRTBackOffice = new List<String>{idRTPresencial,idRTFigital};
            
            /// Solicitudes Asignadas y Abiertas
            for(AgentWork agentW: [SELECT Status, WorkItem.OwnerId, WorkItem.RecordTypeId 
                                    FROM AgentWork 
                                    WHERE Status IN : lstAgentStatus 
                                    AND WorkItem.OwnerId IN : lstAvailableUsers 
                                    AND WorkItem.RecordTypeId IN : lstRTBackOffice ]) {
                mapAgentNumCases.put(agentW.WorkItem.OwnerId, mapAgentNumCases.get(agentW.WorkItem.OwnerId) + 1);
            } 
            /// Ordenar Mapa de Analistas y Numero de Casos Asignados
            for(String strAgent: mapAgentNumCases.keySet() ) {
                if( !mapAssignedCasesUsr.containsKey( mapAgentNumCases.get(strAgent) )  ) {
                    mapAssignedCasesUsr.put( mapAgentNumCases.get(strAgent), new List<String>() );
                }
                mapAssignedCasesUsr.get(mapAgentNumCases.get(strAgent)).add(strAgent);
            }
        }
        System.debug('acabe loadOmniChannelConfiguration');
    }

    /// Carga los registros pendientes de asignar en Omnichannel
    public static void loadQueuePendingServiceRouting() {

        String idRTPresencial = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();
        String idRTFigital = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BackOffice_Figital').getRecordTypeId();

        List<String> lstRTBackOffice = new List<String>{idRTPresencial,idRTFigital};
        lstQueue = [SELECT IsReadyForRouting, PreferredUserId, workItem.RecordTypeId, CreatedDate 
                    FROM PendingServiceRouting 
                    WHERE IsReadyForRouting = false AND workItem.RecordTypeId IN : lstRTBackOffice 
                    ORDER BY CreatedDate ASC];
        //Agregar la logica para hacer el mapa de prioridades y la lista ordenada
       /* if(lstQueue.size()>0){
            Map<PendingServiceRouting, Integer> psrConPrioridad= new Map<PendingServiceRouting, Integer>();
            for(PendingServiceRouting psr:lstQueue){    
                Long tiempoTranscurrido= (system.now().getTime()-psr.createdDate.getTime())/1000;
                    if(psr.workItem.RecordTypeId ==idRTPresencial && tiempoTranscurrido>=Constants.ROJO_PRESENCIAL){
                        psrConPrioridad.put(psr, 1);
                    }else if(psr.workItem.RecordTypeId==idRTPresencial&& tiempoTranscurrido>=Constants.AMARILLO_PRESENCIAL ){
                        psrConPrioridad.put(psr, 2);
                    }else if(psr.workItem.RecordTypeId==idRTPresencial&& tiempoTranscurrido<Constants.AMARILLO_PRESENCIAL){
                        psrConPrioridad.put(psr, 3);
                    }else if(psr.workItem.RecordTypeId==idRTFigital&& tiempoTranscurrido>=Constants.ROJO_FIGI){
                        psrConPrioridad.put(psr, 4);
                    }else if(psr.workItem.RecordTypeId==idRTFigital&& tiempoTranscurrido>=Constants.AMARILLO_FIGI){
                        psrConPrioridad.put(psr, 5);
                    }else{
                        psrConPrioridad.put(psr, 6);
                    }
            }
            for(PendingServiceRouting psr:psrConPrioridad.keySet()){
                if(!mapQueueByPriority.containsKey(psrConPrioridad.get(psr))){
                    mapQueueByPriority.put(psrConPrioridad.get(psr), new List<PendingServiceRouting>());
                }
                mapQueueByPriority.get(psrConPrioridad.get(psr)).add(psr);
            }

            List<Integer> lstPrioridadOrdenada= new List<Integer>(mapQueueByPriority.keySet());
            lstPrioridadOrdenada.sort();
            for(Integer prioridad:lstPrioridadOrdenada){
                lstQueueOrdered.addAll(mapQueueByPriority.get(prioridad));
            }

        }*/
        System.debug('acabe loadPendingServiceRouting'+ lstQueue);
        
    }        
    

    public static void loadCapacityAgentsBO() {

        List<PresenceUserConfig> lstCapacity = [SELECT Capacity FROM PresenceUserConfig WHERE DeveloperName = 'Agentes_de_Riesgos' LIMIT 1];

        capacityAgentsBO = lstCapacity.size() > 0 ? lstCapacity.get(0).Capacity : 0;
    }


    public static void loadPendingServiceRoutingToInsert() {

        if( lstPendingServiceRoutingToInsert == null ) {

            lstPendingServiceRoutingToInsert = new List<PendingServiceRouting>();
        }
    }

    public static void loadPendingServiceRoutingToUpdate() {

        if( lstPendingServiceRoutingToUpdate == null ) {

            lstPendingServiceRoutingToUpdate = new List<PendingServiceRouting>();
        }
    }


    // ESCENARIO 1-->Se llama desde la clase CaseTriggerHelper
    public static void createPendingServiceRouting(String newCaseId, String caseRecordType) {
        System.debug('Inicie escenario 1 crear caso');
        String idRTPresencial = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Riesgos_Originaci_n').getRecordTypeId();

        PendingServiceRouting psr = new PendingServiceRouting();
        psr.workItemId = newCaseId;
        psr.RoutingType = 'SkillsBased';
        psr.CapacityWeight = 1;
        psr.ServiceChannelId = serviceChannelId;
        psr.RoutingModel = 'MostAvailable';
        psr.RoutingPriority = caseRecordType == idRTPresencial ? 1 : 2;
        psr.IsPreferredUserRequired=true;
        System.debug('fer '+mapAssignedCasesUsr);
        //Buscar el usuario menos ocupado y asignarle la solicitud si su carga es menor a su carga de trabajo
        //Si no, solo se crea la solicitud y la asignación se hace en alguno de los dos otros caso
        System.debug('mapAssignedCasesUsr ' + mapAssignedCasesUsr);
        List<Integer> lstOrdenar= new List<Integer>(mapAssignedCasesUsr.keySet());
        lstOrdenar.sort();
        System.debug('Keys ordenadas '+ lstOrdenar);
        if(lstOrdenar.size()>0 &&lstOrdenar[0]< capacityAgentsBO) {
            List<String> lstUsuariosDisponibles= mapAssignedCasesUsr.get(lstOrdenar[0]);
            psr.PreferredUserId = lstUsuariosDisponibles[0];
            psr.IsReadyForRouting = true;

        } else {
            psr.PreferredUserId =UserInfo.getUserId();
            psr.IsReadyForRouting = false;
        }

        lstPendingServiceRoutingToInsert.add(psr);
        System.debug('Terminé escenario 1 ' + lstPendingServiceRoutingToInsert);
    }

    //ESCENARIO 2-->Se Loguea un Analista en OmniChannel
    public static void assingPendingServiceRoutingLoginOmni(String caseOwnerId) {
        System.debug('Inicie escenario 2 login' );
        //Ocupo la lista ordenada de casos por pioridad y le agrego máximo 3
        Integer contadorAsignaciones=0;
        System.debug('Fer '+ lstQueue);
        System.debug('Capacidad '+capacityAgentsBO );
        
        while(lstQueue.size()>0 && contadorAsignaciones<capacityAgentsBO){
            assingPendingServiceRouting(caseOwnerId);
            contadorAsignaciones++;
        
        }
        System.debug('Termine escenario 2 '+  lstPendingServiceRoutingToUpdate);
    }

    // ESCENARIO 3:El Analista termina una Solicitud
    public static void assingPendingServiceRouting(String caseOwnerId) {
        System.debug('Inicie escenario 3, acabar caso');
        //Cada que termina una solicitud, le agrego una solicitud nueva, la que es mas importante
        if(lstQueue.size()>0){
            PendingServiceRouting psr = lstQueue.get(0);
            psr.IsReadyForRouting=true;
            psr.PreferredUserId = caseOwnerId;

            lstPendingServiceRoutingToUpdate.add(psr);
            lstQueue.remove(0);   
        }   
        System.debug('Terminé escenario 3 ' + lstPendingServiceRoutingToUpdate); 
    }

    public static void insertPendingServiceRouting() {

        if( lstPendingServiceRoutingToInsert.size() > 0 ) {

            insert lstPendingServiceRoutingToInsert;
        }
    }

    public static void updatePendingServiceRouting() {

        if( lstPendingServiceRoutingToUpdate.size() > 0 ) {

            update lstPendingServiceRoutingToUpdate;
        }
    }
}