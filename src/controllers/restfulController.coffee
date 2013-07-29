restify = require("restify")
mongoose = require 'mongoose'
_ = require 'lodash'
authorizationService = require '../services/authorizationService'

class RestfulController

  getFields : {}

  search : (req, res, next) =>
    require('../services/cacheService').get 'hello', (err, d) -> 
      console.log d
    query = {}
    @Model.find query, (err, data) ->
      res.send data
      next()

  get : (req, res, next) =>
    id = req.params.id
    checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$")
    if not checkForHexRegExp.test(id)
      @Model.findOne {legacyId : req.params.id}, @getFields, {lean : true}, (err, data) ->
        res.send 200, data
        next()
    else
      @Model.findById req.params.id, @getFields, {lean : true}, (err, data) ->
        res.send 200, data
        next()  

  destroy: (req, res, next) =>
    @Model.remove {'_id' : req.params.id}, (err, doc) ->
      res.send(204)
      next()     

  update: (req, res, next) =>
    @Model.findByIdAndUpdate req.params.id, JSON.parse(req._body), (err, doc) ->
      res.send(200, doc)
      next()    

  create: (req, res, next) =>
    m = new @Model(JSON.parse(req._body))
    console.log m
    m.save (err, doc) ->
      console.log err
      res.send(201, doc)
      next()                    

module.exports = RestfulController