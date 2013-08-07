sinon = require 'sinon'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}
  req = {}
  res = {}  
  mockedEvent = {}
  mockedQuery = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')
    controller.searchService = 
      {
        findBusinesses: (term, cb) ->
          cb()
      }
    req = 
      params : 
        keyword : 'myKeyword'
    res = 
      send: ( (status, body) ->)
    mockedQuery = {
      skip: (x) ->
      limit: (x) ->
      populate: (x) ->
      exec: (x) ->
        x(null, [])
    }
    mockedBusiness = {
      find: (query, fields, options)->
        return mockedQuery
    }
    controller.model = mockedBusiness        
    done()      

  it 'should call elasticsearch when keyword is provided', (done) ->
    spy = sinon.spy(controller.searchService, 'findBusinesses')
    controller.search req, res, ->
      spy.calledWith('myKeyword').should.be.true
      done()

  it 'should not call elasticsearch when keyword is not provided', (done) ->
    req.params = {}
    spy = sinon.spy(controller.searchService, 'findBusinesses')
    controller.search req, res, ->
      spy.calledWith('myKeyword').should.be.false
      done()

  it 'should correctly limit and skip if limit and skip params are passed', (done)->
    req.params =  
      limit: 100
      skip: 1
    console.log req.params
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      console.log data
      skipSpy.calledWith(1).should.be.true
      limitSpy.calledWith(100).should.be.true
    done()

  it "should not use skip and limit if not passed", (done)->
    req.params = {}
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      console.log data
      skipSpy.called.should.be.false
      limitSpy.called.should.be.false
    done() 
