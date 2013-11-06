mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('hoopla-io-core').Business
Event = require('hoopla-io-core').Event
scheduler = require('hoopla-io-core').Scheduler

class DevController
  
  constructor : (@name) ->

  indexAll : (req, res, next) =>  
    indexBusiness = (item, cb) ->
      ss.indexBusiness item,(err) ->
        cb null
    indexEvent = (item, cb) ->
      ss.indexEvent item, (err) ->
        cb null  

    if req.params.p is 'h00pl@Dev'
      ss.deleteIndex ->  
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

  buildAllSchedules: (req, res, next) =>
    scheduleEvent = (item,cb) ->
      scheduler.calculate item, (err, occurrences) ->
        if err
          cb err, null
        else
          item.occurrences = occurrences
          item.save (error, data)->
          if err 
            cb error, null
          else
            cb null, null
    if req.params.p is 'h00pl@Dev'
      Event.find {}, {}, {}, (err, events) ->
        async.each events, scheduleEvent, (err) ->
          res.send 200
          next()
    else
      res.send 403
      next()
      
  bcryptPassword:(req, res, next) =>
    require('../services/bcryptService').encrypt req.params.password, (encrypted)->
      key = require('../services/tokenService').generateKey()
      secret = require('../services/tokenService').generateSecret()
      res.send {encryptedPassword : encrypted, key: key, secret: secret}
      next()

  stats: (req, res, next) =>
    Event.count {}, (err, eventCount) ->
      if err
        res.send 500
        next()
      else
        Business.count {}, (err, busCount) ->
          if err
            res.send 500
            next()
          else
            res.send {businesses: busCount, events: eventCount}
            next()

module.exports =  new DevController()