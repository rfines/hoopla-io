ScheduleService = require('../../src/services/schedulingService')
later = require 'later'
moment = require 'moment'
later.date.localTime();

testEvent = {
  "startRange":"8/01/2013 15:00:00",
  "endRange": "08/31/2013 15:00:00",
  "dayCount": 5,
  "_id":"51fbdc9ec778ed000000ad1f",
  "schedules" : [{
      "h" : [15],
      "m" : [0],
      "duration": 540,
      "start" : "8/01/2013 15:00:00",
      "end" : "8/30/2018 18:00:00",
      "dw" : [],
      "dayOfWeekCount" : [],
      "days" : []
      }]}
test = {
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
    "dayOfWeek" : [1],
    "dayOfWeekCount" : [1],
    "days" : []
  }]}
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
defaults_test = {
  "startRange":"8/01/2013 15:00:00",
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
defaults_2_test = {
  "startRange":"8/01/2013 15:00:00",
  "dayCount": 10,
  schedules:[{
    "hour": [15],
    "minute":[0],
    "duration" : 180,
    "start" : new Date("7/5/2013 15:00:00"),
    "end" : new Date("5/5/2018 18:00:00"),
    "_id" : "51fbdd47c778ed000000aeef",
    "dayOfWeek": [1,2,3,6],
    "weekOfMonth":[1,2,3,4,5]
  }]}
describe "Scheduling using Later library", ->
  it "should convert the schedules object to a usable state", (done)->
    ScheduleService.forLater testEvent.schedules[0], (err,result) ->
      result.should.eql {"h":[15],"m":[0]}
      done()

  it "should calculate daily occurrences for 5 days", (done)->
    ScheduleService.calculate testEvent, (err, results) ->
      results.should.eql [new Date('Mon Aug 01 2013 15:00:00 GMT-0500'),new Date('Mon Aug 02 2013 15:00:00 GMT-0500'),new Date('Mon Aug 03 2013 15:00:00 GMT-0500'),new Date('Mon Aug 04 2013 15:00:00 GMT-0500'),new Date('Mon Aug 05 2013 15:00:00 GMT-0500')]
      done()
     
  it "should calculate monthly occurrences for 90 days", (done)->
    ScheduleService.calculate test, (err, results) ->
      if err
        console.log err
      else
        results.should.eql [ new Date('Sun Aug 04 2013 15:00:00 GMT-0500'), new Date('Sun Sep 01 2013 15:00:00 GMT-0500'), new Date('Sun Oct 06 2013 15:00:00 GMT-0500'), new Date('Sun Nov 03 2013 16:00:00 GMT-0500') ]
      done()
  it "should calculate weekly occurrences for 90 days", (done)->
    ScheduleService.calculate weekly_test, (err, results) ->
      results.should.eql [ new Date('Wed Aug 13 2013 15:00:00 GMT-0500'), new Date('Wed Aug 27 2013 15:00:00 GMT-0500'), new Date('Wed Sep 03 2013 15:00:00 GMT-0500'), new Date('Wed Sep 17 2013 15:00:00 GMT-0500'), new Date('Wed Oct 01 2013 15:00:00 GMT-0500'), new Date('Wed Oct 15 2013 15:00:00 GMT-0500'), new Date('Wed Oct 29 2013 15:00:00 GMT-0500') ]
      done()
  it "should calculate weekly occurrences for 90 days using default values for end range", (done)->
    ScheduleService.calculate defaults_test, (err, results) ->
      results.should.eql [ new Date('Wed Aug 13 2013 15:00:00 GMT-0500'), new Date('Wed Aug 27 2013 15:00:00 GMT-0500'), new Date('Wed Sep 03 2013 15:00:00 GMT-0500'), new Date('Wed Sep 17 2013 15:00:00 GMT-0500'), new Date('Wed Oct 01 2013 15:00:00 GMT-0500'), new Date('Wed Oct 15 2013 15:00:00 GMT-0500'), new Date('Wed Oct 29 2013 15:00:00 GMT-0500') ]
      done()

  it "should calculate weekly occurrences for 10 days using default values for end range", (done)->
    ScheduleService.calculate defaults_2_test, (err, results) ->
      results.should.eql [ new Date('Fri Aug 02 2013 15:00:00 GMT-0500'), new Date('Sun Aug 04 2013 15:00:00 GMT-0500'), new Date('Mon Aug 05 2013 15:00:00 GMT-0500'), new Date('Tue Aug 06 2013 15:00:00 GMT-0500'), new Date('Fri Aug 09 2013 15:00:00 GMT-0500'), new Date('Sun Aug 11 2013 15:00:00 GMT-0500'), new Date('Mon Aug 12 2013 15:00:00 GMT-0500'), new Date('Tue Aug 13 2013 15:00:00 GMT-0500'), new Date('2013-08-16T20:00:00.000Z') ]
      done()
  it "should calculate monthly occurrences for 90 days with more complicated schedule", (done)->
    ScheduleService.calculate comp_test, (err, results) ->
      results.should.eql [ new Date('Sun Aug 15 2013 15:00:00 GMT-0500'), new Date('Sun Sep 19 2013 15:00:00 GMT-0500'), new Date('Sun Oct 17 2013 15:00:00 GMT-0500'), new Date('Sun Nov 21 2013 16:00:00 GMT-0500') ]
      done()
  it "should calculate weekly occurrences for 10 days for food and drink", (done)->
    ScheduleService.calculate weekly_fd_test, (err, results) ->
      results.should.eql [ new Date('Thu Aug 01 2013 18:30:00 GMT-0500'), new Date('Fri Aug 02 2013 18:30:00 GMT-0500'), new Date('Mon Aug 05 2013 18:30:00 GMT-0500'), new Date('Tue Aug 06 2013 18:30:00 GMT-0500'), new Date('Wed Aug 07 2013 18:30:00 GMT-0500'), new Date('Thu Aug 08 2013 18:30:00 GMT-0500'), new Date('Fri Aug 09 2013 18:30:00 GMT-0500'), new Date('Mon Aug 12 2013 18:30:00 GMT-0500'), new Date('Tue Aug 13 2013 18:30:00 GMT-0500'), new Date('Wed Aug 14 2013 18:30:00 GMT-0500') ]
      done()