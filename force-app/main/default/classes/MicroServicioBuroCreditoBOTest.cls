@isTest
public class MicroServicioBuroCreditoBOTest {

    @isTest static void reporteBuro() {

        String body = generaJson();
        MockHttpResponseGeneratorMicroServicios mockMicroSBuro = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSBuro.setMethod('POST');
        mockMicroSBuro.setEndpoint('client/get/xml/buro/circulo');
        mockMicroSBuro.setBody(body);
        Test.setMock(HttpCalloutMock.class, mockMicroSBuro);

        ApexPages.currentPage().getParameters().put('idSolicitud', '1521122');
        ApexPages.currentPage().getParameters().put('tipoReporte', 'B');
        MicroServicioBuroCreditoBO msBuro = new MicroServicioBuroCreditoBO();        

        Test.startTest();

        /// CC
        MicroServicioBuroCreditoBO.mapaRazonesScoreCC();
        MicroServicioBuroCreditoBO.mapaTipoCuentaCC();
        MicroServicioBuroCreditoBO.mapaTipoResponsabilidadCC();
        MicroServicioBuroCreditoBO.mapaTipoCreditoCC();
        MicroServicioBuroCreditoBO.mapaFrecuenciaPagosCC();
        MicroServicioBuroCreditoBO.generaHistoricoDePagosCC('V V V V V V V V V V V V V V V V V V V-- V V V-- V');

        msBuro.getInfoVF();

        Test.stopTest();

        System.assertEquals( msBuro.personaVF.encabezado.IdentificadorBuro, '1210');
    }

    @isTest static void reporteError() {

        String body = generaJson();
        MockHttpResponseGeneratorMicroServicios mockMicroSBuro = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSBuro.setMethod('POST');
        mockMicroSBuro.setEndpoint('client/get/xml/buro/circulo');
        mockMicroSBuro.setStatusCode(400);
        Test.setMock(HttpCalloutMock.class, mockMicroSBuro);

        Map<String, String> params = new Map<String, String>();
        params.put('idSolicitud', '1521122');
		params.put('tipoReporte', 'B');

        MicroServicioBuroCreditoBO msBuro = new MicroServicioBuroCreditoBO();

        Test.startTest();

        BuroDeCreditoXMLJSON reporteError = msBuro.xmlBuroCredito(params);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioBuroCreditoBO'];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void reporteCatch() {

        String body = generaJson();
        MockHttpResponseGeneratorMicroServicios mockMicroSBuro = new MockHttpResponseGeneratorMicroServicios();
        mockMicroSBuro.setMethod('POST');
        mockMicroSBuro.setEndpoint('client/get/xml/buro/circulo');
        mockMicroSBuro.setBody('');
        Test.setMock(HttpCalloutMock.class, mockMicroSBuro);

        Map<String, String> params = new Map<String, String>();
        params.put('idSolicitud', '1521122');
		params.put('tipoReporte', 'B');

        MicroServicioBuroCreditoBO msBuro = new MicroServicioBuroCreditoBO();

        Test.startTest();

        BuroDeCreditoXMLJSON reporteError = msBuro.xmlBuroCredito(params);

        Test.stopTest();

        List<Error_Log__c> listError = [SELECT Message__c FROM Error_Log__c WHERE ApexClass__c = 'MicroServicioBuroCreditoBO'];
        System.assertEquals( !listError.isEmpty() , true);
    }

    @isTest static void historicoPagos1() {

        Date dtAnioActual = System.today();
		Integer intAnioActual = dtAnioActual.year();

        String strDigitos = '123456789012';
        String strFechaCierreCuenta = '1506' + String.valueOf(intAnioActual);
        String strFechaReporte = '';
        String strFechaHistoricaMorisidad = '';

        Test.startTest();

        Map<String, String> mapHPagos = MicroServicioBuroCreditoBO.generaHistoricoDePagos( strDigitos, strFechaCierreCuenta, strFechaReporte, strFechaHistoricaMorisidad);

        Test.stopTest();

        System.assertEquals( mapHPagos.get('1M') , 'MAMFE');
    }

