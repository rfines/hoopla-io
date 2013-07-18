mongoose = require 'mongoose'
sinon = require 'sinon'
RestfulController = require('../../src/controllers/restfulController')

describe "Base Operations for RESTful Routes", ->
  
  findByIdCalled = false

  modelSpy = 
    findById : (id, cb) ->
      findByIdCalled = true
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