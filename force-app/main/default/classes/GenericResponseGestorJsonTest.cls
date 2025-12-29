@IsTest
public class GenericResponseGestorJsonTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"code\": \"001\",'+
		'    \"message\": \"Petición aceptada\",'+
		'    \"data\": {'+
		'        \"command_id\": \"40394a76-7176-4537-ada2-efd068919da6\"'+
		'    }'+
		'}';
        // Perform test
        Test.startTest();
		GenericResponseGestorJson obj = GenericResponseGestorJson.parse(json);
        Test.stopTest();
        // Verify 
		System.assert(obj != null);
		
	}
	
}