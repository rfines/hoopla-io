mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class BusinessController extends RestfulController
  
  Model : require('../models/business').Business
  PostalCode : require('../models/postalCode').PostalCode
  Conversion : require('../services/unitConversionService')
  Mapquest : require('../services/geocodingMQService')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @buildSearchQuery req.params, (err, result) =>
      @Model.find result , (err, data) ->
        res.send data
        next()

  buildSearchQuery : (params, cb) =>
    if not params.ll and not params.near
      err = {'message': 'The request parameters do not contain a near field or ll field.'}
      cb err, null
    else
      distance = @Conversion.milesToMeters(25)
      if(params.maxDistance)
        distance = @Conversion.milesToMeters(parseInt(params.maxDistance))
      if(params.ll)
        ll = params.ll.split(',')
        longitude = parseFloat(ll[0])
        latitude = parseFloat(ll[1])
        cb null, {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ longitude,latitude]},$maxDistance : distance}}}
      else if(params.near)
        #geocode the address here
        isnum = /^\d+$/.test(params.near);
        if(isnum)
          @PostalCode.findOne {'code':params.near}, {}, {}, (err,doc) ->    
            cb null, {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ doc.geo.coordinates[0],doc.geo.coordinates[1]]},$maxDistance: distance}}}
        else
          @Mapquest.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              cb null, {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ result.longitude,result.latitude]},$maxDistance: distance}}}

module.exports = new BusinessController()