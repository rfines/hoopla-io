CONFIG = require 'config'
#key = CONFIG.googleGeocode.key
_ = require 'lodash'
request = require("request")

geocode = (query, cb) ->
  url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{query}&sensor=false"
  request url, (error, response, body) ->
    if error
      cb error
    else if response.statusCode is not 200
      cb {status : 'GEOCODE_FAILED'}, null
    else
      res = JSON.parse(body)
      if res.results and res.results.length == 0
        cb {status : 'NO_MATCH', message : 'No matching locations were found.'}
      else
        l = bestLocation(res.results)
        cb null, {latitude : l.geometry.location.lat, longitude: l.geometry.location.lng}

bestLocation = (locations) ->
  if not locations or locations.length == 0
    return {}
  else
    return locations[0]

module.exports =
  geocode : geocode     
  bestLocation : bestLocation