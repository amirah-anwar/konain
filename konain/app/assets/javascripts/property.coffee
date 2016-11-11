$(document).ready ->

  show_property_sub_types = (clickable) ->
    type = clickable.val()
    if type != undefined
      $.ajax
        type: 'GET'
        url: '/fetch_property_sub_type?property_type=' + type

  show_property_features = (clickable) ->
    type = clickable.val()
    if type != undefined
      $.ajax
        type: 'GET'
        url: '/fetch_property_features?property_type=' + type

  trigger_sub_types = ->
    $('.property-type-options input[type=\'radio\']').click ->
      show_property_sub_types $(this)

  trigger_features = ->
    $('.property-type-options input[type=\'radio\']').click ->
      show_property_features $(this)

  show_property_types = (clickable) ->
    category = clickable.val()
    if category != undefined
      $.ajax
        type: 'GET'
        url: '/fetch_property_type?category=' + category
        success: (data) ->
          trigger_sub_types()
          trigger_features()

  trigger_sub_types()
  trigger_features()

  $('.radio-container input[type=\'radio\']').click ->
    show_property_types $(this)
