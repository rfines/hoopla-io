mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')

class EventController  extends RestfulController
  model : require('../models/event').Event
  builder : require('./helpers/QueryComponentBuilder')
  
  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @builder.buildSearchQuery req.params, (err, centerCoordinates,  result) =>
      @model.find result, {}, {lean:true}, (err, data) ->
        calcDistance = (item, cb) ->
          eventCoordinates = 
            longitude: item.geo.coordinates[0]
            latitude: item.geo.coordinates[1]
          item.distance = geolib.getDistance centerCoordinates, eventCoordinates
          cb null
        async.each data, calcDistance, (err) ->
          res.send data
          next()


module.exports = new EventController()