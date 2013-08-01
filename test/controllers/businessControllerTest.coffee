sinon = require 'sinon'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')
    done()      