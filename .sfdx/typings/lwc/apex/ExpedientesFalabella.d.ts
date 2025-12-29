declare module "@salesforce/apex/ExpedientesFalabella.getDocumentsList" {
  export default function getDocumentsList(): Promise<any>;
}
declare module "@salesforce/apex/ExpedientesFalabella.getDocumentApiGee" {
  export default function getDocumentApiGee(param: {documentSubTypeId: any, idRequest: any}): Promise<any>;
}
declare module "@salesforce/apex/ExpedientesFalabella.getDocumentBlobStorage" {
  export default function getDocumentBlobStorage(param: {idSolicitud: any, link: any, microServicio: any}): Promise<any>;
}
declare module "@salesforce/apex/ExpedientesFalabella.getIdRequest" {
  export default function getIdRequest(param: {numeroIdentificacion: any, tipoIdentificacion: any}): Promise<any>;
}
declare module "@salesforce/apex/ExpedientesFalabella.getContractNumber" {
  export default function getContractNumber(param: {curp: any}): Promise<any>;
}
declare module "@salesforce/apex/ExpedientesFalabella.getPdfCreditReport" {
  export default function getPdfCreditReport(param: {params: any}): Promise<any>;
}
