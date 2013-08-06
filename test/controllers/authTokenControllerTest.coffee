mongoose = require 'mongoose'
sinon = require 'sinon'

describe "Token based Authentication Controller", ->
  
  controller = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    modelSpy = 
      findOne : (query, cb) ->
        cb null, {
          update : (query, options, cb) ->
            cb() if cb
        }
    controller = require('../../src/controllers/authTokenController')
    controller.model = modelSpy
    controller.sha1Service = {
      check : (password, encrypted, onPass, onFail) ->
        onPass()     
      encrypt : (password, cb) ->
        cb('encryptedInSha1')
    }
    controller.bcryptService = {
      check: (password, encrypted, onPass, onFail) ->
        onPass()           
      encrypt: (password, cb) ->
        cb('encryptedInBcrypt')
    }
    done()

  it 'should verify the BCRYPT password on a post', (done) ->
    controller.model.findOne = (query, cb) ->
      cb null, {
        email:'user1@localruckus.com'
        password : '$$HASHEDPASSWORD$$'
        encryptionMethod : 'BCRYPT'
        update : (query, options, cb) ->
          cb() if cb     
      }     
    dbSpy = sinon.spy(controller.model, "findOne")
    bcryptSpy = sinon.spy(controller.bcryptService, 'check')
    req = 
      body : {email:'user1@localruckus.com', password : 'goodPassword'}
      authorization : 
        basic: 
          username : 'apiKey'
    res = 
      send: ( (status, body) ->)
    controller.createToken req, res, ->
      dbSpy.calledWith({email : 'user1@localruckus.com'}).should.be.true
      bcryptSpy.calledWith('goodPassword', '$$HASHEDPASSWORD$$').should.be.true
      done()

  it 'should verify the SHA1 password on a post', (done) ->
    controller.model.findOne = (query, cb) ->
      cb null, {
        email:'user1@localruckus.com'
        password : '$$HASHEDPASSWORD$$'
        encryptionMethod : 'SHA1'
        update : (query, options, cb) ->
          cb() if cb  
      }           
    dbSpy = sinon.spy(controller.model, "findOne")
    sha1Spy = sinon.spy(controller.sha1Service, 'check')
    req = 
      body : {email:'user1@localruckus.com', password : 'goodPassword'}
      authorization : 
        basic: 
          username : 'apiKey'
    res = 
      send: ( (status, body) ->)
    controller.createToken req, res, ->
      dbSpy.calledWith({email : 'user1@localruckus.com'}).should.be.true
      sha1Spy.calledWith('goodPassword', '$$HASHEDPASSWORD$$').should.be.true
      done()    

  it 'should upgrade an SHA1 password to a BCRYPT password after successful validation', (done) ->
    controller.model.findOne = (query, cb) ->
      cb null, {
        email:'user1@localruckus.com'
        password : '$$HASHEDPASSWORD$$'
        encryptionMethod : 'SHA1'
        update : (query, options, cb) ->
          cb() if cb      
      }           
    bcryptSpy = sinon.spy(controller.bcryptService, 'encrypt')
    req = 
      body : {email:'user1@localruckus.com', password : 'goodPassword'}
      authorization : 
        basic: 
          username : 'apiKey'
    res = 
      send: ( (status, body) ->)
    controller.createToken req, res, ->
      bcryptSpy.calledWith('goodPassword').should.be.true

      done()             