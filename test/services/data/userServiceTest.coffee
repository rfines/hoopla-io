sinon = require 'sinon'
service = require('../../../src/services/data/userService')

describe "User data services", ->
  
  it 'should get a user by the apiKey and token', (done) ->
    service.User =
      findOne : (query, fields, options, cb) ->
        cb(null, {})

    spy = sinon.spy(service.User, "findOne");
    service.getByAppToken 'apiKey', 'token', (err, data) ->
      spy.calledWith({'authTokens.apiKey' : 'apiKey', 'authTokens.authToken' : 'token'}).should.be.true
      done()
