$(document).ready ->

  show_projects = (clickable, type) ->
    value = clickable.val()
    if value != undefined
      $.ajax
        type: 'GET'
        url: '/projects/fetch_project?city=' + value + '&fetch_type=' + type

  $('.city-options select').change ->
    show_projects $(this), "side_bar"

  $('.city-dropdown select').change ->
    show_projects $(this), "form"

