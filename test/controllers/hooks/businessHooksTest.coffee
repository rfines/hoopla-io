sinon = require 'sinon'

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



  
