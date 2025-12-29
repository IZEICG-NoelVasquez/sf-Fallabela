public with sharing class ObjectDescriberUtil {

	public static Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

	public static String getSObjectFieldsString (String sObjName) {

		Map <String, Schema.SObjectField> fieldMap = getFieldMap(sObjName);

		String queryFields = '';

		for (Schema.SObjectField sfield : fieldMap.Values()) {
			
			schema.describefieldresult dfield = sfield.getDescribe();

			if (dfield.isAccessible()) {

				queryFields +=  dfield.getname() + ',';

			}

		}

		queryFields = queryFields.removeEnd(',');

		return queryFields;
	}

	public static Map <String, Schema.SObjectField> getFieldMap (String sObjName) {

		return schemaMap.get(sObjName).getDescribe().fields.getMap();

	}
}