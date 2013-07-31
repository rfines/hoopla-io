class SearchQuery

  ofLongitude: (@longitude) ->
    @

  ofLatitude: (@latitude) ->
    @

  ofCoordinates: (@longitude, @latitude) ->
    @

  within: (@distance) ->
    @

<<<<<<< HEAD
  build : ->
    d = parseFloat(@distance)
    return {
      geo:
=======
  miles: () ->
    @convertToMeters = true
    @

  meters: () ->
    @convertToMeters = false

  inCategories: (@categories) ->
    @

  withKeyword: (@keyword) ->
    @

  withCost: (@cost) ->
    @

  inSubCategories: (@subCategories) ->
    @

  build : ->
    query = {}
    
    if @distance and @latitude and @longitude
      if @convertToMeters
        d = conversion.milesToMeters(parseFloat(@distance))
      else 
        d = parseFloat(@distance)
      query.geo = 
>>>>>>> More searching
        $near:
            $geometry : 
              type : "Point"
              coordinates : [ @longitude, @latitude]
            $maxDistance : d
    if @categories
      query.categories = @categories
    if @subCategories
      query.subCategories = @subCategories
    if @keyword
      query.keyword = @keyword
    if @cost
      query.cost = @cost
    return query 

module.exports = SearchQuery