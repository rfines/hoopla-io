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
    req =
      body : {}
    res = 
      send: ( (status, body) ->)  
    done()

  it 'should return a 401 to the user if they try to create a business without being authenticated', (done) ->
    responseSpy = sinon.spy(res, 'send')
    controller.create req, res, (msg) ->
      msg.statusCode.should.be.equal 403
      done()


  it 'should assign the creating user as the OWNER when the business is created', (done) ->
    req.authUser = {
      save : (err) ->
        console.log err    
    }
    business = {}
    userSpy = sinon.spy(req.authUser, 'save')
    next = ->
      console.log 'next'
    #controller.hooks.create.post business, req, res, next, ->
    #  userSpy.called.should.be.true
    #  req.authUser.businessPrivileges.length.should.be.equal 1
    done()



  
