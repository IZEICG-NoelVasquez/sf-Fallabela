/**
* Nombre: Constants
* Autor: Mauricio Rosales
* Descripcion: Clase contenedora de Constantes y Custom Labels
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           18/11/2021      Mauricio Rosales            Creación
* 2.0           30/12/2021      Mauricio Rosales            Custom Label para Queue Aclaraciones del flujo Cancelacion y Retencion de Titular
* --------------------------------------------------------------------------
*/
public class Constants {

    ///Class: AccountTriggerHelper
    public final static String EMBOCE_CENTRALIZADO_VALOR_CREACION_DE_CASOS = System.Label.EMBOCE_CENTRALIZADO_VALOR_CREACION_DE_CASOS;


    ///Class: CaseTriggerHelper
    public final static String EMBOCE_CENTRALIZADO_VALIDACION_DIAS_SUBCATEGORIAS = System.Label.EMBOCE_CENTRALIZADO_VALIDACION_DIAS_SUBCATEGORIAS;
    public final static String RETENCION_TITULAR_QUEUE_ACLARACIONES = System.Label.RETENCION_TITULAR_QUEUE_ACLARACIONES;
    public final static String QUEUE_BACK_OFFICE_CASE_CALL_CENTER = System.Label.QUEUE_BACK_OFFICE_CASE_CALL_CENTER;
    public final static String REGLA_DOCUMENTACION_MENSAJE_ERROR = System.Label.REGLA_DOCUMENTACION_MENSAJE_ERROR;
    public final static String REGLA_DOCUMENTACION_ARCHIVOS_PERMITIDOS = System.Label.REGLA_DOCUMENTACION_ARCHIVOS_PERMITIDOS;
    public final static String REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO = System.Label.REGLA_DOCUMENTACION_ARCHINO_NO_VALIDO;


    ///Class: PathCancelacionDeTitularController
    public final static String PATH_CAN_TIT_MOTIVOS_DE_RETENCION_PERMITIDOS_N_VECES = System.Label.PATH_CAN_TIT_MOTIVOS_DE_RETENCION_PERMITIDOS_N_VECES;


    ///Class: DataUpdateGestor
    public final static String QUEUE_BO_COORDINADORES_APPROVAL_NOTIFICATION = System.Label.QUEUE_BO_COORDINADORES_APPROVAL_NOTIFICATION;
    public final static String CUSTOM_NOTIFICATION_BO = System.Label.CUSTOM_NOTIFICATION_BO;
    public final static String APPROVAL_PROCESS_BO_UPDATE_MOBILE = System.Label.APPROVAL_PROCESS_BO_UPDATE_MOBILE;

    ///Class: ActualizarTicketRiesgosGestor
    public final static String MS_SENDNOTIFICATION_TIPO_SMS = System.Label.MS_SENDNOTIFICATION_TIPO_SMS;
    public final static String MS_SENDNOTIFICATION_CODIGO_AREA_MX = System.Label.MS_SENDNOTIFICATION_CODIGO_AREA_MX;
    public final static String MS_SENDNOTIFICATION_FIGITAL_SMS_APROBADO_1 = System.Label.MS_SENDNOTIFICATION_FIGITAL_SMS_APROBADO_1;
    public final static String MS_SENDNOTIFICATION_FIGITAL_SMS_RECHAZO = System.Label.MS_SENDNOTIFICATION_FIGITAL_SMS_RECHAZO;
    public final static Map<Integer,String> MAP_MONTHS = new Map<Integer,String>{
        1 => 'ENE', 
        2 => 'FEB', 
        3 => 'MAR',
        4 => 'ABR',
        5 => 'MAY',
        6 => 'JUN',
        7 => 'JUL',
        8 => 'AGO',
        9 => 'SEP',
        10 => 'OCT',
        11 => 'NOV',
        12 => 'DIC'
    };

