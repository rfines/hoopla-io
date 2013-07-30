mongoose = require 'mongoose'
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  postalCodeService : require('../services/postalCodeService')
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
      q = new SearchQuery().within(distance).miles()
      if(params.ll)
        ll = params.ll.split(',')
        cb null, q.ofCoordinates(parseFloat(ll[0]), parseFloat(ll[1])).build()
      else if(params.near)
        if /^\d+$/.test(params.near)
          @postalCodeService.get params.near, (err, doc) ->
            cb null, q.ofCoordinates(doc.geo.coordinates[0], doc.geo.coordinates[1]).build()
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              cb null, q.ofCoordinates(result.longitude, result.latitude).build()

module.exports = new BusinessController()