$(document).ready(function () {
	// Dodawanie ofert
	$('#job_description').markItUp(mySettings, { previewAutoRefresh:false });
	$('.flash .dismiss').click(function () {
		$(this).parent('.flash').hide();
		return false;
	});
	

});