    ///Class: FigitalGetScores
    public final static String MS_INCODE_DASHBOARD_URL = System.Label.MS_INCODE_DASHBOARD_URL;
    
    ///Class: ReporteBackOffice
    public final static String REPORTE_BACKOFFICE_PAGINATION_NUMBER_OF_RECORDS = System.Label.REPORTE_BACKOFFICE_PAGINATION_NUMBER_OF_RECORDS;

    ///Class: BatchUpdateCaseGestorBO
    public final static String BATCH_BACKOFFICE_EMAIL_ADDRESS = System.Label.BATCH_BACKOFFICE_EMAIL_ADDRESS;
    public final static String BATCH_BACKOFFICE_NUMBER_ATTEMPTS = System.Label.BATCH_BACKOFFICE_NUMBER_ATTEMPTS;

    /// Se mueven a otra clase de Constantes 
    ///Class: ClientRest
    /*public final static String HTTP_METHOD_POST = System.Label.HTTP_METHOD_POST;
    public final static String HTTP_GRANT_TYPE = System.Label.HTTP_GRANT_TYPE;
    public final static String HTTP_CLIENT_CREDENTIALS = System.Label.HTTP_CLIENT_CREDENTIALS;
    public final static String HTTP_SCOPE = System.Label.HTTP_SCOPE;
    public final static String HTTP_EXECUTE = System.Label.HTTP_EXECUTE;
    public final static String HTTP_CLIENT_ID = System.Label.HTTP_CLIENT_ID;
    public final static String HTTP_CLIENT_SECRET = System.Label.HTTP_CLIENT_SECRET;
    public final static String HTTP_CONTENT_TYPE = System.Label.HTTP_CONTENT_TYPE;
    public final static String HTTP_APP_URLENCODED = System.Label.HTTP_APP_URLENCODED;
    public final static String HTTP_ACCEPT = System.Label.HTTP_ACCEPT;
    public final static String HTTP_APP_JSON = System.Label.HTTP_APP_JSON;
    public final static String HTTP_APIKEY = System.Label.HTTP_APIKEY;
    public final static String HTTP_AUTHORIZATION = System.Label.HTTP_AUTHORIZATION;
    public final static String HTTP_BEARER = System.Label.HTTP_BEARER;    
    public final static String HTTP_TIMEOUT = System.Label.HTTP_TIMEOUT;*/

    ///Class: MicroServicioGuiaEstafeta
    /*public final static String ESTAFETA_ENDPOINT_TOKEN = System.Label.ESTAFETA_ENDPOINT_TOKEN;
    public final static String ESTAFETA_ENDPOINT_CUSTSHIPMENTTRACKING = System.Label.ESTAFETA_ENDPOINT_CUSTSHIPMENTTRACKING;
    public final static String ESTAFETA_SEARCHTYPE = System.Label.ESTAFETA_SEARCHTYPE;
    public final static String ESTAFETA_WAYBILLTYPE = System.Label.ESTAFETA_WAYBILLTYPE;
    public final static String ESTAFETA_FILTERTYPE = System.Label.ESTAFETA_FILTERTYPE;
    public final static String ESTAFETA_HISTORYTYPE = System.Label.ESTAFETA_HISTORYTYPE;*/

    ///Class: PendingServiceRoutingService
    //// Eliminar el perfil del admin antes de pasar a UAT <-------------------------------------------------------------
    public final static List<String> LST_PROFILES_ADMIN_OMNICHANNEL = new List<String>{'Analista Backoffice','Coordinador Backoffice','Gerente Backoffice','System Administrator', 'Administrador del sistema'};
    //// CREAR Custom Label, Metadata o Custom Object <-------------------------------------------------------------
    
    public final static Integer AMARILLO_PRESENCIAL=600;
    public final static Integer ROJO_PRESENCIAL=900;
    public final static Integer AMARILLO_FIGI=64800;
    public final static Integer ROJO_FIGI=86400;
}