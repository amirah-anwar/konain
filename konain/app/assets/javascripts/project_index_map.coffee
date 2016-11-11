bind_project_map = (data)->
  lat = data[0]
  lng = data[1]
  id = data[2]
  latlng = new (google.maps.LatLng)(lat, lng)
  map = new (google.maps.Map)(document.getElementById("project-map-canvas-#{id}"),
    zoom: 15
    center: latlng
    scrollwheel: false)
  marker = new (google.maps.Marker)(
    position: latlng
    map: map)

  $("#myMapModal-#{id}").on 'shown', (e) ->
    google.maps.event.trigger map, 'resize'
    map.setCenter latlng

initialize_map = ->
  for data in gon.array_of_projects_fields
    bind_project_map(data)

(($) ->
  window.ProjectModalMap || (window.ProjectModalMap = {})

  ProjectModalMap.init = ->
    init_controls()

  init_controls = ->
    initialize_map()
).call(this)
