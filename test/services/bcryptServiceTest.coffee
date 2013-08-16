service = require('../../src/services/bcryptService')

describe "Bcrypt Utilities for Password Security", ->
  
  it "should encrypt a password", (done) ->
    password = 'password'
    service.encrypt password, (hash) ->
      hash.should.not.equal.password
      done()    

  it 'should match an encrypted password', (done) ->
    password = 'password'
    service.encrypt password, (hash) ->
      onPass = ->
        done()
      onFail = ->
        false.should.be.true
      service.check password, hash, onPass, onFail

  it 'should encrypt a password', (done)->
    password = "twins3514"
    service.encrypt password, (hash)->
      console.log hash
      hash.should.not.equal.password
      done()
    