mongoose = require 'mongoose'
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  PostalCode : require('../models/postalCode').PostalCode
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

  buildSearchQuery : (params, cb) =>
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
      distance = params.maxDistance || 25
      if(params.ll)
        ll = params.ll.split(',')
        cb null, new SearchQuery().within(distance).miles().ofCoordinates(parseFloat(ll[0]), parseFloat(ll[1])).build()
      else if(params.near)
        if /^\d+$/.test(params.near)
          @PostalCode.findOne {'code':params.near}, {}, {}, (err,doc) ->    
            cb null, new SearchQuery().within(distance).miles().ofCoordinates(doc.geo.coordinates[0], doc.geo.coordinates[1]).build()
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              cb null, new SearchQuery().within(distance).miles().ofCoordinates(result.longitude, result.latitude).build()

module.exports = new BusinessController()