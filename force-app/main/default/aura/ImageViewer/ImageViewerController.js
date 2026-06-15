({
	doInit : function(component, event, helper) {

		var gallery = component.find("gallery").getElement();

		var viewer = new Viewer(gallery, {
			
			url: 'data-original',
			toolbar: {
				'zoom-in': true,
				'zoom-out': true,
				'rotate-left': true,
				'rotate-right': true,
				'reset': true,
			},
		});
	}
})