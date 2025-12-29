declare module "@salesforce/apex/SendEmailTemplateController.send" {
  export default function send(param: {contactId: any, caseId: any, tarjeta: any}): Promise<any>;
}
declare module "@salesforce/apex/SendEmailTemplateController.getUserInfo" {
  export default function getUserInfo(): Promise<any>;
}
declare module "@salesforce/apex/SendEmailTemplateController.getMovimientos" {
  export default function getMovimientos(param: {recordId: any}): Promise<any>;
}
