moment = require 'moment'
later = require 'later'
_ = require 'underscore'

later.date.localTime();

calculate= (event,dayCount,cb) ->
  if event.schedules
    console.log event
    now = moment()
    for x in event.schedules
      occurrences = []
      transformed =  forLater(x)
      console.log transformed
      if moment().add('days', dayCount) < moment(x.end)
        endCalc = moment().add('days', dayCount)
        occurrences = later.schedule({schedules:[transformed]}).next(dayCount,new Date(now),new Date(endCalc))
        console.log "using day count"
        console.log occurrences
      else
        endCalc = moment(x.end)
        occurrences = later.schedule({schedules:[transformed]}).next(dayCount,new Date(now),new Date(endCalc))
        console.log "using end date"
        console.log occurrences
    cb null, occurrences
  else
    cb null, event.fixedOccurrences

forLater = (item) ->
  console.log item
  output = {}
  output.d = item.day if item.day?.length
  output.h= item.h if item.h?.length
  output.m= item.m if item.m?.length
  output.dw= item.dayOfWeek if item.dayOfWeek?.length
  output.dayOfWeekCount= item.dayOfWeekCount if item.dayOfWeekCount?.length
  output.wm= item.wm if item.wm?.length
  return output

module.exports = 
  calculate : calculate