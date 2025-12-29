declare module "@salesforce/apex/CuestionarioApexController.fetchRecordTypeValues" {
  export default function fetchRecordTypeValues(): Promise<any>;
}
declare module "@salesforce/apex/CuestionarioApexController.getSucursales" {
  export default function getSucursales(param: {sucursalId: any}): Promise<any>;
}
declare module "@salesforce/apex/CuestionarioApexController.getLatitudeLongitude" {
  export default function getLatitudeLongitude(param: {sucursal: any}): Promise<any>;
}
declare module "@salesforce/apex/CuestionarioApexController.getNewRecordId" {
  export default function getNewRecordId(param: {latitude: any, longitude: any}): Promise<any>;
}
