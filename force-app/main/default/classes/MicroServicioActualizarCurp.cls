/************************************************************************************************
Apex Class Name	:	MicroServicioActualizarCurp 
Version			:	1.0
Created Date    :	24/09/2019 09:23
Function 		: 	microservicio para modificar el curp del cliente en SAT
Test Class		:	MicroServicioActualizarCurp_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     24/09/2019 	   Original Version 
* Mauricio Rosales   16/06/2021 	   Se mueve el metodo obtenerProductosCliente a la clase MicroServicioProductos
*************************************************************************************************/
public without sharing class MicroServicioActualizarCurp {
     //Llamamos a la clase ClienteMicroServicios
    private ClienteMicroServicios cliente;
    //Método Post
    private static final String POST = 'POST';
    //Colocamos la url del microservicio y lo asignamos a una variable String
    private static final String GETDATA = 'client/update/curp';
    //Métdo contructor
    public MicroServicioActualizarCurp() {
        //Asignamos a esta variable el nombre de la clase
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        //Enviamos los parametros necesarios al microServicio Cliente para poder generar el Token
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(GETDATA);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }
    //Método para parsear la respuesta en formato JSON
    public ActualizarCurpJSON obtenerActualizarCurp(Map<String, String> params) {   
        //Asingamos a esta variable el nombre de la clase   
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        ActualizarCurpJSON result;     
        System.debug('req ' + req);      
        //Con las variables de respuesta generadas, intentamos invocar al microservicio hasta 3 veces
        try {         
            for (Integer i = 0; i < 3; i++) {            
                res = cliente.enviarRequest(req);            
                if (res.getStatusCode() == 200) {  
                    //Una vez que sea exitoso terminamos el intento                
                    isSuccess = true; break;                  
                }               
            }           
            System.debug('res ' + res.getBody());  
            //Recorremos la respuesta para que con ayuda de nuestra clase JSON
            //Hagamos el parseo de la resputa         
            for (String s : res.getBody().split(':')) {              
                System.debug('s ' + s);            
            }        
            if (isSuccess) { result = ActualizarCurpJSON.parse(res.getBody());               
            } else {cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));      
            }
        } catch (Exception e) {          
            cliente.logError(currentClassName, e.getMessage());          
        }   
        return result;
    }
    @AuraEnabled
    public static Account updateSelectedAccount (String idAcc, String curpUpdate) {
        System.debug('updateSelectedAccount');

        System.debug('curpUpdate ' +curpUpdate);
        System.debug('idAcc ' +idAcc);
        if (idAcc == null || curpUpdate == null) {
            return null;
        }

        Account acc = [SELECT CURP__c, Id
                                FROM Account WHERE Id =: idAcc LIMIT 1];
        acc.CURP__c = curpUpdate;
        update acc;
        return AuthenticateHelper.updateSelectedAccount(idAcc);
    }
    
    @AuraEnabled
    public static Map<String, Object> createCaseClosedCurp (String recordTypeId, String customerId, String personId, String category, Boolean altoRiesgo, String metodoContactoValue, String numeroDeTarjetaValue, String camposRequeridos ) {
        Map<String, Object> result = new Map<String, Object>();
        CreateCase casoCurp = new CreateCase();
        result = casoCurp.createCaseClosedByRT(recordTypeId, customerId, personId, category, altoRiesgo, metodoContactoValue, numeroDeTarjetaValue, camposRequeridos);
        return result;
    }
    //Método que envía la petición al microservicio con los parametros que se 
    //envian desde el helper del Componente
    @AuraEnabled
    public static Map<String, Object> actualiza_Curp(String numeroDocumento, String newnumeroDocumento) {
        //Mapa que almacena el resultado de la consulta al microservicio
        Map<String, Object> result = new Map<String, Object>();
        //colocamos por default success en false
        Boolean success = false;
        //Mapa que almacena los paramentros de la invocación al microservicio
        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);   
        params.put('newnumeroDocumento', newnumeroDocumento);       
        System.debug('Actualiza Curp numeroDocumento: ' + numeroDocumento);
        System.debug('Actualiza Curp newnumeroDocumento: ' + newnumeroDocumento);
        //Invocamos al microservicio
        MicroServicioActualizarCurp ActualizarCurp = new MicroServicioActualizarCurp();
        System.debug('ActualizarCurp: ' + ActualizarCurp);
        //Llamamos a la clase JSON para enviarle los parametros
        ActualizarCurpJSON resultActualizarCurp = ActualizarCurp.obtenerActualizarCurp(params);
        System.debug('resultActualizarCurp: ' + resultActualizarCurp);
        //Si la respuesta no es nula colocamos success en true
        if(resultActualizarCurp != null) { success = true;}
        //Llemamos el mapa de la respuesta con el valor de success y la resputa en formato JSON
        System.debug('Consultar ActualizarCurp Success: ' + success);
        result.put('success', success);
        result.put('resultActualizarCurp', resultActualizarCurp);
        //Retornamos el mapa result
        return result;
    }


    //Método que manda llamar al microservicio de Productos para determinar si el curp al cuál deseamos
    //cambiar, ya cuenta con productos dentro de SAT y por lo tanto ya existe
    @AuraEnabled
    public static Map<String, Object> obtenerProductosCliente (String curp) {
        
        return MicroServicioProductos.obtenerProductosCliente(curp);
    }
}