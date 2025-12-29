@RestResource(urlMapping='/api/clienteBusquedaGenerar/*')
global class ClienteBusquedaGenerar {

    @HttpGet
    global static void showAccounts() {

        ///
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        String fechaNacimiento = request.params.containsKey('fechaDeNacimiento') ? request.params.get('fechaDeNacimiento'): null;
        String nombreCliente = request.params.containsKey('nombreCliente') ? request.params.get('nombreCliente'): null;
        String uri = request.requestURI;

        System.debug('fechaNacimiento:  ' + fechaNacimiento);
        System.debug('nombreCliente:  ' + nombreCliente);
        System.debug('uri:  ' + uri);

        try {

            if( uri.equals('/api/clienteBusquedaGenerar') ) {

                ///
                List<String> lstFecha = fechaNacimiento.split('/');
                System.debug('lstFecha:  ' + lstFecha);
                Date dtFechaNacimiento = date.newinstance( Integer.valueOf(lstFecha[2]), Integer.valueOf(lstFecha[1]), Integer.valueOf(lstFecha[0]) );

                String strLikeName = '%' + nombreCliente + '%';
                List<Account> listaClientes = [SELECT Name, 
                                                        LastName, 
                                                        FirstName, 
                                                        CreatedDate, 
                                                        PersonMobilePhone, 
                                                        PersonEmail, 
                                                        CURP__c, 
                                                        Fecha_de_nacimiento1__c, 
                                                        N_mero_de_tarjeta__c, 
                                                        Ultimos_4_d_gitos_de_tarjeta__c 
                                                FROM Account WHERE Fecha_de_nacimiento1__c =: dtFechaNacimiento AND Name LIKE : strLikeName ];

                System.debug('listaClientes:  ' + listaClientes);

                if( !listaClientes.isEmpty() ) {

                    List<Cliente> listClientesFormato = new List<Cliente>();

                    for(Account acc: listaClientes) {
                        Cliente clnt = new Cliente( String.valueOf(acc.Id), 
                                                    String.valueOf(acc.Name), 
                                                    String.valueOf(acc.LastName), 
                                                    String.valueOf(acc.FirstName), 
                                                    String.valueOf(acc.CreatedDate), 
                                                    String.valueOf(acc.PersonMobilePhone), 
                                                    String.valueOf(acc.PersonEmail), 
                                                    String.valueOf(acc.CURP__c), 
                                                    String.valueOf(acc.Fecha_de_nacimiento1__c), 
                                                    String.valueOf(acc.N_mero_de_tarjeta__c), 
                                                    String.valueOf(acc.Ultimos_4_d_gitos_de_tarjeta__c) );
                        listClientesFormato.add(clnt);
                    }

                    Clientes listaFinal = new Clientes(listClientesFormato);

                    response.responseBody = Blob.valueOf(JSON.serialize(listaFinal) );
                    ///response.responseBody = Blob.valueOf(JSON.serialize(listaClientes) );
                } else {

                    Error[] errores = new Error[]{ 
                        new Error('BAD_REQUEST', 'No se encontraron coincidencias')
                    };
                    response.responseBody = Blob.valueOf(JSON.serialize(errores) );
                    return;
                }                

            } else {

                response.statusCode = 404;
            }            

        } catch(Exception ex) {

            System.debug('LINEA:  ' + ex.getLineNumber() + '  ERROR:  ' + ex.getMessage() );

            Error[] errores = new Error[]{ 
                new Error('BAD_REQUEST', 'Revise los parametros de entrada')
            };
            response.responseBody = Blob.valueOf(JSON.serialize(errores) );
        }

    }    

    public class Clientes {
        public List<Cliente> clientes;
        public Clientes(List<Cliente> clientes){
            this.clientes = clientes;
        }
    }

    public class Cliente {
        public String id;
        public String name;
        public String lastName;
        public String firstName;
        public String createdDate;
        public String personMobilePhone;
        public String personEmail;
        public String curp;
        public String fechaDeNacimiento1;
        public String numeroDeTarjeta;
        public String ultimos4DigitosDeTarjeta;

        public Cliente(String id, string name, string lastName, string firstName, string createdDate, string personMobilePhone, string personEmail, string curp, string fechaDeNacimiento1, string numeroDeTarjeta, string ultimos4DigitosDeTarjeta){
            this.id = id;
            this.name = name;
            this.lastName = lastName;
            this.firstName = firstName;
            this.createdDate = createdDate;
            this.personMobilePhone = personMobilePhone;
            this.personEmail = personEmail;
            this.curp = curp;
            this.fechaDeNacimiento1 = fechaDeNacimiento1;
            this.numeroDeTarjeta = numeroDeTarjeta;
            this.ultimos4DigitosDeTarjeta = ultimos4DigitosDeTarjeta;
        }
    }

    public class Error {
        public String errorCode;
        public String message;
        public Error(String errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
}