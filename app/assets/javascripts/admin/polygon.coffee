class Polygon
  constructor: () ->
    @map = L.mapbox.map('map', '/assets/nls_london.json',
      animate: true
      minZoom: 16
      maxZoom: 21
    )


    p = @
    @map.on 'load', () ->
      p.showPolygon()
      p.showFlags()

  showPolygon: () =>
    data = $('#polydata').data("map")

    return if !data or data.features.length==0

    m = @map

    # console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#b00'
        weight: 5
        opacity: 1
        dashArray: '1,16'
        fill: false
    )

    bounds = json.getBounds()

    # console.log bounds

    json.addTo(m)

    m.fitBounds(bounds)

  showFlags: () =>
    data = $('#polydata').data("flags")

    return if !data or data.features.length==0

    m = @map

    # console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#ff0'
        weight: 1
        opacity: 1
        # dashArray: '1,16'
        fill: false
      onEachFeature: (feature, layer) ->
        str = ""
        str += "User: <a href='/users/#{feature.properties.user_id}'>" + feature.properties.user_id + "</a>" if feature.properties?.user_id
        str += "User: " + feature.properties.session_id + "</a>" if feature.properties?.session_id
        str += "<br />" + feature.properties.flag_value if feature.properties?.flag_value
        layer.bindPopup(str)
    )

    bounds = json.getBounds()
    json.addTo(m)
    # m.fitBounds(bounds)

$ ->
  window._p = new Polygon
