ScheduleService = require('../../src/services/schedulingService')
later = require 'later'
moment = require 'moment'
later.date.localTime();

comp_test = {
  "startRange":"8/01/2013 15:00:00",
  "endRange": "11/30/2013 15:00:00",
  "dayCount": 90,
  schedules:[{
    "hour" : [15],
    "minute" : [0],
    "duration" : 180,
    "start" : new Date("7/5/2013 15:00:00"),
    "end" : new Date("5/5/2018 18:00:00"),
    "_id" : "51fbdd47c778ed000000affb",
    "dayOfWeek" : [5],
    "dayOfWeekCount" : [3],
    "days" : [3,4,5]
  }]}
weekly_test = {
  "startRange":"8/01/2013 15:00:00",
  "endRange": "10/31/2013 15:00:00",
  "dayCount": 90,
  schedules:[{
    "hour": [15],
    "minute":[0],
    "duration" : 180,
    "start" : new Date("7/5/2013 15:00:00"),
    "end" : new Date("5/5/2018 18:00:00"),
    "_id" : "51fbdd47c778ed000000afff",
    "dayOfWeek": [3],
    "weekOfMonth":[1,3,5]
  }]}
weekly_fd_test = {
  "startRange":"8/01/2013 18:30:00",
  "endRange": "10/31/2013 22:30:00",
  "dayCount": 10,
  schedules:[{
    "hour": [18],
    "minute":[30],
    "duration" : 180,
    "start" : new Date("7/5/2013 18:30:00"),
    "end" : new Date("5/5/2018 22:30:00"),
    "_id" : "51fbdd47c778ed000000afff",
    dayOfWeek:[2,3,4,5,6]
    
  }]}

describe "Scheduling using Later library", ->

  it "should convert the schedules object to a usable state", (done)->
    testEvent = {
      "dayCount": 5
      "schedules" : [{
          "h" : [15]
          "m" : [0]
          "duration": 540
          "start" : "8/01/2013 15:00:00"
          "end" : "8/30/2018 18:00:00"
          }]}  
    ScheduleService.forLater testEvent.schedules[0], (err,result) ->
      result.should.eql {"h":[15],"m":[0]}
      done()

  it "should calculate daily occurrences for 5 days", (done)->
    testEvent = {
      "dayCount": 5
      "schedules" : [{
          "h" : [15]
          "m" : [0]
          "duration": 540
          "start" : "8/01/2013 15:00:00"
          "end" : "8/30/2018 18:00:00"
          }]}  
    ScheduleService.calculate testEvent, (err, results) ->
      results.length.should.equal 5
      results[0].start.should.eql moment().add('days', 1).startOf('day').hours(15).toDate()
      results[4].start.should.eql moment().add('days', 5).startOf('day').hours(15).toDate()
      done()

  it "should calculate weekly occurrences for 90 days", (done)->
    defaults_test = {
      "dayCount": 90
      schedules:[{
        "hour": [15]
        "minute":[0]
        "duration" : 180
        "start" : new Date("7/5/2013 15:00:00")
        "end" : new Date("5/5/2018 18:00:00")
        "dayOfWeek": [3]
        "weekOfMonth":[1,3,5]
      }]}  
    ScheduleService.calculate defaults_test, (err, results) ->
      moment(results[0].start).hour().should.eql 15
      moment(results[0].start).day().should.eql 2
      done()