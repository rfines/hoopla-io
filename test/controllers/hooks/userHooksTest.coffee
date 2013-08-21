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
    req = {}
    res = {}
    next = ->
      console.log 'next'
    user = 
      password : 'myPassword'
    hooks.create.pre 
      target : user
      req : req
      res: res
      success: ->
        bcryptSpy.calledWith('myPassword').should.be.true
        user.password.should.be.equal 'encryptedPassword'
        user.encryptionMethod.should.be.equal 'BCRYPT'
        done()
    

