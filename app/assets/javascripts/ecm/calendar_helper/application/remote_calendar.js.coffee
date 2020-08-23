$ ->
  $('[data-calendar]').each ->
    url = $(this).attr('data-calendar')
    $.ajax(url: url).done (html) ->
      $(this).append html