moment = require 'moment'
later = require 'later'
_ = require 'lodash'

later.date.localTime();

calculate= (event,dayCount,cb) ->
  if event.schedules
    now = moment()
    for x in event.schedules
      occurrences = []
      transformed =  forLater(x)
      if moment().add('days', dayCount) < moment(x.end)
        endCalc = moment().add('days', dayCount)
        occurrences = later.schedule({schedules:[transformed]}).next(dayCount,new Date(now),new Date(endCalc))
      else
        endCalc = moment(x.end)
        occurrences = later.schedule({schedules:[transformed]}).next(dayCount,new Date(now),new Date(endCalc))
    cb null, occurrences
  else
    cb null, _.pluck(event.fixedOccurrences, 'start')

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