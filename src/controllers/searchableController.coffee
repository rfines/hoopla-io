_ = require 'lodash'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
imageManipulation = require('./helpers/imageManipulation')

class SearchableController extends RestfulController
  searchService : require('../services/searchService')
  populate: ['media']
  hooks: require('./hooks/restfulHooks')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @hooks.search.pre
      req : req
      res : res
      success: () =>
        @validateRequest req, (error) =>
          if error.code
            res.send error.code, error
            next()
          else
            databaseResults = (cb) =>
              @searchDatabase(req, cb)
            searchIndexResults = (cb) =>
              @searchIndex(req, cb)
            datasources = [databaseResults]
            if req.params.keyword
              datasources.push searchIndexResults
            async.parallel datasources, (err, results) =>
              out = @mergeSearches(results)
              out = @rewriteImageUrl req, out if req.params.height and req.params.width
              res.body = out
              @hooks.search.post 
                req : req
                res : res
                success : =>
                  res.send 200, res.body
                  next()
                error : =>
                  res.status = error.code
                  res.send error.message
                  next()


  mergeSearches: (results) ->
    if results[1]
      out = _.filter results[0], (item) ->
        _.contains results[1], item._id.toString()
    else 
      out = results[0]                
    return out
                  

  searchDatabase : (req, cb) =>
    ll = req.params.ll.split(',')
    centerCoordinates = {latitude : parseFloat(ll[1]), longitude: parseFloat(ll[0])}  
    criteria = new SearchQuery().buildFromParams(req.params)
    q = @model.find(criteria, @fields, {lean:true})
    q.populate(@populate.join(' '))
    q.sort(@sort) if @sort
    q.skip(req.params.skip) if req.params.skip
    q.limit(req.params.limit) if req.params.limit
    q.exec (err, data) ->   
      calcDistance = (item, cb) ->         
        businessCoordinates = 
          longitude: item.location.geo.coordinates[0]
          latitude: item.location.geo.coordinates[1]
        item.distance = geolib.getDistance centerCoordinates, businessCoordinates
        cb null
      async.each data, calcDistance, (err) ->
        cb err, data          

  searchIndex : (req, cb) =>
    @searchService.find @type, req.params.keyword, (err, data) ->
      cb null, _.pluck(data, '_id')

  validateRequest : (req, cb) =>
    errors = {}   
    if req.params
      if not req.params.ll and not req.params.near
        errors = {code:400, message: "A 'NEAR' or 'LL' parameter is required."}
      if req.params.keyword  
        if req.params.skip
          delete req.params['skip']
        if req.params.limit
          delete req.params['limit']
    else
      errors = {code:400, message: "No parameters received. A 'NEAR' or 'LL' parameter is required."} 
    cb errors

  rewriteImageUrl : (req, originalList) =>
    return _.map originalList, (item) ->
      if item.media[0]?.url
        item.media[0].url = imageManipulation.resize(req.params.width, req.params.height, item.media[0].url)
      return item

module.exports = SearchableController