declare module "@salesforce/apex/MicroServicioAumentoDeLinea.consultaLineaDeCredito" {
  export default function consultaLineaDeCredito(param: {tipoCupo: any, identificador: any, numeroDocumento: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioAumentoDeLinea.aumentoLineaDeCredito" {
  export default function aumentoLineaDeCredito(param: {tipoCupo: any, identificador: any, numeroDocumento: any, codigoProducto: any, codigoSubProducto: any, identificadorProducto: any, codigoMoneda: any, cupoTotal: any, nuevoCupo: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioAumentoDeLinea.createCaseClosedAumentoCupo" {
  export default function createCaseClosedAumentoCupo(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
