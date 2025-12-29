/**
* Nombre: PdfFormatoAclaracionesController
* Autor: Mauricio Rosales
* Descripcion: Controlador Apex de la Visualforce PdfFormatoAclaraciones
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           22/01/2021       Mauricio Rosales           Creación
* 2.0           05/02/2021       Mauricio Rosales           Se agregan nuevos campos a la tabla de Movimientos
* --------------------------------------------------------------------------
*/
public class PdfFormatoAclaracionesController {

    public Case         caso                 {get; set;}
    public String       numeroTarjeta        {get; set;}

    /**
    * Constructor que obtiene el registro de Casos relacionado con el id que se recibe como parametro en la Visualforce
    **/
    public PdfFormatoAclaracionesController() {

        Map<String, String> params = ApexPages.currentPage().getParameters();
    	String idCaso = params.get('id');

        System.debug('idCaso:  ' + idCaso);

        List<Case> listCasos = [SELECT CaseNumber, 
                                        CreatedDate, 
                                        Origin, 
                                        (SELECT Monto__c, 
                                                Fecha_del_movimiento__c, 
                                                Nombre_de_Instituci_n_Bancaria__c, 
                                                Establecimiento__c, 
                                                Referencia_Factura__c 
                                            FROM Movimientos__r 
                                            WHERE Formato_Aclaraciones__c = TRUE ), 
                                        Descripci_n_del_Cliente__c, 
                                        Account.Name 
                                FROM Case WHERE Id =: idCaso ];

        caso = listCasos.size() > 0 ? listCasos[0] : new Case();

        numeroTarjeta = params.get('t').length() == 16 ? params.get('t').substring(0, 4) + ' ' + params.get('t').substring(4, 8) + ' ' + params.get('t').substring(8, 12) + ' ' + params.get('t').substring(12, 16) : params.get('t');
    }
}