mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('../models/business').Business
Event = require('../models/event').Event

class DevController

  constructor : (@name) ->

  indexAll : (req, res, next) =>  
    indexBusiness = (item, cb) ->
      ss.indexBusiness item, ->
        cb null
    indexEvent = (item, cb) ->
      ss.indexEvent item, ->
        cb null  

    if req.params.p is 'h00pl@Dev'
      ss.deleteIndex()        
      async.parallel {
        businesses: (cb) ->
          Business.find {}, {}, {lean:true}, (err, businesses) ->
            async.eachLimit businesses, 20, indexBusiness, (err) ->
              cb null, null
        events: (cb) ->
          Event.find {}, {}, {lean:true}, (err, events) ->
            async.eachLimit events, 20, indexEvent, (err) ->
              cb null, null              
      }, (err, results) ->
        res.send 200
        next()
    else
      res.send 403
      next()

module.exports =  new DevController()