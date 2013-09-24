mongoose = require 'mongoose'
sinon = require 'sinon'
CONFIG = require 'config'
calendarService = require '../../src/services/calendarService'
ical = require "icalendar"
moment = require 'moment'

describe "Calendar Service Tests", ->
  event = {
    _id: "12345-67890"
    name: "test event"
    description: "Some description"
    location:
      address: "1234 Main St. kansas city, mo. 64105"

  }
  start = new Date("09/01/2014 9:00 AM")
  end = new Date("09/01/2014 11:00 AM")
  description = "#{event.name} at #{event.location.address}, #{event.description}"
  calEvent = new ical.VEvent(event._id)
  calEvent.setDate(start,end)
  calEvent.setSummary(event.description)
  calEvent.setDescription(description)
  testCal = calEvent.toString()
  expected = {success:true, file:testCal}

  it "should create a valid ical file", (done)=>
    calendarService.getCalendar 'ical', event, moment(start),moment(end), (err, response)=>
      console.log "response received"
      if err
        console.log err
        done()
      else
        response.success.should.equal(expected.success)
        done()
    
