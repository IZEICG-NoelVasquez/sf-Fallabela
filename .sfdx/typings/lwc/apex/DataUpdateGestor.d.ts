declare module "@salesforce/apex/DataUpdateGestor.getCaseInfo" {
  export default function getCaseInfo(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/DataUpdateGestor.dataUpdateMS" {
  export default function dataUpdateMS(param: {mapFields: any}): Promise<any>;
}
declare module "@salesforce/apex/DataUpdateGestor.updateCaseRecord" {
  export default function updateCaseRecord(param: {recordId: any, mapFields: any}): Promise<any>;
}
declare module "@salesforce/apex/DataUpdateGestor.createCaseHistory" {
  export default function createCaseHistory(param: {lstMapFields: any}): Promise<any>;
}
declare module "@salesforce/apex/DataUpdateGestor.submitForApproval" {
  export default function submitForApproval(param: {mapFields: any}): Promise<any>;
}
