public class WSCreateDataBO {

    public String name;
    public String surname;
    public String secondsurname;
    public String curp;
    public Integer cardapplicationid;
    public Integer tipo_cola;
    public String evaluationResult;//Estatus
        
    public WSCreateDataBO(String name, String surname, String secondsurname, String curp, Integer cardapplicationid, Integer tipo_cola, String evaluationResult) {
                         
        this.name = name;
        this.surname = surname;
        this.secondsurname = secondsurname;
        this.curp = curp;
        this.cardapplicationid = cardapplicationid;
        this.tipo_cola = tipo_cola;
        this.evaluationResult = evaluationResult;
    }
}