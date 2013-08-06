sinon = require 'sinon'
PasswordResetController = require('../../src/controllers/passwordResetController')

describe "Operations for Password Resets", ->
  controller = {}
  emailService = {}
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
    req = 
      body : JSON.stringify({email:'user1@localruckus.com'})
    res = 
      send: ( (status, body) ->)        
    done()      

  it 'should add a password reset request to the database', (done) ->
    controller.requestResetEmail req, res, ->
      res.statusCode.should.be 200
      done()