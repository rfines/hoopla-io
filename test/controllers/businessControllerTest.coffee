sinon = require 'sinon'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}
  
  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')      
    done()

  it 'should return a 401 to the user if they try to create a business without being authenticated', (done) ->
    req =
      body : {}
    res = 
      send: ( (status, body) ->)  
    responseSpy = sinon.spy(res, 'send')
    controller.create req, res, (msg) ->
      msg.statusCode.should.be.equal 403
      done()


  
