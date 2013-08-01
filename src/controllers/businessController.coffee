mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')


class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  builder : require('./helpers/QueryComponentBuilder')
  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @builder.buildSearchQuery req.params, (err, centerCoordinates,  result) =>
      @model.find result, {}, {lean:true}, (err, data) ->
        calcDistance = (item, cb) ->
          businessCoordinates = 
            longitude: item.geo.coordinates[0]
            latitude: item.geo.coordinates[1]
          item.distance = geolib.getDistance centerCoordinates, businessCoordinates
          cb null
        async.each data, calcDistance, (err) ->
          res.send data
          next()

  
  
module.exports = new BusinessController()