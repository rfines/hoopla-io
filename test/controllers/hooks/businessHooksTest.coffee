sinon = require 'sinon'
mongoose = require 'mongoose'

describe "Business Hooks", ->
  hooks = {}
  req = {}
  res = {}
  
  before (done) ->  
    done()

  beforeEach (done) ->
    hooks = require('../../../src/controllers/hooks/businessHooks')
    req =
      body : {}
    res = 
      send: ( (status, body) ->)  
    done()

  it 'should assign the creating user as the OWNER when the business is created', (done) ->
    req.authUser = {
      save : (cb) ->
          cb()
      businessPrivileges: []
    }
    business = {}
    userSpy = sinon.spy(req.authUser, 'save')
    hooks.create.post business, req, res, ->
      userSpy.called.should.be.true
      req.authUser.businessPrivileges.length.should.be.equal 1
      done()

  it 'should remove all user privileges when a business is deleted', (done) ->
    business = {
      _id : new mongoose.Types.ObjectId()
    }
    userAttachedToBusiness = {
      businessPrivileges : [ {business : business._id}]
      save: (cb) ->
        cb null
    }
    UserService = {
      getByBusinessPrivileges: (businessId, cb) ->
        cb null, [userAttachedToBusiness]
    }
    userServiceSpy = sinon.spy(UserService, 'getByBusinessPrivileges')
    userSpy = sinon.spy(userAttachedToBusiness, 'save')
    hooks.UserService = UserService
    hooks.destroy.post 
      resource : business
      req : req
      res : res
      success : ->
        userServiceSpy.calledWith(business._id).should.be.true
        userAttachedToBusiness.businessPrivileges.length.should.equal 0
        userSpy.called.should.be.true
        done()

  
