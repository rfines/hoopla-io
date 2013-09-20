mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('../models/business').Business
Event = require('../models/event').Event

module.exports.runOnce = (onComplete) ->
  indexBusiness = (item, cb) ->
      ss.indexBusiness item,(err) ->
        cb null
  indexEvent = (item, cb) ->
    ss.indexEvent item, (err) ->
      cb null  

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
      console.log 'done'
      onComplete() if onComplete