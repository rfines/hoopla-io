
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

  withCost: (@maxCost) ->
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
      query.categories = 
        $in: @categories
    if @subCategories
      query.subCategories = 
        $in: @subCategories
    if @maxCost
      query.cost = 
        $lte: @maxCost
    return query 

module.exports = SearchQuery