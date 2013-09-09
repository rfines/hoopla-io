moment = require 'moment'
later = require 'later'
_ = require 'lodash'

later.date.localTime();
calculate= (item,cb) ->
  if item.schedules.length
    occurrences = []
    dayCount = 90
    if item.dayCount
      dayCount = item.dayCount 
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
        if not err
          transformed = result
      if item.endRange?.length
        endRange = new Date(item.endRange)
      else
        if moment().add('days', dayCount) < moment(x.end)
          endRange = new Date(moment().add('days', dayCount))
        else
          endRange = new Date(x.end)
      occurrences = later.schedule({schedules:[transformed]}).next(dayCount,startRange,endRange)
      occurrences = _.map occurrences, (o) ->
        m = moment(o)
        return {start: m.toDate(), end: m.add('minutes', x.duration).toDate()}
    cb null, occurrences
  else
    o = _.map item.fixedOccurrences, (item) ->
      {start : item.start, end : item.end}
    cb null, o

forLater = (item, cb) ->
  output = {}
  if item.day?.length
    output.d = item.day
  else if item.days?.length
    output.d = item.days
  if item.h?.length
    output.h= item.h
  else if item.hour?.length
    output.h = item.hour
  if item.m?.length
    output.m= item.m
  else if item.minute?.length
    output.m = item.minute
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
  cb null, output

module.exports = 
  calculate : calculate
  forLater : forLater
