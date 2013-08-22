
$ ->
	$('code').each () ->
		if $(this).parent('p').first().html() == "<code>" + $(this).html() + "</code>"
			$(this).addClass 'code-block'