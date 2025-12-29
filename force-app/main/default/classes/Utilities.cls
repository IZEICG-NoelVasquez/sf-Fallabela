public class Utilities {

    private static Map<String, Resultado_Autenticacion_Ine__mdt> mapResultadoAutenIne;

    /**
    * Calcula la diferencia de tiempo entre dos Datetime y lo regresa en el formato de texto 'dias horas:minutos'
    *
    * @param dtInicio: Fecha de inicio para calcular la diferenica de tiempo
    * @param dtFin: Fecha de fin para calcular la diferencia de tiempo
    **/
    public static String tiempoDeResolucion(Long intTiempoDeResolucion) {

        String strTiempoDeResolucion = '';

        ///Long intTiempoDeResolucion = dtFin.getTime() - dtInicio.getTime();
        Long intDays = 0;
        Long intHours = 0;
        Long intMinutes = 0;        

        intDays = Integer.valueOf( intTiempoDeResolucion / (1000 * 60 * 60 * 24) );

        if( intDays > 0 ) {

            strTiempoDeResolucion = String.valueOf(intDays) + 'd ';
            intHours = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24))) / (1000 *60 * 60) );

            if( intHours > 0 ) {
                
                strTiempoDeResolucion += intHours > 9 ? String.valueOf(intHours) + ':' : '0' + String.valueOf(intHours) + ':';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                } 
            } else {

                strTiempoDeResolucion += '00:';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                } 
            }
        } else {

            intHours = Integer.valueOf( intTiempoDeResolucion / (1000 *60 * 60) );
            if( intHours > 0 ) {

                strTiempoDeResolucion += intHours > 9 ? String.valueOf(intHours) + ':' : '0' + String.valueOf(intHours) + ':';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                }
            } else {

                strTiempoDeResolucion += '00:';
                intMinutes = Integer.valueOf( (intTiempoDeResolucion - (intDays * (1000 * 60 * 60 * 24)) - (intHours * (1000 *60 * 60))) / (1000 * 60) );

                if( intMinutes > 0 ) {

                    strTiempoDeResolucion += intMinutes > 9 ? String.valueOf(intMinutes) : '0' + String.valueOf(intMinutes);
                } else {

                    strTiempoDeResolucion += '00';
                }
            }
        }

        return strTiempoDeResolucion;
    }


    /**
     * 
     */
    public static Long getAverageLong(List<Long> lstValues) {

        Long total = 0;

        for(Long value: lstValues) {

            total += value;
        }

        return total / lstValues.size();
    }

    /*
    *
    */
    public static void loadCatalogCM() {

        mapResultadoAutenIne = new Map<String, Resultado_Autenticacion_Ine__mdt>();

        for(Resultado_Autenticacion_Ine__mdt resAutIne: [SELECT MasterLabel, glosa__c, Bloqueo_de_Fraudes__c FROM Resultado_Autenticacion_Ine__mdt]) {

            mapResultadoAutenIne.put(resAutIne.MasterLabel, resAutIne);
        }
    }

    /**
    * Valida si el campo es nulo
    * Regresa una variable de exito 
    *
    * @param field: campo a validar
    **/
    public static Boolean validateObjectNullValue(Object field) {

        return field != null ? true : false;
    }


    /**
    * Metodo para buscar en el response del MicroServicio el campo numero_llamada == 'F2'
    * Regresa una variable de exito 
    *
    * @param responseGestor: response del MicroServicio
    **/
    public static Map<String,Object> searchNumeroLlamadaF2(SolicitudGestorJSON responseGestor) {

        Map<String,Object> mapResult = new Map<String,Object>();

        Boolean blnNumeroLlamadaF2 = false;
        Boolean blnEstadoFormalizada = false;
        String keyEvaluacionFraudes = '';
        String keyEvaluacionCredito = '';
        /// Batch n intentos        
        Boolean blnPendingFraudes = false;
        Boolean blnPendingIne = false;
        Boolean blnPendingCredito = false;

        /// Estado de la Solicitud
        if( validateObjectNullValue(responseGestor.data) && validateObjectNullValue(responseGestor.data.solicitud) && validateObjectNullValue(responseGestor.data.solicitud.estado) ) {

            if( responseGestor.data.solicitud.estado == 6 ) {

                blnEstadoFormalizada = true;
            }
        }

        /// EVALUACIONES
        if ( !blnEstadoFormalizada && validateObjectNullValue(responseGestor.data) && validateObjectNullValue(responseGestor.data.solicitud) &&
            validateObjectNullValue(responseGestor.data.solicitud.custom) && validateObjectNullValue(responseGestor.data.solicitud.custom.data) &&
            validateObjectNullValue(responseGestor.data.solicitud.custom.data.evaluaciones) ) {

            for (String keyEvaluacion: responseGestor.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.keySet()) {

                SolicitudGestorJSON.Evaluacion_ID evaluacionID = responseGestor.data.solicitud.custom.data.evaluaciones.LisEvaluaciones.get(keyEvaluacion);
                
                if ( validateObjectNullValue(evaluacionID.numero_llamada) ) {

                    /// Fraudes
                    if (evaluacionID.numero_llamada == 'F2') {

                        ///
                        keyEvaluacionFraudes = keyEvaluacion;
                        blnNumeroLlamadaF2 = true;

                        /// Batch n intentos
                        for(SolicitudGestorJSON.Evaluaciones evaluacion: responseGestor.data.solicitud.evaluaciones ) {

                            if ( validateObjectNullValue(evaluacion.id) && (evaluacion.id == keyEvaluacion) &&
                                (evaluacion.respuesta_motor.get(0) == 14) ) {

                                blnPendingFraudes = true;
                                break;
                            }
                        }
                    }

                    /// INE
                    if ( evaluacionID.numero_llamada == 'INE' ) {

                        /// Batch n intentos
                        blnPendingIne = mapResultadoAutenIne.containsKey(String.valueOf(evaluacionID.resultado_autenticacion_ine)) && mapResultadoAutenIne.get(String.valueOf(evaluacionID.resultado_autenticacion_ine)).Bloqueo_de_Fraudes__c ? true : false;
                    }
                }

                /// Credito
                if( validateObjectNullValue(evaluacionID.detalle_respuesta_motor) ) {

                    keyEvaluacionCredito = keyEvaluacion;

                    /// Batch n intentos
                    if( validateObjectNullValue(evaluacionID.detalle_respuesta_motor.codigoOperacion) && evaluacionID.detalle_respuesta_motor.codigoOperacion == '02' ) {

                        blnPendingCredito = true;
                    }
                }
            }
        }

        mapResult.put('blnNumeroLlamadaF2', blnNumeroLlamadaF2);
        mapResult.put('blnEstadoFormalizada', blnEstadoFormalizada);
        mapResult.put('keyEvaluacionFraudes', keyEvaluacionFraudes);
        mapResult.put('keyEvaluacionCredito', keyEvaluacionCredito);
        /// Batch n intentos
        mapResult.put('blnPendingFraudes', blnPendingFraudes);
        mapResult.put('blnPendingIne', blnPendingIne);
        mapResult.put('blnPendingCredito', blnPendingCredito);

        return mapResult;
    }
}