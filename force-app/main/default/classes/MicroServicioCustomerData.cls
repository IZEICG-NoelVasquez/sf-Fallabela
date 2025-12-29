/************************************************************************************************
Apex Class Name	:	MicroServicioCustomerData 
Version			:	1.0
Created Date    :	19/08/2019 11:35
Function 		: 	microservicio para obtener la información del cliente
Test Class		:	MicroServicioCustomerData_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     19/08/2019 	   Original Version
*************************************************************************************************/
public class MicroServicioCustomerData {
    //Llamamos a la clase ClienteMicroServicios
    private ClienteMicroServicios cliente;
    //Método Post
    private static final String POST = 'POST';
    //Colocamos la url del microservicio y lo asignamos a una variable String
    private static final String GETDATA = 'client/get/data';
    //Métdo contructor
    public MicroServicioCustomerData() {
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
    public CustomerDataJSON obtenerCustomerData(Map<String, String> params) {   
        //Asingamos a esta variable el nombre de la clase   
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        CustomerDataJSON result;     
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
            if (isSuccess) { result = CustomerDataJSON.parse(res.getBody());               
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
    public static Map<String, Object> consulta_Customer_Data(String numeroDocumento) {
        //Mapa que almacena el resultado de la consulta al microservicio
        Map<String, Object> result = new Map<String, Object>();
        //colocamos por default success en false
        Boolean success = false;
        //Mapa que almacena los paramentros de la invocación al microservicio
        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', numeroDocumento);       
        System.debug('Consulta CustomerData numeroDocumento: ' + numeroDocumento);
        //Invocamos al microservicio
        MicroServicioCustomerData CustomerData = new MicroServicioCustomerData();
        System.debug('CustomerData: ' + CustomerData);
        //Llamamos a la clase JSON para enviarle los parametros
        CustomerDataJSON resultCustomerData = CustomerData.obtenerCustomerData(params);
        System.debug('resultCustomerData: ' + resultCustomerData);
        //Si la respuesta no es nula colocamos success en true
        if(resultCustomerData != null) { success = true;}
        //Llemamos el mapa de la respuesta con el valor de success y la resputa en formato JSON
        System.debug('Consultar CustomerData Success: ' + success);
        result.put('success', success);
        result.put('resultCustomerData', resultCustomerData);
        //Retornamos el mapa result
        return result;
    }
}