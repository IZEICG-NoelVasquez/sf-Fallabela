declare module "@salesforce/apex/SendOTPController.getCustomerByCaseId" {
  export default function getCustomerByCaseId(param: {caseId: any}): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.obtenerConfiguracionServicio" {
  export default function obtenerConfiguracionServicio(): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.sendOTPCodeByPhoneTwilio" {
  export default function sendOTPCodeByPhoneTwilio(param: {phoneNumber: any}): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.validateOTPCodeTwilio" {
  export default function validateOTPCodeTwilio(param: {phoneNumber: any, code: any}): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.sendOTPMicroservicio" {
  export default function sendOTPMicroservicio(param: {numeroDocumento: any, numeroCelular: any}): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.validateOTPMicroservicio" {
  export default function validateOTPMicroservicio(param: {numeroDocumento: any, clave: any}): Promise<any>;
}
declare module "@salesforce/apex/SendOTPController.createRegistroOTP" {
  export default function createRegistroOTP(param: {phone: any, cuenta: any, curp: any, mensaje: any, status: any, tipificacion: any, tipo: any, mode: any, caseId: any}): Promise<any>;
}
