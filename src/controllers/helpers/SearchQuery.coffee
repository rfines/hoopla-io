
class SearchQuery
  
  ofLongitude: (@longitude) ->
    @

  ofLatitude: (@latitude) ->
    @

  ofCoordinates: (@longitude, @latitude) ->
    @

  within: (@distance) ->
    @

  withTags: (@tags) ->
    @

  withCost: (@maxCost) ->
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
    if @tags
      query.tags = 
        $in: @tags
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