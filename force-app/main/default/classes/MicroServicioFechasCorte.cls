public class MicroServicioFechasCorte {
    private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
    private static final String FECHACORTE = 'product/billing/date';
    
    public MicroServicioFechasCorte() {
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(FECHACORTE);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
    }
    
    public FechasCorteJSON obtenerFechasCorte(Map<String, String> params) {
        
        String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        FechasCorteJSON result;
        
        System.debug('req ' + req);
        
        try {   
            
            for (Integer i = 0; i < 3; i++) {
                
                res = cliente.enviarRequest(req);
                
                if (res.getStatusCode() == 200) {
                    
                    isSuccess = true;
                    break;
                    
                }
                
            }
            
            System.debug('res ' + res.getBody());
            
            for (String s : res.getBody().split(':')) {
                
                System.debug('s ' + s);
                
            }
            
            if (isSuccess) {
                result = FechasCorteJSON.parse(res.getBody());
                
            } else {
                
                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
                
            }
            
 		//String fechasCorte = '{\"code\":\"ok\",\"message\":{\"estadoOperacion\":{\"codigoOperacion\":\"00\",\"glosaOperacion\":\"OK\"},\"resumenProducto\":[{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-07-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-04-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-06-26\"}		},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-05-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-08-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-03-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-02-26\"}},{\"resumenUltimaFacturacion\":{\"fechaUltimaFacturacion\":\"2018-01-26\"}}]}}';
        //result = FechasCorteJSON.parse(fechasCorte);
            
            
        } catch (Exception e) {
            
            cliente.logError(currentClassName, e.getMessage());
            
        }
        
        
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> obtenerFechasCorteCliente(String curp, String fechaDesde, String fechaHasta, String fechaTerminoFacturacion) {
        Map<String, Object> result = new Map<String, Object>();
        Boolean success = false;
        
        Map<String, String> params = new Map<String, String>();
        params.put('numeroDocumento', curp);
        params.put('fechaDesde', fechaDesde);
        params.put('fechaHasta', fechaHasta);
        
        System.debug('numeroDocumento: ' + curp);
        System.debug('fechaDesde: ' + fechaDesde);
        System.debug('fechaHasta: ' + fechaHasta);
        System.debug('fechaTerminoFacturacion: ' + fechaTerminoFacturacion);
               
        MicroServicioFechasCorte msfc = new MicroServicioFechasCorte();
        FechasCorteJSON fechasCorte = msfc.obtenerFechasCorte(params);
        
        List<SelectOptions> options = new List<SelectOptions>();
        options.add(new SelectOptions('-- None --', ''));
        
        if(fechasCorte != null) {
            success = true;
            
            if ( (!Test.isRunningTest()) && (fechasCorte.message.resumenProducto.size() > 0) ) {
                List<FechasCorteJSON.ResumenProducto> rsmProdList =  fechasCorte.message.resumenProducto;
                for(FechasCorteJSON.ResumenProducto rsmProd: rsmProdList) {
                    options.add(new SelectOptions(rsmProd.resumenUltimaFacturacion.fechaUltimaFacturacion, rsmProd.resumenUltimaFacturacion.fechaUltimaFacturacion));
                }
                
            }
            
        } else {
            success = true;
            
            options.add(new SelectOptions( fechaTerminoFacturacion, fechaTerminoFacturacion));
        }
        System.debug('FechasCorte Success: ' + success);
        result.put('success', success);
        result.put('fechasCorteOptions', options);
        return result;
        
    }
        
    @AuraEnabled
    public static Map<String, String> obtenerParametrosFechasCorte () {

        Map<String, String> result = new Map<String, String>();

        Configuracion_Fecha_Corte__mdt fechasCorte = [SELECT Fecha_Inicio__c, Fecha_Fin__c, SumMovimientosConFecha__c FROM Configuracion_Fecha_Corte__mdt LIMIT 1];

        String fechaInicio = String.valueOf(fechasCorte.Fecha_Inicio__c);
        String fechaFin = String.valueOf(fechasCorte.Fecha_Fin__c);
        String SumMovimientosFecha = String.valueOf(fechasCorte.SumMovimientosConFecha__c);

        System.debug('fechaInicio:  ' + fechaInicio);
        System.debug('fechaFin:  ' + fechaFin);
        System.debug('SumMovimientosFecha:  ' + SumMovimientosFecha);

        result.put('fechaInicio', fechaInicio);
        result.put('fechaFin', fechaFin);        
        result.put('SumMovimientosFecha', SumMovimientosFecha);
        return result;

    }

    public class SelectOptions {
        
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
        
        public SelectOptions (String label, String value) {
            this.label = label;
            this.value = value;
        }
        
    }

}