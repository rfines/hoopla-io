service = require('../../src/services/geocodingMQService')

describe "Geocoding using MapQuest Service", ->
  ###
  it "Should convert a city and state to a latitude/longitude pair", (done) ->
    service.geocodeAddress 'Kansas City, MO' , (err, result) ->
      result.should.equal {latitude: 39.084469, longitude: -94.56303}
    done()
  ###
