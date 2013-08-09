cache = require('./cacheService')
_ = require 'lodash'
mapquestService = require('./mapquestService')
googleService = require('./googleService')

geocodeAddress = (query, cb) ->
  if query.length
    cache.get "GEOCODE:#{query}" , (error, value, extras) ->
      if not error and not value
        mapquestService.geocode query, (err, location) ->
          if err
            googleService.geocode query, (err, location) ->
              if err
                cb err, null
              else
                cache.setex "GEOCODE:#{query}", 2592000, JSON.stringify(location)
                cb null, location                          
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