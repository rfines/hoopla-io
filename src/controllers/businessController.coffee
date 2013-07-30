mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  PostalCode : require('../models/postalCode').PostalCode
  Conversion : require('../services/unitConversionService')
  geoCoder : require('../services/geocodingMQService')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @buildSearchQuery req.params, (err, result) =>
      @model.find result , (err, data) ->
        res.send data
        next()

  validateSearchQuery : (params) ->
    if not params.ll and not params.near
      return {'message': 'The request parameters do not contain a near field or ll field.'}

  getSearchRadius : (params) ->
    if(params.maxDistance)
      return @Conversion.milesToMeters(parseFloat(params.maxDistance))
    else
      return @Conversion.milesToMeters(25)

  withGeoQuery = (q, longitude, latitude, distance) ->
    q.geo =
      $near:
        $geometry : 
          type : "Point"
          coordinates : [ longitude,latitude]
        $maxDistance : distance
    q

  buildSearchQuery : (params, cb) =>
    query = {}
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
      distance = @getSearchRadius(params)
      if(params.ll)
        ll = params.ll.split(',')
        cb null, withGeoQuery(query, parseFloat(ll[0]), parseFloat(ll[1]), distance)
      else if(params.near)
        if /^\d+$/.test(params.near)
          @PostalCode.findOne {'code':params.near}, {}, {}, (err,doc) ->    
            cb null, withGeoQuery(query, doc.geo.coordinates[0], doc.geo.coordinates[1], distance)
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              cb null, withGeoQuery(query, result.longitude, result.latitude, distance)            

module.exports = new BusinessController()