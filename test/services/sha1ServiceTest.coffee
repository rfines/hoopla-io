service = require('../../src/services/sha1Service')
crypto = require('crypto')

describe "Sha1 Utilities for Password Integration", ->

  it 'should match a hashed password', (done) ->
    password = 'password'
    sha1hasher = crypto.createHash('sha1')
    sha1hasher.update(password, 'utf8')
    onPass = ->
      done()
    onFail = ->
      false.should.be.true
    service.check password, sha1hasher.digest('hex'), onPass, onFail
