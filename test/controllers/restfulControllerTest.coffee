mongoose = require 'mongoose'
sinon = require 'sinon'
RestfulController = require('../../src/controllers/restfulController')

describe "Base Operations for RESTful Routes", ->
  
  findByIdCalled = false
  findOneCalled = false
  findOneQuery = {}

  modelSpy = 
    findById : (id, cb) ->
      findByIdCalled = true
      cb(null, {})  
    findOne : (query, cb) ->
      findOneQuery = query
      findOneCalled = true
      cb(null, {})

  beforeEach (done) ->
    findByIdCalled = false
    done()

  it "should get a resource by id", (done) ->
    controller =  new RestfulController()
    controller.Model = modelSpy
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: (->)
    controller.get req, res, ->
      findByIdCalled.should.be.true
      done()

  it "should get a resource by legacyId", (done) ->
    controller =  new RestfulController()
    controller.Model = modelSpy
    req = 
      params : 
        id : 12345
    res = 
      send: (->)
    controller.get req, res, ->
      findOneCalled.should.be.true
      findOneQuery.should.eql {legacyId : req.params.id}
      done()      