mongoose = require 'mongoose'
sinon = require 'sinon'
EventController = require('../../src/controllers/eventController')

describe "Operations for Event Routes", ->
  controller = {}

  before (done) ->  
    done()
  beforeEach (done) ->
    controller = require('../../src/controllers/eventController')
    done()
    
  
