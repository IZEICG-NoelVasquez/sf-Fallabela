/**
* Nombre: UtilitiesBatchCasesEmboce
* Autor: Mauricio Rosales
* Descripcion: Utilidades para los procesos Batch del flujo Emboce Centralizado
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           19/05/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class UtilitiesBatchCasesEmboce {

    public static Map<String,String> validateSaveResult(Database.SaveResult[] lstSaveResult, Boolean blnInsert) {

        Map<String,String> mapErrors = new Map<String,String>();

        for(Database.SaveResult saveRes: lstSaveResult) {

            if( !saveRes.isSuccess() ) {

                List<String> lstErrors = new List<String>();
                List<String> lstStatusCode = new List<String>();

                for(Database.Error error: saveRes.getErrors() ) {

                    lstErrors.add(error.getMessage());
                    lstStatusCode.add(String.valueOf(error.getStatusCode()));
                }

                mapErrors.put( ( blnInsert ? String.join(lstStatusCode, ';') : saveRes.getId() ), String.join(lstErrors, ';'));
            }
        }

        return mapErrors;
    }    
    
    public static void sendEmail(String strBatchName, Map<String,Object> mapErrors) {

        List<String> lstToAdresses = System.Label.EMBOCE_CENTRALIZADO_BATCH_NOTIFICACIONES.split(',');

        String strBodyHtml = createBodyHtml(mapErrors);
        String[] toAddresses = lstToAdresses;

        List<Messaging.SingleEmailMessage> lstMails =  new List<Messaging.SingleEmailMessage>();        
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(toAddresses);
        email.setSubject('Notificación de Error en el Proceso - ' + strBatchName);
        email.setHtmlBody(strBodyHtml);
        email.setSaveAsActivity(false);

        lstMails.add(email);

        Messaging.sendEmail(lstMails);
    }

    public static String createBodyHtml(Map<String,Object> mapErrors) {

        String strBodyHtml = '<html><body>Buen día,';


        if( mapErrors.containsKey('WebService') ) {

            strBodyHtml += '<br/><br/>Se produjo un error al consumir los Web Service de Estafeta:';
            
            strBodyHtml += '<br/><br/><table width="100%" style="border-collapse: collapse; ">';
            strBodyHtml += '<tr><th width="30%" align="left" >Web Service</th>';
            strBodyHtml += '<th width="70%" align="left" >Error</th></tr>';

            Map<String,String> mapErrorsAux = (Map<String,String>)mapErrors.get('WebService');

            for(String strError: mapErrorsAux.keySet()) {

                strBodyHtml += '<tr><td align="left">' + strError + '</td>';
                strBodyHtml += '<td align="left">' + mapErrorsAux.get(strError) + '</td></tr>';
            }
            strBodyHtml += '</table>';
        }

        if( mapErrors.containsKey('WayBill') ) {

            strBodyHtml += '<br/><br/>Se produjo un error en la consulta, guías no encontradas:';

            strBodyHtml += '<br/><br/><table width="100%" style="border-collapse: collapse; ">';
            strBodyHtml += '<tr><th width="30%" align="left" >Id del Caso</th>';
            strBodyHtml += '<th width="70%" align="left" >Número de Guía</th></tr>';

            Map<String,String> mapErrorsAux = (Map<String,String>)mapErrors.get('WayBill');

            for(String strError: mapErrorsAux.keySet()) {

                strBodyHtml += '<tr><td align="left">' + strError + '</td>';
                strBodyHtml += '<td align="left">' + mapErrorsAux.get(strError) + '</td></tr>';
            }
            strBodyHtml += '</table>';
        }

        if( mapErrors.containsKey('DML') ) {

            strBodyHtml += '<br/><br/>Se produjo un error al actualizar los Casos de Emboce Centralizado:';

            strBodyHtml += '<br/><br/><table width="100%" style="border-collapse: collapse; ">';
            strBodyHtml += '<tr><th width="30%" align="left" >Id del Caso</th>';
            strBodyHtml += '<th width="70%" align="left" >Error</th></tr>';

            Map<String,String> mapErrorsAux = (Map<String,String>)mapErrors.get('DML');

            for(String strError: mapErrorsAux.keySet()) {

                strBodyHtml += '<tr><td align="left">' + strError + '</td>';
                strBodyHtml += '<td align="left">' + mapErrorsAux.get(strError) + '</td></tr>';
            }
            strBodyHtml += '</table>';
        }



        if( mapErrors.containsKey('Insert') ) {

            strBodyHtml += '<br/><br/>Se produjo un error al crear los Casos de Emboce Centralizado:';

            strBodyHtml += '<br/><br/><table width="100%" style="border-collapse: collapse; ">';
            strBodyHtml += '<tr><th width="30%" align="left" >Error</th>';
            strBodyHtml += '<th width="70%" align="left" >Detalle</th></tr>';

            Map<String,String> mapErrorsAux = (Map<String,String>)mapErrors.get('Insert');

            for(String strError: mapErrorsAux.keySet()) {

                strBodyHtml += '<tr><td align="left">' + strError + '</td>';
                strBodyHtml += '<td align="left">' + mapErrorsAux.get(strError) + '</td></tr>';
            }
            strBodyHtml += '</table>';

            if( mapErrors.containsKey('lstErrorAccountIds') ) {

                List<String> lstErrorAccountIds = (List<String>)mapErrors.get('lstErrorAccountIds');

                if( lstErrorAccountIds.size() > 0 ) {

                    strBodyHtml += '<br/><table width="100%" style="border-collapse: collapse; ">';
                    strBodyHtml += '<tr><th width="100%" align="left" >Id de la Cuenta</th></tr>';

                    for(String strAccountId: lstErrorAccountIds) {

                        strBodyHtml += '<tr><td align="left">' + strAccountId + '</td></tr>';
                    }
                    strBodyHtml += '</table>';
                }
            }
        }

        strBodyHtml += '<br/><br/>Saludos,';
        strBodyHtml += '<br/>Administrador de Salesforce.';

        return strBodyHtml;
    }
}