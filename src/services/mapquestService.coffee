CONFIG = require 'config'
mapquest = require 'mapquest'
_ = require('underscore')
key = CONFIG.openMaps.key


geocode = (query, cb) ->
  mapquest.geocode key, query, (err, locations) ->
    if err
      cb err, null
    else  
      if locations.length is 0
        cb {status : 'NO_MATCH', message : 'No matching locations were found.'}
      else
        l = bestLocation(locations)
        cb null, {latitude : parseFloat(l.latLng.lat), longitude: parseFloat(l.latLng.lng)}

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
  geocode : geocode     
  bestLocation : bestLocation