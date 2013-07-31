mongoose = require 'mongoose'
sinon = require 'sinon'
BusinessController = require('../../src/controllers/businessController')

describe "Operations for Business Routes", ->
  controller = {}
  modelSpy = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/businessController')
    modelSpy = 
      get : (code, cb) ->
        cb null, {geo: { type:'Point', coordinates:[1.001, 1.001]}}
    controller.postalCodeService = modelSpy
    controller.geoCoder = 
      geocodeAddress : (query, cb) ->
        cb null, {latitude : 1.01, longitude: 1.01}
    done()      
  
  it "should transform longitude/latitude parameter for search", (done) ->
    controller.buildSearchQuery {ll:'-93.5,40.01'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 40233.67719716111}}}
      done()

  it "should transform longitude/latitude parameter for search", (done) ->
    controller.buildSearchQuery {ll:'-94.595033,39.102704'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704 ]},$maxDistance : 40233.67719716111}}}
      done()    

  it "should validate the existence of longitude/latitude or near parameter for search", (done) ->
    controller.buildSearchQuery {}, (err, query) ->
      err.should.eql {'message': 'The request parameters do not contain a near field or ll field.'}
      done()

  it "should get the zip code coordinates from the database when the near param is passed with a postal code", (done) ->
    spy = sinon.spy(controller.postalCodeService, "get");
    controller.buildSearchQuery {near:'64105'}, (err, coords, query) ->
      spy.calledWith('64105').should.be.true
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.001,1.001]},$maxDistance : 40233.67719716111}}}
      done()

  it "should get the zip code coordinates from the database when the near param is passed with a postal code and formulate a query using distance and coords", (done) ->
    spy = sinon.spy(controller.postalCodeService, "get");
    controller.buildSearchQuery {near:'64105', maxDistance: 10}, (err, coords, query) ->
      spy.calledWith('64105').should.be.true
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.001,1.001]}, $maxDistance : 16093.470878864446 }}}
      done()

  it "should build a query using ll and maxdistance", (done) ->
    controller.buildSearchQuery {ll:'-94.595033,39.102704', maxDistance: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 16093.470878864446}}}
      done()

  it "should build a query using near city,state and maxdistance", (done) ->
    controller.buildSearchQuery {near : 'Kansas City, MO', maxDistance: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 16093.470878864446}}}
      done()

  it "should handle maxdistance with float values", (done) ->
    controller.buildSearchQuery {near : 'Kansas City, MO', maxDistance: 0.1}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 160.93470878864446}}}
      done()  