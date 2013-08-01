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

  it "should transform longitude/latitude parameter for search", (done) ->
    builder.buildSearchQuery {ll:'-93.5,40.01'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 40234}}}
      done()

  it "should transform longitude/latitude parameter for search", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704 ]},$maxDistance : 40234}}}
      done()    

  it "should validate the existence of longitude/latitude or near parameter for search", (done) ->
    builder.buildSearchQuery {}, (err, query) ->
      err.should.eql {'message': 'The request parameters do not contain a near field or ll field.'}
      done()
  it "should get the zip code coordinates from the database when the near param is passed with a postal code", (done) ->
    spy = sinon.spy(builder.postalCodeService, "get");
    builder.buildSearchQuery {near:'64105'}, (err, coords, query) ->
      spy.calledWith('64105').should.be.true
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.001,1.001]},$maxDistance : 40234}}}
      done()

  it "should get the zip code coordinates from the database when the near param is passed with a postal code and formulate a query using distance and coords", (done) ->
    spy = sinon.spy(builder.postalCodeService, "get");
    builder.buildSearchQuery {near:'64105', radius: 10}, (err, coords, query) ->
      spy.calledWith('64105').should.be.true
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.001,1.001]}, $maxDistance : 10 }}}
      done()

  it "should build a query using ll and maxdistance", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704', radius: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}}
      done()

  it "should build a query using near city,state and maxdistance", (done) ->
    builder.buildSearchQuery {near : 'Kansas City, MO', radius: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10}}}
      done()

  it "should handle maxdistance with float values", (done) ->
    builder.buildSearchQuery {near : 'Kansas City, MO', radius: 10.1}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}}
      done()        
  it "should handle event categories correctly as well as location", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704', radius: 10, categories:"PETS,FOOD"}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}, 'categories':{$in:["PETS","FOOD"]}}
      done()
  it "should handle maxdistance with float values and cost", (done) ->
    builder.buildSearchQuery {near : 'Kansas City, MO', radius: 10.1, maxCost: '20.00'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'maxCost':{$lte : 20.00}}
      done()    