
# please don't leave my website!
# hack the links that bring out of the domain to open in a new tab
$ ->
  $('a').each ()->
    href = $(this).attr "href"
    if href.indexOf(window.location.origin) == -1 && href[0] != "/"
      $(this).attr 'target', '_blank'