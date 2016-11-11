bind_property_map = ->
  if gon.property_location.lat
    latlng = new (google.maps.LatLng)(gon.property_location.lat, gon.property_location.lng)
    map = new (google.maps.Map)(document.getElementById('property_map'),
        zoom: 17
        center: latlng
        scrollwheel: false)
    marker = new (google.maps.Marker)(
        position: latlng
        map: map)

    contentString1 = '<div id="content">' + '<div id="siteNotice">' + '</div>' + '<div id="bodyContent">'
    contentString2 = "<p><b>#{gon.company_name}: #{gon.address}</br>#{gon.country}</b></p>" + '</div>' + '</div>'
    contentString = [contentString1, contentString2].join("")

    infowindow = new (google.maps.InfoWindow)(
        content: contentString)

    google.maps.event.addListener marker, 'click', ->
      infowindow.open map, marker

    infowindow.open map, marker

(($) ->
 window.PropertyMap || (window.PropertyMap = {})

 PropertyMap.init = ->
   init_controls()

 init_controls = ->
   bind_property_map()
).call(this)
