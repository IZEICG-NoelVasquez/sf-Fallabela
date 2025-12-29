global class fetchUsuarioAclaraciones {
    @InvocableMethod (label='getUsuario' description='Regresa el id del usuario menos ocupado del equipo de aclaraciones' category= 'Case')
    public static List<id> getUsuario(){
        
        //Busco a los usuarios miembros de la queue
        List<GroupMember>lstUsuario=[SELECT UserOrGroupId from GroupMember where Group.Name = 'Aclaraciones'];
        Map<id, integer> numberCasesByUser= new Map<id, integer>();
        for(GroupMember member:lstUsuario){           
            numberCasesByUser.put(member.UserOrGroupId, 0);
        }
        
        //Traigo los casos abiertos que están atendiendo y los ordeno
        List<Case>lstCasos=[Select id, ownerId FROM Case WHERE OwnerId IN :numberCasesByUser.keySet() AND (Status!='Cerrado' OR Status!='Cerrado')];
        for(Case cas:lstCasos){
            numberCasesByUser.put(cas.OwnerId, numberCasesByUser.get(cas.OwnerId)+1);
        }
        System.debug(numberCasesByUser);
        //Busco al mas desocupado
        Map<Integer, List<id>> usersByCases= new Map<Integer, List<id>>();
        for(Id user: numberCasesByUser.keySet()){
            if(!usersByCases.containsKey(numberCasesByUser.get(user))){
                usersByCases.put(numberCasesByUser.get(user), new List<id>{user});
            }else{
                usersByCases.get(numberCasesByUser.get(user)).add(user);
            }
        }       
        
        List<Integer> lstNumeros=new List<Integer> (usersByCases.keySet());
        lstNumeros.sort();    
        id userid=usersByCases.get(lstNumeros[0])[0];        
        System.debug(usersByCases);       
        
        return new List<id>{userid};
        
    }

}