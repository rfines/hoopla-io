sinon = require 'sinon'

describe "User Routes", ->
  controller = {}

  before (done) ->
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/userController')
    done()