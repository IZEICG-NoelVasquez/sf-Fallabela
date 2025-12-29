/**
* Nombre: AuthenticateHelperTest
* Autor
* Descripcion: Test Method de la Clase AuthenticateHelper
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0             ----           -----                      Creación
* 2.0           15/01/2021      Mauricio Rosales            Filtrar SubCategorias para Casos sin Movimientos creados desde el MS Movimientos
* --------------------------------------------------------------------------
*/
@isTest
public class AuthenticateHelperTest {

    static void init() {

        Account acc = new Account();
        acc.LastName = 'Test112233';
        acc.CURP__c = 'ABCD112233HDFABC00';
        insert acc;
    }

    @isTest static void test_method_1() {

        init();

        Map<String,List<Object>> mapSubCategorias = new Map<String,List<Object>>();

        ///
        String strCategoria = 'Problema Transacción';
        Boolean blnIsCommunity = false;
        Boolean blnEsClienteAnonimo = false;
        Boolean blnEsSoriban = false;
        Boolean blnAuthSinCel = false;
        String strParentezco = 'BE';
        Boolean blnIsMovimiento = true;
        Boolean blnCasoSinMovimientos = false;
        mapSubCategorias = AuthenticateHelper.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        ///
        blnIsMovimiento = false;
        strCategoria = 'Reporte de Tarjeta';
        mapSubCategorias = AuthenticateHelper.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        ///
        strParentezco = '';
        blnEsSoriban = true;
        blnAuthSinCel = true;
        mapSubCategorias = AuthenticateHelper.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);


        ///        
        blnEsSoriban = false;
        blnAuthSinCel = false;
        blnEsClienteAnonimo = true;
        mapSubCategorias = AuthenticateHelper.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);

        ///
        blnIsCommunity = true;
        mapSubCategorias = AuthenticateHelper.getCategoriesSubCategories(strCategoria, blnIsCommunity, blnEsClienteAnonimo, blnEsSoriban, blnAuthSinCel, strParentezco, blnIsMovimiento, blnCasoSinMovimientos);


        ///
        Account acc_1 = [SELECT Id FROM Account WHERE CURP__c = 'ABCD112233HDFABC00'];
        Account accUpdate = AuthenticateHelper.updateSelectedAccount(acc_1.Id);

        String strAcc = null;
        Account accNull = AuthenticateHelper.updateSelectedAccount(strAcc);

        ///
        Map<String,List<Object>> mapListaRiesgos = AuthenticateHelper.getInfoAltoRiesgo();
    }
}