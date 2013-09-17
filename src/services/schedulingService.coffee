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
      occurrences = later.schedule({schedules:[transformed]}).next(2,startRange,endRange)
      occurrences = _.map occurrences, (o) ->
        m = moment(o)
        s = moment(m.toDate()).toDate()
        e = moment(m.toDate()).add('minutes', x.duration).toDate()
        return {start: s, end: e}
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
  if item.h
    if _.isArray(item.h)
      output.h= item.h
    else
      output.h = [item.h]
  else if item.hour
    if _.isArray(item.hour)
      output.h= item.hour
    else
      output.h = [item.hour]
  if item.m
    if _.isArray(item.h)
      output.m= item.m
    else
      output.m = [item.m]
  else if item.minute
    if _.isArray(item.h)
      output.m= item.minute
    else
      output.m = [item.minute]
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
