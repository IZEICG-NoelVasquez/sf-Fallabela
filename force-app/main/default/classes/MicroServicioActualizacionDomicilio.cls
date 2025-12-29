/**
* Nombre: MicroServicioActualizacionDomicilio
* Autor: ---
* Descripcion: Clase Apex del Componente Lightning MicroServicioActualizacionDomicilio
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ---             ---                     ---
* 2.0           21/07/2021      Mauricio Rosales        Manejo de Error devuelto por el MicroServicio
* --------------------------------------------------------------------------
*/
public class MicroServicioActualizacionDomicilio {


    @AuraEnabled
    public static Estado__c obtenerEstado(String estado) {

        System.debug('obtenerEstado');

        if(estado == null) {
            return null;
        }

        List<Estado__c> lstEstados = [SELECT Name, Codigo__c FROM Estado__c WHERE Name =: estado ];

        Estado__c result;
        if( lstEstados.size() > 0 ) {
            result = lstEstados[0];
        }

        return result;
    }

    @AuraEnabled
    public static Municipio__c obtenerMunicipio(String municipio, String idEstado) {

        System.debug('obtenerMunicipio');

        if(municipio == null) {
            return null;
        }

        List<Municipio__c> lstMunicipios = [SELECT Name, Estado_Lookup__c FROM Municipio__c WHERE Name =: municipio AND Estado_Lookup__c =: idEstado ];

        Municipio__c result;
        if( lstMunicipios.size() > 0 ) {
            result = lstMunicipios[0];
        }

        return result;
    }

    @AuraEnabled
    public static Colonia__c obtenerColonia(String colonia, String idMunicipio) {

        System.debug('obtenerColonia');

        if(colonia == null) {
            return null;
        }

        List<Colonia__c> lstColonias = [SELECT Name, Municipio_Lookup__c, C_digo_Postal__c FROM Colonia__c WHERE Name =: colonia AND Municipio_Lookup__c =: idMunicipio ];

        Colonia__c result;
        if( lstColonias.size() > 0 ) {
            result = lstColonias[0];
        }

        return result;
    }

    @AuraEnabled
    public static Map<String, Object> createCaseClosedDomicilio (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {

        Map<String, Object> result = new Map<String, Object>();

        CreateCase casoEmail = new CreateCase();
        result = casoEmail.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
      
        return result;
    }

    /**
    * Metodo para Setear los parametros y llamar al MicroServicio
    * Regresa un mapa con una variable de exito y la respuesta del MicroServicio
    *
    * @param campos: mapa con los parametros para el consumo del MicroServicio
    **/
    @AuraEnabled    
    public static Map<String, Object> actualizarDomicilio(Map<String, String> campos ) {
        System.debug('campos:     ' + campos);
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String,Object> params = new Map<String,Object>();

        params.put('cliente', new Map<String, Object>() );

        Map<String,String> mapInfoPersonal = new Map<String, String>();
        mapInfoPersonal.put('paisResidencia', '484');
        ((Map<String,Object>)params.get('cliente')).put('informacionPersonal', mapInfoPersonal);

        if( campos.containsKey('numeroDocumento') ) {
            ((Map<String,Object>)params.get('cliente')).put('numeroDocumento', campos.get('numeroDocumento') );
        }

        /// Se cambia la estructura del JSON en el Request
        params.put('informacionContacto', new Map<String, Object>() );

        Map<String, String> mapDireccion = new Map<String, String>();  
        if( campos.containsKey('tipoBarrio') ) {
            mapDireccion.put('tipoBarrio', campos.get('tipoBarrio') );
        }
        if( campos.containsKey('numeroVivienda') ) {
            mapDireccion.put('numeroVivienda', campos.get('numeroVivienda') );
        }
        if( campos.containsKey('nombreVia') ) {
            mapDireccion.put('nombreVia', campos.get('nombreVia') );
        }
        if( campos.containsKey('descripcionBarrio') ) {
            mapDireccion.put('descripcionBarrio', campos.get('descripcionBarrio') );
        }
        if( campos.containsKey('codigoTipoVia') ) {
            mapDireccion.put('codigoTipoVia', campos.get('codigoTipoVia') );
        }
        if( campos.containsKey('codigoRegion') ) {
            mapDireccion.put('codigoRegion', campos.get('codigoRegion') );
        }
        if( campos.containsKey('codigoPostal') ) {
            mapDireccion.put('codigoPostal', campos.get('codigoPostal') );
        }
        ((Map<String,Object>)params.get('informacionContacto')).put('direccion', mapDireccion);

        //se agrega apartado para atributos flexibles y mandar restoDireccion
        if(campos.containsKey('restoDireccion')){
            System.debug('Entra al contains restoDireccion');
            List<Object> listMapAtributoFlex = new List<Object>();
            Map<String, String> mapRestoDireccion = new Map<String,String>();
            mapRestoDireccion.put('nombreAtributo', 'restodir'); 
            mapRestoDireccion.put('valorAtributo', campos.get('restoDireccion')); 
            listMapAtributoFlex.add(mapRestoDireccion);
            params.put('atributoFlexible', listMapAtributoFlex);
        } 
        System.debug('params:  ' + Json.serializePretty(params));
        
        MicroServicioActualizacionDatosCliente msDom = new MicroServicioActualizacionDatosCliente();
        String domicilio = msDom.actualizarDatos(params);
        ActualizarDatosClienteJSON domicilioExito = null;
        MicroServicioJSONError domicilioError = null;        
        
        try {

            domicilioExito = ActualizarDatosClienteJSON.parse(domicilio);

        } catch(Exception ex) {

            System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );

            try {

                domicilioError = MicroServicioJSONError.parse(domicilio); 

            } catch (Exception ex2) {

                System.debug('ERROR:  ' + ex2.getMessage() + '  LINEA:  ' + ex2.getLineNumber() );
            }
        }

        if( domicilioExito != null ) {

            result.put('success', true);
            result.put('domicilio', domicilioExito );

        } else if( domicilioError != null ) {

            result.put('success', false);
            result.put('domicilio', domicilioError );

        } else {

            result.put('success', false);
            result.put('domicilio', domicilio );
        }

        return result;
    }

    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc, Map<String, String> campos) {

        Account accUpdate = new Account();
        accUpdate.Id = idAcc;
        if( campos.containsKey('tipoBarrio') ) {
            accUpdate.Delegaci_n__c = campos.get('tipoBarrio');
        }
        if( campos.containsKey('numeroVivienda') ) {
            accUpdate.N_mero_de_v_a__c = campos.get('numeroVivienda');
        }
        if( campos.containsKey('nombreVia') ) {
            accUpdate.Nombre_v_a__c = campos.get('nombreVia');
        }
        if( campos.containsKey('descripcionBarrio') ) {
            accUpdate.Colonia__c = campos.get('descripcionBarrio');
        }
        if( campos.containsKey('codigoTipoVia') ) {
            accUpdate.Tipo_de_v_a__c = campos.get('codigoTipoVia');
        }
        if( campos.containsKey('region') ) {
            accUpdate.Regi_n__c = campos.get('region');
        }
        if( campos.containsKey('codigoPostal') ) {
            accUpdate.C_digo_Postal__c = campos.get('codigoPostal');
        } 
        //Se inserta el resto dir en la cuenta
        if( campos.containsKey('restoDireccion') ) {
            accUpdate.Resto_Direcci_n__c = campos.get('restoDireccion');
        }

        try {

            update accUpdate;
        } catch (Exception ex) {
            System.debug('ERROR:  ' + ex.getMessage() );
            System.debug('Linea:  ' + ex.getLineNumber() );
        }        

        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }
}