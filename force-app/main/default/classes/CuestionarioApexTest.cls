/************************************************************************************************
Apex Class Name	:	CuestionarioApexTest 
Version			:	1.0
Created Date    :	23/10/2019 10:28
Function 		: 	Cubrir a la clase controladora del componente CuestionarioDetal y CuestionarioFlujoCrear
Cover Class		:	CuestionarioApexController y CuestionarioFlujoController
Modification Log:
*-------------------------------------------------------------------
* Developer		     Date			   Description
* -------------------------------------------------------------------
* Luis Sandoval	     23/10/2019 	   Original Version
*************************************************************************************************/
@isTest
public class CuestionarioApexTest {
     @isTest static void test_Cuestionario() {
        List<String> sucursales = CuestionarioApexController.getSucursales('12345678');
        Map<String,List<Double>> mapSuc = CuestionarioApexController.getLatitudeLongitude(sucursales[0]);
        List<Double> LatLong = mapSuc.get(sucursales[0]);
        List<Cuestionario__c> CuestionarioList = new List<Cuestionario__c>();
         for(integer i=0; i<20;i++){
			Cuestionario__c cuest = new Cuestionario__c(
                MapUploadImage__c = '069e0000001QLxUAAW,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined,undefined',
            	OTP_Validado__c = false,
                Latitude__c = LatLong[0],
                Longitude__c = LatLong[1]
            );  
             CuestionarioList.add(cuest);
         }
        insert CuestionarioList;
        String cuestId = CuestionarioApexController.getNewRecordId(LatLong[0],LatLong[1]);
        String ArrayImage = CuestionarioFlujoController.getArrayImage(CuestionarioList[0].Id);
        Boolean otpValido = CuestionarioFlujoController.getValidadoOTP(CuestionarioList[1].Id);
        String telefonoSucursal = CuestionarioFlujoController.getPhoneSucursal('Soriana Cumbres');
        String tipo = 'SMS';
        String inicio = 'O';
        String mensaje ='TP: 043123';
        String numeroTelefono = '8129386103';
        String codigoArea = '521';
        String rtCuest = CuestionarioFlujoController.getRecordType(cuestId);
        String sucCuest = CuestionarioFlujoController.getSucursalRecord(cuestId);
        String statusCuest = CuestionarioFlujoController.getStatus(cuestId);
		Map<Id,String> mapIdString = CuestionarioApexController.fetchRecordTypeValues();
        CuestionarioFlujoController.send_notification(tipo, inicio, mensaje, numeroTelefono, codigoArea);
         
     }

}