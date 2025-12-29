declare module "@salesforce/apex/MicroServicioBloqueoDeTarjeta.cardLock" {
  export default function cardLock(param: {mapRequestFields: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioBloqueoDeTarjeta.getCardLockValues" {
  export default function getCardLockValues(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioBloqueoDeTarjeta.createCaseOpenByRT" {
  export default function createCaseOpenByRT(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioBloqueoDeTarjeta.closeCaseByRT" {
  export default function closeCaseByRT(param: {newCaseId: any, mapRequiredFields: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioBloqueoDeTarjeta.updateCaseByRT" {
  export default function updateCaseByRT(param: {caseId: any, mapFields: any}): Promise<any>;
}
