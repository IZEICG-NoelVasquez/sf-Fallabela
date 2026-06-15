({
	gotoRelatedList : function (listName, parentRecordId) {

	    var relatedListEvent = $A.get("e.force:navigateToRelatedList");

	    relatedListEvent.setParams({
	        "relatedListId": listName,
	        "parentRecordId": parentRecordId
	    });

	    relatedListEvent.fire();
	}
})