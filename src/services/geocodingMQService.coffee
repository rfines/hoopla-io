CONFIG = require 'config'
mapquest = require 'mapquest'
cache = require('../services/cacheService')
key = CONFIG.openMaps.key
_ = require('underscore')

geocodeAddress = (query, cb) ->
  if query.length
    q = decodeURIComponent(query)
    cache.get "GEOCODE:#{encodeURIComponent(q)}" , (error, value, extras) ->
      if not error and not value
        mapquest.geocode key, query, (err, locations) ->
          if err
            console.log err
            cb err, null
          else  
            l = bestLocation(locations)
            result = {latitude : parseFloat(l.latLng.lat), longitude: parseFloat(l.latLng.lng)}
            cache.setex "GEOCODE:#{q}", 2592000, JSON.stringify(result)
            cb null, result
      else if not error and value
        cb null, JSON.parse(value.toString())
      else if error
        console.log error

bestLocation = (locations) ->
  if not locations or locations.length == 0
    return {}
  if locations and locations.length == 1
    return locations[0]
  accuracy = ['P1', 'L1', 'I1', 'B3','B2','B1','A5','A4','A3','A2','A1', 'Z4','Z3','Z2','Z1']
  for x in accuracy
    l = _.find locations, (item) ->
      item.geocodeQualityCode[0..1] is x
    break if l
  return l
  if not l
    return locations[0]

module.exports = 
  geocodeAddress: geocodeAddress
  bestLocation : bestLocation