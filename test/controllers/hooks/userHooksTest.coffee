sinon = require 'sinon'

describe "User Routes", ->
  hooks = {}

  before (done) ->
    done()

  beforeEach (done) ->
    hooks = require('../../../src/controllers/hooks/userHooks')
    hooks.bcryptService = {
      encrypt : (password, callback) ->
        callback 'encryptedPassword'
    }
    done()

  it "should bcrypt a password on user creation", (done) ->
    bcryptSpy = sinon.spy(hooks.bcryptService, 'encrypt')
    req = {
      body:
        password : 'myPassword'
    }
    res = {}
    next = ->
      console.log 'next'
    hooks.create.pre 
      req : req
      res: res
      success: ->
        bcryptSpy.calledWith('myPassword').should.be.true
        req.body.password.should.be.equal 'encryptedPassword'
        req.body.encryptionMethod.should.be.equal 'BCRYPT'
        done()
    

