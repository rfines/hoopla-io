_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')


class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  builder : require('./helpers/QueryComponentBuilder')
  searchService : require('../services/searchService')
  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    databaseResults = (cb) =>
      @searchDatabase(req, cb)
    searchIndexResults = (cb) =>
      @searchIndex(req, cb)
    datasources = [databaseResults]
    if req.params.keyword
      datasources.push searchIndexResults
    async.parallel datasources, (err, results) ->
      if results[1]
        out = _.filter results[0], (item) ->
          _.contains results[1], item._id.toString()
      else 
        out = results[0]
      res.send out
      next()

  searchDatabase : (req, cb) =>
    @builder.buildSearchQuery req.params, (err, centerCoordinates,  result) =>
      q = @model.find(result, {}, {lean:true})
      q.populate('media')
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
    @searchService.findBusinesses req.params.keyword, (err, data) ->
      cb null, _.pluck(data, '_id')

module.exports = new BusinessController()