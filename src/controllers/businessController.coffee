mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  postalCodeService : require('../services/postalCodeService')
  geoCoder : require('../services/geocodingMQService')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @buildSearchQuery req.params, (err, centerCoordinates,  result) =>
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

  validateSearchQuery : (params) ->
    if not params.ll and not params.near
      return {'message': 'The request parameters do not contain a near field or ll field.'}

  buildSearchQuery : (params, cb) =>
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
      distance = params.radius || 40234
      q = new SearchQuery().within(distance)
      if(params.ll)
        ll = params.ll.split(',')
        centerCoordinates = {latitude : parseFloat(ll[1]), longitude: parseFloat(ll[0])}
        cb null, centerCoordinates, q.ofCoordinates(parseFloat(ll[0]), parseFloat(ll[1])).build()
      else if(params.near)
        if /^\d+$/.test(params.near)
          @postalCodeService.get params.near, (err, doc) ->
            centerCoordinates = {latitude : doc.geo.coordinates[1], longitude: doc.geo.coordinates[0]}
            cb null, centerCoordinates, q.ofCoordinates(doc.geo.coordinates[0], doc.geo.coordinates[1]).build()
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              centerCoordinates = {longitude : result.longitude, latitude : result.latitude}
              cb null, centerCoordinates, q.ofCoordinates(result.longitude, result.latitude).build()

module.exports = new BusinessController()