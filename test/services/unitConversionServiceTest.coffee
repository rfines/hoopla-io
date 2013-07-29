mongoose = require 'mongoose'
sinon = require 'sinon'
conversionServices = require('../../src/services/unitConversionService')

describe "Operations for converting geo distances", ->
  it "should convert miles to meters", (done) ->
      result = conversionServices.milesToMeters(1)
      result.should.equal 1609.3470878864446
      done()
  it "should convert meters to miles", (done) ->
      result = conversionServices.metersToMiles(1609.3470878864446)
      result.should.equal 1
      done()