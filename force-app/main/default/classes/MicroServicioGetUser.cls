/************************************************************************************************
Apex Class Name	:	microServicioGetUser 
Version			:	1.0
Created Date    :	14/08/2019 5:40
Function 		: 	microservicio Get User, para obtener si el usuario es usuario App
Test Class		:	microServicioGetUser_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     14/08/2019 	   Original Version
*************************************************************************************************/
public class MicroServicioGetUser {
    //Llamamos a la clase ClienteMicroServicios
    private ClienteMicroServicios cliente;
    //Método Post
    private static final String POST = 'POST';
    //Colocamos la url del microservicio y lo asignamos a una variable String
    private static final String GETUSER = 'client/get/user';
    //Métdo contructor
    public MicroServicioGetUser() {
        //Asignamos a esta variable el nombre de la clase
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        //Enviamos los parametros necesarios al microServicio Cliente para poder generar el Token
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(GETUSER);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }
    //Método para parsear la respuesta en formato JSON
    public GetUserJSON obtenerGetUser(Map<String, String> params) {   
        //Asingamos a esta variable el nombre de la clase   
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        GetUserJSON result;     
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
            if (isSuccess) { result = GetUserJSON.parse(res.getBody());               
            } else {cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));      
            }
        } catch (Exception e) {          
            cliente.logError(currentClassName, e.getMessage());          
        }   
        return result;
    }
    //Método que envía la petición al microservicio con los parametros que se 
    //envian desde el helper del Componente
    @AuraEnabled
    public static Map<String, Object> consulta_Get_User(String tipoDocumento, String numeroDocumento) {
        //Mapa que almacena el resultado de la consulta al microservicio
        Map<String, Object> result = new Map<String, Object>();
        //colocamos por default success en false
        Boolean success = false;
        //Mapa que almacena los paramentros de la invocación al microservicio
        Map<String, String> params = new Map<String, String>();
        params.put('tipoDocumento', tipoDocumento); 
        params.put('numeroDocumento', numeroDocumento);       
        System.debug('Consulta GetUser tipoDocumento: ' + tipoDocumento);
        System.debug('Consulta GetUser numeroDocumento: ' + numeroDocumento);
        //Invocamos al microservicio
        MicroServicioGetUser getUser = new MicroServicioGetUser();
        System.debug('getUser1: ' + getUser);
        //Llamamos a la clase JSON para enviarle los parametros
        GetUserJSON resultGetUser = getUser.obtenerGetUser(params);
        System.debug('resultGetUser: ' + resultGetUser);
        //Si la respuesta no es nula colocamos success en true
        if(resultGetUser != null) { success = true;}
        //Llemamos el mapa de la respuesta con el valor de success y la resputa en formato JSON
        System.debug('Consultar GetUser Success: ' + success);
        result.put('success', success);
        result.put('resultGetUser', resultGetUser);
        //Retornamos el mapa result
        return result;
    }
    
}