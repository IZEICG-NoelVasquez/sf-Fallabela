public class MicroServicioBuroCreditoBO {
	private ClienteMicroServicios cliente;
    private static final String POST = 'POST';
	private static final String BURO = 'client/get/xml/buro/circulo';

	public Persona 		personaVF 				{get; set;}
	public Boolean      buroDeCredito           {get; set;}

	public MicroServicioBuroCreditoBO() {

		String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        cliente = new ClienteMicroServicios();
        cliente.setMethod(POST);
        cliente.setEndpoint(BURO);
        cliente.setMicroServicio(currentClassName);
        cliente.generarToken();
	}
	
	public BuroDeCreditoXMLJSON xmlBuroCredito(Map<String, String> params) {
        
		String currentClassName = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
        HttpResponse res;
        HttpRequest req = cliente.crearRequest(params); 
        Boolean isSuccess = false;
        BuroDeCreditoXMLJSON result;

        System.debug('req ' + req);
		
        try {   
			
            for (Integer i = 0; i < 3; i++) {

                res = cliente.enviarRequest(req);

                if (res.getStatusCode() == 200) {

                    isSuccess = true;
                    break;
                }
            }

            System.debug('res ' + res.getBody());
            
            if (isSuccess) {

				result = BuroDeCreditoXMLJSON.parse(res.getBody());
				
            } else {

                cliente.logError(currentClassName, String.valueOf(res.getStatusCode()));
            }
            
        } catch (Exception e) {
            
			cliente.logError(currentClassName, e.getMessage());
		}
		        
        return result;
	}

	public static List<String> getSubstringsByOC(String open, String close, String text) {

		List<String> lst = new List<String>();
		try {
			Integer howMany = text.countMatches(close);
			
			String textAux;

			for(integer i = 0; i < howMany; i ++) {

				textAux = text.substringBetween(open, close);
				if( String.isBlank(textAux)  ) {

					break;
				} else {
					
					lst.Add(open + textAux + close);
					text = text.removeStart(open + textAux + close);
				}			
			}

		} catch(Exception ex) {
			System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
		}

		return lst;
	}

	public static String fixString(String xml, String op, String cl) {

		String auxOpen = op;
		String auxEnd = cl;
		Integer firstOp = xml.indexOf(auxOpen);
		integer lastcl = xml.lastIndexOf(auxEnd);
		String Cad = xml.substring(firstOp, lastcl + AuxEnd.length());
		Cad = Cad.removeStart(auxOpen);
		Cad = Cad.removeEnd(auxEnd);
		return Cad;
	}

	public void getInfoVF() {

		String idSolicitud;
		String tipoReporte;

		idSolicitud = ApexPages.currentPage().getParameters().get('idSolicitud');
		tipoReporte = ApexPages.currentPage().getParameters().get('tipoReporte');		

		personaVF = getJSON(idSolicitud, tipoReporte);

		/// Circulo de Credito
		buroDeCredito = personaVF.blnBuroDeCredito;
	}

	public static Persona getJSON(String idSolicitud, String tipoReporte) {

		Persona personaResult;

		try {
			//
			Map<String, String> params = new Map<String, String>();
			params.put('idSolicitud', idSolicitud);
			params.put('tipoReporte', tipoReporte);

			System.debug('idSolicitud: ' + idSolicitud);
			System.debug('tipoReporte: ' + tipoReporte);
			
			MicroServicioBuroCreditoBO msXMLBuro = new MicroServicioBuroCreditoBO();
			BuroDeCreditoXMLJSON xmlBuro = msXMLBuro.xmlBuroCredito(params);

			Boolean buroDeCredito = xmlBuro.message.tipoReporte == 'B' ? true : false;		
			
			String xml = xmlBuro.message.reporteCredito;

			/*String xml = '<Persona> <Encabezado> <NumeroReferenciaOperador>1234567890123456789012345</NumeroReferenciaOperador> <ClavePais>MX</ClavePais> <IdentificadorBuro>1210</IdentificadorBuro> ';
			xml += '<ClaveOtorgante>FF81731005</ClaveOtorgante> <ClaveRetornoConsumidorPrincipal>1</ClaveRetornoConsumidorPrincipal> <ClaveRetornoConsumidorSecundario>0</ClaveRetornoConsumidorSecundario> ';
			xml += '<NumeroControlConsulta>1486764797</NumeroControlConsulta> </Encabezado> ';
			xml += '<Nombre> <ApellidoPaterno>GONZALEZ</ApellidoPaterno> <ApellidoMaterno>GOMEZ</ApellidoMaterno> <PrimerNombre>PABLO</PrimerNombre> <SegundoNombre>ALBERTO</SegundoNombre> <FechaNacimiento>08061960</FechaNacimiento> ';
			xml += '<RFC>GOGP600608H4A</RFC> <Prefijo>LIC</Prefijo> <Nacionalidad>MX</Nacionalidad> <Residencia>1</Residencia> <EstadoCivil>M</EstadoCivil> <Sexo>M</Sexo> <ClaveImpuestosOtroPais>GOGP600608HCLNMB07</ClaveImpuestosOtroPais> ';
			xml += '<NumeroDependientes>03</NumeroDependientes> <EdadesDependientes>360907</EdadesDependientes> <FechaRecepcionInformacionDependientes>23031999</FechaRecepcionInformacionDependientes> </Nombre> ';
			xml += '<Domicilios> <Domicilio> <Direccion1>AV LA HDA 15</Direccion1> <DelegacionMunicipio>PARRAS</DelegacionMunicipio> <Estado>COA</Estado> <CP>27989</CP> <FechaReporteDireccion>28022017</FechaReporteDireccion> </Domicilio> ';
			xml += '<Domicilio> <Direccion1>CLL CARLOS PELLICER 265</Direccion1> <ColoniaPoblacion>VA STA CECILIA</ColoniaPoblacion> <DelegacionMunicipio>MONTERREY</DelegacionMunicipio> <Ciudad>MONTERREY</Ciudad> <Estado>NL</Estado> ';
			xml += '<CP>64157</CP> <NumeroTelefono>8183152169</NumeroTelefono> <FechaReporteDireccion>31122011</FechaReporteDireccion> </Domicilio> </Domicilios> ';
			xml += '<Empleos> <Empleo> <NombreEmpresa>PROPIO</NombreEmpresa> <Direccion1/> <NumeroTelefono>3531432</NumeroTelefono> <FechaContratacion>01121987</FechaContratacion> </Empleo> ';
			xml += '<Empleo> <NombreEmpresa>ALCRIS DE NORTE</NombreEmpresa> <Direccion1/> <NumeroTelefono>3507688</NumeroTelefono> </Empleo> </Empleos> ';			
			//xml += '<Cuentas> <Cuenta> <FechaActualizacion>17012018</FechaActualizacion> <NombreOtorgante>COMUNICACIONES</NombreOtorgante> <NumeroTelefonoOtorgante>0</NumeroTelefonoOtorgante> ';
			//xml += '<IdentificadorSociedadInformacionCrediticia>0</IdentificadorSociedadInformacionCrediticia> <IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad> <TipoCuenta>R</TipoCuenta> <TipoContrato>CL</TipoContrato> ';
			//xml += '<ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria> <FrecuenciaPagos>Z</FrecuenciaPagos> <MontoPagar>0</MontoPagar> <FechaAperturaCuenta>26041999</FechaAperturaCuenta> <FechaUltimoPago>02022011</FechaUltimoPago> ';
			//xml += '<FechaUltimaCompra>04122010</FechaUltimaCompra> <FechaReporte>31122017</FechaReporte> <ModoReportar>A</ModoReportar> <CreditoMaximo>451</CreditoMaximo> <SaldoActual>0+</SaldoActual> <LimiteCredito>0</LimiteCredito> ';
			//xml += '<SaldoVencido>0</SaldoVencido> <FormaPagoActual>01</FormaPagoActual> <HistoricoPagos>111111111111111111111111</HistoricoPagos> <FechaMasRecienteHistoricoPagos>30112017</FechaMasRecienteHistoricoPagos> ';
			//xml += '<FechaMasAntiguaHistoricoPagos>30012014</FechaMasAntiguaHistoricoPagos> </Cuenta> </Cuentas> ';
			xml += '<Cuentas>';
			xml += '<Cuenta> <FechaActualizacion>17012018</FechaActualizacion> <NombreOtorgante>COMUNICACIONES</NombreOtorgante> <NumeroTelefonoOtorgante>0</NumeroTelefonoOtorgante> ';
			xml += '<IdentificadorSociedadInformacionCrediticia>0</IdentificadorSociedadInformacionCrediticia> <IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad> <TipoCuenta>R</TipoCuenta> <TipoContrato>CL</TipoContrato> ';
			xml += '<ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria> <FrecuenciaPagos>Z</FrecuenciaPagos> <MontoPagar>0</MontoPagar> <FechaAperturaCuenta>26041999</FechaAperturaCuenta> <FechaUltimoPago>02022011</FechaUltimoPago> ';
			xml += '<FechaUltimaCompra>04122010</FechaUltimaCompra> <FechaReporte>31122017</FechaReporte> <ModoReportar>A</ModoReportar> <CreditoMaximo>451</CreditoMaximo> <SaldoActual>0+</SaldoActual> <LimiteCredito>0</LimiteCredito> ';
			xml += '<SaldoVencido>0</SaldoVencido> <FormaPagoActual>01</FormaPagoActual> <HistoricoPagos>111111111111111111111111</HistoricoPagos> <FechaMasRecienteHistoricoPagos>30112017</FechaMasRecienteHistoricoPagos> ';
			xml += '<FechaMasAntiguaHistoricoPagos>30012014</FechaMasAntiguaHistoricoPagos> </Cuenta>';
			xml += '</Cuentas>';
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
			xml += '<CodigoError>00</CodigoError> </ScoreBC> </ScoreBuroCredito> </Persona>';*/

			// Circulo de Credito
			/*String xml = '<Persona><Encabezado><Version/><NumeroReferenciaOperador/><ProductoRequerido/><ClavePais/><IdentificadorBuro/><ClaveUsuario/><Password/><TipoConsulta/><TipoContrato/><ClaveUnidadMonetaria/><ImporteContrato/>';
			xml += '<Idioma/><TipoSalida/><ClaveOtorgante>9361305</ClaveOtorgante><ClaveRetornoConsumidorPrincipal>0024270049</ClaveRetornoConsumidorPrincipal><ClaveRetornoConsumidorSecundario/>';
			xml += '<NumeroControlConsulta>470580286</NumeroControlConsulta><ExpedienteEncontrado>1</ExpedienteEncontrado></Encabezado><Nombre><ApellidoPaterno>GUEVARA</ApellidoPaterno><ApellidoMaterno>GONZALEZ</ApellidoMaterno>';
			xml += '<ApellidoAdicional/><PrimerNombre>JULIA</PrimerNombre><SegundoNombre>ISABEL</SegundoNombre><FechaNacimiento>1952-04-22</FechaNacimiento><RFC>GUCC520422</RFC><Prefijo/><Sufijo/><Nacionalidad/>';
			xml += '<Residencia>5</Residencia><NumeroLicenciaConducir/><EstadoCivil/><Sexo/><NumeroCedulaProfesional/><NumeroRegistroElectoral/><ClaveImpuestosOtroPais/><ClaveOtroPais/><NumeroDependientes>0</NumeroDependientes>';
			xml += '<EdadesDependientes/><FechaRecepcionInformacionDependientes/><FechaDefuncion/></Nombre><Domicilios><Domicilio><Direccion1>AV CHOPO 1219</Direccion1><ColoniaPoblacion>ebanos xi</ColoniaPoblacion>';
			xml += '<DelegacionMunicipio>APODACA</DelegacionMunicipio><Ciudad>CIUDAD APODACA</Ciudad><Estado>NL</Estado><CP>66610</CP><FechaResidencia>2018-12-05</FechaResidencia><NumeroTelefono/><TipoDomicilio/>';
			xml += '<IndicadorEspecialDomicilio/><FechaReporteDireccion>2018-12-05</FechaReporteDireccion></Domicilio><Domicilio><Direccion1>AV CHOPO 1219</Direccion1><ColoniaPoblacion>LOS EBANOS</ColoniaPoblacion>';
			xml += '<DelegacionMunicipio>APODACA</DelegacionMunicipio><Ciudad>APODACA</Ciudad><Estado>NL</Estado><CP>66612</CP><FechaResidencia>2006-09-26</FechaResidencia><NumeroTelefono/><TipoDomicilio/>';
			xml += '<IndicadorEspecialDomicilio>0</IndicadorEspecialDomicilio><FechaReporteDireccion>2006-09-26</FechaReporteDireccion></Domicilio></Domicilios><Empleos/>';
			xml += '<Cuentas>';
			xml += '<Cuenta><FechaActualizacion>2020-02-28</FechaActualizacion>';
			xml += '<RegistroImpugnado>0</RegistroImpugnado><ClaveOtorgante/><NombreOtorgante>TIENDA DEPARTAMENTAL</NombreOtorgante><NumeroCuentaActual/><IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad>';
			xml += '<TipoCuenta>L</TipoCuenta><TipoContrato>TC</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria><ValorActivoValuacion>0</ValorActivoValuacion><NumeroPagos>0</NumeroPagos><FrecuenciaPagos>M</FrecuenciaPagos>';
			xml += '<MontoPagar>500</MontoPagar><FechaAperturaCuenta>2019-02-20</FechaAperturaCuenta><FechaUltimoPago>2019-02-09</FechaUltimoPago><FechaUltimaCompra>2019-01-10</FechaUltimaCompra><FechaCierreCuenta/>';
			xml += '<FechaReporte>2020-01-31</FechaReporte><UltimaFechaSaldoCero/><Garantia/><CreditoMaximo>25000</CreditoMaximo><SaldoActual>13000</SaldoActual><LimiteCredito>15000</LimiteCredito><SaldoVencido>0</SaldoVencido>';
			xml += '<NumeroPagosVencidos>0</NumeroPagosVencidos><FormaPagoActual> V</FormaPagoActual><HistoricoPagos> V V V V</HistoricoPagos><FechaMasRecienteHistoricoPagos/><FechaMasAntiguaHistoricoPagos/><ClaveObservacion/>';
			xml += '<TotalPagosReportados>0</TotalPagosReportados><ImporteSaldoMorosidadHistMasGrave>0</ImporteSaldoMorosidadHistMasGrave><FechaHistoricaMorosidadMasGrave/><MopHistoricoMorosidadMasGrave>0</MopHistoricoMorosidadMasGrave>';
			xml += '<MontoUltimoPago/></Cuenta><Cuenta><FechaActualizacion>2020-02-28</FechaActualizacion><RegistroImpugnado>0</RegistroImpugnado><ClaveOtorgante/><NombreOtorgante>BANCOS</NombreOtorgante><NumeroCuentaActual/>';
			xml += '<IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad><TipoCuenta>L</TipoCuenta><TipoContrato>TC</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria><ValorActivoValuacion>0</ValorActivoValuacion>';
			xml += '<NumeroPagos>0</NumeroPagos><FrecuenciaPagos>M</FrecuenciaPagos><MontoPagar>800</MontoPagar><FechaAperturaCuenta>2019-02-20</FechaAperturaCuenta><FechaUltimoPago>2019-02-09</FechaUltimoPago>';
			xml += '<FechaUltimaCompra>2019-01-10</FechaUltimaCompra><FechaCierreCuenta/><FechaReporte>2020-01-31</FechaReporte><UltimaFechaSaldoCero/><Garantia/><CreditoMaximo>25000</CreditoMaximo><SaldoActual>13000</SaldoActual>';
			xml += '<LimiteCredito>15000</LimiteCredito><SaldoVencido>1000</SaldoVencido><NumeroPagosVencidos>0</NumeroPagosVencidos><FormaPagoActual>02</FormaPagoActual><HistoricoPagos>01 V V V V</HistoricoPagos>';
			xml += '<FechaMasRecienteHistoricoPagos/><FechaMasAntiguaHistoricoPagos/><ClaveObservacion/><TotalPagosReportados>0</TotalPagosReportados><ImporteSaldoMorosidadHistMasGrave>0</ImporteSaldoMorosidadHistMasGrave>';
			xml += '<FechaHistoricaMorosidadMasGrave/><MopHistoricoMorosidadMasGrave>0</MopHistoricoMorosidadMasGrave><MontoUltimoPago/></Cuenta><Cuenta><FechaActualizacion>2020-02-28</FechaActualizacion>';
			xml += '<RegistroImpugnado>0</RegistroImpugnado><ClaveOtorgante/><NombreOtorgante>BANCOS</NombreOtorgante><NumeroCuentaActual/><IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad><TipoCuenta>L</TipoCuenta>';
			xml += '<TipoContrato>PN</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria><ValorActivoValuacion>0</ValorActivoValuacion><NumeroPagos>0</NumeroPagos><FrecuenciaPagos>S</FrecuenciaPagos><MontoPagar>4000</MontoPagar>';
			xml += '<FechaAperturaCuenta>2019-02-14</FechaAperturaCuenta><FechaUltimoPago>2020-02-27</FechaUltimoPago><FechaUltimaCompra>2020-02-24</FechaUltimaCompra><FechaCierreCuenta/><FechaReporte>2020-01-31</FechaReporte>';
			xml += '<UltimaFechaSaldoCero/><Garantia/><CreditoMaximo>27100</CreditoMaximo><SaldoActual>6000</SaldoActual><LimiteCredito>80300</LimiteCredito><SaldoVencido>2000</SaldoVencido><NumeroPagosVencidos>0</NumeroPagosVencidos>';
			xml += '<FormaPagoActual> V</FormaPagoActual><HistoricoPagos> V V V V V V V V V V V V</HistoricoPagos><FechaMasRecienteHistoricoPagos/><FechaMasAntiguaHistoricoPagos/><ClaveObservacion/>';
			xml += '<TotalPagosReportados>0</TotalPagosReportados><ImporteSaldoMorosidadHistMasGrave>0</ImporteSaldoMorosidadHistMasGrave><FechaHistoricaMorosidadMasGrave/><MopHistoricoMorosidadMasGrave>0</MopHistoricoMorosidadMasGrave>';
			xml += '<MontoUltimoPago/></Cuenta><Cuenta><FechaActualizacion>2018-08-20</FechaActualizacion><RegistroImpugnado>0</RegistroImpugnado><ClaveOtorgante/><NombreOtorgante>COMUNICACIONES / BC</NombreOtorgante>';
			xml += '<NumeroCuentaActual/><IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad><TipoCuenta>L</TipoCuenta><TipoContrato>OT</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria><ValorActivoValuacion/>';
			xml += '<NumeroPagos/><FrecuenciaPagos>M</FrecuenciaPagos><MontoPagar>0</MontoPagar><FechaAperturaCuenta>2006-02-14</FechaAperturaCuenta><FechaUltimoPago>2015-11-30</FechaUltimoPago><FechaUltimaCompra>2018-05-06</FechaUltimaCompra>';
			xml += '<FechaCierreCuenta>2018-06-01</FechaCierreCuenta><FechaReporte>2018-05-31</FechaReporte><UltimaFechaSaldoCero>2008-03-31</UltimaFechaSaldoCero><Garantia/><CreditoMaximo>1099</CreditoMaximo><SaldoActual>0</SaldoActual>';
			xml += '<LimiteCredito/><SaldoVencido>0</SaldoVencido><NumeroPagosVencidos>0</NumeroPagosVencidos><FormaPagoActual> V</FormaPagoActual><HistoricoPagos> V V V V V V V V V V V V V V V V V V V-- V V V-- V</HistoricoPagos>';
			xml += '<FechaMasRecienteHistoricoPagos/><FechaMasAntiguaHistoricoPagos/><ClaveObservacion/><TotalPagosReportados/><ImporteSaldoMorosidadHistMasGrave>0</ImporteSaldoMorosidadHistMasGrave><FechaHistoricaMorosidadMasGrave/>';
			xml += '<MopHistoricoMorosidadMasGrave/><MontoUltimoPago/></Cuenta>';
			xml += '</Cuentas>';
			xml += '<ConsultasEfectuadas><ConsultaEfectuada><FechaConsulta>2018-12-05</FechaConsulta><ClaveOtorgante/>';
			xml += '<NombreOtorgante>SERVICIOS FINANCIEROS SORIANA</NombreOtorgante><TelefonoOtorgante>8183299000</TelefonoOtorgante><TipoContrato>R</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria>';
			xml += '<ImporteContrato>1</ImporteContrato><IndicadorTipoResponsabilidad/></ConsultaEfectuada><ConsultaEfectuada><FechaConsulta>2018-11-01</FechaConsulta><ClaveOtorgante/><NombreOtorgante>SIC</NombreOtorgante>';
			xml += '<TelefonoOtorgante/><TipoContrato>F</TipoContrato><ClaveUnidadMonetaria>MX</ClaveUnidadMonetaria><ImporteContrato>0</ImporteContrato><IndicadorTipoResponsabilidad/></ConsultaEfectuada><ConsultaEfectuada>';
			xml += '<FechaConsulta>2018-11-01</FechaConsulta><ClaveOtorgante/><NombreOtorgante>FINANCIERA / BC</NombreOtorgante><TelefonoOtorgante/><TipoContrato>TC</TipoContrato><ClaveUnidadMonetaria/><ImporteContrato>0</ImporteContrato>';
			xml += '<IndicadorTipoResponsabilidad>I</IndicadorTipoResponsabilidad></ConsultaEfectuada></ConsultasEfectuadas><ResumenReporte><ResumenReporte><FechaIngresoBD/><NumeroMOP7/><NumeroMOP6/><NumeroMOP5/><NumeroMOP4/>';
			xml += '<NumeroMOP3/><NumeroMOP2/><NumeroMOP1/><NumeroMOP0/><NumeroMOPUR/><NumeroCuentas/><CuentasPagosFijosHipotecas/><CuentasRevolventesAbiertas/><CuentasCerradas/><CuentasNegativasActuales/><CuentasClavesHistoriaNegativa/>';
			xml += '<CuentasDisputa/><NumeroSolicitudesUltimos6Meses/><NuevaDireccionReportadaUltimos60Dias/><MensajesAlerta/><ExistenciaDeclaracionesConsumidor/><TipoMoneda/><TotalCreditosMaximosRevolventes/><TotalLimitesCreditoRevolventes/>';
			xml += '<TotalSaldosActualesRevolventes/><TotalSaldosVencidosRevolventes/><TotalPagosRevolventes/><PctLimiteCreditoUtilizadoRevolventes/><TotalCreditosMaximosPagosFijos/><TotalSaldosActualesPagosFijos/>';
			xml += '<TotalSaldosVencidosPagosFijos/><TotalPagosPagosFijos/><NumeroMOP96/><NumeroMOP97/><NumeroMOP99/><FechaAperturaCuentaMasAntigua/><FechaAperturaCuentaMasReciente/><TotalSolicitudesReporte/>';
			xml += '<FechaSolicitudReporteMasReciente/><NumeroTotalCuentasDespachoCobranza/><FechaAperturaCuentaMasRecienteDespachoCobranza/><NumeroTotalSolicitudesDespachosCobranza/><FechaSolicitudMasRecienteDespachoCobranza/>';
			xml += '</ResumenReporte></ResumenReporte><HawkAlertConsulta><HawkAlertC><FechaReporte/><CodigoClave/><TipoInstitucion/><Mensaje/></HawkAlertC></HawkAlertConsulta><HawkAlertBD><HawkAlertBD><FechaReporte/><CodigoClave/>';
			xml += '<TipoInstitucion/><Mensaje/></HawkAlertBD></HawkAlertBD><DeclaracionesCliente><DeclaracionConsumidor/></DeclaracionesCliente><ScoreBuroCredito><ScoreBC><nombreScore>FICO</nombreScore><CodigoScore>26</CodigoScore>';
			xml += '<ValorScore>680</ValorScore><CodigoRazon>J0 G1 E2 F7</CodigoRazon><CodigoRazon>J0 G1 E2 F7</CodigoRazon><CodigoRazon>J0 G1 E2 F7</CodigoRazon><CodigoRazon>J0 G1 E2 F7</CodigoRazon><CodigoError>0</CodigoError>';
			xml += '</ScoreBC></ScoreBuroCredito><Error><AR><ReferenciaOperador/><SujetoNoAutenticado/><ClaveOPasswordErroneo/><ErrorSistemaBC/><EtiquetaSegmentoErronea/><FaltaCampoRequerido/></AR><UR><NumeroReferenciaOperador/>';
			xml += '<SolicitudClienteErronea/><VersionProporcionadaErronea/><ProductoSolicitadoErroneo/><PasswordOClaveErronea/><SegmentoRequeridoNoProporcionado/><UltimaInformacionValidaCliente/><InformacionErroneaParaConsulta/>';
			xml += '<ValorErroneoCampoRelacionado/><ErrorSistemaBuroCredito/><EtiquetaSegmentoErronea/><OrdenErroneoSegmento/><NumeroErroneoSegmentos/><FaltaCampoRequerido/><ErrorReporteBloqueado/></UR></Error><ReporteImpreso/>';
			xml += '<Caracteristicas><Caracteristica><Plantilla/><IdCaracteristica/><NumeroCaracteristica/><Valor/><CodigoError/></Caracteristica></Caracteristicas><ReportePDF><Reporte/><Error><AR><ReferenciaOperador/>';
			xml += '<SujetoNoAutenticado/><ClaveOPasswordErroneo/><ErrorSistemaBC/><EtiquetaSegmentoErronea/><FaltaCampoRequerido/></AR><UR><NumeroReferenciaOperador/><SolicitudClienteErronea/><VersionProporcionadaErronea/>';
			xml += '<ProductoSolicitadoErroneo/><PasswordOClaveErronea/><SegmentoRequeridoNoProporcionado/><UltimaInformacionValidaCliente/><InformacionErroneaParaConsulta/><ValorErroneoCampoRelacionado/><ErrorSistemaBuroCredito/>';
			xml += '<EtiquetaSegmentoErronea/><OrdenErroneoSegmento/><NumeroErroneoSegmentos/><FaltaCampoRequerido/><ErrorReporteBloqueado/></UR></Error></ReportePDF><FR><LeyendaReporteBloqueado/></FR></Persona>';*/
			

			// Mapas con los Catalogos - Custom Metadata
			Map<String, String> mapEstados = mapaEstados();
			Map<String, String> mapCodigosRazon = buroDeCredito ? mapaCodigosRazon() : new Map<String, String>();
			Map<String, String> mapCodigosError = mapaCodigosError();
			Map<String, String> mapFormaPagoFechaAct = mapaFormaPagoFechaAct();
			Map<String, String> mapTipoCuenta = buroDeCredito ? mapaTipoCuenta() : new Map<String, String>();
			Map<String, String> mapTipoContrato = buroDeCredito ? mapaTipoContrato() : new Map<String, String>();
			Map<String, String> mapClaveObservacion = mapaClaveObservacion();
			Map<String, String> mapFrecuenciaDePago = buroDeCredito ? mapaFrecuenciaDePagos() : new Map<String, String>();
			Map<String, String> mapIndicadorResponsabilidad = buroDeCredito ? mapaIndicadorResponsabilidad() : new Map<String, String>();
			/// Circulo de Credito
			Map<String, String> mapRazonesScoreCC = buroDeCredito ? new Map<String, String>() : mapaRazonesScoreCC();
			Map<String, String> mapTipoDeCuentaCC = buroDeCredito ? new Map<String, String>() : mapaTipoCuentaCC();
			Map<String, String> mapTipoResponsabilidadCC = buroDeCredito ? new Map<String, String>() : mapaTipoResponsabilidadCC();
			Map<String, String> mapTipoCreditoCC = buroDeCredito ? new Map<String, String>() : mapaTipoCreditoCC();
			Map<String, String> mapFrecuenciaPagosCC = buroDeCredito ? new Map<String, String>() : mapaFrecuenciaPagosCC();

			/// API Nuevo Motor - Se elimina cadena xmlns
			String strRemoveXmlns = System.Label.REPORTE_BACKOFFICE_XML_REMOVE_STRING;
			xml = xml.contains(strRemoveXmlns) ? xml.remove(' ' + strRemoveXmlns) : xml;

			Map<String, String> sections = new Map<String, String>();
			String Encabezado = xml.substringBetween('<Encabezado>', '</Encabezado>');
			String Nombre = xml.substringBetween('<Nombre>', '</Nombre>');
			String Domicilios = xml.substringBetween('<Domicilios>', '</Domicilios>');
			String Empleos = xml.substringBetween('<Empleos>', '</Empleos>');
			String Cuentas = xml.substringBetween('<Cuentas>', '</Cuentas>');
			String ConsultasEfectuadas = xml.substringBetween('<ConsultasEfectuadas>', '</ConsultasEfectuadas>');
			String ResumenReportes = fixString(xml, '<ResumenReporte>', '</ResumenReporte>');
			/*String HawkAlertConsulta = xml.substringBetween('<HawkAlertConsulta>', '</HawkAlertConsulta>');*/
			/*String HawkAlertBDS = fixString(xml, '<HawkAlertBD>', '</HawkAlertBD>');*/
			String ScoreBuroCreditos = xml.substringBetween('<ScoreBuroCredito>', '</ScoreBuroCredito>');

			//Agregando secciones a mapa
			sections.put('Encabezado', Encabezado);
			sections.put('Nombre', Nombre);
			integer i = 0;

			for(String item :getSubstringsByOC('<Domicilio>', '</Domicilio>', Domicilios)) {
				sections.put('Domicilio' + i, item);
				i++; 
			}
			for(String item :getSubstringsByOC('<Empleo>', '</Empleo>', Empleos)) {
				sections.put('Empleo' + i, item);
				i++; 
			}
			for(String item :getSubstringsByOC('<Cuenta>', '</Cuenta>', Cuentas)) {
				sections.put('Cuenta' + i, item);
				i++; 
			}
			for(String item :getSubstringsByOC('<ConsultaEfectuada>', '</ConsultaEfectuada>', ConsultasEfectuadas)) {
				sections.put('ConsultaEfectuada' + i, item);
				i++; 
			}
			for(String item :getSubstringsByOC('<ResumenReporte>', '</ResumenReporte>', ResumenReportes)) {
				sections.put('ResumenReporte' + i, item);
				i++; 
			}
			/*for(String item :getSubstringsByOC('<HawkAlertC>', '</HawkAlertC>', HawkAlertConsulta)) {
				sections.put('HawkAlertC' + i, item);
				i++; 
			}*/
			/*for(String item :getSubstringsByOC('<HawkAlertBD>', '</HawkAlertBD>', HawkAlertBDS)) {
				sections.put('HawkAlertBD' + i, item);
				i++; 
			}*/
			for(String item :getSubstringsByOC('<ScoreBC>', '</ScoreBC>', ScoreBuroCreditos)) {
				sections.put('ScoreBC' + i, item);
				i++; 
			}

			//[Las siguientes instancias serán contenidas en el objeto final de la clase Persona para serializar como json]

			//[Encabezado]
			Encabezado enc = new Encabezado(null, null, null, null, null, null, null, null, null);

			enc.NumeroReferenciaOperador = sections.get('Encabezado').substringBetween('<NumeroReferenciaOperador>', '</NumeroReferenciaOperador>');
			enc.ClavePais = sections.get('Encabezado').substringBetween('<ClavePais>', '</ClavePais>');
			enc.IdentificadorBuro = sections.get('Encabezado').substringBetween('<IdentificadorBuro>', '</IdentificadorBuro>');
			String strClaveOtorgante = sections.get('Encabezado').substringBetween('<ClaveOtorgante>', '</ClaveOtorgante>');
			enc.ClaveOtorgante = strClaveOtorgante;
			strClaveOtorgante = String.isNotBlank(strClaveOtorgante) ? strClaveOtorgante.replace('+','').replace('-','') : '0';
			enc.ClaveOtorganteCC = !buroDeCredito ? Integer.valueOf(strClaveOtorgante) : 0;
			enc.ClaveRetornoConsumidorPrincipal = sections.get('Encabezado').substringBetween('<ClaveRetornoConsumidorPrincipal>', '</ClaveRetornoConsumidorPrincipal>');
			enc.ClaveRetornoConsumidorSecundario = sections.get('Encabezado').substringBetween('<ClaveRetornoConsumidorSecundario>', '</ClaveRetornoConsumidorSecundario>');
			String strNumeroControlConsulta = sections.get('Encabezado').substringBetween('<NumeroControlConsulta>', '</NumeroControlConsulta>');
			enc.NumeroControlConsulta = strNumeroControlConsulta;
			strNumeroControlConsulta = String.isNotBlank(strNumeroControlConsulta) ? strNumeroControlConsulta.replace('+','').replace('-','') : '0';
			enc.NumeroControlConsultaCC = !buroDeCredito ? Integer.valueOf(strNumeroControlConsulta) : 0;

			//[Nombre]
			Nombre nom = new Nombre(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);

			nom.ApellidoPaterno = sections.get('Nombre').substringBetween('<ApellidoPaterno>', '</ApellidoPaterno>');
			nom.ApellidoMaterno = sections.get('Nombre').substringBetween('<ApellidoMaterno>', '</ApellidoMaterno>');
			nom.PrimerNombre = sections.get('Nombre').substringBetween('<PrimerNombre>', '</PrimerNombre>');
			nom.SegundoNombre = sections.get('Nombre').substringBetween('<SegundoNombre>', '</SegundoNombre>');
			nom.FechaNacimiento = formatoFecha( sections.get('Nombre').substringBetween('<FechaNacimiento>', '</FechaNacimiento>'), true);
			nom.RFC = sections.get('Nombre').substringBetween('<RFC>', '</RFC>');
			nom.Prefijo = sections.get('Nombre').substringBetween('<Prefijo>', '</Prefijo>');
			nom.Nacionalidad = sections.get('Nombre').substringBetween('<Nacionalidad>', '</Nacionalidad>');
			nom.Residencia = sections.get('Nombre').substringBetween('<Residencia>', '</Residencia>');
			nom.EstadoCivil = sections.get('Nombre').substringBetween('<EstadoCivil>', '</EstadoCivil>');
			nom.Sexo = sections.get('Nombre').substringBetween('<Sexo>', '</Sexo>');
			nom.ClaveImpuestosOtroPais = sections.get('Nombre').substringBetween('<ClaveImpuestosOtroPais>', '</ClaveImpuestosOtroPais>');
			nom.NumeroDependientes = sections.get('Nombre').substringBetween('<NumeroDependientes>', '</NumeroDependientes>');
			nom.EdadesDependientes = sections.get('Nombre').substringBetween('<EdadesDependientes>', '</EdadesDependientes>');
			nom.FechaRecepcionInformacionDependientes = sections.get('Nombre').substringBetween('<FechaRecepcionInformacionDependientes>', '</FechaRecepcionInformacionDependientes>');
			nom.NumeroRegistroElectoral = sections.get('Nombre').substringBetween('<NumeroRegistroElectoral>', '</NumeroRegistroElectoral>');

			List<Domicilio> doms = new List<Domicilio>();
			List<Empleo> emps = new List<Empleo>();
			List<Cuenta> cuens = new List<Cuenta>();
			List<ConsultaEfectuada> conEfecutuadas = new List<ConsultaEfectuada>();
			List<ResumenReporte> resReps = new List<ResumenReporte>();
			/*List<HawkAlertC> HawkAlertCs = new List<HawkAlertC>();*/
			/*List<HawkAlertBD> HawkAlertBDlst = new List<HawkAlertBD>();*/
			List<ScoreBC> scBClst = new List<ScoreBC>();
			List<CodigoRazon> codRazones = new List<CodigoRazon>();
			List<ResumenReporteSumaDeCuentas> resumenRepSumaCuentas = new List<ResumenReporteSumaDeCuentas>();

			/// Mapa MOP Cuentas Abiertas/Cerradas
			Map<String, Map<String, Integer>> mapMopCuentas = new Map<String, Map<String, Integer>>();

			//[En esta sección se llenan las listas pertenecientes al objeto de la clase Persona]
			for(String item :sections.keyset()) {

				if(item.contains('Domicilio')) {

					Domicilio dom = new Domicilio();
					dom.Direccion1 = sections.get(item).substringBetween('<Direccion1>', '</Direccion1>');
					dom.DelegacionMunicipio = sections.get(item).substringBetween('<DelegacionMunicipio>', '</DelegacionMunicipio>');
					String est = sections.get(item).substringBetween('<Estado>', '</Estado>');
					dom.Estado = mapEstados.containsKey(est) ? mapEstados.get(est) : est;
					dom.CP = sections.get(item).substringBetween('<CP>', '</CP>');
					dom.FechaReporteDireccion = formatoFecha( sections.get(item).substringBetween('<FechaReporteDireccion>', '</FechaReporteDireccion>'), true);
					dom.ColoniaPoblacion = sections.get(item).substringBetween('<ColoniaPoblacion>', '</ColoniaPoblacion>');
					dom.Ciudad = sections.get(item).substringBetween('<Ciudad>', '</Ciudad>');
					dom.NumeroTelefono = sections.get(item).substringBetween('<NumeroTelefono>', '</NumeroTelefono>');
					dom.CodPais = sections.get(item).substringBetween('<CodPais>', '</CodPais>');
					doms.Add(dom);
				}

				if(item.contains('Empleo')) {

					Empleo emp = new Empleo();
					emp.NombreEmpresa = sections.get(item).substringBetween('<NombreEmpresa>', '</NombreEmpresa>');
					emp.Cargo = sections.get(item).substringBetween('<Cargo>', '</Cargo>');
					emp.Salario = sections.get(item).substringBetween('<Salario>', '</Salario>');
					emp.BaseSalarial = sections.get(item).substringBetween('<BaseSalarial>', '</BaseSalarial>');
					emp.Direccion1 = sections.get(item).substringBetween('<Direccion1>', '</Direccion1>');
					emp.Direccion2 = sections.get(item).substringBetween('<Direccion2>', '</Direccion2>');
					emp.ColoniaPoblacion = sections.get(item).substringBetween('<ColoniaPoblacion>', '</ColoniaPoblacion>');
					emp.DelegacionMunicipio = sections.get(item).substringBetween('<DelegacionMunicipio>', '</DelegacionMunicipio>');
					emp.Ciudad = sections.get(item).substringBetween('<Ciudad>', '</Ciudad>');
					String estadoEmp = sections.get(item).substringBetween('<Estado>', '</Estado>');
					emp.Estado = mapEstados.containsKey(estadoEmp) ? mapEstados.get(estadoEmp) : estadoEmp;
					emp.CP = sections.get(item).substringBetween('<CP>', '</CP>');
					emp.NumeroTelefono = sections.get(item).substringBetween('<NumeroTelefono>', '</NumeroTelefono>');
					emp.CodPais = sections.get(item).substringBetween('<CodPais>', '</CodPais>');
					emp.FechaReportoEmpleo = formatoFecha( sections.get(item).substringBetween('<FechaReportoEmpleo>', '</FechaReportoEmpleo>'), true);
					emp.FechaContratacion = formatoFecha( sections.get(item).substringBetween('<FechaContratacion>', '</FechaContratacion>'), true);
					emp.FechaUltimoDiaEmpleo = formatoFecha( sections.get(item).substringBetween('<FechaUltimoDiaEmpleo>', '</FechaUltimoDiaEmpleo>'), true);

					emps.Add(emp);
				}

				if(item.contains('Cuenta')) {

					Cuenta cue = new Cuenta();
					cue.FechaActualizacion = sections.get(item).substringBetween('<FechaActualizacion>', '</FechaActualizacion>');
					cue.NombreOtorgante = sections.get(item).substringBetween('<NombreOtorgante>', '</NombreOtorgante>');
					cue.NumeroTelefonoOtorgante = sections.get(item).substringBetween('<NumeroTelefonoOtorgante>', '</NumeroTelefonoOtorgante>');
					cue.IdentificadorSociedadInformacionCrediticia = sections.get(item).substringBetween('<IdentificadorSociedadInformacionCrediticia>', '</IdentificadorSociedadInformacionCrediticia>');
					String strIndicadorTipoResponsabilidadCta = sections.get(item).substringBetween('<IndicadorTipoResponsabilidad>', '</IndicadorTipoResponsabilidad>');
					cue.IndicadorTipoResponsabilidad = buroDeCredito && mapIndicadorResponsabilidad.containsKey(strIndicadorTipoResponsabilidadCta) ? mapIndicadorResponsabilidad.get(strIndicadorTipoResponsabilidadCta) : (!buroDeCredito && mapTipoResponsabilidadCC.containsKey(strIndicadorTipoResponsabilidadCta) ? mapTipoResponsabilidadCC.get(strIndicadorTipoResponsabilidadCta) : strIndicadorTipoResponsabilidadCta);
					String strTipoCuenta = sections.get(item).substringBetween('<TipoCuenta>', '</TipoCuenta>');
					cue.TipoCuenta = buroDeCredito && mapTipoCuenta.containsKey(strTipoCuenta) ? mapTipoCuenta.get(strTipoCuenta) : (!buroDeCredito && mapTipoDeCuentaCC.containsKey(strTipoCuenta) ? mapTipoDeCuentaCC.get(strTipoCuenta) : strTipoCuenta);
					String strTipoContrato = sections.get(item).substringBetween('<TipoContrato>', '</TipoContrato>');
					cue.TipoContrato = buroDeCredito && mapTipoContrato.containsKey(strTipoContrato) ? mapTipoContrato.get(strTipoContrato) : (!buroDeCredito && mapTipoCreditoCC.containsKey(strTipoContrato) ? mapTipoCreditoCC.get(strTipoContrato) : strTipoContrato);
					cue.ClaveUnidadMonetaria = sections.get(item).substringBetween('<ClaveUnidadMonetaria>', '</ClaveUnidadMonetaria>');
					String strFrecuenciaPagos = sections.get(item).substringBetween('<FrecuenciaPagos>', '</FrecuenciaPagos>');
					cue.FrecuenciaPagos = buroDeCredito && mapFrecuenciaDePago.containsKey(strFrecuenciaPagos) ? mapFrecuenciaDePago.get(strFrecuenciaPagos) : (!buroDeCredito && mapFrecuenciaPagosCC.containsKey(strFrecuenciaPagos) ? mapFrecuenciaPagosCC.get(strFrecuenciaPagos) : strFrecuenciaPagos);
					cue.NumeroPagos = sections.get(item).substringBetween('<NumeroPagos>', '</NumeroPagos>');
					cue.FechaAperturaCuenta = formatoFecha( sections.get(item).substringBetween('<FechaAperturaCuenta>', '</FechaAperturaCuenta>'), false);
					cue.FechaUltimoPago = formatoFecha( sections.get(item).substringBetween('<FechaUltimoPago>', '</FechaUltimoPago>'), false);
					cue.FechaUltimaCompra = formatoFecha( sections.get(item).substringBetween('<FechaUltimaCompra>', '</FechaUltimaCompra>'), false);
					String strFechaReporte = sections.get(item).substringBetween('<FechaReporte>', '</FechaReporte>');
					cue.FechaReporte = formatoFecha( strFechaReporte, false);
					cue.ModoReportar = sections.get(item).substringBetween('<ModoReportar>', '</ModoReportar>');
					String strHistoricoPagos = sections.get(item).substringBetween('<HistoricoPagos>', '</HistoricoPagos>');
					cue.HistoricoPagos = buroDeCredito ? strHistoricoPagos : generaHistoricoDePagosCC(strHistoricoPagos) ;
					cue.FechaMasRecienteHistoricoPagos = sections.get(item).substringBetween('<FechaMasRecienteHistoricoPagos>', '</FechaMasRecienteHistoricoPagos>');
					cue.FechaMasAntiguaHistoricoPagos = sections.get(item).substringBetween('<FechaMasAntiguaHistoricoPagos>', '</FechaMasAntiguaHistoricoPagos>');							
					String strMontoUltimoPago = sections.get(item).substringBetween('<MontoUltimoPago>', '</MontoUltimoPago>');
					strMontoUltimoPago = String.isNotBlank(strMontoUltimoPago) ? strMontoUltimoPago.replace('+','').replace('-','') : '0';
					cue.MontoUltimoPago = Decimal.valueOf(strMontoUltimoPago);
					cue.MopHistoricoMorosidadMasGrave = sections.get(item).substringBetween('<MopHistoricoMorosidadMasGrave>', '</MopHistoricoMorosidadMasGrave>');
					String strFechaHistoricaMorosidadMasGrave = sections.get(item).substringBetween('<FechaHistoricaMorosidadMasGrave>', '</FechaHistoricaMorosidadMasGrave>');
					cue.FechaHistoricaMorosidadMasGrave = formatoFecha( strFechaHistoricaMorosidadMasGrave, false);
					cue.ImporteSaldoMorosidadHistMasGrave = sections.get(item).substringBetween('<ImporteSaldoMorosidadHistMasGrave>', '</ImporteSaldoMorosidadHistMasGrave>');				
					String strClaveObservacion = sections.get(item).substringBetween('<ClaveObservacion>', '</ClaveObservacion>');
					cue.ClaveObservacion = mapClaveObservacion.containsKey(strClaveObservacion) ? strClaveObservacion + '=' + mapClaveObservacion.get(strClaveObservacion) : strClaveObservacion;

					/// MOP
					String strFormaPagoActual = sections.get(item).substringBetween('<FormaPagoActual>', '</FormaPagoActual>');
					cue.FormaPagoActual = mapFormaPagoFechaAct.containsKey(strFormaPagoActual) ? strFormaPagoActual + '=' + mapFormaPagoFechaAct.get(strFormaPagoActual) : strFormaPagoActual;
					/// Se guarda el **MOP** en el Mapa para Resumen de Creditos
					if( String.isNotBlank(strFormaPagoActual) ) {

						if( !mapMopCuentas.containsKey(strFormaPagoActual) ) {

							mapMopCuentas.put(strFormaPagoActual, new Map<String, Integer>() );
						}					
					}
					String strFechaCierreCuenta = sections.get(item).substringBetween('<FechaCierreCuenta>', '</FechaCierreCuenta>');
					cue.FechaCierreCuenta = formatoFecha( strFechaCierreCuenta, false);
					String strLimiteCredito = sections.get(item).substringBetween('<LimiteCredito>', '</LimiteCredito>');
					String strCreditoMaximo = sections.get(item).substringBetween('<CreditoMaximo>', '</CreditoMaximo>');
					String strSaldoActual = sections.get(item).substringBetween('<SaldoActual>', '</SaldoActual>');				
					String strSaldoVencido = sections.get(item).substringBetween('<SaldoVencido>', '</SaldoVencido>');				
					cue.MontoPagar = sections.get(item).substringBetween('<MontoPagar>', '</MontoPagar>');

					strLimiteCredito = String.isNotBlank(strLimiteCredito) ? strLimiteCredito.replace('+','').replace('-','') : '0';
					cue.LimiteCredito = Decimal.valueOf(strLimiteCredito);
					strCreditoMaximo = String.isNotBlank(strCreditoMaximo) ? strCreditoMaximo.replace('+','').replace('-','') : '0';
					cue.CreditoMaximo = Decimal.valueOf(strCreditoMaximo);
					strSaldoActual = String.isNotBlank(strSaldoActual) ? strSaldoActual.replace('+','').replace('-','') : '0';
					cue.SaldoActual = Decimal.valueOf(strSaldoActual);
					strSaldoVencido = String.isNotBlank(strSaldoVencido) ? strSaldoVencido.replace('+','').replace('-','') : '0';
					cue.SaldoVencido = Decimal.valueOf(strSaldoVencido);
					String strMontoPagar = String.isNotBlank(cue.MontoPagar) ? cue.MontoPagar.replace('+','').replace('-','') : '0';

					if( String.isBlank(strFechaCierreCuenta) ) {

						/// Cuenta Abierta
						mapMopCuentas.get(strFormaPagoActual).put('CuentasAbiertas', mapMopCuentas.get(strFormaPagoActual).containsKey('CuentasAbiertas') ? mapMopCuentas.get(strFormaPagoActual).get('CuentasAbiertas') + 1 : 1 );
						mapMopCuentas.get(strFormaPagoActual).put('LimiteAbiertas', mapMopCuentas.get(strFormaPagoActual).containsKey('LimiteAbiertas') ? mapMopCuentas.get(strFormaPagoActual).get('LimiteAbiertas') + Integer.valueOf(strLimiteCredito) : Integer.valueOf(strLimiteCredito) );
						mapMopCuentas.get(strFormaPagoActual).put('MaximoAbiertas', mapMopCuentas.get(strFormaPagoActual).containsKey('MaximoAbiertas') ? mapMopCuentas.get(strFormaPagoActual).get('MaximoAbiertas') + Integer.valueOf(strCreditoMaximo) : Integer.valueOf(strCreditoMaximo) );
						mapMopCuentas.get(strFormaPagoActual).put('SaldoActualAbiertas', mapMopCuentas.get(strFormaPagoActual).containsKey('SaldoActualAbiertas') ? mapMopCuentas.get(strFormaPagoActual).get('SaldoActualAbiertas') + Integer.valueOf(strSaldoActual) : Integer.valueOf(strSaldoActual) );
						mapMopCuentas.get(strFormaPagoActual).put('SaldoVencidoAbiertas', mapMopCuentas.get(strFormaPagoActual).containsKey('SaldoVencidoAbiertas') ? mapMopCuentas.get(strFormaPagoActual).get('SaldoVencidoAbiertas') + Integer.valueOf(strSaldoVencido) : Integer.valueOf(strSaldoVencido) );
						mapMopCuentas.get(strFormaPagoActual).put('PagoARealizar', mapMopCuentas.get(strFormaPagoActual).containsKey('PagoARealizar') ? mapMopCuentas.get(strFormaPagoActual).get('PagoARealizar') + Integer.valueOf(strMontoPagar) : Integer.valueOf(strMontoPagar) );
					} else {

						/// Cuenta Cerrada
						mapMopCuentas.get(strFormaPagoActual).put('CuentasCerradas', mapMopCuentas.get(strFormaPagoActual).containsKey('CuentasCerradas') ? mapMopCuentas.get(strFormaPagoActual).get('CuentasCerradas') + 1 : 1 );
						mapMopCuentas.get(strFormaPagoActual).put('LimiteCerradas', mapMopCuentas.get(strFormaPagoActual).containsKey('LimiteCerradas') ? mapMopCuentas.get(strFormaPagoActual).get('LimiteCerradas') + Integer.valueOf(strLimiteCredito) : Integer.valueOf(strLimiteCredito) );
						mapMopCuentas.get(strFormaPagoActual).put('MaximoCerradas', mapMopCuentas.get(strFormaPagoActual).containsKey('MaximoCerradas') ? mapMopCuentas.get(strFormaPagoActual).get('MaximoCerradas') + Integer.valueOf(strCreditoMaximo) : Integer.valueOf(strCreditoMaximo) );
						mapMopCuentas.get(strFormaPagoActual).put('SaldoActualCerradas', mapMopCuentas.get(strFormaPagoActual).containsKey('SaldoActualCerradas') ? mapMopCuentas.get(strFormaPagoActual).get('SaldoActualCerradas') + Integer.valueOf(strSaldoActual) : Integer.valueOf(strSaldoActual) );
						mapMopCuentas.get(strFormaPagoActual).put('MontoCerradas', mapMopCuentas.get(strFormaPagoActual).containsKey('MontoCerradas') ? mapMopCuentas.get(strFormaPagoActual).get('MontoCerradas') + Integer.valueOf(strSaldoVencido) : Integer.valueOf(strSaldoVencido) );
					}

					// Tabla Historico de Pagos
					if( buroDeCredito ) {

						Map<String, String> mapMesesDigitos = generaHistoricoDePagos(cue.HistoricoPagos, strFechaCierreCuenta, strFechaReporte, strFechaHistoricaMorosidadMasGrave);
						cue.PrimeroMeses = mapMesesDigitos.get('1M');
						cue.PrimeroDigitos = mapMesesDigitos.get('1D');
						cue.SegundoMeses = mapMesesDigitos.get('2M');
						cue.SegundoDigitos = mapMesesDigitos.get('2D');
						cue.TerceroMeses = mapMesesDigitos.get('3M');
						cue.TerceroDigitos = mapMesesDigitos.get('3D');
						cue.PrimerAnio = Integer.valueOf( mapMesesDigitos.get('1A') );
					}

					cuens.Add(cue);
				}

				if(item.contains('ConsultaEfectuada')) {

					ConsultaEfectuada conEfecutuada = new ConsultaEfectuada();
					String strFechaConsulta = sections.get(item).substringBetween('<FechaConsulta>', '</FechaConsulta>');
					conEfecutuada.FechaConsulta = formatoFecha( strFechaConsulta, true);
					conEfecutuada.IdentificacionBuro = sections.get(item).substringBetween('<IdentificacionBuro>', '</IdentificacionBuro>');
					conEfecutuada.NombreOtorgante = sections.get(item).substringBetween('<NombreOtorgante>', '</NombreOtorgante>');
					conEfecutuada.TelefonoOtorgante = sections.get(item).substringBetween('<TelefonoOtorgante>', '</TelefonoOtorgante>');
					String strTipoContratoConsulta = sections.get(item).substringBetween('<TipoContrato>', '</TipoContrato>');
					conEfecutuada.TipoContrato = buroDeCredito && mapTipoContrato.containsKey(strTipoContratoConsulta) ? mapTipoContrato.get(strTipoContratoConsulta) : (!buroDeCredito && mapTipoDeCuentaCC.containsKey(strTipoContratoConsulta) ? mapTipoDeCuentaCC.get(strTipoContratoConsulta) : (buroDeCredito ? strTipoContratoConsulta : '' ) );
					conEfecutuada.ClaveUnidadMonetaria = sections.get(item).substringBetween('<ClaveUnidadMonetaria>', '</ClaveUnidadMonetaria>');
					String strImporteContrato = sections.get(item).substringBetween('<ImporteContrato>', '</ImporteContrato>');
					conEfecutuada.ImporteContrato = Decimal.valueOf(strImporteContrato);
					conEfecutuada.ResultadoFinal = sections.get(item).substringBetween('<ResultadoFinal>', '</ResultadoFinal>');
					conEfecutuada.IdentificadorOrigenConsulta = sections.get(item).substringBetween('<IdentificadorOrigenConsulta>', '</IdentificadorOrigenConsulta>');
					String strIndicadorResponsabilidad = sections.get(item).substringBetween('<IndicadorTipoResponsabilidad>', '</IndicadorTipoResponsabilidad>');
					conEfecutuada.IndicadorTipoResponsabilidad = mapIndicadorResponsabilidad.containsKey(strIndicadorResponsabilidad) ? mapIndicadorResponsabilidad.get(strIndicadorResponsabilidad) : strIndicadorResponsabilidad;
					conEfecutuadas.add(conEfecutuada);
				}

				if(item.contains('ResumenReporte')) {

					ResumenReporte resRep = new ResumenReporte();
					resRep.FechaIngresoBD = formatoFecha( sections.get(item).substringBetween('<FechaIngresoBD>', '</FechaIngresoBD>'), true);
					resRep.NumeroMOP7 = sections.get(item).substringBetween('<NumeroMOP7>', '</NumeroMOP7>');
					resRep.NumeroMOP6 = sections.get(item).substringBetween('<NumeroMOP6>', '</NumeroMOP6>');
					resRep.NumeroMOP5 = sections.get(item).substringBetween('<NumeroMOP5>', '</NumeroMOP5>');
					resRep.NumeroMOP4 = sections.get(item).substringBetween('<NumeroMOP4>', '</NumeroMOP4>');
					resRep.NumeroMOP3 = sections.get(item).substringBetween('<NumeroMOP3>', '</NumeroMOP3>');
					resRep.NumeroMOP2 = sections.get(item).substringBetween('<NumeroMOP2>', '</NumeroMOP2>');
					resRep.NumeroMOP1 = sections.get(item).substringBetween('<NumeroMOP1>', '</NumeroMOP1>');
					resRep.NumeroMOP0 = sections.get(item).substringBetween('<NumeroMOP0>', '</NumeroMOP0>');
					resRep.NumeroMOPUR = sections.get(item).substringBetween('<NumeroMOPUR>', '</NumeroMOPUR>');
					resRep.NumeroCuentas = sections.get(item).substringBetween('<NumeroCuentas>', '</NumeroCuentas>');
					resRep.CuentasPagosFijosHipotecas = sections.get(item).substringBetween('<CuentasPagosFijosHipotecas>', '</CuentasPagosFijosHipotecas>');
					String strCuentasRevolventesAbiertas = sections.get(item).substringBetween('<CuentasRevolventesAbiertas>', '</CuentasRevolventesAbiertas>');
					strCuentasRevolventesAbiertas = String.isNotBlank(strCuentasRevolventesAbiertas) ? strCuentasRevolventesAbiertas.replace('+','').replace('-','') : '0';
					resRep.CuentasRevolventesAbiertas = Integer.valueOf(strCuentasRevolventesAbiertas);
					resRep.CuentasCerradas = sections.get(item).substringBetween('<CuentasCerradas>', '</CuentasCerradas>');
					resRep.CuentasNegativasActuales = sections.get(item).substringBetween('<CuentasNegativasActuales>', '</CuentasNegativasActuales>');
					resRep.CuentasClavesHistoriaNegativa = sections.get(item).substringBetween('<CuentasClavesHistoriaNegativa>', '</CuentasClavesHistoriaNegativa>');
					resRep.CuentasDisputa = sections.get(item).substringBetween('<CuentasDisputa>', '</CuentasDisputa>');
					resRep.NumeroSolicitudesUltimos6Meses = sections.get(item).substringBetween('<NumeroSolicitudesUltimos6Meses>', '</NumeroSolicitudesUltimos6Meses>');
					resRep.NuevaDireccionReportadaUltimos60Dias = sections.get(item).substringBetween('<NuevaDireccionReportadaUltimos60Dias>', '</NuevaDireccionReportadaUltimos60Dias>');
					resRep.MensajesAlerta = sections.get(item).substringBetween('<MensajesAlerta>', '</MensajesAlerta>');
					resRep.ExistenciaDeclaracionesConsumidor = sections.get(item).substringBetween('<ExistenciaDeclaracionesConsumidor>', '</ExistenciaDeclaracionesConsumidor>');
					resRep.TipoMoneda = sections.get(item).substringBetween('<TipoMoneda>', '</TipoMoneda>');
					String strTotalCreditosMaximosRevolventes = sections.get(item).substringBetween('<TotalCreditosMaximosRevolventes>', '</TotalCreditosMaximosRevolventes>');
					strTotalCreditosMaximosRevolventes = String.isNotBlank(strTotalCreditosMaximosRevolventes) ? strTotalCreditosMaximosRevolventes.replace('+','').replace('-','') : '0';
					resRep.TotalCreditosMaximosRevolventes = Integer.valueOf(strTotalCreditosMaximosRevolventes);
					String strTotalLimitesCreditoRevolventes = sections.get(item).substringBetween('<TotalLimitesCreditoRevolventes>', '</TotalLimitesCreditoRevolventes>');
					strTotalLimitesCreditoRevolventes = String.isNotBlank(strTotalLimitesCreditoRevolventes) ? strTotalLimitesCreditoRevolventes.replace('+','').replace('-','') : '0';
					resRep.TotalLimitesCreditoRevolventes = Integer.valueOf(strTotalLimitesCreditoRevolventes);
					String strTotalSaldosActualesRevolventes = sections.get(item).substringBetween('<TotalSaldosActualesRevolventes>', '</TotalSaldosActualesRevolventes>');
					strTotalSaldosActualesRevolventes = String.isNotBlank(strTotalSaldosActualesRevolventes) ? strTotalSaldosActualesRevolventes.replace('+','').replace('-','') : '0';
					resRep.TotalSaldosActualesRevolventes = Integer.valueOf(strTotalSaldosActualesRevolventes);
					resRep.TotalSaldosVencidosRevolventes = sections.get(item).substringBetween('<TotalSaldosVencidosRevolventes>', '</TotalSaldosVencidosRevolventes>');
					String strTotalPagosRevolventes = sections.get(item).substringBetween('<TotalPagosRevolventes>', '</TotalPagosRevolventes>');
					strTotalPagosRevolventes = String.isNotBlank(strTotalPagosRevolventes) ? strTotalPagosRevolventes.replace('+','').replace('-','') : '0';
					resRep.TotalPagosRevolventes = Integer.valueOf(strTotalPagosRevolventes);
					resRep.PctLimiteCreditoUtilizadoRevolventes = sections.get(item).substringBetween('<PctLimiteCreditoUtilizadoRevolventes>', '</PctLimiteCreditoUtilizadoRevolventes>');
					resRep.TotalCreditosMaximosPagosFijos = sections.get(item).substringBetween('<TotalCreditosMaximosPagosFijos>', '</TotalCreditosMaximosPagosFijos>');
					resRep.TotalSaldosActualesPagosFijos = sections.get(item).substringBetween('<TotalSaldosActualesPagosFijos>', '</TotalSaldosActualesPagosFijos>');
					resRep.TotalSaldosVencidosPagosFijos = sections.get(item).substringBetween('<TotalSaldosVencidosPagosFijos>', '</TotalSaldosVencidosPagosFijos>');
					resRep.TotalPagosPagosFijos = sections.get(item).substringBetween('<TotalPagosPagosFijos>', '</TotalPagosPagosFijos>');
					resRep.NumeroMOP96 = sections.get(item).substringBetween('<NumeroMOP96>', '</NumeroMOP96>');
					resRep.NumeroMOP97 = sections.get(item).substringBetween('<NumeroMOP97>', '</NumeroMOP97>');
					resRep.NumeroMOP99 = sections.get(item).substringBetween('<NumeroMOP99>', '</NumeroMOP99>');
					resRep.FechaAperturaCuentaMasAntigua = sections.get(item).substringBetween('<FechaAperturaCuentaMasAntigua>', '</FechaAperturaCuentaMasAntigua>');
					resRep.FechaAperturaCuentaMasReciente = sections.get(item).substringBetween('<FechaAperturaCuentaMasReciente>', '</FechaAperturaCuentaMasReciente>');
					resRep.TotalSolicitudesReporte = sections.get(item).substringBetween('<TotalSolicitudesReporte>', '</TotalSolicitudesReporte>');
					resRep.FechaSolicitudReporteMasReciente = sections.get(item).substringBetween('<FechaSolicitudReporteMasReciente>', '</FechaSolicitudReporteMasReciente>');
					resRep.NumeroTotalCuentasDespachoCobranza = sections.get(item).substringBetween('<NumeroTotalCuentasDespachoCobranza>', '</NumeroTotalCuentasDespachoCobranza>');
					resRep.FechaAperturaCuentaMasRecienteDespachoCobranza = sections.get(item).substringBetween('<FechaAperturaCuentaMasRecienteDespachoCobranza>', '</FechaAperturaCuentaMasRecienteDespachoCobranza>');
					resRep.NumeroTotalSolicitudesDespachosCobranza = sections.get(item).substringBetween('<NumeroTotalSolicitudesDespachosCobranza>', '</NumeroTotalSolicitudesDespachosCobranza>');
					resRep.FechaSolicitudMasRecienteDespachoCobranza = sections.get(item).substringBetween('<FechaSolicitudMasRecienteDespachoCobranza>', '</FechaSolicitudMasRecienteDespachoCobranza>');
					resReps.Add(resRep);
				}

				/*if(item.contains('HawkAlertC')) {

					HawkAlertC hawk = new HawkAlertC();
					hawk.FechaReporte = formatoFecha( sections.get(item).substringBetween('<FechaReporte>', '</FechaReporte>'), true);
					hawk.CodigoClave = sections.get(item).substringBetween('<CodigoClave>', '</CodigoClave>');
					hawk.TipoInstitucion = sections.get(item).substringBetween('<TipoInstitucion>', '</TipoInstitucion>');
					hawk.Mensaje = sections.get(item).substringBetween('<Mensaje>', '</Mensaje>');
					HawkAlertCs.Add(hawk);
				}*/

				/*if(item.contains('HawkAlertBD')) {

					HawkAlertBD hawkAlert = new HawkAlertBD();
					hawkAlert.FechaReporte = formatoFecha( sections.get(item).substringBetween('<FechaReporte>', '</FechaReporte>'), true);
					hawkAlert.CodigoClave = sections.get(item).substringBetween('<CodigoClave>', '</CodigoClave>');
					hawkAlert.TipoInstitucion = sections.get(item).substringBetween('<TipoInstitucion>', '</TipoInstitucion>');
					hawkAlert.Mensaje = sections.get(item).substringBetween('<Mensaje>', '</Mensaje>');

					HawkAlertBDlst.Add(hawkAlert);
				}*/


				if(item.contains('ScoreBC')) {

					ScoreBC scBC = new ScoreBC();
					scBC.nombreScore = sections.get(item).substringBetween('<nombreScore>', '</nombreScore>');
					scBC.CodigoScore = sections.get(item).substringBetween('<CodigoScore>', '</CodigoScore>');
					scBC.ValorScore = sections.get(item).substringBetween('<ValorScore>', '</ValorScore>');
					String codigosRazonCC = '';
					List<String> lstRazonesScoreCC = new List<String>();

					for(String it : getSubstringsByOC('<CodigoRazon>', '</CodigoRazon>', sections.get(item)) ) {

						CodigoRazon codRazonNew;
						String Aux = it.substringBetween('<CodigoRazon>', '</CodigoRazon>');

						List<String> listAux = Aux.split(' ');

						/// Circulo de Credito
						codigosRazonCC = !buroDeCredito && String.isBlank(codigosRazonCC) ? Aux.replace(' ', ', ') : codigosRazonCC;

						if( !listAux.isEmpty() ) {

							for(String subCodeRazon: listAux ) {

								codRazonNew = new CodigoRazon();
								codRazonNew.CodRazon = buroDeCredito && mapCodigosRazon.containsKey(subCodeRazon) ? subCodeRazon + '=' + mapCodigosRazon.get(subCodeRazon) : (!buroDeCredito && mapRazonesScoreCC.containsKey(subCodeRazon) ? subCodeRazon + ' - ' + mapRazonesScoreCC.get(subCodeRazon) : subCodeRazon);
								codRazones.Add(codRazonNew);
							}
							break;

						} else if( !String.isBlank(Aux) ) {

							codRazonNew = new CodigoRazon();
							codRazonNew.CodRazon = mapCodigosRazon.containsKey(Aux) ? Aux + '=' + mapCodigosRazon.get(Aux) : Aux;
							codRazones.Add(codRazonNew);
						}
					}

					if(!codRazones.isEmpty()) {

						scBC.codigosRazon = codRazones;
					}

					/// Circulo de Credito
					scBC.CodigosRazonCC = codigosRazonCC;

					String strCodError = sections.get(item).substringBetween('<CodigoError>', '</CodigoError>');
					scBC.CodigoError =  mapCodigosError.containsKey(strCodError) ? strCodError + '=' + mapCodigosError.get(strCodError) : strCodError;

					scBClst.add(scBC);
				}
			}

			/// Se recorre el Mapa Mop Cuentas para Tabla Resumen de Creditos
			for(String strMOP: mapMopCuentas.keyset() ) {

				if( mapMopCuentas.containsKey(strMop) ) {
					ResumenReporteSumaDeCuentas resumenRepSumaCtas = new ResumenReporteSumaDeCuentas();
					resumenRepSumaCtas.Mop = strMOP;
					resumenRepSumaCtas.CuentasAbiertas = mapMopCuentas.get(strMop).get('CuentasAbiertas') != null ? mapMopCuentas.get(strMop).get('CuentasAbiertas') : 0;
					resumenRepSumaCtas.LimiteAbiertas = mapMopCuentas.get(strMop).get('LimiteAbiertas') != null ? mapMopCuentas.get(strMop).get('LimiteAbiertas') : 0;
					resumenRepSumaCtas.MaximoAbiertas = mapMopCuentas.get(strMop).get('MaximoAbiertas') != null ? mapMopCuentas.get(strMop).get('MaximoAbiertas') : 0;
					resumenRepSumaCtas.SaldoActualAbiertas = mapMopCuentas.get(strMop).get('SaldoActualAbiertas') != null ? mapMopCuentas.get(strMop).get('SaldoActualAbiertas') : 0;
					resumenRepSumaCtas.SaldoVencidoAbiertas = mapMopCuentas.get(strMop).get('SaldoVencidoAbiertas') != null ? mapMopCuentas.get(strMop).get('SaldoVencidoAbiertas') : 0;
					resumenRepSumaCtas.PagoARealizar = mapMopCuentas.get(strMop).get('PagoARealizar') != null ? mapMopCuentas.get(strMop).get('PagoARealizar') : 0;
					resumenRepSumaCtas.CuentasCerradas = mapMopCuentas.get(strMop).get('CuentasCerradas') != null ? mapMopCuentas.get(strMop).get('CuentasCerradas') : 0;
					resumenRepSumaCtas.LimiteCerradas = mapMopCuentas.get(strMop).get('LimiteCerradas') != null ? mapMopCuentas.get(strMop).get('LimiteCerradas') : 0;
					resumenRepSumaCtas.MaximoCerradas = mapMopCuentas.get(strMop).get('MaximoCerradas') != null ? mapMopCuentas.get(strMop).get('MaximoCerradas') : 0;
					resumenRepSumaCtas.SaldoActualCerradas = mapMopCuentas.get(strMop).get('SaldoActualCerradas') != null ? mapMopCuentas.get(strMop).get('SaldoActualCerradas') : 0;
					resumenRepSumaCtas.MontoCerradas = mapMopCuentas.get(strMop).get('MontoCerradas') != null ? mapMopCuentas.get(strMop).get('MontoCerradas') : 0;

					resumenRepSumaCuentas.add(resumenRepSumaCtas);
				}
			}

			personaResult = new Persona(enc, nom, doms, emps, cuens, conEfecutuadas, resReps, /*HawkAlertCs, HawkAlertBDlst,*/ scBClst, resumenRepSumaCuentas, buroDeCredito);

		} catch(Exception ex) {

			System.debug('ERROR:  ' + ex.getMessage() + '  LINEA:  ' + ex.getLineNumber() );
			personaResult = new Persona(null, null, null, null, null, null, null, null, null, true);
		}

		return personaResult;
	}

	/// Custom Metadata Estados
	public static Map<String, String> mapaEstados() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(REGION__mdt estado: [SELECT MasterLabel, REGION__c FROM REGION__mdt] ) {

			mapaResult.put(estado.MasterLabel, estado.REGION__c);
		}

		return mapaResult;
	}

	/// Custom Metadata Codigos de Razon
	public static Map<String, String> mapaCodigosRazon() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_CodigosRazon__mdt codigoRazon: [SELECT MasterLabel, codigo__c FROM Catalogo_CodigosRazon__mdt ] ) {

			mapaResult.put(codigoRazon.codigo__c, codigoRazon.MasterLabel);
		}

		return mapaResult;
	}

	/// Custom Metadata Codigos de Error
	public static Map<String, String> mapaCodigosError() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_CodigoError__mdt codError: [SELECT MasterLabel, Descripcion__c FROM Catalogo_CodigoError__mdt] ) {

			mapaResult.put(codError.MasterLabel, codError.Descripcion__c);
		}

		return mapaResult;
    }

    /// Custom Metadata Forma de Pago en Fecha Actualizacion
    public static Map<String, String> mapaFormaPagoFechaAct() {

		Map<String, String> mapaResult = new Map<String, String>();
		
        for(Catalogo_FormaPagoFechaActualizacion__mdt codFormaPago: [SELECT MasterLabel, Codigo__c FROM Catalogo_FormaPagoFechaActualizacion__mdt] ) {

            mapaResult.put(codFormaPago.Codigo__c, codFormaPago.MasterLabel);
        }

        return mapaResult;
	}

	/// Custom Metadata Frecuencia de Pagos
	public static Map<String, String> mapaFrecuenciaDePagos() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_Frecuencia_de_Pagos__mdt codFrecuenciaPago: [SELECT MasterLabel, Valor__c FROM Catalogo_Frecuencia_de_Pagos__mdt] ) {

			mapaResult.put(codFrecuenciaPago.MasterLabel, codFrecuenciaPago.Valor__c);
        }

        return mapaResult;
	}

	/// Custom Metadata TipoCuenta
	public static Map<String, String> mapaTipoCuenta() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_TipoCuenta__mdt codTipoCuenta: [SELECT Codigo__c, MasterLabel FROM Catalogo_TipoCuenta__mdt] ) {

			mapaResult.put(codTipoCuenta.Codigo__c, codTipoCuenta.MasterLabel);
		}

		return mapaResult;
	}


	/// Custom Metadata TipoContrato
	public static Map<String, String> mapaTipoContrato() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_TipoContrato__mdt codTipoContrato: [SELECT MasterLabel, Descripcion__c FROM Catalogo_TipoContrato__mdt] ) {

			mapaResult.put(codTipoContrato.MasterLabel, codTipoContrato.Descripcion__c);
		}

		return mapaResult;
	}

	/// Custom Metadata ClaveObservacion
	public static Map<String, String> mapaClaveObservacion() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_ClaveObservacion__mdt codClaveObs: [SELECT MasterLabel, Nombre__c FROM Catalogo_ClaveObservacion__mdt] ) {

			mapaResult.put(codClaveObs.MasterLabel, codClaveObs.Nombre__c);
		}

		return mapaResult;
	}

	/// Custom Metadata Indicador Tipo Responsabilidad
	public static Map<String, String> mapaIndicadorResponsabilidad() {

		Map<String, String> mapaResult = new Map<String, String>();

		for(Catalogo_IndicadorTipoResponsabilidad__mdt codIndicadorResp: [SELECT Codigo__c, MasterLabel FROM Catalogo_IndicadorTipoResponsabilidad__mdt] ) {

			mapaResult.put(codIndicadorResp.Codigo__c, codIndicadorResp.MasterLabel);
		}

		return mapaResult;
	}

	/// Custom Metadata Razones de Score CC
	public static Map<String, String> mapaRazonesScoreCC() {

		Map<String, String> mapResult = new Map<String, String>();

		for(Catalogo_RazonesScore__mdt codRazonScore: [SELECT MasterLabel, Descripcion__c FROM Catalogo_RazonesScore__mdt] ) {

			mapResult.put(codRazonScore.MasterLabel, codRazonScore.Descripcion__c);
		}

		return mapResult;
	}

	/// Custom Metadata Tipo de Cuenta CC
	public static Map<String, String> mapaTipoCuentaCC() {

		Map<String, String> mapResult = new Map<String, String>();

		for(Catalogo_TipoCuenta_CC__mdt codTipoCuenta: [SELECT MasterLabel, Descripcion__c FROM Catalogo_TipoCuenta_CC__mdt] ) {

			mapResult.put(codTipoCuenta.MasterLabel, codTipoCuenta.Descripcion__c);
		}

		return mapResult;
	}

	/// Custom Metadata Tipo de Responsabilidad CC
	public static Map<String, String> mapaTipoResponsabilidadCC() {

		Map<String, String> mapResult = new Map<String, String>();

		for(Catalogo_TipoResponsabilidad_CC__mdt codTipoResp: [SELECT MasterLabel, Descripcion__c FROM Catalogo_TipoResponsabilidad_CC__mdt] ) {

			mapResult.put(codTipoResp.MasterLabel, codTipoResp.Descripcion__c);
		}

		return mapResult;
	}

	/// Custom Metadata Tipo de Credito CC
	public static Map<String, String> mapaTipoCreditoCC() {

		Map<String, String> mapResult = new Map<String, String>();

		for(Catalogo_TipoCredito_CC__mdt codTipoCredito: [SELECT MasterLabel, Descripcion__c FROM Catalogo_TipoCredito_CC__mdt] ) {

			mapResult.put(codTipoCredito.MasterLabel, codTipoCredito.Descripcion__c);
		}

		return mapResult;
	}

	/// Custom Metadata Frecuencia de Pagos CC
	public static Map<String, String> mapaFrecuenciaPagosCC() {

		Map<String, String> mapResult = new Map<String, String>();

		for(Catalogo_FrecuenciaPagos_CC__mdt codFrecuenciaPago: [SELECT MasterLabel, Descripcion__c FROM Catalogo_FrecuenciaPagos_CC__mdt] ) {

			mapResult.put(codFrecuenciaPago.MasterLabel, codFrecuenciaPago.Descripcion__c);
		}

		return mapResult;
	}

    ///
    public static String formatoFecha(String fecha, Boolean blnCompleta) {

        String strFechaResult;
        String strDia, strMes, strAnio;
        Map<String, String> mapDigitosMes = new Map<String, String>();
        mapDigitosMes.put('01','ENE');
        mapDigitosMes.put('02','FEB');
        mapDigitosMes.put('03','MAR');
        mapDigitosMes.put('04','ABR');
        mapDigitosMes.put('05','MAY');
        mapDigitosMes.put('06','JUN');
        mapDigitosMes.put('07','JUL');
        mapDigitosMes.put('08','AGO');
        mapDigitosMes.put('09','SEP');
        mapDigitosMes.put('10','OCT');
        mapDigitosMes.put('11','NOV');
		mapDigitosMes.put('12','DIC');		

        if( !String.isBlank(fecha) && (fecha.length() == 8 || fecha.length() == 10) ) {

            strDia = fecha.length() == 8 ? fecha.subString(0,2) : fecha.subString(8,10);
            strMes = fecha.length() == 8 ? fecha.subString(2,4) : fecha.subString(5,7);
            strAnio = fecha.length() == 8 ? fecha.subString(4,8) : fecha.subString(0,4);

            strFechaResult = blnCompleta ? strDia : '';
            strFechaResult += blnCompleta ? '-' : '';
            strFechaResult += mapDigitosMes.containsKey(strMes) ? mapDigitosMes.get(strMes) : strMes;
            strFechaResult += blnCompleta ? '-' : '/';
            strFechaResult += blnCompleta ? strAnio : strAnio.subString(2,4);

        } else {

            strFechaResult = fecha;
        }        

        return strFechaResult;
	}	

	/// Historico de Pagos
	public static Map<String, String> generaHistoricoDePagos(String strDigitos, String strFechaCierreCuenta, String strFechaReporte, String strFechaHistoricaMorisidad) {

		Map<String, String> mapResult = new Map<String, String>();

		// Mapa para crear la secuencia de Meses del Primer Anio
		Map<Integer, String> mapMesesPrimerA = new Map<Integer, String>();
		mapMesesPrimerA.put(1,'E');
		mapMesesPrimerA.put(2,'FE');
		mapMesesPrimerA.put(3,'MFE');
		mapMesesPrimerA.put(4,'AMFE');
		mapMesesPrimerA.put(5,'MAMFE');
		mapMesesPrimerA.put(6,'JMAMFE');
		mapMesesPrimerA.put(7,'JJMAMFE');
		mapMesesPrimerA.put(8,'AJJMAMFE');
		mapMesesPrimerA.put(9,'SAJJMAMFE');
		mapMesesPrimerA.put(10,'OSAJJMAMFE');
		mapMesesPrimerA.put(11,'NOSAJJMAMFE');
		mapMesesPrimerA.put(12,'DNOSAJJMAMFE'); //

		// Mapa para crear la secuencia de Meses del Primer Anio Incompleto
		Map<Decimal, String> mapMesesPrimerAIncompleto = new Map<Decimal, String>();
		mapMesesPrimerAIncompleto.put(11.10, 'NOSAJJMAMF');
		mapMesesPrimerAIncompleto.put(11.9, 'NOSAJJMAM');
		mapMesesPrimerAIncompleto.put(11.8, 'NOSAJJMA');
		mapMesesPrimerAIncompleto.put(11.7, 'NOSAJJM');
		mapMesesPrimerAIncompleto.put(11.6, 'NOSAJJ');
		mapMesesPrimerAIncompleto.put(11.5, 'NOSAJ');
		mapMesesPrimerAIncompleto.put(11.4, 'NOSA');
		mapMesesPrimerAIncompleto.put(11.3, 'NOS');
		mapMesesPrimerAIncompleto.put(11.2, 'NO');
		mapMesesPrimerAIncompleto.put(11.1, 'N');
		mapMesesPrimerAIncompleto.put(10.9, 'OSAJJMAMF');
		mapMesesPrimerAIncompleto.put(10.8, 'OSAJJMAM');
		mapMesesPrimerAIncompleto.put(10.7, 'OSAJJMA');
		mapMesesPrimerAIncompleto.put(10.6, 'OSAJJM');
		mapMesesPrimerAIncompleto.put(10.5, 'OSAJJ');
		mapMesesPrimerAIncompleto.put(10.4, 'OSAJ');
		mapMesesPrimerAIncompleto.put(10.3, 'OSA');
		mapMesesPrimerAIncompleto.put(10.2, 'OS');
		mapMesesPrimerAIncompleto.put(10.1, 'O');
		mapMesesPrimerAIncompleto.put(9.8, 'SAJJMAMF');
		mapMesesPrimerAIncompleto.put(9.7, 'SAJJMAM');
		mapMesesPrimerAIncompleto.put(9.6, 'SAJJMA');
		mapMesesPrimerAIncompleto.put(9.5, 'SAJJM');
		mapMesesPrimerAIncompleto.put(9.4, 'SAJJ');
		mapMesesPrimerAIncompleto.put(9.3, 'SAJ');
		mapMesesPrimerAIncompleto.put(9.2, 'SA');
		mapMesesPrimerAIncompleto.put(9.1, 'S');
		mapMesesPrimerAIncompleto.put(8.7, 'AJJMAMF');
		mapMesesPrimerAIncompleto.put(8.6, 'AJJMAM');
		mapMesesPrimerAIncompleto.put(8.5, 'AJJMA');
		mapMesesPrimerAIncompleto.put(8.4, 'AJJM');
		mapMesesPrimerAIncompleto.put(8.3, 'AJJ');
		mapMesesPrimerAIncompleto.put(8.2, 'AJ');
		mapMesesPrimerAIncompleto.put(8.1, 'A');
		mapMesesPrimerAIncompleto.put(7.6, 'JJMAMF');
		mapMesesPrimerAIncompleto.put(7.5, 'JJMAM');
		mapMesesPrimerAIncompleto.put(7.4, 'JJMA');
		mapMesesPrimerAIncompleto.put(7.3, 'JJM');
		mapMesesPrimerAIncompleto.put(7.2, 'JJ');
		mapMesesPrimerAIncompleto.put(7.1, 'J');
		mapMesesPrimerAIncompleto.put(6.5, 'JMAMF');
		mapMesesPrimerAIncompleto.put(6.4, 'JMAM');
		mapMesesPrimerAIncompleto.put(6.3, 'JMA');
		mapMesesPrimerAIncompleto.put(6.2, 'JM');
		mapMesesPrimerAIncompleto.put(6.1, 'J');
		mapMesesPrimerAIncompleto.put(5.4, 'MAMF');
		mapMesesPrimerAIncompleto.put(5.3, 'MAM');
		mapMesesPrimerAIncompleto.put(5.2, 'MA');
		mapMesesPrimerAIncompleto.put(5.1, 'M');
		mapMesesPrimerAIncompleto.put(4.3, 'AMF');
		mapMesesPrimerAIncompleto.put(4.2, 'AM');
		mapMesesPrimerAIncompleto.put(4.1, 'A');
		mapMesesPrimerAIncompleto.put(3.2, 'MF');
		mapMesesPrimerAIncompleto.put(3.1, 'M');
		mapMesesPrimerAIncompleto.put(2.1, 'F');

		// Mapa para crear la secuencia de Meses del Segundo y Tercer Anio
		Map<Integer, String> mapMesesSegundoTercero = new Map<Integer, String>();
		mapMesesSegundoTercero.put(1,'D');
		mapMesesSegundoTercero.put(2,'DN');
		mapMesesSegundoTercero.put(3,'DNO');
		mapMesesSegundoTercero.put(4,'DNOS');
		mapMesesSegundoTercero.put(5,'DNOSA');
		mapMesesSegundoTercero.put(6,'DNOSAJ');
		mapMesesSegundoTercero.put(7,'DNOSAJJ');
		mapMesesSegundoTercero.put(8,'DNOSAJJM');
		mapMesesSegundoTercero.put(9,'DNOSAJJMA');
		mapMesesSegundoTercero.put(10,'DNOSAJJMAM');
		mapMesesSegundoTercero.put(11,'DNOSAJJMAMF');
		mapMesesSegundoTercero.put(12,'DNOSAJJMAMFE');

		/// Anio Actual
		Integer intAnioActual = -1;


		String strPrimerAnioMeses = '';
		String strSegundoAnioMeses = '';
		String strTercerAnioMeses = '';
		String strPrimerAnioDigitos = '';
		String strSegundoAnioDigitos = '';
		String strTercerAnioDigitos = '';

		String strAnio, strMes;
		Integer intMes, intMesAnterior, intPrimerAnio;
		Boolean blnPrimerAnioAsignado = false;

		// Se valida si la Cadena de Digitos Tiene al menos un elemento
		if( !String.isBlank(strDigitos) && strDigitos.length() > 0 ) {

			/// Se cambia la letra X por '-'
			strDigitos = strDigitos.replace('X','-');
			strDigitos = strDigitos.replace('x','-');

			Boolean blnFechaValida = false;

			// Se valida si el campo Cierre No es Nulo
			if( !String.isBlank(strFechaCierreCuenta) && strFechaCierreCuenta.length() == 8 ) {

				blnFechaValida = true;
				strAnio = strFechaCierreCuenta.subString(4,8);
				strMes = strFechaCierreCuenta.subString(2,4);

			} else if( !String.isBlank(strFechaReporte) && strFechaReporte.length() == 8 ) {

				blnFechaValida = true;
				strAnio = strFechaReporte.subString(4,8);
				strMes = strFechaReporte.subString(2,4);

			} else if( !String.isBlank(strFechaHistoricaMorisidad) && strFechaHistoricaMorisidad.length() == 8 ) {

				blnFechaValida = true;
				strAnio = strFechaHistoricaMorisidad.subString(4,8);
				strMes = strFechaHistoricaMorisidad.subString(2,4);
			}

			if( blnFechaValida ) {
			
				intPrimerAnio = Integer.valueOf(strAnio);
				///
				intAnioActual = intPrimerAnio;

				intMes = Integer.valueOf(strMes);
				intMesAnterior = intMes - 1;

				/// Primer Anio
				if( (intMesAnterior == strDigitos.length()) && (intAnioActual == intPrimerAnio) ) {
					
					strPrimerAnioMeses = mapMesesPrimerA.get(strDigitos.length());
					strPrimerAnioDigitos = strDigitos;
					/// Segundo Anio y Tercer Anio se quedan Vacios
					/// *** FIN ***

				} else if( (strDigitos.length() < intMesAnterior) && (intAnioActual == intPrimerAnio) ) {

					strPrimerAnioMeses = mapMesesPrimerAIncompleto.get(Decimal.valueOf( intMesAnterior + '.' + strDigitos.length() ));
					strPrimerAnioDigitos = strDigitos;
			 	} else {

					/// Se valida caso Mes ENE --> MesAnterior 0
					strPrimerAnioMeses = (intMesAnterior > 0) && (intAnioActual == intPrimerAnio) ? mapMesesPrimerA.get(intMesAnterior) : '';
					strPrimerAnioDigitos = (intMesAnterior > 0) && (intAnioActual == intPrimerAnio) ? strDigitos.subString(0,intMesAnterior) : '';

					/// Digitos Restantes para el Segundo Anio					
					strDigitos = (intMesAnterior > 0) && (intAnioActual == intPrimerAnio) ? strDigitos.subString(intMesAnterior, strDigitos.length()) : strDigitos;
					blnPrimerAnioAsignado = (intAnioActual == intPrimerAnio) ? true : false;

					// Segundo Anio
					if(  (strDigitos.length() <= 12) && blnPrimerAnioAsignado && ( (intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio) )  ) {

						strSegundoAnioMeses = blnPrimerAnioAsignado ? mapMesesSegundoTercero.get(strDigitos.length()) : mapMesesPrimerA.get(strDigitos.length());
						strSegundoAnioDigitos = strDigitos;
						/// Tercer Anio se queda Vacio
						/// *** FIN ***

					} else if( (strDigitos.length() < intMesAnterior) && ((intAnioActual - 1) == intPrimerAnio) ) {
						
						strSegundoAnioMeses = mapMesesPrimerAIncompleto.get(Decimal.valueOf( intMesAnterior + '.' + strDigitos.length() ));
						strSegundoAnioDigitos = strDigitos;
					} else {

						strSegundoAnioMeses = ((intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio)) ? 
													(blnPrimerAnioAsignado || (intMesAnterior < 1 && intAnioActual == intPrimerAnio) ? 
														mapMesesSegundoTercero.get(12) : 
														mapMesesPrimerA.get(intMesAnterior)) 
													: '';

						strSegundoAnioDigitos = ((intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio)) ? 
													(blnPrimerAnioAsignado || (intMesAnterior < 1 && intAnioActual == intPrimerAnio) ? 
														strDigitos.subString(0,12) : 
														strDigitos.subString(0,intMesAnterior)
													) : '';

						/// Digitos Restantes para el Tercer Anio
						strDigitos = ((intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio)) ? (blnPrimerAnioAsignado || (intMesAnterior < 1 && intAnioActual == intPrimerAnio) ? strDigitos.subString(12, strDigitos.length()) : strDigitos.subString(intMesAnterior, strDigitos.length())) : strDigitos;
						blnPrimerAnioAsignado = blnPrimerAnioAsignado || ((intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio)) ? true : false;

						// Tercer Anio
						if(  (strDigitos.length() <= 12) && blnPrimerAnioAsignado && ( (intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio) || ((intAnioActual - 2) == intPrimerAnio) )  ) {

							strTercerAnioMeses = blnPrimerAnioAsignado ? mapMesesSegundoTercero.get(strDigitos.length()) : mapMesesPrimerA.get(strDigitos.length());
							strTercerAnioDigitos = strDigitos;
							/// *** FIN ***

						} else if( (strDigitos.length() < intMesAnterior) && ((intAnioActual - 2) == intPrimerAnio) ) {

							strTercerAnioMeses = mapMesesPrimerAIncompleto.get(Decimal.valueOf( intMesAnterior + '.' + strDigitos.length() ));
							strTercerAnioDigitos = strDigitos;
						} else {

							strTercerAnioMeses = (intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio) || ((intAnioActual - 2) == intPrimerAnio) ? (blnPrimerAnioAsignado ? mapMesesSegundoTercero.get(12) : mapMesesPrimerA.get(intMesAnterior)) : '';
							strTercerAnioDigitos = (intAnioActual == intPrimerAnio) || ((intAnioActual - 1) == intPrimerAnio) || ((intAnioActual - 2) == intPrimerAnio) ? (blnPrimerAnioAsignado ? strDigitos.subString(0,12) : strDigitos.subString(0,intMesAnterior)) : '';
							/// *** La cadena contiene mas Digitos ***
						}
					}
				}
			}			
		}

		/// Mapa con los Meses y Digitos 
		mapResult.put('1M', strPrimerAnioMeses);
		mapResult.put('1D', strPrimerAnioDigitos);
		mapResult.put('2M', strSegundoAnioMeses);
		mapResult.put('2D', strSegundoAnioDigitos);
		mapResult.put('3M', strTercerAnioMeses);
		mapResult.put('3D', strTercerAnioDigitos);
		mapResult.put('1A', String.valueOf(intAnioActual) );

		return mapResult;		
	}

	/// Historico de Pagos Circulo de Credito
	public static String generaHistoricoDePagosCC(String strDigitos) {

		String result = '';

		if( String.isNotBlank(strDigitos) ) {

			strDigitos = strDigitos.replaceAll(' ', '');

			Integer count = 0;

			for(Integer i = 0; i < strDigitos.length() ; i ++ ) {

				result += strDigitos.substring(i, i + 1);
				result +=  String.isNotBlank(strDigitos.substring(i, i + 1)) ? '.' : '';

				if( Math.Mod(result.length() - count, 20) == 0 ) {

					result += ' ';
					count ++;
				}
			}

			result = result.replaceAll('-.-', '--');
			result = result.replaceAll('-. ', '- ');
		}

		return result;
	}

	public class Persona {

		public Encabezado encabezado {get; set;}
		public Nombre nombre {get; set;}
		public List<Domicilio> domicilios {get; set;}
		public List<Empleo> empleos {get; set;}
		public List<Cuenta> cuentas {get; set;}
		public List<ConsultaEfectuada> consultasEfectuadas {get; set;}
		public List<ResumenReporte> ResumenReportes {get; set;}
		/*@AuraEnabled
		public List<HawkAlertC> HawkAlertConsulta;*/
		/*@AuraEnabled
		public List<HawkAlertBD> HawkAlertBDS;*/
		public List<ScoreBC> ScoreBuroCredito {get; set;}
		public List<ResumenReporteSumaDeCuentas> ResumenReportesSumaCuentas {get; set;}
		public Boolean blnBuroDeCredito {get; set;}

		Persona(Encabezado encabezado, Nombre nombre, List<Domicilio> domicilios, List<Empleo> empleos, List<Cuenta> cuentas, List<ConsultaEfectuada> consultasEfectuadas, 
				List<ResumenReporte> ResumenReportes, /*List<HawkAlertC> HawkAlertConsulta,List<HawkAlertBD> HawkAlertBDS,*/ List<ScoreBC> ScoreBuroCredito, List<ResumenReporteSumaDeCuentas> ResumenReportesSumaCuentas, 
				Boolean blnBuroDeCredito) {
			this.encabezado = encabezado;
			this.nombre = nombre;
			this.domicilios = domicilios;
			this.empleos = empleos;
			this.cuentas = cuentas;
			this.consultasEfectuadas = consultasEfectuadas;
			this.ResumenReportes = ResumenReportes;
			/*this.HawkAlertConsulta = HawkAlertConsulta;*/
			/*this.HawkAlertBDS = HawkAlertBDS;*/
			this.ScoreBuroCredito = ScoreBuroCredito;
			this.ResumenReportesSumaCuentas = ResumenReportesSumaCuentas;
			this.blnBuroDeCredito = blnBuroDeCredito;
		}
	}

	public class Encabezado {

		public String NumeroReferenciaOperador {get; set;}
		public String ClavePais {get; set;}
		public String IdentificadorBuro {get; set;}
		public String ClaveOtorgante {get; set;}
		public Integer ClaveOtorganteCC {get; set;}
		public String ClaveRetornoConsumidorPrincipal {get; set;}
		public String ClaveRetornoConsumidorSecundario {get; set;}
		public String NumeroControlConsulta {get; set;}
		public Integer NumeroControlConsultaCC {get; set;}

		Encabezado(String NumeroReferenciaOperador, String ClavePais, String IdentificadorBuro, String ClaveOtorgante, Integer ClaveOtorganteCC, String ClaveRetornoConsumidorPrincipal, 
					String ClaveRetornoConsumidorSecundario, String NumeroControlConsulta, Integer NumeroControlConsultaCC) {
			this.NumeroReferenciaOperador = NumeroReferenciaOperador;
			this.ClavePais = ClavePais;
			this.IdentificadorBuro = IdentificadorBuro;
			this.ClaveOtorgante = ClaveOtorgante;
			this.ClaveOtorganteCC = ClaveOtorganteCC;
			this.ClaveRetornoConsumidorPrincipal = ClaveRetornoConsumidorPrincipal;
			this.ClaveRetornoConsumidorSecundario = ClaveRetornoConsumidorSecundario;
			this.NumeroControlConsulta = NumeroControlConsulta;
			this.NumeroControlConsultaCC = NumeroControlConsultaCC;
		}
	}

	public class Nombre {

		public String ApellidoPaterno {get; set;}
		public String ApellidoMaterno {get; set;}
		public String PrimerNombre {get; set;}
		public String SegundoNombre {get; set;}
		public String FechaNacimiento {get; set;}
		public String RFC {get; set;}
		public String Prefijo {get; set;}
		public String Nacionalidad {get; set;}
		public String Residencia {get; set;}
		public String EstadoCivil {get; set;}
		public String Sexo {get; set;}
		public String ClaveImpuestosOtroPais {get; set;}
		public String NumeroDependientes {get; set;}
		public String EdadesDependientes {get; set;}
		public String FechaRecepcionInformacionDependientes {get; set;}
		public String NumeroRegistroElectoral {get; set;}

		Nombre(String ApellidoPaterno, String ApellidoMaterno, String PrimerNombre, String SegundoNombre, String FechaNacimiento, String RFC, String Prefijo, String Nacionalidad, String Residencia, 
			   String EstadoCivil, String Sexo, String ClaveImpuestosOtroPais, String NumeroDependientes, String EdadesDependientes, String FechaRecepcionInformacionDependientes, 
			   String NumeroRegistroElectoral) {
			this.ApellidoPaterno = ApellidoPaterno;
			this.ApellidoMaterno = ApellidoMaterno;
			this.PrimerNombre = PrimerNombre;
			this.SegundoNombre = SegundoNombre;
			this.FechaNacimiento = FechaNacimiento;
			this.RFC = RFC;
			this.Prefijo = Prefijo;
			this.Nacionalidad = Nacionalidad;
			this.Residencia = Residencia;
			this.EstadoCivil = EstadoCivil;
			this.Sexo = Sexo;
			this.ClaveImpuestosOtroPais = ClaveImpuestosOtroPais;
			this.NumeroDependientes = NumeroDependientes;
			this.EdadesDependientes = EdadesDependientes;
			this.FechaRecepcionInformacionDependientes = FechaRecepcionInformacionDependientes;
			this.NumeroRegistroElectoral = NumeroRegistroElectoral;
		}

	}

	public class Domicilio {

		public String Direccion1 {get; set;}
		public String DelegacionMunicipio {get; set;}
		public String Estado {get; set;}
		public String CP {get; set;}
		public String FechaReporteDireccion {get; set;}
		public String ColoniaPoblacion {get; set;}
		public String Ciudad {get; set;}
		public String NumeroTelefono {get; set;}
		public String CodPais {get; set;}
	}

	public class Empleo {

		public String NombreEmpresa {get; set;}
		public String Cargo {get; set;}
		public String Salario {get; set;}
		public String BaseSalarial {get; set;}
		public String Direccion1 {get; set;}
		public String Direccion2 {get; set;}
		public String ColoniaPoblacion {get; set;}
		public String DelegacionMunicipio {get; set;}
		public String Ciudad {get; set;}
		public String Estado {get; set;}
		public String CP {get; set;}
		public String NumeroTelefono {get; set;}
		public String CodPais {get; set;}
		public String FechaReportoEmpleo {get; set;}
		public String FechaContratacion {get; set;}
		public String FechaUltimoDiaEmpleo {get; set;}
	}

	public class Cuenta {

		public String FechaActualizacion {get; set;}
		public String NombreOtorgante {get; set;}
		public String NumeroTelefonoOtorgante {get; set;}
		public String IdentificadorSociedadInformacionCrediticia {get; set;}
		public String IndicadorTipoResponsabilidad {get; set;}
		public String TipoCuenta {get; set;}
		public String TipoContrato {get; set;}
		public String ClaveUnidadMonetaria {get; set;}
		public String FrecuenciaPagos {get; set;}
        public String MontoPagar {get; set;}
		public String NumeroPagos {get; set;}
		public String FechaAperturaCuenta {get; set;}
		public String FechaUltimoPago {get; set;}
		public String FechaUltimaCompra {get; set;}
		public String FechaReporte {get; set;}
		public String ModoReportar {get; set;}
		public Decimal CreditoMaximo {get; set;}
		public Decimal SaldoActual {get; set;}
		public Decimal LimiteCredito {get; set;}
		public Decimal SaldoVencido {get; set;}
		public String FormaPagoActual {get; set;}
		public String HistoricoPagos {get; set;}
		public String FechaMasRecienteHistoricoPagos {get; set;}
		public String FechaMasAntiguaHistoricoPagos {get; set;}
        public String FechaCierreCuenta {get; set;}
		public Decimal MontoUltimoPago {get; set;}
		public String MopHistoricoMorosidadMasGrave {get; set;}
		public String FechaHistoricaMorosidadMasGrave {get; set;}
		public String ImporteSaldoMorosidadHistMasGrave {get; set;}
		public String PrimeroMeses {get; set;}
		public String PrimeroDigitos {get; set;}
		public String SegundoMeses {get; set;}
		public String SegundoDigitos {get; set;}
		public String TerceroMeses {get; set;}
		public String TerceroDigitos {get; set;}
		public String ClaveObservacion {get; set;}
		public Integer PrimerAnio {get; set;}
	}

	public class ConsultaEfectuada {

		public String FechaConsulta {get; set;}
		public String IdentificacionBuro {get; set;}
		public String NombreOtorgante {get; set;}
		public String TelefonoOtorgante {get; set;}
		public String TipoContrato {get; set;}
		public String ClaveUnidadMonetaria {get; set;}
		public Decimal ImporteContrato {get; set;}
		public String ResultadoFinal {get; set;}
		public String IdentificadorOrigenConsulta {get; set;}
		public String IndicadorTipoResponsabilidad {get; set;}
	}

	public class ResumenReporte {

		public String FechaIngresoBD {get; set;}
		public String NumeroMOP7 {get; set;}
		public String NumeroMOP6 {get; set;}
		public String NumeroMOP5 {get; set;}
		public String NumeroMOP4 {get; set;}
		public String NumeroMOP3 {get; set;}
		public String NumeroMOP2 {get; set;}
		public String NumeroMOP1 {get; set;}
		public String NumeroMOP0 {get; set;}
		public String NumeroMOPUR {get; set;}
		public String NumeroCuentas {get; set;}
		public String CuentasPagosFijosHipotecas {get; set;}
		public Integer CuentasRevolventesAbiertas {get; set;}
		public String CuentasCerradas {get; set;}
		public String CuentasNegativasActuales {get; set;}
		public String CuentasClavesHistoriaNegativa {get; set;}
		public String CuentasDisputa {get; set;}
		public String NumeroSolicitudesUltimos6Meses {get; set;}
		public String NuevaDireccionReportadaUltimos60Dias {get; set;}
		public String MensajesAlerta {get; set;}
		public String ExistenciaDeclaracionesConsumidor {get; set;}
		public String TipoMoneda {get; set;}
		public Integer TotalCreditosMaximosRevolventes {get; set;}
		public Integer TotalLimitesCreditoRevolventes {get; set;}
		public Integer TotalSaldosActualesRevolventes {get; set;}
		public String TotalSaldosVencidosRevolventes {get; set;}
		public Integer TotalPagosRevolventes {get; set;}
		public String PctLimiteCreditoUtilizadoRevolventes {get; set;}
		public String TotalCreditosMaximosPagosFijos {get; set;}
		public String TotalSaldosActualesPagosFijos {get; set;}
		public String TotalSaldosVencidosPagosFijos {get; set;}
		public String TotalPagosPagosFijos {get; set;}
		public String NumeroMOP96 {get; set;}
		public String NumeroMOP97 {get; set;}
		public String NumeroMOP99 {get; set;}
		public String FechaAperturaCuentaMasAntigua {get; set;}
		public String FechaAperturaCuentaMasReciente {get; set;}
		public String TotalSolicitudesReporte {get; set;}
		public String FechaSolicitudReporteMasReciente {get; set;}
		public String NumeroTotalCuentasDespachoCobranza {get; set;}
		public String FechaAperturaCuentaMasRecienteDespachoCobranza {get; set;}
		public String NumeroTotalSolicitudesDespachosCobranza {get; set;}
		public String FechaSolicitudMasRecienteDespachoCobranza {get; set;}
	}

	public class ResumenReporteSumaDeCuentas {

		public String Mop {get; set;}
		public Integer CuentasAbiertas {get; set;}
		public Integer LimiteAbiertas {get; set;}
		public Integer MaximoAbiertas {get; set;}
		public Integer SaldoActualAbiertas {get; set;}
		public Integer SaldoVencidoAbiertas {get; set;}
		public Integer PagoARealizar {get; set;}
		public Integer CuentasCerradas {get; set;}
		public Integer LimiteCerradas {get; set;}
		public Integer MaximoCerradas {get; set;}
		public Integer SaldoActualCerradas {get; set;}
		public Integer MontoCerradas {get; set;}
	}

	/*class HawkAlertC {
		@auraEnabled
		public String FechaReporte;
		@auraEnabled
		public String CodigoClave;
		@auraEnabled
		public String TipoInstitucion;
		@auraEnabled
		public String Mensaje;
	}*/

	/*class HawkAlertBD {
		@auraEnabled
		public String FechaReporte;
		@auraEnabled
		public String CodigoClave;
		@auraEnabled
		public String TipoInstitucion;
		@auraEnabled
		public String Mensaje;
	}*/

	public class ScoreBC {

		public String nombreScore {get; set;}
		public String CodigoScore {get; set;}
		public String ValorScore {get; set;}
		public List<CodigoRazon> codigosRazon {get; set;}
		public String CodigoError {get; set;}
		public String CodigosRazonCC {get; set;}
	}

	public class CodigoRazon {

		public String CodRazon {get; set;}
	}
}