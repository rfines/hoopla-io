mapquest = require 'mapquest'
cache = require('../services/cacheService')
geocodeAddress = (query, cb) ->
  if query.length
    q = decodeURIComponent(query)
    cache.get "GEOCODE:#{q}" , (error, value, extras) ->
      if not error and not value
        mapquest.geocode q, (err, location) ->
          if err
            console.log err
            cb err, null
          else  
            result = {latitude : parseFloat(location.latLng.lat), longitude: parseFloat(location.latLng.lng)}
            cache.setex "GEOCODE:#{q}", 2592000, JSON.stringify(result)
            cb null, result
      else if not error and value
        cb null, JSON.parse(value.toString())
      else if error
        console.log error

module.exports = 
  geocodeAddress: geocodeAddress
