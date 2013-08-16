_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
async = require 'async'

module.exports.runOnce = ->
  calculateSchedules = (item,cb)=>
    scheduleService.calculate item, (error, occurrences) ->
      if error
        cb error, null
      else  
        item.occurrences = occurrences
        item.save (errors, next)=>
          if errors
            cb errors, null
          else
            cb null, null


  events.find {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}]},{}, {}, (err, data) ->
    console.log err if err
    async.each data, calculateSchedules, (err) ->
      if err
        process.exit 1
      else
        process.exit 0
      
