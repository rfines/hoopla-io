mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('../models/business').Business
Event = require('../models/event').Event
scheduler = require('../services/schedulingService')

class DevController
  
  constructor : (@name) ->

  indexAll : (req, res, next) =>  
    indexBusiness = (item, cb) ->
      ss.indexBusiness item,(err) ->
        console.log err if err
        cb null
    indexEvent = (item, cb) ->
      ss.indexEvent item, (err) ->
        console.log err if err
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

  buildAllSchedules: (req, res, next) =>
    console.log "****Starting schedule build****"
    if req.params.p is 'h00pl@Dev'
      scheduleEvent : (item,cb) ->
        console.log "Inside Schedule Event #{item}"
        scheduler.calculate item, (err, occurrences) ->
          if err
            console.log err
            cb err, null
          else
            item.occurrences = occurrences
            item.save (error, data)->
            if err 
              console.log error
              cb error, null
            else
              cb null, null

      Event.find {}, {}, {}, (err, events) ->
        async.each events, scheduleEvent, (err) ->
          res.send 200
          next()
    else
      console.log "****Returning due to insufficient priviliges****"
      res.send 403
      next()
      
module.exports =  new DevController()