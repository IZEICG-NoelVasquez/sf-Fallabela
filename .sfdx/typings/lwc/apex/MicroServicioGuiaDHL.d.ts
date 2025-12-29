declare module "@salesforce/apex/MicroServicioGuiaDHL.getGuiaDHL" {
  export default function getGuiaDHL(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioGuiaDHL.getDetailDHL" {
  export default function getDetailDHL(param: {guiaDHL: any, CURP: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioGuiaDHL.createCaseClosedGuia" {
  export default function createCaseClosedGuia(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, metodoContactoValue: any, numeroDeTarjetaValue: any, camposRequeridos: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioGuiaDHL.updateEstatus" {
  export default function updateEstatus(param: {recordId: any, lastEstatus: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioGuiaDHL.getWayBillEstafeta" {
  export default function getWayBillEstafeta(param: {wayBill: any}): Promise<any>;
}
