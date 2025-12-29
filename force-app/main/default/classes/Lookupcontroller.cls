public with sharing class Lookupcontroller {

	@AuraEnabled
	public static List<sObject> querySalesforceRecord(String queryString) {
		
		return Database.query(queryString);

	}

}