mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class EventController  extends RestfulController
  Model : require('../models/event').Event

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    nearZip = req.params.nearZip
    distance = parseInt(req.params.distance)
    query = { 'geo' :{ $near :{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,  39.102704 ] } , $maxDistance : distance} } }
    console.log @Model
    @Model.find query, (err, data) ->
      res.send data
      next()

module.exports = new EventController()