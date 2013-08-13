_ = require 'lodash'
scheduleService = require('../services/schedulingService')
events = require('../models/event').Event
mongoService = require '../services/mongoService'
async = require 'async'

mongoService.init()
module.exports.runOnce = ->
  calculateSchedules = (item,cb)=>
    scheduleService.calculate item, (error, occurrences) ->
      if error
        console.log error
        cb error, null
      else  
        item.occurrences = occurrences
        item.save (errors, next)=>
          if errors
            console.log errors
            cb errors, null
          else
            cb null, null


  events.find {$or:["schedules.end":{$gte: Date.now()}, {"fixedOccurrences.end":{$gte:Date.now()}}]},{}, {}, (err, data) ->
    console.log err if err
    console.log data
    async.each data, calculateSchedules, (err) ->
      console.log "hello"
      if err
        process.exit 1
      else
        process.exit 0
      