    @isTest static void historicoPagos2() {

        Date dtAnioActual = System.today();
		Integer intAnioActual = dtAnioActual.year();

        String strDigitos = '1234';
        String strFechaCierreCuenta = '';
        String strFechaReporte = '1506' + String.valueOf(intAnioActual);
        String strFechaHistoricaMorisidad = '';

        Test.startTest();

        Map<String, String> mapHPagos = MicroServicioBuroCreditoBO.generaHistoricoDePagos( strDigitos, strFechaCierreCuenta, strFechaReporte, strFechaHistoricaMorisidad);

        Test.stopTest();

        System.assertEquals( mapHPagos.get('1M') , 'MAMF');
    }

    @isTest static void historicoPagos3() {

        Date dtAnioActual = System.today();
		Integer intAnioActual = dtAnioActual.year();

        String strDigitos = '123456789012';
        String strFechaCierreCuenta = '';
        String strFechaReporte = '';
        String strFechaHistoricaMorisidad = '1506' + String.valueOf(intAnioActual - 1);

        Test.startTest();

        Map<String, String> mapHPagos = MicroServicioBuroCreditoBO.generaHistoricoDePagos( strDigitos, strFechaCierreCuenta, strFechaReporte, strFechaHistoricaMorisidad);

        Test.stopTest();

        System.assertEquals( mapHPagos.get('2M') , 'DNOSAJJ');
    }

