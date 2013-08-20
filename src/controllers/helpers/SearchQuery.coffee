
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
  atBusiness:(@businessId) ->
    @
  build : ->
    query = {}
    d = parseFloat(@distance)
    query['location.geo'] = 
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
    if @businessId
      query.business =@businessId
    return query 

  buildFromParams: (params) ->
    distance = params.radius || 40234
    ll = params.ll.split(',')
    q = new SearchQuery().within(distance)
    q.ofCoordinates(parseFloat(ll[0]), parseFloat(ll[1])) 
    if params.tags
      q.withTags(params.tags.split(','))
    if params.maxCost
      q.withCost(parseFloat(params.maxCost))
    if params.start and params.end
      betweenDates = {start:params.start, end: params.end}
    else if params.start and not params.end
      betweenDates = {start:params.start}
    
    q.betweenDates(betweenDates.start,betweenDates.end) if betweenDates

    return q.build()

module.exports = SearchQuery