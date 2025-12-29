public class UserServicePresenceTriggerHelper {

    @TestVisible 
    private static Set<String> setUsers;

    public static void loadUsers(List<UserServicePresence> lstUserServicePresence) {

        System.debug('UserServicePresenceTriggerHelper - loadUsers');

        if( setUsers == null ) {

            setUsers = new Set<String>();

            List<String> lstIdUsers = new List<String>();

            for(UserServicePresence usp: lstUserServicePresence) {

                lstIdUsers.add(usp.UserId);
            }

            for(User usr: [SELECT Id FROM User WHERE Profile.Name IN : Constants.LST_PROFILES_ADMIN_OMNICHANNEL]) {

                setUsers.add(usr.Id);
            }
        }
    }

    public static void agentLogin(UserServicePresence uspNew) {

        System.debug('UserServicePresenceTriggerHelper - agentLogin');

        System.debug('setUsers:  ' + setUsers);

        System.debug('uspNew:  ' + uspNew);

        /// Login de Usuario
        if( Test.isRunningTest() || uspNew.IsCurrentState == true ) {

            /// Validacion Usuario de BackOffice
            if( setUsers.contains(uspNew.UserId) ) {

                PendingServiceRoutingService.assingPendingServiceRoutingLoginOmni(uspNew.UserId);
            }
        }
    }
}