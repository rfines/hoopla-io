
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

  betweenDates: (@start, @end) ->
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
      query.maxCost = 
        $lte: @maxCost
    if @start and @end
      query.occurrences=
        $gte: @start,$lte:@end
    else if @start
      query.occurrences = 
        $gte:@start

    return query 

module.exports = SearchQuery