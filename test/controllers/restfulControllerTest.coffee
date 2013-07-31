mongoose = require 'mongoose'
sinon = require 'sinon'
RestfulController = require('../../src/controllers/restfulController')

describe "Base Operations for RESTful Routes", ->
  
  controller = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller =  new RestfulController()
    modelSpy = 
      findById : (id, fields, options, cb) ->
        cb null, { 
          update : (data, cb) ->
            cb()
          remove : (cb) ->
            cb()
        }
      findOne : (query, fields, options, cb) ->
        cb null, { 
          update : (data, cb) ->
            cb()
          remove : (cb) ->
            cb()
        }
      remove : (query, cb) ->
        cb null, { 
          update : (data, cb) ->
            cb()
          remove : (cb) ->
            cb()
        }
      findByIdAndUpdate : (id, body, cb) ->
        cb null, { 
          update : (data, cb) ->
            cb()
          remove : (cb) ->
            cb()
        }
    controller.model = modelSpy
    done()

  it "should get a resource by id", (done) ->
    spy = sinon.spy(controller.model, "findById");
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)
    controller.get req, res, ->
      spy.called.should.be.true
      done()

  it "should get a resource by legacyId", (done) ->
    spy = sinon.spy(controller.model, "findOne");
    req = 
      params : 
        id : 12345
    res = 
      send: ( (status, body) ->)
    controller.get req, res, ->
      spy.called.should.be.true
      spy.calledWith({legacyId : req.params.id}).should.be.true
      done() 

  it 'should set the status code to 200 on successful get', (done) ->
    req = 
      params : 
        id : 12345
    res = 
      send: ( (status, body) ->)
    spy = sinon.spy(res, 'send')  
    controller.get req, res, ->
      spy.calledWith(200).should.be.true
      done()            
  
  it "should return a 404 when the resource is not found", (done) ->
    controller.model.findById = (id, fields, options, cb) ->
      cb(null, null)   
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)
    spy = sinon.spy(res, "send");
    controller.get req, res, ->
      spy.calledWith(404).should.be.true
      done()     

  it 'should delete a resource by Id', (done) ->
    spy = sinon.spy(controller.model, "findById")
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)
    controller.destroy req, res, ->
      spy.calledWith(req.params.id).should.be.true
      done()  

  
  it 'should return a 204 status on deletion', (done) ->
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ((status, body)->)

    spy = sinon.spy(res, 'send')
    controller.destroy req, res, ->
      spy.calledWith(204).should.be.true
      done()    
  
  it 'should update a resource by id', (done) ->
    spy = sinon.spy(controller.model, "findById")
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
      _body : JSON.stringify({data:'1'})
    res = 
      send: ( (status, body) ->)
    controller.update req, res, ->
      #spy.calledWith(req.params.id).should.be.true
      done()  
  