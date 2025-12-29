declare module "@salesforce/apex/MicroServicioMovimientos.obtenerMovSinFechaCorteCliente" {
  export default function obtenerMovSinFechaCorteCliente(param: {codigo: any, identificador: any, identificadorPrimerRegistro: any, identificadorUltimoRegistro: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioMovimientos.obtenerMovConFechaCorteCliente" {
  export default function obtenerMovConFechaCorteCliente(param: {codigo: any, identificador: any, fechaCorte: any, identificadorPrimerRegistro: any, identificadorUltimoRegistro: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioMovimientos.obtenerDetalleMovimientoCliente" {
  export default function obtenerDetalleMovimientoCliente(param: {numeroExtracto: any, numeroMovimientoExtracto: any, numeroOperacionCuota: any, numeroFinanciacion: any, titularidad: any, contrato: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioMovimientos.obtenerDetalleMovimientoClienteList" {
  export default function obtenerDetalleMovimientoClienteList(param: {movimientosList: any}): Promise<any>;
}
declare module "@salesforce/apex/MicroServicioMovimientos.casoCreadoConsultaSaldos" {
  export default function casoCreadoConsultaSaldos(param: {customerId: any}): Promise<any>;
}
