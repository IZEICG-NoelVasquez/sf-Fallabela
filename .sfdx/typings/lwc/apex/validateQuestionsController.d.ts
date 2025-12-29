declare module "@salesforce/apex/validateQuestionsController.getValidateQuestionsTry" {
  export default function getValidateQuestionsTry(param: {tipoDeIntento: any, rangoDiasVencimiento: any, rangoDiasUltimoPago: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.getValidationToday" {
  export default function getValidationToday(param: {customerId: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.casosDelCliente" {
  export default function casosDelCliente(param: {customerId: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.casosAbiertosDelCliente" {
  export default function casosAbiertosDelCliente(param: {customerId: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.getCardData" {
  export default function getCardData(param: {numeroDeTarjeta: any, customerId: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.createValidacionIncorrecta" {
  export default function createValidacionIncorrecta(param: {numeroDeTarjeta: any, customerId: any, DiaDeCorte: any, UltimoPago: any, DiaUltimoPago: any, CompraDiferida: any, exitosa: any, coincidencias: any, tieneCasosAbiertos: any, tieneCasosAbiertosAns: any, idCaso: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.createCaseClosedCurp" {
  export default function createCaseClosedCurp(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
declare module "@salesforce/apex/validateQuestionsController.getUserProfile" {
  export default function getUserProfile(): Promise<any>;
}
