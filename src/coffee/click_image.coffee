$ ->
	$('.post img').each () ->
		$(this).on 'click', () ->
			window.open $(this).attr 'src'