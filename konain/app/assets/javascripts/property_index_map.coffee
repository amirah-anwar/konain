bind_property_map = (data)->
  lat = data[0]
  lng = data[1]
  id = data[2]
  latlng = new (google.maps.LatLng)(lat, lng)
  map = new (google.maps.Map)(document.getElementById("map-canvas-#{id}"),
      zoom: 15
      center: latlng
      scrollwheel: false)
  marker = new (google.maps.Marker)(
      position: latlng
      map: map)

  $("#myMapModal-#{id}").on 'shown', (e) ->
      google.maps.event.trigger map, 'resize'
      map.setCenter latlng

initialize_map = (property_fields_array) ->
  for data in property_fields_array
    bind_property_map(data)

(($) ->
 window.ModalMap || (window.ModalMap = {})

 ModalMap.init = (property_fields_array) ->
   init_controls(property_fields_array)

 init_controls = (property_fields_array) ->
   initialize_map(property_fields_array)
).call(this)
