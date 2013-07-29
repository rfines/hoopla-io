mapquest = require 'mapquest'

geocodeAddress = (query, cb) ->
  if query.length
    q = decodeURIComponent(query)
    mapquest.geocode q, (err, location) ->
      if err
        cb err, null
      else  
        cb null, {latitude : parseFloat(location.latLng.lat), longitude: parseFloat(location.latLng.lng)}

module.exports = 
  geocodeAddress: geocodeAddress
