public class SolicitudGestorJSON {

	public class Solicitud {
         public String id {get;set;} 
		 public Integer numero {get;set;} 
		 public String fecha_solicitud {get;set;} 
		 public Integer tipo {get;set;} 
		 public Integer estado {get;set;} 
		 public Integer canal {get;set;} 
		 public Integer oficina_genera_solicitud {get;set;} 
		 public String fecha_actualizacion {get;set;}
		 public String fecha_actualizacion_estado {get;set;} 
		 public String fecha_creacion_gestor {get;set;} 
		 public String usuario {get;set;} 
		 public String numero_empleado {get;set;} 
		 public Integer tipo_referido {get;set;} 
		 public Datos_identificacion datos_identificacion {get;set;} 
		 public Datos_contacto datos_contacto {get;set;} 
		 public Datos_financieros datos_financieros {get;set;} 
		 public List<Evaluaciones> evaluaciones {get;set;} 
		 public List<Productos> productos {get;set;} 
		 public List<Medios_de_pago> medios_de_pago {get;set;} 
		 public List<Identificaciones> identificaciones {get;set;} 
		 public Custom custom {get;set;} 
		 public List<Personales> personales {get;set;} 
		 public List<Laborales> laborales {get;set;} 
		 public List<Observaciones> observaciones {get;set;} 

