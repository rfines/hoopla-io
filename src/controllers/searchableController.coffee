_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')


class SearchableController extends RestfulController
  builder : require('./helpers/QueryComponentBuilder')
  searchService : require('../services/searchService')
  populate: ['media']

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @hooks.search.pre req, res, (err) =>
      console.log err if err
      @validateRequest req, (error) =>
        if error.code
          console.log error
          res.body = error
          res.status = error.code
          res.send()

          next()
        else
          console.log "Validation successful"
          console.log @hooks
          databaseResults = (cb) =>
            @searchDatabase(req, cb)
          searchIndexResults = (cb) =>
            @searchIndex(req, cb)
          datasources = [databaseResults]
          if req.params.keyword
            datasources.push searchIndexResults
          async.parallel datasources, (err, results) =>
            if results[1]
              out = _.filter results[0], (item) ->
                _.contains results[1], item._id.toString()
            else 
              out = results[0]
            @hooks.search.post out, res, (error, data) =>
              console.log "post executed"
              if error
                console.log error
                res.status = error.code
                res.send error.message
                next()
              else
                res.send data
                next()
              

  searchDatabase : (req, cb) =>
    @builder.buildSearchQuery req.params, (err, centerCoordinates,  result) => 
      q = @model.find(result, {}, {lean:true})
      q.populate(@populate.join(' '))
      if req.params.skip
        q.skip req.params.skip
      if req.params.limit
        q.limit req.params.limit
      q.exec (err, data) ->   
        calcDistance = (item, cb) ->         
          businessCoordinates = 
            longitude: item.geo.coordinates[0]
            latitude: item.geo.coordinates[1]
          item.distance = geolib.getDistance centerCoordinates, businessCoordinates
          cb null
        async.each data, calcDistance, (err) ->
          
          cb err, data          

  searchIndex : (req, cb) =>
    @searchService.find @type,req.params.keyword, (err, data) ->
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


module.exports = SearchableController