restify = require("restify")
securityConstraints = require('./helpers/securityConstraints')
Event = require('hoopla-io-core').Event
async = require 'async'
curationRisk = require './helpers/curationRisk'
_ = require 'lodash'

class CurationController

  getEventBatch : (req, res, next) => 
    events = undefined 
    businessEventCount = undefined
    async.series [
      (cb) ->
        Event.aggregate { $group: { _id: "$business",count:{$sum: 1}}}, (err, data) ->
          businessEventCount = data
          cb()
      (cb) ->
        query = {}
        q = Event.find {}, {}, {lean:true,limit: 100}
        q.exec (err, data) ->
          events = data
          cb()
      (cb) ->
        score = (event, cb) ->
          b = _.find businessEventCount, (item) ->
            return item?._id?.toString() == event?.business.toString()
          event.riskScore = curationRisk.forEvent(event, b)
          cb()
        async.each events, score, ->
          cb()
      (cb) ->
        events = _.sortBy events, (item) ->
          return -item.riskScore
        cb()
      (cb) ->
        res.send events
        next()
    ]

module.exports = new CurationController()
