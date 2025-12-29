/************************************************************************************************
Apex Class Name	:	MicroServicioSendNotification 
Version			:	1.0
Created Date    :	27/08/2019 12:12
Function 		: 	microservicio para enviar un sms al cliente
Test Class		:	MicroServicioSendNotification_Test
Code Coverage   :
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     27/08/2019 	   Original Version
*************************************************************************************************/
global with sharing class MicroServicioSendNotification {
    
    @InvocableMethod(label='Send Notification' description='Send SMS Notification.')
    global static void send_notification(List<Casos> casos) {
        for(integer i=0; i<casos.size(); i++){
            String mensaje = casos[i].mensaje;
            if(mensaje.length()>159){
                if(mensaje.contains('su aclaracion')){
                    Integer posicion = mensaje.indexOf('su aclaracion');
                    mensaje = mensaje.left(posicion-(mensaje.length()-158)) + ' ' +mensaje.right(mensaje.length()-posicion);         
                }
                else{mensaje = mensaje.right(159);
                }
            }  
            system.debug('casos[i]'+casos[i]);
            MicroServicioSendNotification.send_notification_future(casos[i].tipo,casos[i].inicio,mensaje,casos[i].numeroTelefono,casos[i].codigoArea,casos[i].curp);
        }
    }
    global class Casos {
        @InvocableVariable(required=true)
        global String tipo;

        @InvocableVariable(required=true)
        global String inicio;

        @InvocableVariable(required=true)
        global String mensaje;

        @InvocableVariable(required=true)
        global String numeroTelefono;

        @InvocableVariable(required=true)
        global String codigoArea;

         @InvocableVariable(required=true)
        global String curp;
    }

    @Future(callout=true)
    public static void send_notification_future(string tipo,string inicio,string mensaje,string numeroTelefono,string codigoArea, string curp) {

        ///
        sendNotification(tipo, inicio, mensaje, numeroTelefono, codigoArea, curp, true);
    }

    public static void sendNotification(string tipo,string inicio,string mensaje,string numeroTelefono,string codigoArea, string curp, Boolean invokeCustomerData) {

        if( invokeCustomerData ) {

            String phone;
            if(curp != null && curp != '') {

                Map<String,Object> mapCustomerData = MicroServicioCustomerData.consulta_Customer_Data(curp);
                Object ObjectJSON = mapCustomerData.get('resultCustomerData');
                CustomerDataJSON CDJSON= (CustomerDataJSON)ObjectJSON;
                
                if(CDJSON != null && CDJSON.message.cliente != null) {

                    for(Integer i=0; i<CDJSON.message.cliente.informacionContacto.telefono.size();i++){
                        if(CDJSON.message.cliente.informacionContacto.telefono[i].tipoTelefono == 'MO'){
                            phone = CDJSON.message.cliente.informacionContacto.telefono[i].numeroTelefono;
                        }
                    }
                }
            }
            if(phone != null){
                numeroTelefono = phone.right(10);
                if(phone.length() == 13){codigoarea = phone.left(3);}
            }
            System.debug('phone cliente '+phone);
            
            Cadena__mdt cad = [SELECT Cadena__c
                            FROM Cadena__mdt 
                            WHERE MasterLabel =: 'CodigoArea' 
                            LIMIT 1];
            if(codigoarea.length() >3){ codigoarea = codigoarea.right(3);}     
            if(codigoarea == '152'){codigoarea = '521';}
            if(cad.Cadena__c != null){codigoarea = cad.Cadena__c + codigoarea;}
        }

        //Mapa que almacena el resultado de la consulta al microservicio
        Map<String, Object> result = new Map<String, Object>();
        //colocamos por default success en false
        Boolean success = false;
        //Mapa que almacena los paramentros de la invocación al microservicio
        Map<String, String> params = new Map<String, String>();
        params.put('tipo', tipo); 
        params.put('inicio', inicio);   
        params.put('mensaje', inicio + mensaje); 
        params.put('numeroTelefono', numeroTelefono); 
        params.put('codigoArea', codigoArea);      
        System.debug('Consulta tipo: ' + tipo);
        System.debug('Consulta inicio: ' + inicio);
        System.debug('Consulta mensaje: '+ inicio + mensaje);
        System.debug('Consulta numeroTelefono: ' + numeroTelefono);
        System.debug('Consulta codigoArea: ' + codigoArea);
        //Invocamos al microservicio
        MicroServicioSendNotification SendNotification = new MicroServicioSendNotification();
        System.debug('SendNotification: ' + SendNotification);
        //Llamamos a la clase JSON para enviarle los parametros
        SendNotificationJSON resultSendNotification = SendNotification.getSendNotification(params);
        System.debug('resultSendNotification: ' + resultSendNotification);
        //Si la respuesta no es nula colocamos success en true
        if(resultSendNotification != null) { success = true;}
        //Llemamos el mapa de la respuesta con el valor de success y la resputa en formato JSON
        System.debug('Consultar Send Notification Success: ' + success);
        result.put('success', success);
        result.put('resultSendNotification', resultSendNotification);
        //Retornamos el mapa result
        //return resultado; 
    }
    //Llamamos a la clase ClienteMicroServicios
    private ClienteMicroServicios cliente;
    //Método Post
    private static final String POST = 'POST';
    //Colocamos la url del microservicio y lo asignamos a una variable String
    private static final String GETDATA = 'client/send/message';
    //Métdo contructor
    public MicroServicioSendNotification() {
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
    public SendNotificationJSON getSendNotification(Map<String, String> params) {   
        //Asingamos a esta variable el nombre de la clase   
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        SendNotificationJSON result;     
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
            if (isSuccess) { result = SendNotificationJSON.parse(res.getBody());               
            } else {cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));      
            }
        } catch (Exception e) {          
            cliente.logError(currentClassName, e.getMessage());          
        }   
        return result;
    }
    //Método que envía el SMS
	
}