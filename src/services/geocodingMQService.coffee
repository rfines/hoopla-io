mapquest = require 'mapquest'
cache = require('../services/cacheService')
geocodeAddress = (query, cb) ->
  if query.length
    q = decodeURIComponent(query)
    console.log "trying to get #{q} from cache"
    cache.get "GEOCODE:#{q}" , (error, value, extras) ->
      if not error and not value
        mapquest.geocode q, (err, location) ->
          if err
            console.log err
            cb err, null
          else  
            console.log "#{q} not cached"
            result = {latitude : parseFloat(location.latLng.lat), longitude: parseFloat(location.latLng.lng)}
            cache.set "GEOCODE:#{q}", JSON.stringify(result)
            cb null, result
      else if not error and value
        console.log "#{q} cached"
        cb null, JSON.parse(value.toString())
      else if error
        console.log error

module.exports = 
  geocodeAddress: geocodeAddress
