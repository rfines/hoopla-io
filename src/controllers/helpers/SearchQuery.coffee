
class SearchQuery
  
  ofLongitude: (@longitude) ->
    @

  ofLatitude: (@latitude) ->
    @

  ofCoordinates: (@longitude, @latitude) ->
    @

  within: (@distance) ->
    @

  inCategories: (@categories) ->
    @

  withCost: (@cost) ->
    @

  inSubCategories: (@subCategories) ->
    @

  build : ->
    query = {}
    d = parseFloat(@distance)
    query.geo = 
      $near:
          $geometry : 
            type : "Point"
            coordinates : [ @longitude, @latitude]
          $maxDistance : d
    if @categories
      query.categories = @categories
    if @subCategories
      query.subCategories = @subCategories
    if @cost
      query.cost = @cost
    return query 

module.exports = SearchQuery