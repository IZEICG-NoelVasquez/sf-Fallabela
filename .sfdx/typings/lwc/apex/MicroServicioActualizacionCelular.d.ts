declare module "@salesforce/apex/MicroServicioActualizacionCelular.createCaseClosedMobile" {
  export default function createCaseClosedMobile(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionCelular.actualizaValidacionPreguntas" {
  export default function actualizaValidacionPreguntas(param: {idValidacion: any, idCaso: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionCelular.actualizarCelular" {
  export default function actualizarCelular(param: {campos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionCelular.updateSelectedAccount" {
  export default function updateSelectedAccount(param: {idAcc: any, campos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioActualizacionCelular.sendSMSmedioAltoRiesgo" {
  export default function sendSMSmedioAltoRiesgo(param: {selectedAccount: any}): Promise<any>;
}
