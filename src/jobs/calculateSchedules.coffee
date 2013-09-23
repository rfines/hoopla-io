_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
async = require 'async'

module.exports.runOnce = (onComplete) ->
  process = (item,cb)=>
    scheduleService.calculate item, (error, out) ->
      if error
        cb null
      else  
        item.scheduleText = out.scheduleText
        item.occurrences = out.occurrences
        item.save (errors, next)=>
          if errors
            cb null, null
          else
            cb null, null

  query = {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}, {'schedules.end' : {$exists : false}}]}
  events.find query,{}, {}, (err, data) ->
    async.eachLimit data, 20, process, (err) ->

      onComplete() if onComplete
      
