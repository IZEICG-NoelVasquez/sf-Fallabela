/**
* Nombre: CustomNotificationService
* Autor: Mauricio Rosales
* Descripcion: Clase de Servicio para las Notificaciones Personalizadas
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                     Descripción
* --------------------------------------------------------------------------
* 1.0           20/04/2022      Mauricio Rosales           Creación
* --------------------------------------------------------------------------
*/
public class CustomNotificationService {
    
    public static void sendCustomNotification(Set<String> recipientsIds, String title, String body, String notificationTypeId, String targetId) {

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationTypeId);
        notification.setTargetId(targetId);

        try {

            notification.send(recipientsIds);

        } catch (Exception ex) {

            System.debug('Error CustomNotificationService:  ' + ex.getMessage() );
        }
    }
    public static void sendCustomNotificationPageRef(Set<String> recipientsIds, String title, String body, String notificationTypeId, String targetPageRef) {

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationTypeId);
        notification.setTargetPageRef(targetPageRef);

        try {

            notification.send(recipientsIds);

        } catch (Exception ex) {

            System.debug('Error CustomNotificationService:  ' + ex.getMessage() );
        }
    }
    
}