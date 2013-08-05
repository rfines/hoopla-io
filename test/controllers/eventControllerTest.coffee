mongoose = require 'mongoose'
sinon = require 'sinon'
EventController = require('../../src/controllers/eventController')

describe "Operations for Event Routes", ->
  controller = {}
  modelSpy = {}
  builder = {}
  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/eventController')
    builder = require('../../src/controllers/helpers/QueryComponentBuilder')
    modelSpy = 
      get : (code, cb) ->
        cb null, {geo: { type:'Point', coordinates:[1.001, 1.001]}}
    builder.postalCodeService = modelSpy
    builder.geoCoder = 
      geocodeAddress : (query, cb) ->
        cb null, {latitude : 1.01, longitude: 1.01}
    done()
