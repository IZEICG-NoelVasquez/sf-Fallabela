public class OtrosDatosController {

    @AuraEnabled
    public static Map<String, String> getNacionalidades(){
        Map<String, String> nacionalidades = new Map<String, String>();
        List<Nacionalidad__mdt> nacList = [Select MasterLabel, Pais__c, DeveloperName,NamespacePrefix 
                                           From Nacionalidad__mdt
                                           ORDER BY Pais__c ASC];
        if(nacList.size()>0){
            for(Nacionalidad__mdt nac : nacList){
                nacionalidades.put(nac.MasterLabel, nac.Pais__c);
            }
        }
        return nacionalidades;
    }

    @AuraEnabled
    public static List<String> getActividades(){
        List<String> ActivadesList = new List<String>();
        List<Actividad_o_Giro__mdt> ActGiroList = [Select MasterLabel, DeveloperName,NamespacePrefix 
                                                   From Actividad_o_Giro__mdt
                                                   ORDER BY MasterLabel];
        if(ActGiroList.size()>0){
            for(Actividad_o_Giro__mdt act : ActGiroList){
                ActivadesList.add(act.MasterLabel);
            }
        }
        return ActivadesList;
    }

    @AuraEnabled
    public static Map<String, String> getProfesiones(){
        Map<String, String> Profesiones = new Map<String, String>();
        List<Profesion__mdt> proList = [Select MasterLabel, Profesion__c, DeveloperName,NamespacePrefix 
                                        From Profesion__mdt
                                        ORDER BY MasterLabel];
        if(proList.size()>0){
            for(Profesion__mdt pro : proList){
                Profesiones.put(pro.MasterLabel, pro.Profesion__c);
            }
        }
        return Profesiones;
    }

    @AuraEnabled
    public static Map<String, String> getSexos(){
        Map<String, String> SexosMap = new Map<String, String>();
        List<Sexo__mdt> sexoList = [Select MasterLabel, DeveloperName,NamespacePrefix 
                                    From Sexo__mdt
                                    ORDER BY MasterLabel];
        if(sexoList.size()>0){
            for(Sexo__mdt sexo : sexoList){
                SexosMap.put(sexo.MasterLabel, sexo.DeveloperName);
            }
        }
        return SexosMap;
    }

    @AuraEnabled
    public static Map<String, String> getEstados(){
        Map<String, String> EstadosMap = new Map<String, String>();
        List<Region__mdt> EstadoList = [Select MasterLabel, Region__c, DeveloperName,NamespacePrefix 
                                        From Region__mdt
                                        ORDER BY MasterLabel];
        if(EstadoList.size()>0){
            for(Region__mdt reg : EstadoList){
                EstadosMap.put(reg.MasterLabel, reg.Region__c);
            }
        }
        return EstadosMap;
    }

    @AuraEnabled
    public static Map<String, String> getEstadoCivil(){
        Map<String, String> EstadoCivilMap = new Map<String, String>();
        List<Estado_Civil__mdt> EstadoCivilList = [Select MasterLabel, Estado_Civil__c, DeveloperName,NamespacePrefix 
                                                   From Estado_Civil__mdt
                                                   ORDER BY MasterLabel];
        if(EstadoCivilList.size()>0){
            for(Estado_Civil__mdt reg : EstadoCivilList){
                EstadoCivilMap.put(reg.MasterLabel, reg.Estado_Civil__c);
            }
        }
        return EstadoCivilMap;
    }

    

    @AuraEnabled
    public static Account getOtrosDatos(Id accId){
        Account acc = [Select Id, Estado_Civil__c, Genero__c,Entidad_Federativa_de_Nacimiento__c,
                       Nacionalidad__c, Pais_de_Nacimiento__c, Actividad_o_Giro_del_Negocio__c,
                       Ocupacion_o_Profesion__c, Telefono_Fijo_Casa__c, Telefono_Fijo_Trabajo__c,
                       FIEL__c, Publicidad__c, RFC__c
                       From Account 
                       Where Id =: accId LIMIT 1];
        return acc;    
    }

    @AuraEnabled
    public static Map<String, Object> otrosDatosF(Map<String, String> campos ) {

        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;

        Map<String, Object> params = new Map<String, Object>();

        if( campos.containsKey('rfc') || campos.containsKey('publicidad') ) {

            List<Object> listMapAtributoFlex = new List<Object>();

            Map<String, String> mapRFC = new Map<String,String>();
            if( campos.containsKey('rfc') ) {                      
                
                mapRFC.put('valorAtributo', campos.get('rfc') );
                mapRFC.put('nombreAtributo', 'rfc');                
                listMapAtributoFlex.add(mapRFC);
            }

            Map<String, String> mapPublicidad = new Map<String,String>();
            if( campos.containsKey('publicidad') ) {                      
                
                System.debug('campos.get(publicidad):  ' + campos.get('publicidad') );
                mapPublicidad.put('valorAtributo', campos.get('publicidad') == 'true' ? 'S' : 'N' );
                mapPublicidad.put('nombreAtributo', 'aceptaRecibirPublicidad');                
                listMapAtributoFlex.add(mapPublicidad);
            }

            params.put('atributoFlexible', listMapAtributoFlex);
        }

        ///// ///// ///// ///// /////

        if( campos.containsKey('numeroTelefonoCasa') || campos.containsKey('numeroTelefonoTrabajo') ) {

            List<Object> listMapTelefono = new List<Object>();

            Map<String, String> mapTelCasa = new Map<String,String>();
            if( campos.containsKey('numeroTelefonoCasa') ) {                      
                
                mapTelCasa.put('tipoTelefono', 'TE');
                mapTelCasa.put('numeroTelefono', campos.get('numeroTelefonoCasa') );
                listMapTelefono.add(mapTelCasa);
            }

            Map<String, String> mapTelTrabajo = new Map<String,String>();
            if( campos.containsKey('numeroTelefonoTrabajo') ) {                      
                
                mapTelTrabajo.put('tipoTelefono', 'FA');
                mapTelTrabajo.put('numeroTelefono', campos.get('numeroTelefonoTrabajo') );
                listMapTelefono.add(mapTelTrabajo);
            }

            Map<String, Object> mapInfoContTelefonos = new Map<String, Object>();
            mapInfoContTelefonos.put('telefono', listMapTelefono);

            params.put('informacionContacto', mapInfoContTelefonos);
        }

        ///// ///// ///// ///// /////

        Map<String, Object> mapCliente = new Map<String, Object>();
        

        Map<String,String> mapInfoPersonal = new Map<String, String>();

        if( campos.containsKey('profesionCliente') ) {
            mapInfoPersonal.put('profesionCliente', campos.get('profesionCliente') );
        }

        if( campos.containsKey('paisResidencia') ) {
            mapInfoPersonal.put('paisResidencia', campos.get('paisResidencia') );
        } else {
            mapInfoPersonal.put('paisResidencia', '484'); /// Se envia por default el Pais de Residencia en caso de no especificarse
        }
        
        if( campos.containsKey('codigoPaisNacimiento') ) {
            mapInfoPersonal.put('codigoPaisNacimiento', campos.get('codigoPaisNacimiento') );
        }        
        
        mapCliente.put('informacionPersonal', mapInfoPersonal);

        ///// ///// ///// ///// /////

        if( campos.containsKey('estadoCivil') ) {
            mapCliente.put('estadoCivil', campos.get('estadoCivil') );
        }
        if( campos.containsKey('nacionalidad') ) {
            mapCliente.put('nacionalidad', campos.get('nacionalidad') );
        }
        if( campos.containsKey('genero') ) {
            mapCliente.put('genero', campos.get('genero') );
        }
        if( campos.containsKey('numeroDocumento') ) {
            mapCliente.put('numeroDocumento', campos.get('numeroDocumento') );
        }

        params.put('cliente', mapCliente);

        ///// ///// ///// ///// /////
                

        System.debug('params:  ' + params);

        MicroServicioActualizacionDatosCliente msCamposReg = new MicroServicioActualizacionDatosCliente();
        ActualizarDatosClienteJSON camposReg = msCamposReg.actualizarDatosJSON2_1n(params);
        
        if(camposReg != null) {
            success = true;
        }

        System.debug('Actualizar Campos Regulatorios Success: ' + success);
        result.put('success', success);
        result.put('camposReg', camposReg);
        return result;
    }

    @AuraEnabled
    public static Account updateAccount(String idAcc, Map<String, String> campos) {

        Account accUpdate = new Account();
        accUpdate.Id = idAcc;

        if( campos.containsKey('nacionalidadTexto') ) {
            accUpdate.Nacionalidad__c = campos.get('nacionalidadTexto');
        }
        if( campos.containsKey('actividadGiro') ) {
            accUpdate.Actividad_o_Giro_del_Negocio__c = campos.get('actividadGiro');
        }
        if( campos.containsKey('codigoPaisNacimientoTexto') ) {
            accUpdate.Pais_de_Nacimiento__c = campos.get('codigoPaisNacimientoTexto');
        }
        if( campos.containsKey('profesionClienteTexto') ) {
            accUpdate.Ocupacion_o_Profesion__c = campos.get('profesionClienteTexto');
        }
        if( campos.containsKey('entidadFedNacimientoTexto') ) {
            accUpdate.Entidad_Federativa_de_Nacimiento__c = campos.get('entidadFedNacimientoTexto');
        }
        if( campos.containsKey('fiel') ) {
            accUpdate.FIEL__c = campos.get('fiel');
        }
        if( campos.containsKey('generoTexto') ) {
            accUpdate.Genero__c = campos.get('generoTexto');
        }
        if( campos.containsKey('estadoCivilTexto') ) {
            accUpdate.Estado_Civil__c = campos.get('estadoCivilTexto');
        }
        if( campos.containsKey('numeroTelefonoCasa') ) {
            accUpdate.Telefono_Fijo_Casa__c = campos.get('numeroTelefonoCasa');
        }
        if( campos.containsKey('numeroTelefonoTrabajo') ) {
            accUpdate.Telefono_Fijo_Trabajo__c = campos.get('numeroTelefonoTrabajo');
        }
        if( campos.containsKey('rfc') ) {
            accUpdate.RFC__c = campos.get('rfc');
        }
        if( campos.containsKey('publicidad') ) {
            accUpdate.Publicidad__c = campos.get('publicidad') == 'true' ? true : false ;
        }

        try {

            update accUpdate;
        } catch (Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() );
            System.debug('Linea:  ' + ex.getLineNumber() );
        }        

        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedCamposReg (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }
}