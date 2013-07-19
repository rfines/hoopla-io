mongoose = require 'mongoose'
sinon = require 'sinon'
RestfulController = require('../../src/controllers/restfulController')

describe "Base Operations for RESTful Routes", ->
  
  controller = {}

  modelSpy = 
    findById : (id, fields, cb) ->
      cb(null, {})  
    findOne : (query, fields, cb) ->
      cb(null, {})
    remove : (query, cb) ->
      cb(null, {})
    findByIdAndUpdate : (id, body, cb) ->
      cb(null, {})

  before (done) ->  
    done()

  beforeEach (done) ->
    controller =  new RestfulController()
    controller.Model = modelSpy

    done()

  it "should get a resource by id", (done) ->
    spy = sinon.spy(controller.Model, "findById");
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)
    controller.get req, res, ->
      spy.called.should.be.true
      done()

  it "should get a resource by legacyId", (done) ->
    spy = sinon.spy(controller.Model, "findOne");
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
      spy.calledWith(200, {}).should.be.true
      done()     


  it 'should delete a resource by Id', (done) ->
    spy = sinon.spy(controller.Model, "remove")
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)
    controller.destroy req, res, ->
      spy.calledWith({'_id' : req.params.id}).should.be.true
      done()  

  it 'should return a 204 status on deletion', (done) ->
    #spy = sinon.spy(controller.Model, "remove")
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
    spy = sinon.spy(controller.Model, "findByIdAndUpdate")
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
      _body : JSON.stringify({data:'1'})
    res = 
      send: ( (status, body) ->)
    controller.update req, res, ->
      spy.calledWith(req.params.id, {data:'1'}).should.be.true
      done()  
