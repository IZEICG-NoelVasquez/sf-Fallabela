declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.obtenerEstado" {
  export default function obtenerEstado(param: {estado: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.obtenerMunicipio" {
  export default function obtenerMunicipio(param: {municipio: any, idEstado: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.obtenerColonia" {
  export default function obtenerColonia(param: {colonia: any, idMunicipio: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.createCaseClosedDomicilio" {
  export default function createCaseClosedDomicilio(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.actualizarDomicilio" {
  export default function actualizarDomicilio(param: {campos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionDomicilio.updateSelectedAccount" {
  export default function updateSelectedAccount(param: {idAcc: any, campos: any}): Promise<any>;
}
