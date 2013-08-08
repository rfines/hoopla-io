sinon = require 'sinon'

describe "User Routes", ->
  controller = {}

  before (done) ->
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/userController')
    console.log controller.bcryptService
    controller.bcryptService = {
      encrypt : (password, callback) ->
        callback 'encryptedPassword'
    }
    done()

  it "should bcrypt a password on user creation", (done) ->
    bcryptSpy = sinon.spy(controller.bcryptService, 'encrypt')
    user = 
      password : 'myPassword'
    controller.hooks.create.pre user, ->
      bcryptSpy.calledWith('myPassword').should.be.true
      user.password.should.be.equal 'encryptedPassword'
      user.encryptionMethod.should.be.equal 'BCRYPT'
      done()
    

