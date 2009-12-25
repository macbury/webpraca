$(document).ajaxSend(function(event, request, settings) { 
	if (typeof(window._token) == "undefined") return;
	
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window._token);
});

function flash(type, message) {
	$('.wrapper').prepend('<div class="flash flash_'+type+'">'+message+'</div>');
	$('.notice, .error').hover(function () {
		$(this).slideUp();
	});
	setTimeout(function () {
		$('.flash').slideUp();
	}, 5000);
}

$.fn.extend({
	show_errors: function(errors_hash) {
		$(this).find('.inline-errors').remove();
		$.each(errors_hash, function (input_id, errors) {
			var error = $('<p>');
			error.addClass('inline-errors')
					 .text(errors.join(', '));

			$('#'+input_id).append(error);
		});
	},
});