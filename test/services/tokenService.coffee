service = require('../../src/services/tokenService')

describe "Utilities for generating/managing api keys and secrets", ->
  
  it "should generate an api key of 20 length", (done) ->
    service.generateKey().length.should.equal 20
    done()

  it "should generate an api secret of 40 length", (done) ->
    service.generateSecret().length.should.equal 40
    done()    