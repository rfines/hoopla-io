mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class BusinessController extends RestfulController
  
  Model : require('../models/business').Business

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @Model.find @buildSearchQuery(req.params) , (err, data) ->
      res.send data
      next()

  buildSearchQuery : (params) =>
    ll = params.ll.split(',')
    longitude = parseFloat(ll[0])
    latitude = parseFloat(ll[1])
    {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ longitude,latitude]}}}}

module.exports = new BusinessController()