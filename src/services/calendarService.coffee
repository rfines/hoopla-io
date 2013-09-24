icalendar = require 'icalendar'
Event = require '../models/event'
CONFIG = require('config')
eventUtils = require('../utils/eventUtils')
moment = require 'moment'
_ = require 'lodash'


createICalFile=(event, occurrenceStartDate, occurrenceEndDate, cb) ->
  if event and occurrenceEndDate and occurrenceStartDate
    calName = event.name
    address = event.location.address
    des = event.description
    description = "#{calName} at #{address}, #{des}"
    ical = new icalendar.VEvent(event._id)
    ical.setSummary(des)
    ical.setDate(occurrenceStartDate.toDate(), occurrenceEndDate.toDate())
    ical.setDescription description
    cb null, ical.toString()
  else
    cb "No event or dates passed in.", null


module.exports.getCalendar= (type,event,start,end,cb)->
  switch type
    when 'ical' then createICalFile(event,start,end, cb)
    else
      cb "Unsupported type error"