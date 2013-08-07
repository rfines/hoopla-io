sinon = require 'sinon'
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
    controller = require('../../src/controllers/passwordResetController')
    mockModel = class Mock
      constructor: (@name)->

      save: (cb) ->
        cb(null, {})
    controller.passwordReset = mockModel
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
        global_merge_vars : [{name: 'PASSWORD_RESET_URL', content: "http://localhost:3000/password/reset?token=123"}]        
      template_name : 'password-reset-request'
      template_content : []
    controller.requestResetEmail req, res, ->
      emailServiceSpy.called.should.be.true
      actualArgs = emailServiceSpy.getCall(0).args[0]
      actualArgs.should.be.eql expectedParams
      done()

  it 'should should save the new password is the token and email address are valid', (done) ->
    req.body = { email : 'user1@localruckus.com', token : '123', password : 'newPassword'}
    controller.user = {
      findOne : (query, fields, options, cb) ->
        cb null, {
          _id : 'userId'
          update : (query, options, cb) ->
            cb null, {}
        }
    }
    controller.passwordReset =
      findOne : (query, fields, options, cb) ->
        cb null, {
          _id : 'myId'
          email : 'user1@localruckus.com'
          update : (query, options, cb) ->
            cb null, {}          
        }
      update: (query, options, cb) ->
        cb(null, {})
    controller.bcryptService = {
      check: (password, encrypted, onPass, onFail) ->
        onPass()           
      encrypt: (password, cb) ->
        cb('encryptedInBcrypt')
    }            
    pwSpy = sinon.spy(controller.passwordReset, 'findOne')
    userSpy = sinon.spy(controller.user, 'findOne')
    bcryptSpy = sinon.spy(controller.bcryptService, 'encrypt')
    controller.resetPassword req, res, ->
      pwSpy.calledWith({ email : 'user1@localruckus.com', token : '123'}).should.be.true
      userSpy.calledWith({email : 'user1@localruckus.com'}).should.be.true
      bcryptSpy.calledWith('newPassword').should.be.true
      done()  

  it 'should should reject with a 403 if the email/token cannot be found', (done) ->
    req.body = { email : 'user1@localruckus.com', token : '123', password : 'newPassword'}
    controller.passwordReset =
      findOne : (query, fields, options, cb) ->
        cb null, {}
      update: (query, options, cb) ->
        cb(null, {})
    pwSpy = sinon.spy(controller.passwordReset, 'findOne')
    resSpy = sinon.spy(res, 'send')
    controller.resetPassword req, res, ->
      pwSpy.calledWith({ email : 'user1@localruckus.com', token : '123'}).should.be.true
      resSpy.calledWith(403).should.be.true
      done()            

