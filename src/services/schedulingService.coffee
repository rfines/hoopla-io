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
    startRange = new Date(now)
    for x in item.schedules
      transformed = {}
      forLater x, (err,result)->
        if not err
          transformed = result
      if moment().add('days', dayCount) < moment(x.end)
        endRange = new Date(moment().add('days', dayCount))
      else
        endRange = new Date(x.end)
      occurrences = later.schedule({schedules:[transformed]}).next(dayCount,startRange,endRange)
      occurrences = _.map occurrences, (o) ->
        m = moment(o)
        s = moment(m.toDate()).toDate()
        e = moment(m.toDate()).add('minutes', x.duration).toDate()
        return {start: s, end: e}
      out = {occurrences : occurrences}
    out.scheduleText = scheduleText(item)
    out.nextOccurrence = _.first(occurrences).start if occurrences?.length > 0
    cb null, out
  else
    minutesToAdd = item.tzOffset - moment().zone()
    o = _.map item.fixedOccurrences, (fo) ->
      s = moment(fo.start).subtract('minutes', minutesToAdd)
      e = moment(fo.end).subtract('minutes', minutesToAdd)
      return {start : s.toDate(), end : e.toDate()}
    nextOccurrence = _.find o, (item) ->
      moment(item.start).isAfter(moment().startOf('day'))
    if not nextOccurrence
      cb null, {occurrences: o, scheduleText: '', nextOccurrence : undefined}
    else
      cb null, {occurrences: o, scheduleText: '', nextOccurrence : nextOccurrence.start}

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
    if _.isArray(item.minute)
      output.m= item.minute
    else
      output.m = [item.minute]
  if item.dayOfWeek
    if _.isArray(item.dayOfWeek)
      output.dw= item.dayOfWeek
    else
      output.dw = [item.dayOfWeek]  
  else if item.dw
    if _.isArray(item.dw)
      output.dw= item.dw
    else
      output.dw = [item.dw]   
  if item.dayOfWeekCount?.length
    output.dayOfWeekCount= item.dayOfWeekCount
  if item.wm
    output.wm= item.wm
  else if item.weekOfMonth
    output.wm = item.weekOfMonth
  cb null, output

scheduleText= (event) ->
  out = ""
  dayOrder =  ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  dayCountOrder = ['Last', 'First', 'Second', 'Third', 'Fourth']
  if event.schedules?[0]
    s = event.schedules[0]
    s.dayOfWeek = _.sortBy s.dayOfWeek, (i) ->
      i    
    endDate = moment(s.end)
    if s.dayOfWeek?.length is 0 and s.dayOfWeekCount?.length is 0
       out = 'Every Day'
    else
      days = _.map s.dayOfWeek, (i) ->
        return dayOrder[i-1]
      if s.dayOfWeekCount?.length > 0
        out = "The #{dayCountOrder[s.dayOfWeekCount]} #{days.join(', ')} of the month"
      else
        out = "Every #{days.join(', ')}"
      if s.end
        out = "#{out} until #{endDate.format('MM/DD/YYYY')}"   
      else
        out = "#{out}"
    return out
  else
    return out

module.exports = 
  calculate : calculate
  scheduleText : scheduleText
  forLater : forLater
