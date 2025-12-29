declare module "@salesforce/apex/OmniChannelReport.getUsers" {
  export default function getUsers(param: {lstProfiles: any}): Promise<any>;
}
declare module "@salesforce/apex/OmniChannelReport.getOmniReport" {
  export default function getOmniReport(param: {mapUsers: any, startDate: any, endDate: any}): Promise<any>;
}
