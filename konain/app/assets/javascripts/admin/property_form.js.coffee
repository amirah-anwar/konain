$(document).ready ->

  fetch_sub_types = (type, sub_type)->
    $.ajax
      type: 'GET'
      url: '/admin/fetch_sub_types?property_type=' + type + '&fetch_sub_type=' + sub_type

  fetch_features = (type, features)->
    $.ajax
      type: 'GET'
      url: '/admin/fetch_features?property_type=' + type + '&fetch_features=' + features

  show_selected_type = ->
    property = gon.property
    if property != undefined
      category = property.category
      type = property.property_type
      if category != undefined
        $.ajax
          type: 'GET'
          url: '/admin/fetch_types?category=' + category + '&fetch_type=' + type

  show_selected_sub_type = ->
    property = gon.property
    if property != undefined
      type = property.property_type
      sub_type = property.property_sub_type
      if type != undefined
        fetch_sub_types(type, sub_type)

  show_selected_features = ->
    property = gon.property
    if property != undefined
      type = property.property_type
      features = property.property_features
      if type != undefined
        fetch_features(type, features)

  show_property_sub_types = (clickable) ->
    type = clickable.val()
    if type != undefined
      fetch_sub_types(type, "")

  show_property_features = (clickable) ->
    type = clickable.val()
    if type != undefined
      fetch_features(type, "")

  trigger_sub_types = ->
    first_type = $("#admin-property-type option:first").val()
    fetch_sub_types(first_type, "")

    $("#admin-property-type").change ->
      show_property_sub_types $(this)

  trigger_features = ->
    first_type = $("#admin-property-type option:first").val()
    fetch_features(first_type, "")

    $("#admin-property-type").change ->
      show_property_features $(this)

  show_property_types = (clickable) ->
    category = clickable.val()
    if category != undefined && category.length > 0
      $.ajax
        type: 'GET'
        url: '/admin/fetch_types?category=' + category
        success: (data) ->
          trigger_sub_types()
          trigger_features()

  get_sub_projects = (selectable, fetch_type) ->
    project_id = selectable.find('option:selected').val()
    url =  '/projects/' + project_id + '/fetch_sub_projects/'
    url = url + '?fetch_type=' + fetch_type if fetch_type
    $.ajax
      type: 'GET'
      url: url

  get_admin_property_sub_projects = (selectable) ->
    project_id = selectable.find('option:selected').val()
    $.ajax
      type: 'GET'
      url: '/admin/fetch_sub_projects/' + project_id

  show_selected_type()
  show_selected_sub_type()
  show_selected_features()

  $("#admin-property-category").change ->
    show_property_types $(this)

  $("#admin-property-type").change ->
    show_property_sub_types $(this)
    show_property_features $(this)

  $('.admin-property-project').change ->
    get_admin_property_sub_projects($(this));

  $('#side_bar_prop_id').change ->
    get_sub_projects($(this), 'side_bar')

  $('#property_project_id').change ->
    get_sub_projects($(this))
