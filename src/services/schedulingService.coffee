moment = require 'moment'
later = require 'later'
_ = require 'lodash'

calculate= (item,cb) ->
  if item.schedules.length > 0
    out = {}
    occurrences = []
    dayCount = 60
    if item.dayCount
      dayCount = item.dayCount 
    now = moment()
    startRange = new Date()
    endRange = new Date()
    startRange = new Date(now)
    x = item.schedules[0]
    transformed = {}
    forLater x, (err,result)->
      if not err
        transformed = result
      else
        console.log err
    if x.end
      endRange = new Date(x.end)
    else
      endRange = new Date(moment().add('days', dayCount))
    if moment(x.start).isAfter(now)
      startRange = new Date(x.start)
    else
      startRange = new Date(now)
    occurrences = later.schedule({schedules:[transformed]}).next(dayCount,startRange,endRange)
    occurrences = _.map occurrences, (o) ->
      m = moment(o)
      s = moment(m.toDate()).toDate()
      e = moment(m.toDate()).add('minutes', x.duration).toDate()
      {start: s, end: e}
    out.occurrences = occurrences
    pastOccurrence = later.schedule({schedules:[transformed]}).prev(1)
    m = moment(pastOccurrence)
    s = moment(m.toDate()).toDate()
    e = moment(m.toDate()).add('minutes', x.duration).toDate()
    pastOccurrence = {start : s, end: e}
    out.prevOccurrence = pastOccurrence if pastOccurrence
    out.scheduleText = scheduleText(item)
    out.nextOccurrence = _.first(occurrences) if occurrences?.length > 0
    cb null, out
  else
    minutesToAdd = item.tzOffset - moment().zone()
    o = _.map item.fixedOccurrences, (fo) ->
      s = moment(fo.start).subtract('minutes', minutesToAdd)
      e = moment(fo.end).subtract('minutes', minutesToAdd)
      return {start : s.toDate(), end : e.toDate()}
    out = { occurrences: o, scheduleText: ''}
    nextOccurrence = _.find o, (item) ->
      moment(item.start).isAfter(moment().startOf('day'))
    pastOccurrences = _.filter o, (item) ->
      moment(item.start).isBefore(moment().endOf('day'))
    out.prevOccurrence = _.last(pastOccurrences) if pastOccurrences?.length > 0
    out.nextOccurrence = nextOccurrence
    cb null, out

forLater = (item, cb) ->
  output = {}
  if item.day?.length
    output.d = item.day
  else if item.days?.length
    output.d = item.days
  if item.h
    output.h = makeArray(item.h)
  else if item.hour
    output.h =  makeArray(item.hour)
  if item.m
    output.m = makeArray(item.m)
  else if item.minute
    output.m = makeArray(item.minute)
  if item.dayOfWeek
    output.dw = makeArray(item.dayOfWeek)
  else if item.dw
    output.dw = makeArray(item.dw)
  if item.dayOfWeekCount?.length
    output.dayOfWeekCount= item.dayOfWeekCount
  if item.wm
    output.wm= item.wm
  else if item.weekOfMonth
    output.wm = item.weekOfMonth
  cb null, output

makeArray = (p) ->
  if _.isArray(p) 
    return p 
  else 
    return [p]

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
