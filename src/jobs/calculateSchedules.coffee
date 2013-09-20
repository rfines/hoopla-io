_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
async = require 'async'

module.exports.runOnce = (onComplete) ->
  calculateSchedules = (item,cb)=>
    scheduleService.calculate item, (error, occurrences) ->
      if error
        cb null
      else  
        item.occurrences = occurrences
        item.save (errors, next)=>
          if errors
            cb null, null
          else
            cb null, null

  query = {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}, {'schedules.end' : {$exists : false}}]}
  events.find query,{}, {}, (err, data) ->
    async.eachSeries data, calculateSchedules, (err) ->
      onComplete() if onComplete
      
