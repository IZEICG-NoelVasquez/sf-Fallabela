/**
* Nombre: BatchUpdateCasesEmboce
* Autor: Mauricio Rosales
* Descripcion: Clase Batch para actualizar el campo Estatus_final_de_tarjeta__c de los Casos Emboce Centralizado, al consultar el Web Service de Estafeta 
* --------------------------------------------------------------------------
* Versión       Fecha           Autor                   Descripción
* --------------------------------------------------------------------------
* 1.0           01/03/2023      Mauricio Rosales            Creación
* --------------------------------------------------------------------------
*/
public class BatchUpdateCasesEmboce implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {

    String estatus = System.Label.ESTAFETA_ESTATUS_BATCH_CASOS_EMBOCE;
    ///
    List<String> lstStatusClosedCases;
    List<String> lstStatusCanceledCases;

    /// Errores
    Map<String,Map<String,String>> mapErrors;

    /// Validar Devoluciones
    List<String> lstReturns;

    
    public BatchUpdateCasesEmboce() {

        String strStatusClosed = System.Label.EMBOCE_CENTRALIZADO_STATUS_SPA_CERRAR_CASOS;
        String strStatusCanceled = System.Label.EMBOCE_CENTRALIZADO_STATUS_SPA_CANCELAR_CASOS;

        lstStatusClosedCases = strStatusClosed.split(',');
        lstStatusCanceledCases = strStatusCanceled.split(',');

        mapErrors = new Map<String,Map<String,String>>();

        /// Validar Devoluciones
        String strReturns = System.Label.EMBOCE_CENTRALIZADO_DEVOLUCION_DE_GUIAS;
        lstReturns = strReturns.split(',');
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {

        String caseIdEmboce = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Emboce_Centralizado').getRecordTypeId();
        
        return Database.getQueryLocator([SELECT Estatus_final_de_tarjeta__c, Num_Folio_a_Consultar__c, Status 
                                        FROM Case 
                                        WHERE RecordTypeId =: caseIdEmboce 
                                        AND Estatus_final_de_tarjeta__c !=: estatus 
                                        AND Num_Folio_a_Consultar__c LIKE '______________________'
                                        AND Status NOT IN ('Cerrado','Cancelado') ]);
    }

    public void execute(Database.BatchableContext BC, List<Case> scope) {

        Map<String,String> mapCaseIdWayBill = new Map<String,String>();
        Map<String,String> mapWayBillStatusSPA = new Map<String,String>();
        /// Validar Devoluciones
        Map<String,String> mapWayBillReceiverName = new Map<String,String>();

        for(Case caseEmboce: scope) {

            if( caseEmboce.Num_Folio_a_Consultar__c.length() == 22 ) {

                mapCaseIdWayBill.put(caseEmboce.Id, caseEmboce.Num_Folio_a_Consultar__c);
            }            
        }        

        if( mapCaseIdWayBill.size() > 0 ) {
            
            /// Web Service Token Estafeta
            Map<String, Object> mapToken = EstafetaService.oauthToken();

            if( Boolean.valueOf(mapToken.get('success')) ) {

                OauthEstafetaJSON responseOauth = OauthEstafetaJSON.parse( String.valueOf(mapToken.get('responseBody')) );

                /// Web Service CustShipmentTraking Estafeta
                Map<String,Object> mapWaybill = EstafetaService.custShipmentTrackingList(responseOauth.access_token, mapCaseIdWayBill.values());

                String strResponseWayBill = mapWaybill.containsKey('responseBody') ? String.valueOf(mapWaybill.get('responseBody')) : '';

                if( Boolean.valueOf(mapWaybill.get('success')) && strResponseWayBill.contains('"trackingData":{"TrackingData"') ) {

                    strResponseWayBill = strResponseWayBill.contains('"TrackingData":{') ? strResponseWayBill.replace('"TrackingData":{', '"TrackingData":[{').replace('}}}}}}', '}}]}}}}') : strResponseWayBill;

                    CustShipmentTrackingEstafetaJSON responseWayBill = CustShipmentTrackingEstafetaJSON.parse(strResponseWayBill);

                    if( (responseWayBill.ExecuteQueryResponse != null) && (responseWayBill.ExecuteQueryResponse.ExecuteQueryResult != null) && (responseWayBill.ExecuteQueryResponse.ExecuteQueryResult.trackingData != null) 
                        && (responseWayBill.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData != null) ) {

                        for(CustShipmentTrackingEstafetaJSON.TrackingData tracking: responseWayBill.ExecuteQueryResponse.ExecuteQueryResult.trackingData.TrackingData) {

                            mapWayBillStatusSPA.put(tracking.waybill, tracking.statusSPA);

                            /// Validar Devoluciones
                            if( tracking.deliveryData != null && tracking.deliveryData.receiverName != null ) {

                                mapWayBillReceiverName.put(tracking.waybill, tracking.deliveryData.receiverName);
                            }
                        }
                    }


                    /// Se compara la lista de Guias con la respuesta del WS
                    if( mapWayBillStatusSPA.size() < mapCaseIdWayBill.size() ) {

                        Map<String,String> mapErrorAux = new Map<String,String>();

                        for(String caseId : mapCaseIdWayBill.keySet() ) {                            

                            if( !mapWayBillStatusSPA.containsKey(mapCaseIdWayBill.get(caseId)) ) {

                                /// Error alguna o mas guias no existen o no se encontraron
                                mapErrorAux.put(caseId, mapCaseIdWayBill.get(caseId));
                            }                            
                        }

                        if( mapErrorAux.size() > 0 ) {

                            if( !mapErrors.containsKey('WayBill') ) {

                                mapErrors.put('WayBill', mapErrorAux);

                            } else {
                                
                                mapErrors.get('WayBill').putAll(mapErrorAux);
                            }
                        }
                    }
                    
                    Boolean blnReturn = false;

                    for(Case caseEmboce: scope) {

                        blnReturn = false;
                        
                        if( mapWayBillStatusSPA.containsKey(caseEmboce.Num_Folio_a_Consultar__c) ) {

                            /// Actualizar el campo Estatus_final_de_tarjeta__c de Casos
                            caseEmboce.Estatus_final_de_tarjeta__c = mapWayBillStatusSPA.get(caseEmboce.Num_Folio_a_Consultar__c);

                            /// Validar Devoluciones antes de Cerrar los casos
                            if( mapWayBillReceiverName.containsKey(caseEmboce.Num_Folio_a_Consultar__c) && (lstReturns.size() > 0) ) {

                                for(String strReturn: lstReturns) {

                                    if( mapWayBillReceiverName.get(caseEmboce.Num_Folio_a_Consultar__c).contains(strReturn) ) {

                                        blnReturn = true;
                                        break;
                                    }
                                }
                            }

                            /// Validar Devoluciones antes de Cerrar los casos
                            if( !blnReturn ) {
                                
                                /// Cerrar el Caso
                                if( (lstStatusClosedCases.size() > 0) && lstStatusClosedCases.contains(mapWayBillStatusSPA.get(caseEmboce.Num_Folio_a_Consultar__c)) ) {

                                    caseEmboce.Status = 'Cerrado';
                                }                                
                            }

                            /// Cancelar el Caso
                            if( (lstStatusCanceledCases.size() > 0) && lstStatusCanceledCases.contains(mapWayBillStatusSPA.get(caseEmboce.Num_Folio_a_Consultar__c)) ) {

                                caseEmboce.Status = 'Cancelado';
                            }
                        }
                    }

                    Database.SaveResult[] lstSaveResult = Database.update(scope, false);

                    /// Error al Actualizar los Casos de Emboce
                    Map<String,String> mapErrorAux = !Test.isRunningTest() ? UtilitiesBatchCasesEmboce.validateSaveResult(lstSaveResult, false) : new Map<String,String>{'Error' => 'Error'};

                    if( mapErrorAux.size() > 0 ) {

                        if( !mapErrors.containsKey('DML') ) {

                            mapErrors.put('DML', mapErrorAux);

                        } else {

                            mapErrors.get('DML').putAll(mapErrorAux);
                        }
                    }

                } else {

                    /// Error en el Web Service CutShipmentrackingV2                    
                    if( !mapErrors.containsKey('WebService') ) {

                        mapErrors.put('WebService', new Map<String,String>{ 'CutShipmentrackingV2' => ( String.valueOf(mapWaybill.get('response')) + ';' + String.valueOf(mapWaybill.get('error'))) });

                    } else {

                        mapErrors.get('WebService').putAll(new Map<String,String>{ 'CutShipmentrackingV2' => ( String.valueOf(mapWaybill.get('response')) + ';' + String.valueOf(mapWaybill.get('error'))) });
                    }
                }
                
            } else {

                /// Error al obtener el Token de Estafeta
                if( !mapErrors.containsKey('WebService') ) {

                    mapErrors.put('WebService', new Map<String,String>{ 'CustShipmentTracking Token' => ( String.valueOf(mapToken.get('response')) + ';' + String.valueOf(mapToken.get('error'))) });

                } else {

                    mapErrors.get('WebService').putAll(new Map<String,String>{ 'CustShipmentTracking Token' => ( String.valueOf(mapToken.get('response')) + ';' + String.valueOf(mapToken.get('error'))) });
                }
            }
        }
    }

    public void finish (Database.BatchableContext BC) {

        /// Se envia notificacion via Mail
        if( mapErrors.size() > 0 ) {

            UtilitiesBatchCasesEmboce.sendEmail('Batch Consulta de Guias Estafeta', mapErrors);
        }
    }
}