mongoose = require 'mongoose'
sinon = require 'sinon'
RestfulController = require('../../src/controllers/restfulController')

describe "Base Operations for RESTful Routes", ->
  
  controller = {}
  document = {}
  req = {}
  res = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller =  new RestfulController()
    document =
      update : (data, cb) ->
        cb()
      remove : (cb) ->
        cb()
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
    res = 
      send: ( (status, body) ->)        
    modelSpy = 
      findById : (id, fields, options) ->
        return {
          lean : ->
            console.log 'populate'
          populate: ->
            console.log 'populate'
          exec : (cb) ->
            cb null, document
        }
        
      findOne : (query, fields, options, cb) ->
        return {
          lean : ->
            console.log 'populate'
          populate: ->
            console.log 'populate'
          exec : (cb) ->
            cb null, document
        }
      remove : (query, cb) ->
        cb null, document
      findByIdAndUpdate : (id, body, cb) ->
        cb null, document
    controller.model = modelSpy
    done()

  it "should get a resource by id", (done) ->
    spy = sinon.spy(controller.model, "findById");
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
    req.params.id = 12345
    spy = sinon.spy(res, 'send')  
    controller.get req, res, ->
      spy.calledWith(200).should.be.true
      done()            
  
  it "should return a 404 when the resource is not found", (done) ->
    controller.model.findById = (id, fields, options) ->
      return {
        lean : ->
          console.log 'populate'
        populate: ->
          console.log 'populate'
        exec : (cb) ->
          cb null, null
      } 
    spy = sinon.spy(res, "send");
    controller.get req, res, ->
      spy.calledWith(404).should.be.true
      done()     

  it 'should delete a resource by Id', (done) ->       
    spy = sinon.spy(document, "remove")
    controller.destroy req, res, ->
      spy.called.should.be.true
      done()  

  
  it 'should return a 204 status on deletion', (done) ->
    spy = sinon.spy(res, 'send')
    controller.destroy req, res, ->
      spy.calledWith(204).should.be.true
      done()    
  
  it 'should update a resource by id', (done) ->
    req = 
      params : 
        id : new mongoose.Types.ObjectId()
      body : {data:'1'}
    spy = sinon.spy(document, "update")
    controller.update req, res, ->
      spy.calledWith({data:'1'}).should.be.true
      done()  