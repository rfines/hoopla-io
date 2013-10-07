_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
async = require 'async'

module.exports.runOnce = (onComplete) ->
  process = (item,cb)=>
    item.save (err) =>
      cb null, null
  #query = {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}, {'schedules.end' : {$exists : false}}]}
  query = {}
  events.find query,{}, {}, (err, data) ->
    async.eachLimit data, 20, process, (err) ->
      onComplete() if onComplete
      
