mongoose = require 'mongoose'
sinon = require 'sinon'
EventController = require('../../src/controllers/eventController')

describe "Operations for Event Routes", ->
  controller = {}
  modelSpy = {}
  builder = {}
  mockedEvent = {}
  mockedQuery = {}
  req = {}
  before (done) ->  
    done()
  beforeEach (done) ->
    controller = require('../../src/controllers/eventController')
    builder = require('../../src/controllers/helpers/QueryComponentBuilder')
    mockedQuery = {
      skip: (x) ->
      limit: (x) ->
      populate: (x) ->
      exec: (x) ->
    }
    mockedEvent = {
      find: (query, fields, options)->
        return mockedQuery
    }
    controller.model = mockedEvent
    done()
    
  it "should correctly limit and skip if limit and skip params are passed", (done)->
    req = 
      params: 
        limit: 100
        skip: 1
    res = 
      send: ( (status, body) ->) 
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      skipSpy.calledWith({skip : 1}).should.be.true
      limitSpy.calledWith({limit : 100}).should.be.true
    done()
  it "should not use skip and limit if not passed", (done)->
    req.params = {}
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      skipSpy.called.should.be.false
      limitSpy.called.should.be.false
    done()
