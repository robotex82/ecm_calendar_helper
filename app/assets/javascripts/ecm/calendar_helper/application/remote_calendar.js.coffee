$ ->
  $('[data-calendar]').each ->
    url = $(this).attr('data-calendar')
    $(this).load(url)