		public Solicitud(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'numero') {
							numero = parser.getIntegerValue();
						} else if (text == 'fecha_solicitud') {
							fecha_solicitud = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'estado') {
							estado = parser.getIntegerValue();
						} else if (text == 'canal') {
							canal = parser.getIntegerValue();
						} else if (text == 'oficina_genera_solicitud') {
							oficina_genera_solicitud = parser.getIntegerValue();
						} else if (text == 'fecha_actualizacion') {
							fecha_actualizacion = parser.getText();
						} else if (text == 'fecha_actualizacion_estado') {
							fecha_actualizacion_estado = parser.getText();
						} else if (text == 'fecha_creacion_gestor') {
							fecha_creacion_gestor = parser.getText();
						} else if (text == 'usuario') {
							usuario = parser.getText();
						} else if (text == 'numero_empleado') {
							numero_empleado = parser.getText();
						} else if (text == 'tipo_referido') {
							tipo_referido = parser.getIntegerValue();
						} else if (text == 'datos_identificacion') {
							datos_identificacion = new Datos_identificacion(parser);
						} else if (text == 'datos_contacto') {
							datos_contacto = new Datos_contacto(parser);
						} else if (text == 'datos_financieros') {
							datos_financieros = new Datos_financieros(parser);
						} else if (text == 'evaluaciones') {
							evaluaciones = arrayOfEvaluaciones(parser);
						} else if (text == 'productos') {
							productos = arrayOfProductos(parser);
						}
						else if (text == 'observaciones') {
							observaciones = arrayOfObservaciones(parser);
						}
						 else if (text == 'medios_de_pago') {
							medios_de_pago = arrayOfMedios_de_pago(parser);
						} else if (text == 'identificaciones') {
							identificaciones = arrayOfIdentificaciones(parser);
						} else if (text == 'custom') {
							custom = new Custom(parser);
						} else if (text == 'personales') {
							personales = arrayOfPersonales(parser);
						} else if (text == 'laborales') {
							laborales = arrayOfLaborales(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Solicitud consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String code {get;set;} 
	public String message {get;set;} 
	public Data_Z data {get;set;} 

	public SolicitudGestorJSON(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'code') {
						code = parser.getText();
					} else if (text == 'message') {
						message = parser.getText();
					} else if (text == 'data') {
						data = new Data_Z(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SolicitudGestorJSON consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Datos_financieros {
		public Normativos normativos {get;set;} 
		public Renta renta {get;set;} 

		public Datos_financieros(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'normativos') {
							normativos = new Normativos(parser);
						} 
						else if (text == 'renta') {
							renta = new Renta (parser);
						} 
						else {
							System.debug(LoggingLevel.WARN, 'Datos_financieros consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Personales {
		public String id {get;set;} 
		public String nombres {get;set;} 
		public String nombre1 {get;set;} 
		public String nombre2 {get;set;} 
		public String apellido1 {get;set;} 
		public String apellido2 {get;set;} 
		public String fecha_nacimiento {get;set;} 
		public Integer nacionalidad {get;set;} 
		public Integer sexo {get;set;} 
		public Integer estado_civil {get;set;} 
		public Integer tipo_persona {get;set;} 
		public String lugar_nacimiento {get;set;} 
		public Integer pais_nacimiento {get;set;} 
		public Integer cantidad_dependientes {get;set;} 
		public Integer parentesco {get;set;} 

		public Personales(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'nombres') {
							nombres = parser.getText();
						} else if (text == 'nombre1') {
							nombre1 = parser.getText();
						} else if (text == 'nombre2') {
							nombre2 = parser.getText();
						} else if (text == 'apellido1') {
							apellido1 = parser.getText();
						} else if (text == 'apellido2') {
							apellido2 = parser.getText();
						} else if (text == 'fecha_nacimiento') {
							fecha_nacimiento = parser.getText();
						} else if (text == 'nacionalidad') {
							nacionalidad = parser.getIntegerValue();
						} else if (text == 'sexo') {
							sexo = parser.getIntegerValue();
						} else if (text == 'estado_civil') {
							estado_civil = parser.getIntegerValue();
						} else if (text == 'tipo_persona') {
							tipo_persona = parser.getIntegerValue();
						} else if (text == 'lugar_nacimiento') {
							lugar_nacimiento = parser.getText();
						} else if (text == 'pais_nacimiento') {
							pais_nacimiento = parser.getIntegerValue();
						} else if (text == 'cantidad_dependientes') {
							cantidad_dependientes = parser.getIntegerValue();
						} else if (text == 'parentesco') {
							parentesco = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Personales consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Telefonos {
		public String id {get;set;} 
		public Integer tipo {get;set;} 
		public String numero {get;set;} 
		public Integer codigo_area {get;set;} 

		public Telefonos(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'numero') {
							numero = parser.getText();
						} else if (text == 'codigo_area') {
							codigo_area = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Telefonos consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Laborales {
		public String id {get;set;} 
		public String nombre_empresa {get;set;} 
		public Integer giro {get;set;} 
		public Integer actividad {get;set;} 
		public Integer antiguedad {get;set;} 
		public Boolean actividad_empresarial {get;set;} 
	    public String fecha_ingreso {get;set;} 
		public String fecha_egreso {get;set;} 

		public Laborales(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'nombre_empresa') {
							nombre_empresa = parser.getText();
						} else if (text == 'giro') {
							giro = parser.getIntegerValue();
						} else if (text == 'actividad') {
							actividad = parser.getIntegerValue();
						} 
						 else if (text == 'fecha_ingreso') {
							fecha_ingreso = parser.getText();
						} else if (text == 'fecha_egreso') {
							fecha_egreso = parser.getText();
						}
						else if (text == 'antiguedad') {
							antiguedad = parser.getIntegerValue();
						} else if (text == 'actividad_empresarial') {
							actividad_empresarial = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Laborales consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomReferenciasId {
		public String nombre_completo {get;set;} 
		public String telefono {get;set;} 

		public CustomReferenciasId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nombre_completo') {
							nombre_completo = parser.getText();
						} else if (text == 'telefono') {
							telefono = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, '1_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Medios_de_pago {
		public String id {get;set;} 
		public Integer tipo {get;set;} 

		public Medios_de_pago(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Medios_de_pago consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomDatosAutorizacionId {
		public Boolean acepta_autenticacion {get;set;} 
		public Boolean ejercido_credito_automotriz {get;set;} 
		public Boolean ejercido_credito_hipotecario {get;set;} 
		public Boolean tarjeta_credito {get;set;} 
		public String ultimos_cuatro_digitos_tdc {get;set;} 


		public CustomDatosAutorizacionId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'acepta_autenticacion') {
							acepta_autenticacion = parser.getBooleanValue();
						} 
						else if (text == 'ejercido_credito_automotriz') {
							ejercido_credito_automotriz = parser.getBooleanValue();
						} else if (text == 'ejercido_credito_hipotecario') {
							ejercido_credito_hipotecario = parser.getBooleanValue();
						} else if (text == 'tarjeta_credito') {
							tarjeta_credito = parser.getBooleanValue();
						} else if (text == 'ultimos_cuatro_digitos_tdc') {
							ultimos_cuatro_digitos_tdc = parser.getText();
						}
						 else {
							System.debug(LoggingLevel.WARN, 'CustomDatosAutorizacionId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Referencias_custom {
		//public CustomReferenciasId customReferenciasID {get;set;} 
		public Map<String,CustomReferenciasId> LisReferencias = new Map<String,customReferenciasID>();
		public Referencias_custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text != ''  && text !=null) {
							LisReferencias.put(text,new CustomReferenciasId(parser));
						}else {
							System.debug(LoggingLevel.WARN, 'Referencias_custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Normativos {
		public String id {get;set;} 
		public Boolean acepta_terminos {get;set;} 
		public Boolean aviso_privacidad {get;set;} 
		public Boolean acepta_publicidad {get;set;} 
		public String numero_serie {get;set;} 
		public Integer origen_recursos {get;set;} 
		public Integer destino_recursos {get;set;} 
		public Integer promedio_gasto_tarjeta {get;set;} 
		public Integer promedio_uso_tarjeta {get;set;} 

		public Normativos(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'acepta_terminos') {
							acepta_terminos = parser.getBooleanValue();
						} else if (text == 'aviso_privacidad') {
							aviso_privacidad = parser.getBooleanValue();
						} else if (text == 'acepta_publicidad') {
							acepta_publicidad = parser.getBooleanValue();
						} else if (text == 'numero_serie') {
							numero_serie = parser.getText();
						} else if (text == 'origen_recursos') {
							origen_recursos = parser.getIntegerValue();
						} else if (text == 'destino_recursos') {
							destino_recursos = parser.getIntegerValue();
						} else if (text == 'promedio_gasto_tarjeta') {
							promedio_gasto_tarjeta = parser.getIntegerValue();
						} else if (text == 'promedio_uso_tarjeta') {
							promedio_uso_tarjeta = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Normativos consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class Renta {
		public String id {get;set;} 
		public String sueldo_bruto {get;set;} 

		public Renta(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'sueldo_bruto') {
							sueldo_bruto = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Renta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	} 
	
	public class Identificaciones {
		public String id {get;set;} 
		public Integer tipo {get;set;} 
		public String numero {get;set;} 
		public String numero_serie {get;set;} 
		public String clave {get;set;} 
		public String codigo1 {get;set;} 
		public String codigo2 {get;set;} 

		public Identificaciones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'numero') {
							numero = parser.getText();
						} else if (text == 'numero_serie') {
							numero_serie = parser.getText();
						} else if (text == 'clave') {
							clave = parser.getText();
						} else if (text == 'codigo1') {
							codigo1 = parser.getText();
						} else if (text == 'codigo2') {
							codigo2 = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Identificaciones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Direcciones_custom {
		public Map<String,CustomDireccionId> Lisdirecciones = new Map<String,customDireccionID>();  
		CustomDireccionId customDireccionID;
		public Direcciones_custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text != '' || text!= null) {
							Lisdirecciones.put(text,new CustomDireccionId(parser));
						}  
						else {
							System.debug(LoggingLevel.WARN, 'Direcciones_custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public Datos_autorizacion_custom Datos_autorizacion_custom {get;set;} 
		public Datos_contacto_custom datos_contacto {get;set;} 
		public Evaluaciones_custom evaluaciones {get;set;} 
		public Referencias_custom referencias {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'datos_autorizacion') {
							Datos_autorizacion_custom = new Datos_autorizacion_custom(parser);
						} else if (text == 'datos_contacto') {
							datos_contacto = new Datos_contacto_custom(parser);
						} else if (text == 'evaluaciones') {
							evaluaciones = new Evaluaciones_custom(parser);
						} else if (text == 'referencias') {
							referencias = new Referencias_custom(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Custom {
		public String id {get;set;} 
		public Data data {get;set;} 

		public Custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'data') {
							data = new Data(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Evaluaciones {
		public String id {get;set;} 
		public String monto_aprobado_motor {get;set;} 
		public List<Integer> respuesta_motor {get;set;} 
       public Evaluaciones (){}
		public Evaluaciones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'monto_aprobado_motor') {
							monto_aprobado_motor = parser.getText();
						} else if (text == 'respuesta_motor') {
							respuesta_motor = arrayOfInteger(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Evaluaciones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomDireccionId {
		public String calle {get;set;} 
		public String codigo_postal {get;set;} 
		public String descripcion_barrio {get;set;} 
		public String descripcion_ciudad {get;set;} 
		public String descripcion_region {get;set;} 
		public Boolean direccion_distinta_ine {get;set;} 
		public String numero_exterior {get;set;} 
		public String numero_interior {get;set;} 
		public String otra_colonia {get;set;} 
		public String poblacion {get;set;} 
		public Integer tipo {get;set;} 

		public CustomDireccionId(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'calle') {
							calle = parser.getText();
						} else if (text == 'codigo_postal') {
							codigo_postal = parser.getText();
						} else if (text == 'descripcion_barrio') {
							descripcion_barrio = parser.getText();
						} else if (text == 'descripcion_ciudad') {
							descripcion_ciudad = parser.getText();
						} else if (text == 'descripcion_region') {
							descripcion_region = parser.getText();
						} else if (text == 'direccion_distinta_ine') {
							direccion_distinta_ine = parser.getBooleanValue();
						} else if (text == 'numero_exterior') {
							numero_exterior = parser.getText();
						} else if (text == 'numero_interior') {
							numero_interior = parser.getText();
						} else if (text == 'otra_colonia') {
							otra_colonia = parser.getText();
						} else if (text == 'poblacion') {
							poblacion = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomDireccionId consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Observaciones {
		public String id {get;set;} 
		public String glosa {get;set;} 
		public Integer tipo {get;set;} 
		public String codigo {get;set;} 
		public String origen {get;set;} 

		public Observaciones(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'glosa') {
							glosa = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'codigo') {
							codigo = parser.getText();
						} else if (text == 'origen') {
							origen = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Observaciones consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Productos {
		public String id {get;set;} 
		public Integer tipo {get;set;} 
		public String dia_facturacion {get;set;} 
		public String envio_estado_cuenta {get;set;} 

		public Productos(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'dia_facturacion') {
							dia_facturacion = parser.getText();
						} else if (text == 'envio_estado_cuenta') {
							envio_estado_cuenta = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Productos consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data_Z {
		public Solicitud solicitud {get;set;} 

		public Data_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'solicitud') {
							solicitud = new Solicitud(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Data_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Datos_contacto {
		public String email {get;set;} 
		public List<Telefonos> telefonos {get;set;} 

		public Datos_contacto(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'email') {
							email = parser.getText();
						} else if (text == 'telefonos') {
							telefonos = arrayOfTelefonos(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Datos_contacto consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Datos_identificacion {
		public Integer tipo {get;set;} 
		public String numero {get;set;} 
		public String numero_serie {get;set;} 
		public Integer bloqueo {get;set;} 

		public Datos_identificacion(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'tipo') {
							tipo = parser.getIntegerValue();
						} else if (text == 'numero') {
							numero = parser.getText();
						} else if (text == 'numero_serie') {
							numero_serie = parser.getText();
						} else if (text == 'bloqueo') {
							bloqueo = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Datos_identificacion consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Evaluaciones_custom {
		public Evaluacion_ID evaluacion_ID {get;set;} // in json: 177af1ce-5181-4dd4-821b-f8a1d1df0105
		 //Evaluaciones evaluacion = new Evaluaciones(); 
		 public Map<String,Evaluacion_ID> LisEvaluaciones = new Map<String,Evaluacion_ID>();  
		public Evaluaciones_custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text != '' && text!= null) {
							LisEvaluaciones.put(text, new evaluacion_ID(parser));
						} else {
							System.debug(LoggingLevel.WARN, 'Evaluaciones_custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Evaluacion_ID {
		public String canal_actual {get;set;} 
		public String canal_origen {get;set;} 
		public String decision_motor {get;set;} 
		public Boolean empleado_falabella {get;set;} 
		public String numero_llamada {get;set;} 
		public Integer resultado_autenticacion_ine {get;set;} 
		public Integer score_emailage {get;set;} 
		public Detalle_respuesta_motor detalle_respuesta_motor {get;set;} 

		public Evaluacion_ID(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'canal_actual') {
							canal_actual = parser.getText();
						} else if (text == 'canal_origen') {
							canal_origen = parser.getText();
						} else if (text == 'decision_motor') {
							decision_motor = parser.getText();
						} else if (text == 'empleado_falabella') {
							empleado_falabella = parser.getBooleanValue();
						} else if (text == 'numero_llamada') {
							numero_llamada = parser.getText();
						} else if (text == 'resultado_autenticacion_ine') {
							resultado_autenticacion_ine = parser.getIntegerValue();
						} else if (text == 'score_emailage') {
							score_emailage = parser.getIntegerValue();
						} 
						else if(text == 'detalle_respuesta_motor'){
							detalle_respuesta_motor = new Detalle_respuesta_motor(parser);
						}
						else {
							System.debug(LoggingLevel.WARN, 'Evaluacion_ID consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

public class Detalle_respuesta_motor {
		public String anexo1 {get;set;} 
		public String anexo2 {get;set;} 
		public String anexo3 {get;set;} 
		public String anio {get;set;} 
		public String autenticacion {get;set;} 
		public String bcscore {get;set;} 
		public CodigoEvaluacion codigoEvaluacion {get;set;} 
		public String codigoOperacion {get;set;} 
		public String coeficiente {get;set;} 
		public String conTdc {get;set;} 
		public String conexionCreditica {get;set;} 
		public String cupoRecomendado {get;set;} 
		public String decisionMotor {get;set;} 
		public String flag {get;set;} 
		public String flagPreeva {get;set;} 
		public String flagPreevaAuto {get;set;} 
		public String flagPreevaHipo {get;set;} 
		public String flagPreevaTc {get;set;} 
		public String glosaOperacion {get;set;} 
		public String grupoRfm {get;set;} 
		public String idEmpleado {get;set;} 
		public String nombre {get;set;} 
		public String promedioMensualCompra {get;set;} 
		public String scoreBuro {get;set;} 
		public String scoreSociodemografico {get;set;} 
		public String tarjetaAprecio {get;set;} 
		public String valiPreeva {get;set;} 
		public String variable1 {get;set;} 
		public String variable2 {get;set;} 
		public String webAgent {get;set;} 
		public Map<String, String> mapRmotor = new Map<String, String>();

		public Detalle_respuesta_motor(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'anexo1') {
							anexo1 = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'anexo2') {
							anexo2 = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'anexo3') {
							anexo3 = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'anio') {
							anio = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'autenticacion') {
							autenticacion = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'bcscore') {
							bcscore = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'codigoEvaluacion') {
							codigoEvaluacion = new CodigoEvaluacion(parser);
						} else if (text == 'codigoOperacion') {
							codigoOperacion = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'coeficiente') {
							coeficiente = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'conTdc') {
							conTdc = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'conexionCreditica') {
							conexionCreditica = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'cupoRecomendado') {
							cupoRecomendado = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'decisionMotor') {
							decisionMotor = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'flag') {
							flag = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'flagPreeva') {
							flagPreeva = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'flagPreevaAuto') {
							flagPreevaAuto = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'flagPreevaHipo') {
							flagPreevaHipo = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'flagPreevaTc') {
							flagPreevaTc = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'glosaOperacion') {
							glosaOperacion = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'grupoRfm') {
							grupoRfm = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'idEmpleado') {
							idEmpleado = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'nombre') {
							nombre = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'promedioMensualCompra') {
							promedioMensualCompra = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'scoreBuro') {
							scoreBuro = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'scoreSociodemografico') {
							scoreSociodemografico = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'tarjetaAprecio') {
							tarjetaAprecio = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'valiPreeva') {
							valiPreeva = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'variable1') {
							variable1 = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'variable2') {
							variable2 = parser.getText();
							mapRmotor.put(text, parser.getText());
						} else if (text == 'webAgent') {
							webAgent = parser.getText();
							mapRmotor.put(text, parser.getText());
						}	
                         else {
							System.debug(LoggingLevel.WARN, 'Detalle_respuesta_motor consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class CodigoEvaluacion {
	   public  Map<String, String> mCodigoEvaluacion = new Map<String, String>();
		public CodigoEvaluacion(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text != '' && text!= null) {
							//0 = parser.getText();
							mCodigoEvaluacion.put(text,parser.getText());
						} else {
							System.debug(LoggingLevel.WARN, 'CodigoEvaluacion consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
		
	public class Datos_autorizacion_custom {
		//public CustomDatosAutorizacionId customDatosAutorizacionID {get;set;} // in json: 2ce5b1bb-7234-477e-aa96-1040490bc737
		 public Map<String,customDatosAutorizacionID> LisDatosAutorizacion = new Map<String,customDatosAutorizacionID>(); 
		// identificaciones.id =  2ce5b1bb-7234-477e-aa96-1040490bc737
		public Datos_autorizacion_custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text != '' && text !=null ) {
							LisDatosAutorizacion.put(text, new CustomDatosAutorizacionId(parser));
						} else {
							System.debug(LoggingLevel.WARN, 'Datos_autorizacion_custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Datos_contacto_custom {
		public Direcciones_custom direcciones {get;set;} 

		public Datos_contacto_custom(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'direcciones') {
							direcciones = new Direcciones_custom(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Datos_contacto_custom consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static SolicitudGestorJSON parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SolicitudGestorJSON(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<Telefonos> arrayOfTelefonos(System.JSONParser p) {
        List<Telefonos> res = new List<Telefonos>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Telefonos(p));
        }
        return res;
    }

    private static List<Integer> arrayOfInteger(System.JSONParser p) {
        List<Integer> res = new List<Integer>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getIntegerValue());
        }
        return res;
    }

    private static List<Evaluaciones> arrayOfEvaluaciones(System.JSONParser p) {
        List<Evaluaciones> res = new List<Evaluaciones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Evaluaciones(p));
        }
        return res;
    }


    private static List<Identificaciones> arrayOfIdentificaciones(System.JSONParser p) {
        List<Identificaciones> res = new List<Identificaciones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Identificaciones(p));
        }
        return res;
    }

    private static List<Personales> arrayOfPersonales(System.JSONParser p) {
        List<Personales> res = new List<Personales>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Personales(p));
        }
        return res;
    }


    private static List<Medios_de_pago> arrayOfMedios_de_pago(System.JSONParser p) {
        List<Medios_de_pago> res = new List<Medios_de_pago>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Medios_de_pago(p));
        }
        return res;
    }

    private static List<Productos> arrayOfProductos(System.JSONParser p) {
        List<Productos> res = new List<Productos>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Productos(p));
        }
        return res;
    }

    private static List<Laborales> arrayOfLaborales(System.JSONParser p) {
        List<Laborales> res = new List<Laborales>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Laborales(p));
        }
        return res;
    }
	   private static List<Observaciones> arrayOfObservaciones(System.JSONParser p) {
        List<Observaciones> res = new List<Observaciones>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Observaciones(p));
        }
        return res;
	}
	
}