mongoose = require 'mongoose'

class BusinessController
  Model : require('../models/business').Business

  constructor : (@name) ->

  search : (req, res, next) =>
    nearZip = req.params.nearZip
    distance = parseInt(req.params.distance)
    query = { 'geo' :{ $near :{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,  39.102704 ] } , $maxDistance : distance} } }
    @Model.find query, (err, data) ->
      console.log 'my data'
      res.send data
      next()

  get : (req, res, next) =>
    res.send {Hello : 'World6'}
    next()

  getSecret : (req, res, next) =>
    res.send {Hello : 'Secret'}
    next()  

module.exports = new BusinessController()