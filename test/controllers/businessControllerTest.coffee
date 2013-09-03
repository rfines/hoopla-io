sinon = require 'sinon'
mongoose = require 'mongoose'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}
  req = {}
  res = {}
  
  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')
    document = {}
    modelSpy = 
      find : (query, fields, options, cb) ->
        cb null, document


    controller.events = modelSpy      
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

  it 'should not allow you to delete a business if you do not have privs on it', (done) ->
    business = {
      _id : new mongoose.Types.ObjectId()
    }
    user = {businessPrivileges : []}
    controller.security.destroy(user, business).should.be.false
    done()

  it 'should not allow you to delete a business if you are not the owner', (done) ->
    business = {
      _id : new mongoose.Types.ObjectId()
    }
    user = {businessPrivileges : [{businessId : business._id,role : 'COLLABORATOR'}]}
    controller.security.destroy(user, business).should.be.false
    done()   

  it 'should  allow you to delete a business if you are the owner', (done) ->
    business = {
      _id : new mongoose.Types.ObjectId()
    }
    user = {businessPrivileges : [{business : business._id, role : 'OWNER'}]}
    controller.security.destroy(user, business).should.be.true
    done()        

  it 'should  allow you to update a business if have privileges on the business', (done) ->
    business = {
      _id : new mongoose.Types.ObjectId()
    }
    user = {businessPrivileges : [{business : business._id, role : 'COLLABORATOR'}]}
    controller.security.update(user, business).should.be.true
    done() 

  it 'should return a list of events owned by a business', (done) ->
    req.params = {}
    req.query  = {}
    req.params.id = "123"
    req.params.ll  = '-94.595033,39.102704'
    spy = sinon.spy(controller.events, 'find') 
    controller.getEvents req, res,(err,result) ->
      spy.calledWith({'business' : req.params.id}).should.be.true
      done()

  it 'should return a list of all events owned by all businesses', (done) ->
    req.params = {}
    req.query  = {}
    req.query.additional_ids = "123,354,546"
    req.params.ll  = '-94.595033,39.102704'
    spy = sinon.spy(controller.events, 'find') 
    controller.getEvents req, res,(err,result) ->
      spy.calledWith({'business' : {$in:["123", "354","546"]}}).should.be.true
      done()                   