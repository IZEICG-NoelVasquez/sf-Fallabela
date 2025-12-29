@isTest
public class MicroServicioSaldoEnPuntosTest {

    @isTest static void saldoPuntosExito() {

        MockHttpResponseGeneratorMicroServicios mockSaldos = new MockHttpResponseGeneratorMicroServicios();
        mockSaldos.setMethod('POST');
        mockSaldos.setEndpoint('get/points');
        Test.setMock(HttpCalloutMock.class, mockSaldos);

        String numeroDocumento = 'ABCD112233HDFABC00';

        Test.startTest();

        Map<String, Object> mapSaldoPuntos = MicroServicioSaldoEnPuntos.obtenerSaldoEnPuntos(numeroDocumento);

        Test.stoptest();

        System.assertEquals(mapSaldoPuntos.get('success'), true);
    }

    @isTest static void saldoPuntosError() {

        MockHttpResponseGeneratorMicroServicios mockSaldos = new MockHttpResponseGeneratorMicroServicios();
        mockSaldos.setMethod('POST');
        mockSaldos.setEndpoint('get/points');
        mockSaldos.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockSaldos);

        String numeroDocumento = 'ABCD112233HDFABC00';

        Test.startTest();

        Map<String, Object> mapSaldosError = MicroServicioSaldoEnPuntos.obtenerSaldoEnPuntos(numeroDocumento);

        Test.stoptest();

        System.assertEquals(mapSaldosError.get('success'), false);
    }

    @isTest static void saldoPuntosCatch() {

        MockHttpResponseGeneratorMicroServicios mockSaldos = new MockHttpResponseGeneratorMicroServicios();
        mockSaldos.setMethod('POST');
        mockSaldos.setEndpoint('get/points');
        mockSaldos.setStatusCode(200);
        mockSaldos.setBody('');
        Test.setMock(HttpCalloutMock.class, mockSaldos);

        String numeroDocumento = 'ABCD112233HDFABC00';

        Map<String, String> params = new Map<String, String>();

        Test.startTest();        

        Map<String, Object> mapSaldosCatch = MicroServicioSaldoEnPuntos.obtenerSaldoEnPuntos(numeroDocumento);

        Test.stoptest();

        System.assertEquals(mapSaldosCatch.get('success'), false);
    }

}