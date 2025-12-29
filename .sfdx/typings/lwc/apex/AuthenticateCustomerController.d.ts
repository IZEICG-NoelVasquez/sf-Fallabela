declare module "@salesforce/apex/AuthenticateCustomerController.getCategories" {
  export default function getCategories(param: {isCommunity: any, esClienteAnonimo: any, esSoriban: any, authSinCel: any, parentezco: any, isMovimiento: any, casoSinSeleccionarMovimientos: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCategoriesSubCategories" {
  export default function getCategoriesSubCategories(param: {category: any, isCommunity: any, esClienteAnonimo: any, esSoriban: any, authSinCel: any, parentezco: any, isMovimiento: any, casoSinSeleccionarMovimientos: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getInfoAltoRiesgo" {
  export default function getInfoAltoRiesgo(): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCaseRecordTypesByName" {
  export default function getCaseRecordTypesByName(): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getAgent" {
  export default function getAgent(): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.createCaseByRT" {
  export default function createCaseByRT(param: {recordTypeId: any, customerId: any, personId: any, category: any, altoRiesgo: any, esClienteAnonimo: any, clienteAnonimo: any, esRetipificacion: any, caseRecordId: any, metodoContactoValue: any, numeroDeTarjetaValue: any, movimientosList: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCustomer" {
  export default function getCustomer(param: {customerId: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCustomerByCaseId" {
  export default function getCustomerByCaseId(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCustomerByCURP" {
  export default function getCustomerByCURP(param: {curp: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getCustomerById" {
  export default function getCustomerById(param: {idAcc: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getPortalFieldsConfig" {
  export default function getPortalFieldsConfig(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.actualizarNuevoCelular" {
  export default function actualizarNuevoCelular(param: {validatedRecordId: any, isValid: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.actualizarPANCelular" {
  export default function actualizarPANCelular(param: {validatedRecordId: any, isValid: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.obtenerProductosCliente" {
  export default function obtenerProductosCliente(param: {curp: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.obtenerSaldosCliente" {
  export default function obtenerSaldosCliente(param: {codigoProducto: any, codigoSubProducto: any, identificadorProducto: any, identificador: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.sendSMSmedioAltoRiesgo" {
  export default function sendSMSmedioAltoRiesgo(param: {selectedAccount: any}): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.validacionesOTPDinamicas" {
  export default function validacionesOTPDinamicas(): Promise<any>;
}
declare module "@salesforce/apex/AuthenticateCustomerController.getMetadataProductTypeCatalog" {
  export default function getMetadataProductTypeCatalog(): Promise<any>;
}
