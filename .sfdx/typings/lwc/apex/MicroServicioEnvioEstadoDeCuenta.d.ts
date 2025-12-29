declare module "@salesforce/apex/MicroServicioEnvioEstadoDeCuenta.envioEstadoCuenta" {
  export default function envioEstadoCuenta(param: {contrato: any, fechaCorte: any, direccionCorreoElectronico: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioEnvioEstadoDeCuenta.createCaseClosedEnvioEdoCta" {
  export default function createCaseClosedEnvioEdoCta(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
