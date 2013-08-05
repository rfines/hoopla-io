cache = require('./cacheService')
_ = require('underscore')
mapquestService = require('./mapquestService')

geocodeAddress = (query, cb) ->
  if query.length
    cache.get "GEOCODE:#{query}" , (error, value, extras) ->
      if not error and not value
        mapquestService.geocode query, (err, location) ->
          if err
            if err.status and err.status is 'NO_MATCH'
              console.log 'no match found'
            cb err, null
          else  
            cache.setex "GEOCODE:#{query}", 2592000, JSON.stringify(location)
            cb null, location            
      else if not error and value
        cb null, JSON.parse(value.toString())
  else
    cb {message : 'query is required'}, null

module.exports = 
  geocodeAddress: geocodeAddress
  mapquestService : mapquestService