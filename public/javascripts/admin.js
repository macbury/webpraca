$(document).ready(function () {
	// Strona z kategoriami
	$("#categories").sortable({ 
		handle: '.handle',
		stop: function(event, ui){
			var categories = $("#categories").sortable("serialize");
			$("#categories li").removeClass('alt');
			$("#categories li:odd").addClass('alt');
			$('.loader').show();
			$.ajax({
				type: "POST",
				url: "/admin/categories/reorder",
				data: categories,
				success: function(){
					$('.loader').hide();
				},
			});
		},
	});
	
	// Strona edycji stron
	
	$('#page_body').markItUp(mySettings, { previewAutoRefresh:false });
});