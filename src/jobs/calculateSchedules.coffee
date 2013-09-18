_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
async = require 'async'

module.exports.runOnce = (onComplete) ->
  calculateSchedules = (item,cb)=>
    scheduleService.calculate item, (error, occurrences) ->
      if error
        console.log error
        cb null
      else  
        item.occurrences = occurrences
        item.save (errors, next)=>
          if errors
            console.log errors
            cb null, null
          else
            cb null, null

  query = {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}, {'schedules.end' : {$exists : false}}]}
  events.find query,{}, {}, (err, data) ->
    console.log 'calculate schedules'
    async.eachSeries data, calculateSchedules, (err) ->
      console.log err
      console.log 'all done'
      onComplete() if onComplete
      
