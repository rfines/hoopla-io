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
    user = {businessPrivileges : [{businessId : business._id, role : 'OWNER'}]}
    controller.security.destroy(user, business).should.be.true
    done()        