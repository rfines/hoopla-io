_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')

class LegacyRouteController extends SearchableController
  model : require('../models/event').Event
  scheduleService : require('../services/schedulingService')
  type: 'event'
  populate:['media','business','host', "business.media", "host.media"]
  hooks: require('./hooks/legacyHooks')

  constructor : (@name) ->
    super(@name)

  get: (req, res, next) ->
    @hooks.get.pre 
      req : req
      res : res
      error: (err) =>
        res.status = err.code
        res.body = err.message
        res.send()
        next()
      success: =>
        id = req.params.id
        checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$")
        if not checkForHexRegExp.test(id)
          @model.findOne {legacyId : req.params.id}, @getFields, {lean : true}, (err, data) =>
            if not err and not data
              res.send 404
              next()
            else 
              res.body = data
              if req.imageHeight or req.imageWidth
                res.body.imageHeight = req.imageHeight
                res.body.imageWidth = req.imageWidth 
              @hooks.get.post 
                req : req
                res : res
                error: (err) ->
                  res.send err.code, err.message
                  next()
                success: ->
                  res.send 200, res.body
                  next()

module.exports = new LegacyRouteController()

