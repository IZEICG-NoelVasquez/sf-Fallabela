@isTest
public class FetchUsuarioColaTest {

    @isTest
    public static void getUSerTest() {

        FetchUsuarioCola.Requests fucr =  new FetchUsuarioCola.Requests();
        fucr.nombreCola = 'Aclaraciones';

        List<FetchUsuarioCola.Requests> fucrList = new List<FetchUsuarioCola.Requests>();
        fucrList.add(fucr);

        test.startTest();
        List<id> lst = FetchUsuarioCola.getUsuario(fucrList);
        test.stopTest(); 
    }
}