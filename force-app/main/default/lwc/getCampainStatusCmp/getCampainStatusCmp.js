import { LightningElement, api } from "lwc";
import getCampainStatus from '@salesforce/apex/GetCampainsController.getCampains';
export default class GetCampainStatusCmp extends LightningElement {
  @api accountId;
  messageError='';
  withOutErros = false;
 columns = [

    {label: 'Campaña', fieldName: 'name'  },
    {label: 'Estado', fieldName: 'status'}
  ];
  recordsList = [];
  
  connectedCallback() {
     this.getCampainValues();
    console.log('account id get', this.accountId.Id);
  }

  async getCampainValues(){

    try {
       this.recordsList =    await  getCampainStatus({accountId : this.accountId.Id});
      this.withOutErros =  true;
       console.log('this.recordsList'+JSON.stringify( this.recordsList));
  }catch (e) {
      console.log('getCampain Values error', e.body.message);
    }
  }

  get existingRecords() {
      return this.recordsList.length >0 ? true : false;
  }
  get  recordMessage (){
      return this.recordsList.length >0 ? this.recordsList[0].status : 'NO SUCEPTIBLE A CAMPAÑA';
  }
}