conversion = require('../../services/unitConversionService')

class SearchQuery
  convertToMeters : false
  
  ofLongitude: (@longitude) ->
    @

  ofLatitude: (@latitude) ->
    @

  ofCoordinates: (@longitude, @latitude) ->
    @

  within: (@distance) ->
    @

  miles: () ->
    @convertToMeters = true
    @

  meters: () ->
    @convertToMeters = false

  build : ->
    if @convertToMeters
      d = conversion.milesToMeters(parseFloat(@distance))
    else 
      d = parseFloat(@distance)
    return {
      geo:
        $near:
          $geometry : 
            type : "Point"
            coordinates : [ @longitude, @latitude]
          $maxDistance : d
    }

module.exports = SearchQuery