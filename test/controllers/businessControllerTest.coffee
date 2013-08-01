sinon = require 'sinon'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}
  req = {}
  res = {}  

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')
    controller.searchService = 
      {
        findBusinesses: (term, cb) ->
          cb()
      }
    controller.searchDatabase = (req, cb) ->
      cb()
    req = 
      params : 
        keyword : 'myKeyword'
    res = 
      send: ( (status, body) ->)        
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
