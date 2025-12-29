/**
* Nombre: SendEmailTemplateController
* Autor: ----
* Descripcion: Controlador Apex del Componente Lightning PDFAclaracionesSend
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           ----             ----                       Creación
* 2.0           26/01/2021       Mauricio Rosales           Componente para visualizar el PDF
* 3.0           03/02/2021       Mauricio Rosales           Validacion de al menos un movimiento seleccionado
* 3.1           26/03/2021       Mauricio Rosales           Consulta del Email del Contacto
* 3.2           29/03/2021       Mauricio Rosales           Se crea tarea de envio de Email
* --------------------------------------------------------------------------
*/
public without sharing class SendEmailTemplateController {
    
    @AuraEnabled
    public static Boolean send(String contactId, String caseId, String tarjeta){
        
        Case cs = [SELECT Correo_Formato_Aclaraciones_Enviado__c, URLAclaraciones__c, Correo_Direccion_Aclaraciones__c, Subcategor_a_Texto__c, Clasificaci_n_Cargo_Formula__c, CaseNumber, ContactEmail FROM Case where Id= :caseId LIMIT 1];
        
        if (cs != null) {
            if(cs.Correo_Formato_Aclaraciones_Enviado__c) {
                return false;
            }
        }
        
        Blob cryptoKey;
        Blob data = Blob.valueOf(tarjeta);
        
        if(APIKey__c.getAll().containsKey('PDFKey') && APIKey__c.getInstance('PDFKey').cryptoKey__c != null) {
            cryptoKey = EncodingUtil.base64Decode(APIKey__c.getInstance('PDFKey').cryptoKey__c);
        }
        
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
        String encodeBase64encrypData = EncodingUtil.base64Encode(encryptedData);
        String urlBase64encrypData = EncodingUtil.urlEncode(encodeBase64encrypData, 'UTF-8');
        
        Site site = [SELECT GuestUserId, Name, Subdomain, OptionsRequireHttps, UrlPathPrefix FROM Site WHERE Name = :'Formato_Aclaraciones'];
        
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
        /*
        String httpStr = 'http<span>:</span>//';
        if(site.OptionsRequireHttps == true) {
            httpStr = 'https<span>:</span>//';
        }
        
        String siteFullUrl = httpStr;*/
        String siteFullUrl = '';
        if(org.IsSandbox == true) {
            siteFullUrl += UserInfo.getUserName().substringAfterLast('.')+'-';
        }
        
        siteFullUrl += site.Subdomain + '.';
        siteFullUrl += (org.IsSandbox || org.OrganizationType == 'Developer Edition' ? (org.InstanceName.toLowerCase() + '.') : '') + 'force<span>.</span>com';
        siteFullUrl += '/' + site.UrlPathPrefix;
        
        //URL
        cs.URLAclaraciones__c = siteFullUrl + '?id=' + caseId + '&t=' + urlBase64encrypData; 
        
        if (cs.Subcategor_a_Texto__c == 'Cargo no reconocido' && cs.Clasificaci_n_Cargo_Formula__c == 'Cargo desconocido') {
            cs.Correo_Direccion_Aclaraciones__c = 'cargodesconocido<span>@</span>falabella<span>.</span>onmicrosoft<span>.</span>com '; //cargodesconocido@falabella.onmicrosoft.com
        } else if (cs.Subcategor_a_Texto__c == 'Cargo no reconocido' && cs.Clasificaci_n_Cargo_Formula__c == 'Cargo no reconocido') {
            cs.Correo_Direccion_Aclaraciones__c = 'aclaracionesmx<span>@</span>falabella<span>.</span>com<span>.</span>mx '; // aclaracionesmx@falabella.com.mx
        } else {
            cs.Correo_Direccion_Aclaraciones__c = 'aclaraciones<span>@</span>falabella<span>.</span>com<span>.</span>mx '; //aclaraciones@falabella.com.mx
        }

        update cs;
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body, BrandTemplateId FROM EmailTemplate WHERE developername = 'Formato_aclaraci_n_Falabella_2' LIMIT 1];
        
        String emailTemplateId=emailTemplate.Id;
        
        
        
        //build the email message
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(emailTemplateId, contactId, caseId);
        
        mail.setReplyTo('servicioaclientes@falabella.com.mx');
        mail.setSenderDisplayName('Atención a Clientes Falabella');
        mail.setTargetObjectId(contactId);
        mail.setSaveAsActivity(false);
        
        mails.add(mail);
        
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(mails);         
        }   
        cs.Correo_Formato_Aclaraciones_Enviado__c = true;
        cs.URLAclaraciones__c = null;
        update cs;

        Task task = new Task();
        task.TaskSubtype = 'Email';
        task.WhatId = caseId;
        task.Subject = 'Email: Formato de Aclaración Falabella Folio: ' + cs.CaseNumber;
        task.Status = 'Completed';
        task.ActivityDate = System.today();
        task.WhoId = contactId;
        task.Description = cs.ContactEmail;
        insert task;
        
        return true;
    } 

    /*
    * Obtiene el nombre del perfil del usuario actual
    * Regresa un Mapa con una variable booleana de exito, y la informacion del Perfil
    */
    @AuraEnabled
    public static Map<String, Object> getUserInfo() {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        List<User> listUsr = [SELECT Profile.Name FROM User WHERE Id =: userinfo.getUserId()];

        if( listUsr.size() > 0 ) {

            mapResult.put('userProfile', listUsr[0].Profile.Name);

            success = true;
        }

        mapResult.put('success', success);
        
        return mapResult;
    }

    /*
    * Obtiene la lista relacionada de movimientos para un registro de Casos
    * Regresa un Mapa con una variable booleana de exito, si el caso tiene al menos un movimiento. Y el Email del contacto 
    * 
    * @param recordId: id del registro del Caso 
    */
    @AuraEnabled
    public static Map<String, Object> getMovimientos(String recordId) {

        Map<String, Object> mapResult = new Map<String, Object>();
        Boolean success = false;

        List<Movimientos__c> listMovimientos = [SELECT Id, Caso_Movimiento__r.ContactEmail FROM Movimientos__c WHERE Caso_Movimiento__c =: recordId AND Formato_Aclaraciones__c = TRUE];

        if( listMovimientos.size() > 0 ) {

            success = true;
            mapResult.put('contactEmail', listMovimientos[0].Caso_Movimiento__r.ContactEmail);
        }

        mapResult.put('success', success);

        return mapResult;
    }
    
}