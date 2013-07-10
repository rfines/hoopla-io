service = require('../../src/services/sha1Service')

describe "Sha1 Utilities for Password Integration", ->

  it 'should match a hashed password', (done) ->
    password = 'password'
    crypto = require('crypto')
    sha1hasher = crypto.createHash('sha1')
    sha1hasher.update(password, 'utf8')
    hash=sha1hasher.digest('hex')
    onPass = ->
      done()
    onFail = ->
      false.should.be.true
    service.check password, hash, onPass, onFail
