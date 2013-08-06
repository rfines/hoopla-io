sinon = require 'sinon'
PasswordResetController = require('../../src/controllers/passwordResetController')

describe "Operations for Password Resets", ->
  controller = {}
  emailService = {
    send : (options, cb) ->
      cb()
  }
  req = {}
  res = {}  

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = PasswordResetController
    mockModel = class Mock
      constructor: (@name)->

      save: (cb) ->
        cb(null, {})
    controller.PasswordReset = mockModel
    controller.emailService = emailService
    controller.tokenService = {
      generateWithTimestamp : (len) ->
        return 123
    }
    req = 
      body : {email:'user1@localruckus.com'}
    res = 
      send: ( (status, body) ->)        
    done()      

  it 'should add a password reset request to the database', (done) ->
    responseSpy = sinon.spy(res, 'send')
    controller.requestResetEmail req, res, ->
      responseSpy.calledWith(201).should.be.true
      done()

  it 'should email the user a password reset link', (done) ->
    emailServiceSpy = sinon.spy(controller.emailService, 'send')
    expectedParams = 
      message: 
        'to' : [{email:'user1@localruckus.com'}]
      template_name : 'password-reset-request'
      template_content : [{PASSWORD_RESET_URL  : "http://localhost:3000/password/reset?token=123"}]
    controller.requestResetEmail req, res, ->
      emailServiceSpy.called.should.be.true
      actualArgs = emailServiceSpy.getCall(0).args[0]
      actualArgs.should.be.eql expectedParams
      done()      