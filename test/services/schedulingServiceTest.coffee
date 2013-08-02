ScheduleService = require('../../src/services/schedulingService')
later = require 'later'
moment = require 'moment'
later.date.localTime();

testEvent = {
  "_id":"51fbdc9ec778ed000000ad1f"
  "schedules" : [
      "h" : [15],
      "m" : [0],
      "duration": 540,
      "start" : "7/30/2013 15:00:00",
      "end" : "7/30/2018 18:00:00",
      "dw" : [],
      "dayOfWeekCount" : [],
      "days" : [4]
      ]
    ,
    "fixedOccurrences":[]
}
test = {schedules:[{
    "hour" : 15,
    "minute" : 0,
    "duration" : 180,
    "start" : new Date("5/5/2013 15:00:00"),
    "end" : new Date("5/5/2018 18:00:00"),
    "_id" : "51fbdd47c778ed000000affb",
    "dayOfWeek" : [1],
    "dayOfWeekCount" : [1],
    "days" : []
  }]}
describe "Scheduling using Later library", ->
  it "should calculate daily occurrences for 1 days", (done)->
    ScheduleService.calculate testEvent, 1, (err, results) ->
      if err
        console.log err
      else
        results.should.eql new Date('Fri Aug 03 2013 15:00:00 GMT-0500')
      done()
     
  it "should calculate monthly occurrences for 90 days", (done)->
    ScheduleService.calculate test, 90, (err, results) ->
      if err
        console.log err
      else
        results.should.eql [ new Date('Sun Aug 04 2013 00:00:00 GMT-0500'), new Date('Sun Sep 01 2013 00:00:00 GMT-0500'), new Date('Sun Oct 06 2013 00:00:00 GMT-0500') ]
      done()
