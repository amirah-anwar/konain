bind_project_map = ->
  console.log gon.project_location
  if gon.project_location.lat
    console.log gon.project_location.lat

    latlng = new (google.maps.LatLng)(gon.project_location.lat, gon.project_location.lng)
    map = new (google.maps.Map)(document.getElementById('project-map'),
      zoom: 15
      center: latlng
      scrollwheel: false)
    marker = new (google.maps.Marker)(
      position: latlng
      map: map)

(($) ->
  window.ProjectMap || (window.ProjectMap = {})

  ProjectMap.init = ->
    init_controls()

  init_controls = ->
    bind_project_map()
).call(this)
