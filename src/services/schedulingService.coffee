moment = require 'moment'
later = require 'later'
_ = require 'lodash'

later.date.localTime();

calculate= (item,cb) ->
  if item.schedules
    occurrences = []
    dayCount = 90
    if item.dayCount
      dayCount = item.dayCount 
    console.log item
    now = moment()
    startRange = new Date()
    endRange = new Date()
    if item.startRange?.length
      startRange = new Date(item.startRange)
    else
      startRange = new Date(now)
    for x in item.schedules
      transformed = {}
      forLater x, (err,result)->
        console.log result
        if err
          console.log err
        else
          transformed = result
          console.log "Transformed: "
          console.log transformed
      if item.endRange?.length
        endRange = new Date(item.endRange)
      else
        if moment().add('days', dayCount) < moment(x.end)
          endRange = new Date(moment().add('days', dayCount))
        else
          endRange = new Date(x.end)
      console.log "Ending: #{endRange}"
      occurrences = later.schedule({schedules:[transformed]}).next(dayCount,startRange,endRange)
    cb null, occurrences
  else
    cb null, _.pluck(item.fixedOccurrences, 'start')

forLater = (item, cb) ->
  output = {}
  if item.day?.length
    output.d = item.day
  else if item.days?.length
    output.d = item.days
  if item.h?.length
    output.h= item.h
  else if item.hours?.length
    output.h = item.hours
  if item.m?.length
    output.m= item.m
  else if item.minutes?.length
    output.m = item.minutes
  if item.dayOfWeek?.length
    output.dw= item.dayOfWeek
  else if item.dw?.length
    output.dw = item.dw
  if item.dayOfWeekCount?.length
    output.dayOfWeekCount= item.dayOfWeekCount
  if item.wm
    output.wm= item.wm
  else if item.weekOfMonth
    output.wm = item.weekOfMonth
  console.log output
  cb null, output

module.exports = 
  calculate : calculate
  forLater : forLater
