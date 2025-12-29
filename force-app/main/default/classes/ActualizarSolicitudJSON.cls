public class ActualizarSolicitudJSON {
    
    public Integer cardApplicationId;
    public String reasonRejected;
    public String reasonPending;
    public String codigoStatusEvaluacion;
    public String curp;
    public String callNumber;

    public static ActualizarSolicitudJSON parse(String json) {
        return (ActualizarSolicitudJSON) System.JSON.deserialize(json, ActualizarSolicitudJSON.class);
    }
}