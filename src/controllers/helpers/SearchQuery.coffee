
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

  buildFromParams: (params) ->
    ll = params.ll.split(',')
    coordinates = {latitude : parseFloat(ll[1]), longitude: parseFloat(ll[0])}      
    if params.tags
      tags = params.tags.split(',')
    if params.maxCost
      maxCost = parseFloat(params.maxCost)
    if params.start and params.end
      betweenDates = {start:params.start, end: params.end}
    else if params.start and not params.end
      betweenDates = {start:params.start}
    distance = params.radius || 40234
    q = new SearchQuery().within(distance)
    q.ofCoordinates(coordinates.longitude, coordinates.latitude) 
    q.withTags(tags) if tags?.length
    q.withCost(maxCost) if maxCost
    q.betweenDates(betweenDates.start,betweenDates.end) if betweenDates
    return q.build()

module.exports = SearchQuery