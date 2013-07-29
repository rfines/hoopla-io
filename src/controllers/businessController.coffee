mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class BusinessController extends RestfulController
  
  Model : require('../models/business').Business
  PostalCode : require('../models/postalCode').PostalCode

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @Model.find @buildSearchQuery(req.params) , (err, data) ->
      res.send data
      next()

  buildSearchQuery : (params, cb) =>
    if not params.ll and not params.near
      err = {'message': 'The request parameters do not contain a near field or ll field.'}
      cb err, null
    else
      if(params.ll)
        ll = params.ll.split(',')
        longitude = parseFloat(ll[0])
        latitude = parseFloat(ll[1])
        cb null, {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ longitude,latitude]}}}}
      else if(params.near)
        #geocode the address here
        @PostalCode.findOne {'code':params.near}, {}, {}, (err,doc) ->
          cb null, {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ doc.geo.coordinates[0],doc.geo.coordinates[1]]}}}}

module.exports = new BusinessController()