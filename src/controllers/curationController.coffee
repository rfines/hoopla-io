restify = require("restify")
securityConstraints = require('./helpers/securityConstraints')
Event = require('hoopla-io-core').Event
RejectedEvent = require('hoopla-io-core').RejectedEvent
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
        console.log {'occurrences.start' : {$gte : new Date()}, curatorApproved : {$exists: false}}
        q = Event.find {'occurrences.start' : {$gte : new Date()}, curatorApproved : {$exists: false}}, {fixedOccurrences:0, schedules:0, occurrences:0, nextOccurrence:0, legacySchedule:0, location:0}, {lean:true,limit: 100}
        q.populate('business', 'name')
        q.populate('createUser', 'email')
        q.sort('-createDate')
        q.exec (err, data) ->
          events = data
          cb()
      (cb) ->
        score = (event, cb) ->
          b = _.find businessEventCount, (item) ->
            return item?._id?.toString() == event?.business._id.toString()
          risk = curationRisk.forEvent(event, b)
          event.riskScore = risk.score
          event.riskReasons = _.uniq(risk.reasons)
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
  rejectEvent:(req, res, next)=>
    if req.params._id
      Event.find {_id:req.params._id}, {},{lean:true}, (err,doc)=>
        if err
          console.log err
          res.send 401, err
          next()
        else
          rEvent = new RejectedEvent(doc)
          if rEvent
            rEvent.save (err)=>
              if err
                console.log err
                res.send 401, err
                next()
              else
                Event.remove {_id:req.params._id}, true, (err)=>
                  if err
                    console.log err
                    res.send 401, err
                    next()
                  else
                    res.send 200
                    next()
          else
            res.send 401, {message:"something went wrong"}
            next()
    else
      res.send 401, {message:"No _id in request"}
      next()
  acceptEvent:(req,res,next)=>
    if req.params._id
      Event.findByIdAndUpdate req.params._id, {$set:{'curatorApproved':true}}, (err, doc)=>
        if err
          console.log err
          res.send 401, err
          next()
        else
          res.send 200
          next()
module.exports = new CurationController()
