u = require('../../src/utils/addressUtils')

describe "Utilities for manipulating addresses", ->
  
  it "should generalize a street address down to city and state", (done) ->
    address = "200 Main, Kansas City, MO"
    u.zoomOut(address).should.equal 'Kansas City, MO'
    done()