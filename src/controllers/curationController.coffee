restify = require("restify")
securityConstraints = require('./helpers/securityConstraints')
Event = require('hoopla-io-core').Event
async = require 'async'

class CurationController

  getEventBatch : (req, res, next) => 
    rawEvents = undefined 
    async.series [
      (cb) ->
        Event.aggregate { $group: { _id: "$business",count:{$sum: 1}}}, (err, data) ->
          businessEventCount = data
          cb()
      (cb) ->
        query = {}
        q = Event.find {}, {}, {lean:true,limit: 100}
        q.exec (err, data) ->
          rawEvents = data
          cb()
      (cb) ->
        score = (event, cb) ->
          event.riskScore = Math.floor(Math.random()*101)
          cb()
        async.each rawEvents, score, ->
          console.log 'sending'
          res.send rawEvents
          next()
    ]

module.exports = new CurationController()