    static String generaJson() {        

        String xml = '<Persona> <Encabezado> <NumeroReferenciaOperador>1234567890123456789012345</NumeroReferenciaOperador> <ClavePais>MX</ClavePais> <IdentificadorBuro>1210</IdentificadorBuro> ';
			xml += '<ClaveOtorgante>81731005</ClaveOtorgante> <ClaveRetornoConsumidorPrincipal>1</ClaveRetornoConsumidorPrincipal> <ClaveRetornoConsumidorSecundario>0</ClaveRetornoConsumidorSecundario> ';
			xml += '<NumeroControlConsulta>1486764797</NumeroControlConsulta> </Encabezado> ';
			xml += '<Nombre> <ApellidoPaterno>GONZALEZ</ApellidoPaterno> <ApellidoMaterno>GOMEZ</ApellidoMaterno> <PrimerNombre>PABLO</PrimerNombre> <SegundoNombre>ALBERTO</SegundoNombre> <FechaNacimiento>08061960</FechaNacimiento> ';
			xml += '<RFC>GOGP600608H4A</RFC> <Prefijo>LIC</Prefijo> <Nacionalidad>MX</Nacionalidad> <Residencia>1</Residencia> <EstadoCivil>M</EstadoCivil> <Sexo>M</Sexo> <ClaveImpuestosOtroPais>GOGP600608HCLNMB07</ClaveImpuestosOtroPais> ';
			xml += '<NumeroDependientes>03</NumeroDependientes> <EdadesDependientes>360907</EdadesDependientes> <FechaRecepcionInformacionDependientes>23031999</FechaRecepcionInformacionDependientes> </Nombre> ';
			xml += '<Domicilios> <Domicilio> <Direccion1>AV LA HDA 15</Direccion1> <DelegacionMunicipio>PARRAS</DelegacionMunicipio> <Estado>COA</Estado> <CP>27989</CP> <FechaReporteDireccion>28022017</FechaReporteDireccion> </Domicilio> ';
			xml += '<Domicilio> <Direccion1>CLL CARLOS PELLICER 265</Direccion1> <ColoniaPoblacion>VA STA CECILIA</ColoniaPoblacion> <DelegacionMunicipio>MONTERREY</DelegacionMunicipio> <Ciudad>MONTERREY</Ciudad> <Estado>NL</Estado> ';
			xml += '<CP>64157</CP> <NumeroTelefono>8183152169</NumeroTelefono> <FechaReporteDireccion>31122011</FechaReporteDireccion> </Domicilio> </Domicilios> ';
			xml += '<Empleos> <Empleo> <NombreEmpresa>PROPIO</NombreEmpresa> <Direccion1/> <NumeroTelefono>3531432</NumeroTelefono> <FechaContratacion>01121987</FechaContratacion> </Empleo> ';
			xml += '<Empleo> <NombreEmpresa>ALCRIS DE NORTE</NombreEmpresa> <Direccion1/> <NumeroTelefono>3507688</NumeroTelefono> </Empleo> </Empleos> ';
			xml += '<Cuentas> <Cuenta> <FechaActualizacion>17012018</FechaActualizacion> <NombreOtorgante>COMUNICACIONES</NombreOtorgante> <NumeroTelefonoOtorgante>0</NumeroTelefonoOtorgante> ';
			xml += '<IdentificadorSociedadInformacionCrediticia>0</IdentificadorSociedadInformacionCrediticia> <IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad> <TipoCuenta>O</TipoCuenta> <TipoContrato>CL</TipoContrato> ';
			xml += '<ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria> <FrecuenciaPagos>Z</FrecuenciaPagos> <MontoPagar>0</MontoPagar> <FechaAperturaCuenta>26041999</FechaAperturaCuenta> <FechaUltimoPago>02022011</FechaUltimoPago> ';
			xml += '<FechaUltimaCompra>04122010</FechaUltimaCompra> <FechaReporte>31122017</FechaReporte> <ModoReportar>A</ModoReportar> <CreditoMaximo>451</CreditoMaximo> <SaldoActual>0+</SaldoActual> <LimiteCredito>0</LimiteCredito> ';
			xml += '<SaldoVencido>0</SaldoVencido> <FormaPagoActual>01</FormaPagoActual> <HistoricoPagos>111111111111111111111111</HistoricoPagos> <FechaMasRecienteHistoricoPagos>30112017</FechaMasRecienteHistoricoPagos> ';
			xml += '<FechaMasAntiguaHistoricoPagos>30012014</FechaMasAntiguaHistoricoPagos> </Cuenta> </Cuentas> ';
			xml += '<ConsultasEfectuadas> <ConsultaEfectuada> <FechaConsulta>25012018</FechaConsulta> <IdentificacionBuro>0000</IdentificacionBuro> <NombreOtorgante>BURO DE CREDITO</NombreOtorgante> ';
			xml += '<TelefonoOtorgante>54494832</TelefonoOtorgante> <TipoContrato>CC</TipoContrato> <ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria> <ImporteContrato>000000000</ImporteContrato> <ResultadoFinal>1</ResultadoFinal> ';
			xml += '<IdentificadorOrigenConsulta>1</IdentificadorOrigenConsulta> </ConsultaEfectuada> <ConsultaEfectuada> <FechaConsulta>25012018</FechaConsulta> <ClaveOtorgante>FF81731005</ClaveOtorgante> ';
			xml += '<NombreOtorgante>TC FALABELLA</NombreOtorgante> <TipoContrato>CC</TipoContrato> <ImporteContrato>0</ImporteContrato> <IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad> <ResultadoFinal>0</ResultadoFinal> ';
			xml += '<IdentificadorOrigenConsulta>0</IdentificadorOrigenConsulta> </ConsultaEfectuada> </ConsultasEfectuadas> ';
			xml += '<ResumenReporte> <ResumenReporte> <FechaIngresoBD>26111995</FechaIngresoBD> <NumeroMOP7>00</NumeroMOP7> <NumeroMOP6>00</NumeroMOP6> <NumeroMOP5>00</NumeroMOP5> <NumeroMOP4>00</NumeroMOP4> <NumeroMOP3>00</NumeroMOP3> ';
			xml += '<NumeroMOP2>00</NumeroMOP2> <NumeroMOP1>09</NumeroMOP1> <NumeroMOP0>00</NumeroMOP0> <NumeroMOPUR>00</NumeroMOPUR> <NumeroCuentas>0009</NumeroCuentas> <CuentasPagosFijosHipotecas>0002</CuentasPagosFijosHipotecas> ';
			xml += '<CuentasRevolventesAbiertas>0007</CuentasRevolventesAbiertas> <CuentasCerradas>0000</CuentasCerradas> <CuentasNegativasActuales>0000</CuentasNegativasActuales> ';
			xml += '<CuentasClavesHistoriaNegativa>0001</CuentasClavesHistoriaNegativa> <CuentasDisputa>00</CuentasDisputa> <NumeroSolicitudesUltimos6Meses>10</NumeroSolicitudesUltimos6Meses> ';
			xml += '<NuevaDireccionReportadaUltimos60Dias>N</NuevaDireccionReportadaUltimos60Dias> <MensajesAlerta>NNNYN</MensajesAlerta> <ExistenciaDeclaracionesConsumidor>N</ExistenciaDeclaracionesConsumidor> <TipoMoneda>MX</TipoMoneda> ';
			xml += '<TotalCreditosMaximosRevolventes>000116293</TotalCreditosMaximosRevolventes> <TotalLimitesCreditoRevolventes>000267001</TotalLimitesCreditoRevolventes> ';
			xml += '<TotalSaldosActualesRevolventes>000086648+</TotalSaldosActualesRevolventes> <TotalSaldosVencidosRevolventes>000000000</TotalSaldosVencidosRevolventes> <TotalPagosRevolventes>000000000</TotalPagosRevolventes> ';
			xml += '<PctLimiteCreditoUtilizadoRevolventes>032</PctLimiteCreditoUtilizadoRevolventes> <TotalCreditosMaximosPagosFijos>000085000</TotalCreditosMaximosPagosFijos> ';
			xml += '<TotalSaldosActualesPagosFijos>000058165+</TotalSaldosActualesPagosFijos> <TotalSaldosVencidosPagosFijos>000000000</TotalSaldosVencidosPagosFijos> <TotalPagosPagosFijos>000003823</TotalPagosPagosFijos> ';
			xml += '<NumeroMOP96>00</NumeroMOP96> <NumeroMOP97>00</NumeroMOP97> <NumeroMOP99>00</NumeroMOP99> <FechaAperturaCuentaMasAntigua>23031995</FechaAperturaCuentaMasAntigua> ';
			xml += '<FechaAperturaCuentaMasReciente>10082017</FechaAperturaCuentaMasReciente> <TotalSolicitudesReporte>25</TotalSolicitudesReporte> <FechaSolicitudReporteMasReciente>25012018</FechaSolicitudReporteMasReciente> ';
			xml += '<NumeroTotalCuentasDespachoCobranza>00</NumeroTotalCuentasDespachoCobranza> <FechaAperturaCuentaMasRecienteDespachoCobranza>00000000</FechaAperturaCuentaMasRecienteDespachoCobranza> ';
			xml += '<NumeroTotalSolicitudesDespachosCobranza>00</NumeroTotalSolicitudesDespachosCobranza> <FechaSolicitudMasRecienteDespachoCobranza>00000000</FechaSolicitudMasRecienteDespachoCobranza> </ResumenReporte> </ResumenReporte> ';
			xml += '<HawkAlertConsulta> <HawkAlertC> <FechaReporte>25012018</FechaReporte> <CodigoClave>890</CodigoClave> <TipoInstitucion>BURO DE CREDITO </TipoInstitucion> <Mensaje>COLONIA NO COINCIDE CON CODIGO POSTAL 64634</Mensaje> ';
			xml += '</HawkAlertC> </HawkAlertConsulta> <HawkAlertBD> <HawkAlertBD> <FechaReporte>25012018</FechaReporte> <CodigoClave>850</CodigoClave> <TipoInstitucion>BURO DE CREDITO </TipoInstitucion> ';
			xml += '<Mensaje>TELEFONO 8183152169 NO CORRESPONDE A ZONA POSTAL</Mensaje> </HawkAlertBD> </HawkAlertBD> <DeclaracionesCliente/> ';
			xml += '<ScoreBuroCredito> <ScoreBC> <nombreScore>BC SCORE</nombreScore> <CodigoScore>007</CodigoScore> <ValorScore>-008</ValorScore> <CodigoRazon>28</CodigoRazon> <CodigoRazon>16</CodigoRazon> <CodigoRazon>04</CodigoRazon> ';
            xml += '<CodigoError>00</CodigoError> </ScoreBC> </ScoreBuroCredito> </Persona>';
            
        String json = '{'+
                '\"code\": \"ok\",'+
                '\"message\": {'+
                '\"idConsulta\": \"1521122\",'+
                '\"tipoReporte\": \"B\",'+
                '\"reporteCredito\": \"'+ xml +'\",'+
                '\"codigo\": \"0\",'+
                '\"descripcion\": \"EL REPORTE SE CONSULTO CORRECTAMENTE\"'+
                '}}';

        return json;
    }
}