restify = require("restify")
mongoose = require 'mongoose'
_ = require 'lodash'
authorizationService = require '../services/authorizationService'

class RestfulController

  getFields : {}
  security: 
    destroy : (authenticatedUser, target) ->
      true
    update : (authenticatedUser, target) ->
      true
    create : (authenticatedUser, target) ->
      true            

  search : (req, res, next) =>  
    query = {}
    @model.find query, @getFields, (err, data) ->
      res.send data
      next()

  get : (req, res, next) =>
    id = req.params.id
    checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$")
    if not checkForHexRegExp.test(id)
      @model.findOne {legacyId : req.params.id}, @getFields, {lean : true}, (err, data) ->
        if not err and not data
          res.send 404
        else  
          res.send 200, data
        next()
    else
      @model.findById req.params.id, @getFields, {lean : true}, (err, data) =>
        if not err and not data
          res.send 404
        else  
          res.send 200, data
        next()

  destroy: (req, res, next) =>
    @model.findById req.params.id, {}, {}, (err, target) =>
      if @security.destroy(req.authUser, target)
        target.remove (err, doc) ->
          res.send(204)
          next()     
      else
        return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")
  
  update: (req, res, next) =>
    @model.findById req.params.id, {}, {}, (err, target) =>
      if @security.update(req.authUser, target)
        target.update req.body, (err, doc) ->
          @hooks.update.post(target) if @hooks?.update?.post
          res.send(200, doc)
          next()    
      else
        return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")        

  create: (req, res, next) =>
    target = new @model(req.body)
    target.save (err, doc) ->
      @hooks.create.post(target) if @hooks?.create?.post
      console.log err if err
      res.send(201, doc)
      next()                    

module.exports = RestfulController