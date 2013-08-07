sinon = require 'sinon'

describe "Query Builder", ->
  modelSpy = {}
  builder = {}
  before (done) ->  
    done()

  beforeEach (done) ->
    builder = require('../../../src/controllers/helpers/QueryComponentBuilder')
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

  it "should build a query using ll and maxdistance", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704', radius: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}}
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

  it "should build a query using ll and maxdistance", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704', radius: 10}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}}
      done()

  it "should handle maxdistance with float values", (done) ->
    builder.buildSearchQuery {ll : '1.01,1.01', radius: 10.1}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}}
      done()        

  it "should handle event categories correctly as well as location", (done) ->
    builder.buildSearchQuery {ll:'-94.595033,39.102704', radius: 10, categories:"PETS,FOOD"}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}, 'categories':{$in:["PETS","FOOD"]}}
      done()

  it "should handle maxdistance with float values and cost", (done) ->
    builder.buildSearchQuery {ll: '1.01,1.01', radius: 10.1, maxCost: '20.00'}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'maxCost':{$lte : 20.00}}
      done() 

  it "should handle maxdistance with float values and start date", (done) ->
    start = new Date("8/5/2013 15:00:00")
    builder.buildSearchQuery {ll: '1.01,1.01', radius: 10.1, start: start}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'occurrences':{$gte : start}}
      done()  
  it "should handle maxdistance with float values and both dates", (done) ->
    start = new Date("8/5/2013 15:00:00")
    end = new Date("8/8/2013 18:00:00")
    builder.buildSearchQuery {ll: '1.01,1.01', radius: 10.1, start: start, end: end}, (err, coords, query) ->
      query.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'occurrences':{$gte : start, $lte :end}}
      done()          